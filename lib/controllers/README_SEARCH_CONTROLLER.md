# AppSearchController Usage Guide

The `AppSearchController` is a centralized search controller that can be used throughout the project for consistent search functionality.

## Features

- **Debounced Search**: 300ms delay to prevent excessive API calls
- **Reactive UI**: Uses GetX reactive variables for instant UI updates
- **Generic Search Methods**: Pre-built methods for common search patterns
- **Memory Management**: Proper cleanup of timers and controllers

## Basic Usage

### 1. Initialize the Controller

```dart
final AppSearchController searchController = Get.put(AppSearchController());
```

### 2. Set Search Callback

```dart
searchController.setSearchCallback((searchQuery) {
  // Your search logic here
  _filterData();
});
```

### 3. Use in UI

```dart
TextField(
  controller: searchController.searchTextController,
  decoration: InputDecoration(
    hintText: 'Search...',
    suffixIcon: searchController.hasSearchQuery
        ? IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => searchController.clearSearch(),
          )
        : null,
  ),
)
```

## Pre-built Search Methods

### Search Purchases
```dart
final filtered = searchController.searchPurchases(
  purchaseController.purchases,
  (purchase) => purchase.invoiceNumber,
  (purchase) => purchase.supplierName,
);
```

### Search Products
```dart
final filtered = searchController.searchProducts(
  productController.products,
  (product) => product.name,
  (product) => product.category,
);
```

### Search Sales
```dart
final filtered = searchController.searchSales(
  saleController.sales,
  (sale) => sale.invoiceNumber,
  (sale) => sale.customerName,
);
```

### Generic Search
```dart
final filtered = searchController.searchList(
  myList,
  (item) => item.searchableField,
);
```

## Reactive Properties

- `searchText.value`: Current search text
- `hasSearchQuery`: Boolean indicating if there's an active search
- `isSearching.value`: Boolean indicating if search is in progress (during debounce)

## Example Implementation

```dart
class MyView extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    final AppSearchController searchController = Get.put(AppSearchController());
    final MyController myController = Get.put(MyController());
    
    // Set search callback
    searchController.setSearchCallback((_) {
      _filterData();
    });
    
    return Scaffold(
      body: Column(
        children: [
          // Search Field
          TextField(
            controller: searchController.searchTextController,
            decoration: InputDecoration(
              hintText: 'Search...',
              suffixIcon: Obx(() => searchController.hasSearchQuery
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => searchController.clearSearch(),
                    )
                  : null),
            ),
          ),
          
          // Results
          Expanded(
            child: Obx(() {
              final filtered = searchController.searchList(
                myController.items,
                (item) => item.name,
              );
              
              return ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(filtered[index].name));
                },
              );
            }),
          ),
        ],
      ),
    );
  }
  
  void _filterData() {
    // Your filtering logic here
  }
}
```

## Benefits

1. **Consistent UX**: Same search behavior across all views
2. **Performance**: Debounced search prevents excessive filtering
3. **Reusability**: One controller for all search needs
4. **Maintainability**: Centralized search logic
5. **Memory Safe**: Proper cleanup prevents memory leaks

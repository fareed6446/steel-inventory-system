# Steel Factory Inventory Management System

A comprehensive desktop inventory management system built with Flutter, designed specifically for steel factories. This system helps manage daily purchases, sales, stock movements, and provides detailed analytics and reporting.

## 🏭 Features

### Core Functionality
- **Product Management**: Add, edit, and manage steel products with detailed specifications
- **Purchase Management**: Track daily purchases from suppliers with invoice management
- **Sales Management**: Record sales transactions with customer information
- **Stock Management**: Real-time stock tracking with automatic updates
- **Stock Movement Tracking**: Complete audit trail of all stock movements
- **Analytics Dashboard**: Comprehensive reporting with charts and graphs

### Key Features
- **Real-time Stock Updates**: Automatic stock level updates on purchases and sales
- **Low Stock Alerts**: Automatic notifications for products below minimum stock levels
- **Overstock Warnings**: Alerts for products exceeding maximum stock levels
- **Financial Analytics**: Revenue, expenses, and profit tracking
- **Stock Movement History**: Complete audit trail of all transactions
- **Responsive Design**: Optimized for desktop use with modern UI

## 🏗️ Architecture

### MVC Pattern with GetX
The application follows the Model-View-Controller (MVC) architecture pattern using GetX for state management:

```
lib/
├── models/           # Data models
├── views/            # UI screens
├── controllers/      # Business logic controllers
├── services/         # Database and external services
├── widgets/          # Reusable UI components
├── utils/            # Utility functions
└── constants/        # App constants
```

### Models
- **Product**: Steel product specifications (name, category, grade, dimensions)
- **Purchase**: Purchase transactions with supplier details
- **Sale**: Sales transactions with customer information
- **Stock**: Current stock levels and thresholds
- **StockMovement**: Audit trail of all stock changes

### Controllers
- **ProductController**: Manages product CRUD operations
- **PurchaseController**: Handles purchase transactions and stock updates
- **SaleController**: Manages sales and stock deductions
- **StockController**: Monitors stock levels and movements
- **DashboardController**: Provides analytics and reporting data

## 🛠️ Technology Stack

- **Framework**: Flutter 3.9.2+
- **State Management**: GetX
- **Database**: SQLite (sqflite)
- **Charts**: FL Chart
- **UI Components**: Material Design 3
- **Architecture**: MVC Pattern

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6                    # State management
  sqflite: ^2.3.0               # Local database
  path: ^1.8.3                  # File paths
  fl_chart: ^0.66.0             # Charts and graphs
  syncfusion_flutter_charts: ^24.1.41  # Advanced charts
  intl: ^0.19.0                 # Internationalization
  flutter_staggered_grid_view: ^0.7.0  # Grid layouts
  data_table_2: ^2.5.6          # Data tables
  path_provider: ^2.1.1         # File system access
  uuid: ^4.2.1                  # Unique ID generation
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart SDK 3.0.0 or higher
- A compatible IDE (VS Code, Android Studio, or IntelliJ IDEA)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd inventory_manager
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Desktop Support
This application is optimized for desktop platforms:
- **Windows**: `flutter run -d windows`
- **macOS**: `flutter run -d macos`
- **Linux**: `flutter run -d linux`

## 📊 Database Schema

The application uses SQLite with the following main tables:

### Products Table
```sql
CREATE TABLE products (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL,
  unit TEXT NOT NULL,
  weight REAL,
  length REAL,
  width REAL,
  thickness REAL,
  grade TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
```

### Purchases Table
```sql
CREATE TABLE purchases (
  id TEXT PRIMARY KEY,
  product_id TEXT NOT NULL,
  supplier_name TEXT NOT NULL,
  supplier_contact TEXT NOT NULL,
  quantity REAL NOT NULL,
  unit_price REAL NOT NULL,
  total_amount REAL NOT NULL,
  purchase_date TEXT NOT NULL,
  invoice_number TEXT NOT NULL,
  notes TEXT,
  status TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products (id)
)
```

### Sales Table
```sql
CREATE TABLE sales (
  id TEXT PRIMARY KEY,
  product_id TEXT NOT NULL,
  customer_name TEXT NOT NULL,
  customer_contact TEXT NOT NULL,
  quantity REAL NOT NULL,
  unit_price REAL NOT NULL,
  total_amount REAL NOT NULL,
  sale_date TEXT NOT NULL,
  invoice_number TEXT NOT NULL,
  notes TEXT,
  status TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products (id)
)
```

### Stock Table
```sql
CREATE TABLE stock (
  id TEXT PRIMARY KEY,
  product_id TEXT NOT NULL,
  current_quantity REAL NOT NULL,
  reserved_quantity REAL NOT NULL,
  available_quantity REAL NOT NULL,
  minimum_stock_level REAL NOT NULL,
  maximum_stock_level REAL NOT NULL,
  last_updated TEXT NOT NULL,
  location TEXT NOT NULL,
  batch_number TEXT,
  expiry_date TEXT,
  FOREIGN KEY (product_id) REFERENCES products (id)
)
```

### Stock Movements Table
```sql
CREATE TABLE stock_movements (
  id TEXT PRIMARY KEY,
  product_id TEXT NOT NULL,
  transaction_type TEXT NOT NULL,
  transaction_id TEXT NOT NULL,
  quantity REAL NOT NULL,
  previous_quantity REAL NOT NULL,
  new_quantity REAL NOT NULL,
  reason TEXT NOT NULL,
  movement_date TEXT NOT NULL,
  notes TEXT,
  user_id TEXT NOT NULL,
  created_at TEXT NOT NULL,
  FOREIGN KEY (product_id) REFERENCES products (id)
)
```

## 🎯 Usage Guide

### 1. Product Management
- Add new steel products with specifications (category, grade, dimensions)
- Set minimum and maximum stock levels
- Track product details and specifications

### 2. Purchase Management
- Record daily purchases from suppliers
- Automatic stock level updates
- Invoice tracking and supplier management

### 3. Sales Management
- Record sales transactions
- Customer information management
- Automatic stock deduction with validation

### 4. Stock Management
- Real-time stock level monitoring
- Low stock and overstock alerts
- Manual stock adjustments
- Stock movement history

### 5. Analytics & Reporting
- Revenue vs expenses analysis
- Stock status overview
- Top selling products
- Financial metrics and KPIs

## 📈 Analytics Features

### Dashboard Metrics
- **Total Revenue**: Sum of all sales transactions
- **Total Expenses**: Sum of all purchase transactions
- **Net Profit**: Revenue minus expenses
- **Profit Margin**: Percentage profit calculation
- **Stock Value**: Total value of current inventory

### Charts and Graphs
- **Revenue vs Expenses Chart**: Line chart showing daily trends
- **Stock Status Pie Chart**: Visual representation of stock levels
- **Stock Movement Bar Chart**: Daily stock movement patterns

### Reports
- **Top Selling Products**: Best performing products by quantity
- **Low Stock Alerts**: Products requiring restocking
- **Transaction Summary**: Overview of purchases and sales
- **Date Range Reports**: Customizable reporting periods

## 🔧 Configuration

### Steel Categories
The system supports various steel categories:
- Carbon Steel
- Stainless Steel
- Alloy Steel
- Tool Steel
- Structural Steel
- Sheet Metal
- Rebar
- Wire Rod
- Pipe
- Tube

### Steel Grades
Common steel grades are pre-configured:
- A36, A572, A992 (Structural)
- 304, 316, 316L (Stainless)
- 410, 420, 440C (Tool Steel)
- D2, H13, S7 (Specialty)

### Units
Supported measurement units:
- kg, tons (Weight)
- pieces (Count)
- meters, feet, inches (Length)
- sheets, coils (Form)

## 🚨 Stock Alerts

### Low Stock Alerts
- Automatic detection when stock falls below minimum level
- Visual indicators in the dashboard
- Alert notifications for immediate attention

### Overstock Warnings
- Detection when stock exceeds maximum level
- Helps prevent over-investment in inventory
- Optimizes warehouse space utilization

## 🔒 Data Integrity

### Transaction Validation
- Stock availability checks before sales
- Automatic stock updates on transactions
- Complete audit trail of all changes

### Error Handling
- Comprehensive error messages
- Data validation at input level
- Graceful handling of edge cases

## 🎨 UI/UX Features

### Modern Design
- Material Design 3 components
- Responsive layout for desktop
- Intuitive navigation with sidebar

### User Experience
- Real-time data updates
- Loading indicators
- Success/error notifications
- Confirmation dialogs for critical actions

## 🔮 Future Enhancements

### Planned Features
- **Multi-location Support**: Manage multiple warehouses
- **Barcode Scanning**: Product identification via barcodes
- **Advanced Reporting**: More detailed analytics
- **User Management**: Multi-user support with roles
- **Backup & Restore**: Data backup functionality
- **Export Features**: PDF and Excel export capabilities

### Integration Possibilities
- **ERP Integration**: Connect with existing ERP systems
- **Accounting Software**: Integration with accounting platforms
- **Supplier Portals**: Direct supplier integration
- **Customer Portals**: Customer self-service features

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation for common solutions

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- GetX team for state management
- FL Chart for beautiful charts
- Material Design team for UI components

---

**Built with ❤️ for Steel Factory Management**
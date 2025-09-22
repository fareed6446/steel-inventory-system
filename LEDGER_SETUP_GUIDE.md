# 🏦 Ledger System Setup Guide

This guide will help you set up the comprehensive Ledger (Account Statement) System for your Steel Factory Inventory Management System.

## 📋 Prerequisites

- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Supabase project set up
- Existing Steel Factory Inventory System running

## 🗄️ Database Setup

### 1. Run the SQL Schema

1. **Open Supabase Dashboard**: Go to [supabase.com](https://supabase.com) and sign in
2. **Navigate to SQL Editor**: Click on "SQL Editor" in the left sidebar
3. **Run Ledger Schema**: Copy and paste the contents of `ledger_schema.sql` into the SQL editor
4. **Execute**: Click "Run" to create all tables, views, functions, and triggers

### 2. Verify Database Setup

After running the schema, verify these components are created:

- ✅ `persons` table
- ✅ `transactions` table
- ✅ `ledger_detailed` view
- ✅ `persons_summary` view
- ✅ `get_person_summary()` function
- ✅ `calculate_running_balance()` function
- ✅ Sample data (4 persons with 10 transactions)

### 3. Test the Views

Run these test queries in Supabase SQL Editor:

```sql
-- Test ledger detailed view
SELECT * FROM ledger_detailed WHERE person_name = 'ABC Steel Works' ORDER BY created_at;

-- Test persons summary
SELECT * FROM persons_summary ORDER BY name;

-- Test summary function
SELECT * FROM get_person_summary((SELECT id FROM persons WHERE name = 'ABC Steel Works'));
```

## 🚀 Flutter Setup

### 1. Files Added to Your Project

The following files have been added to your Flutter project:

```
lib/
├── models/
│   ├── ledger_person.dart          # Person and PersonSummary models
│   └── ledger_transaction.dart     # Transaction and LedgerEntry models
├── services/
│   └── ledger_service.dart         # Extended Supabase service for ledger
├── controllers/
│   └── ledger_controller.dart      # GetX controller for ledger business logic
├── views/
│   └── ledger_view.dart            # Main ledger screen UI
└── widgets/
    └── ledger_dialogs.dart         # Dialog components for CRUD operations
```

### 2. Dependencies

The system uses your existing dependencies:
- `get: ^4.6.6` (for state management)
- `supabase_flutter: ^2.5.6` (for database operations)
- `intl: ^0.19.0` (for date formatting)
- `uuid: ^4.2.1` (for ID generation)

### 3. Integration Complete

The ledger system is already integrated with your existing system:
- ✅ Added to dependency injection
- ✅ Added to main navigation
- ✅ Uses existing theme system
- ✅ Follows existing architecture patterns

## 🎯 Features Overview

### 📊 **Core Features**

1. **Person Management**
   - Add/edit/delete persons (suppliers, customers, both)
   - Opening balance tracking
   - Contact information storage
   - Business type classification

2. **Transaction Management**
   - Add/edit/delete transactions
   - Four transaction types: Sale, Purchase, Payment Received, Payment Given
   - Reference number tracking
   - Date/time stamping

3. **Ledger View**
   - Excel-like table with horizontal/vertical scrolling
   - Real-time running balance calculation
   - Debit/Credit columns
   - Transaction history in chronological order

4. **Analytics & Reporting**
   - Summary cards with key metrics
   - Outstanding balance tracking
   - Transaction count per person
   - Financial position overview

### 🎨 **UI Features**

1. **Responsive Layout**
   - Left sidebar: Persons list with search/filter
   - Right content: Selected person's ledger details
   - Desktop-optimized design

2. **Excel-like Table**
   - Sortable columns
   - Horizontal scrolling for large data
   - Color-coded transaction types
   - Balance indicators (positive/negative)

3. **Interactive Elements**
   - Click to select person
   - Add/edit/delete buttons
   - Search and filter functionality
   - Real-time data updates

## 🔧 Usage Guide

### 1. **Accessing the Ledger**

1. Run your Flutter app
2. Navigate to the "Ledger" tab in the main navigation
3. The ledger system will load automatically

### 2. **Adding a New Person**

1. Click the "+" button in the persons sidebar header
2. Fill in the person details:
   - Name (required)
   - Business Type (Customer/Supplier/Both)
   - Opening Balance
   - Contact Information
3. Click "Add Person"

### 3. **Adding Transactions**

1. Select a person from the left sidebar
2. Click the "+" button in the ledger header
3. Fill in transaction details:
   - Transaction Type
   - Amount
   - Description
   - Date
   - Reference Number (optional)
4. Click "Add Transaction"

### 4. **Viewing Account Statement**

1. Select any person from the left sidebar
2. View their complete account statement:
   - Summary cards at the top
   - Detailed transaction table below
   - Running balance for each transaction

### 5. **Searching and Filtering**

1. Use the search box to find persons by name
2. Use the dropdown to filter by business type
3. Results update in real-time

## 📈 **Accounting Logic**

### **Debit/Credit Rules**

- **Debit**: Purchase + Payment Given
- **Credit**: Sale + Payment Received

### **Balance Calculation**

```
Running Balance = Opening Balance + Credits - Debits
```

### **Transaction Ordering**

- Transactions are ordered by `transaction_date` ASC, then `created_at` ASC
- This ensures accurate running balance calculation

## 🔍 **Troubleshooting**

### **Common Issues**

1. **Database Connection Errors**
   - Verify Supabase URL and keys in `supabase_config.dart`
   - Check internet connection
   - Ensure RLS policies are properly set

2. **Empty Ledger View**
   - Run the sample data SQL if no data appears
   - Check if persons are marked as active (`is_active = true`)

3. **Balance Calculation Issues**
   - Verify transactions are ordered by date
   - Check for null values in amounts
   - Ensure proper transaction types

4. **UI Layout Issues**
   - Ensure minimum screen width of 1200px for optimal experience
   - Check Flutter version compatibility

### **Debug Mode**

Enable debug logging by adding this to your main.dart:

```dart
// In main.dart, add this before Supabase.initialize()
if (kDebugMode) {
  Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
    debug: true, // Enable debug mode
  );
}
```

## 📊 **Sample Data**

The system comes with sample data:

- **4 Persons**: ABC Steel Works, XYZ Construction, Metro Steel Suppliers, Premium Builders Ltd
- **10 Transactions**: Various sales, purchases, and payments
- **Realistic Balances**: Different financial positions for testing

## 🔒 **Security Features**

- **Row Level Security (RLS)**: Enabled on all tables
- **Authentication Required**: All operations require user authentication
- **Data Validation**: Input validation on both client and server side
- **Audit Trail**: Complete transaction history with timestamps

## 🚀 **Performance Optimizations**

- **Indexed Queries**: Database indexes on frequently queried columns
- **Efficient Views**: Pre-calculated views for better performance
- **Lazy Loading**: Data loaded only when needed
- **Real-time Updates**: GetX reactive state management

## 📱 **Desktop Optimization**

- **Responsive Design**: Optimized for desktop landscape view
- **Keyboard Navigation**: Full keyboard support
- **Mouse Interactions**: Hover effects and click feedback
- **Professional UI**: Steel industry-themed design

## 🔄 **Integration with Existing System**

The ledger system seamlessly integrates with your existing Steel Factory Inventory System:

- **Shared Theme**: Uses your existing theme constants
- **Consistent UI**: Follows your design patterns
- **Navigation**: Added to main navigation menu
- **Architecture**: Follows your MVC pattern with GetX

## 📞 **Support**

If you encounter any issues:

1. Check the console logs for error messages
2. Verify database schema is correctly set up
3. Ensure all dependencies are installed
4. Check Supabase connection and permissions

## 🎉 **You're Ready!**

Your comprehensive Ledger System is now ready to use! The system provides:

- ✅ Complete account statement functionality
- ✅ Excel-like transaction table
- ✅ Real-time balance calculations
- ✅ Professional desktop UI
- ✅ Full CRUD operations
- ✅ Search and filtering
- ✅ Integration with existing system

Start by exploring the sample data, then add your own persons and transactions to manage your steel factory's financial records efficiently!

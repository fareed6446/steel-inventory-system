# 🏭 Steel Inventory Management System

A comprehensive desktop inventory management system built with Flutter and Supabase, specifically designed for steel factories to manage products, purchases, sales, stock, and party relationships.

## ✨ Features

### 🏗️ **Core Inventory Management**
- **Product Management**: Add, edit, and manage steel products with specifications
- **Purchase Management**: Track incoming steel materials and supplies
- **Sales Management**: Record steel product sales and customer orders
- **Stock Management**: Real-time stock levels and movement tracking
- **Party Management**: Manage suppliers and customers with transaction history

### 📊 **Analytics & Reporting**
- **Dashboard**: Key metrics and visual analytics
- **Financial Reports**: Purchase/sales summaries and profit analysis
- **Stock Reports**: Current stock levels and movement history
- **Party Reports**: Supplier/customer transaction details and balances

### 🎨 **User Interface**
- **Desktop Optimized**: Built specifically for desktop landscape view
- **Modern UI**: Steel-themed design with professional appearance
- **Responsive Tables**: Efficient data display with sorting and filtering
- **Interactive Dialogs**: User-friendly forms for data entry

### 🔐 **Authentication & Security**
- **Supabase Auth**: Secure email-based authentication
- **Role-based Access**: Admin, Manager, and Operator roles
- **Data Security**: Row Level Security (RLS) policies
- **Session Management**: Persistent login state

## 🛠️ **Technology Stack**

- **Frontend**: Flutter (Desktop)
- **Backend**: Supabase (PostgreSQL + Auth + Real-time)
- **State Management**: GetX
- **Architecture**: MVC Pattern
- **Database**: PostgreSQL with RLS
- **Charts**: FL Chart & Syncfusion Charts

## 📋 **Prerequisites**

- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Supabase Account
- Git

## 🚀 **Installation & Setup**

### 1. **Clone the Repository**
```bash
git clone https://github.com/fareed6446/steel-inventory-management-system.git
cd steel-inventory-management-system
```

### 2. **Install Dependencies**
```bash
flutter pub get
```

### 3. **Supabase Setup**
1. Create a new project at [Supabase](https://supabase.com)
2. Run the SQL schema from `supabase_schema_complete.sql`
3. Run the parties setup from `add_parties_tables.sql`
4. Add sample data using `add_sample_products.sql`

### 4. **Configure Supabase**
Update `lib/config/supabase_config.dart` with your Supabase credentials:
```dart
class SupabaseConfig {
  static const String url = 'YOUR_SUPABASE_URL';
  static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

### 5. **Run the Application**
```bash
flutter run -d windows  # For Windows
flutter run -d macos    # For macOS
flutter run -d linux    # For Linux
```

## 📁 **Project Structure**

```
lib/
├── config/                 # Configuration files
├── controllers/            # GetX controllers
├── core/                  # Theme and constants
├── models/                # Data models
├── services/              # Supabase service
├── views/                 # UI screens
└── widgets/               # Reusable widgets
```

## 🗄️ **Database Schema**

### **Core Tables**
- `products` - Steel products and specifications
- `purchases` - Incoming material transactions
- `sales` - Outgoing product sales
- `stock` - Current inventory levels
- `stock_movements` - Stock change history
- `parties` - Suppliers and customers
- `party_transactions` - Party transaction history

### **Key Features**
- **Auto-generated Invoice Numbers**: INV-YYYYMMDD format
- **Real-time Stock Updates**: Automatic stock adjustments
- **Transaction History**: Complete audit trail
- **Balance Tracking**: Party financial balances

## 🎨 **Theme System**

The application uses a comprehensive steel-themed design system:
- **Primary Colors**: Steel blue and industrial orange
- **Module Colors**: Purchase (blue), Sales (green), Stock (purple)
- **Consistent Styling**: Unified design language throughout

## 📱 **Screens Overview**

### **Main Navigation**
- **Dashboard**: Analytics and key metrics
- **Products**: Steel product management
- **Purchases**: Incoming material tracking
- **Sales**: Product sales management
- **Stock**: Inventory levels and movements
- **Parties**: Supplier/customer management
- **Reports**: Analytics and reporting
- **Settings**: Application configuration

### **Key Features per Screen**
- **Data Tables**: Sortable, filterable, responsive
- **Summary Cards**: Key metrics at a glance
- **Action Dialogs**: Add/edit forms with validation
- **Search & Filter**: Quick data access
- **Export Options**: Data export capabilities

## 🔧 **Configuration**

### **Invoice Settings**
- A4 page format support
- Customizable templates
- Auto-generated invoice numbers
- Company information integration

### **Currency & Localization**
- PKR (Pakistani Rupees) default
- Configurable currency settings
- Date/time formatting
- Number formatting

## 📊 **Sample Data**

The project includes sample data for:
- Steel products (rods, beams, sheets, etc.)
- Sample suppliers and customers
- Initial stock levels
- Sample transactions

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 **Author**

**Fareed Zubair**
- GitHub: [@fareed6446](https://github.com/fareed6446)
- Email: fareed6446@gmail.com

## 🙏 **Acknowledgments**

- Flutter team for the amazing framework
- Supabase for the backend infrastructure
- GetX for state management
- All open-source contributors

## 📞 **Support**

If you have any questions or need help, please:
1. Check the [Issues](https://github.com/fareed6446/steel-inventory-management-system/issues) page
2. Create a new issue with detailed description
3. Contact the author directly

---

**Built with ❤️ for the steel industry**
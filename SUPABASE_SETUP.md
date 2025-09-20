# Supabase Integration Setup Guide

This guide will help you set up Supabase for your Steel Factory Inventory Management System.

## 🚀 Quick Setup

### 1. Supabase Project Setup

Your Supabase project is already configured with:
- **URL**: `https://aakecfoesogyokxqaroo.supabase.co`
- **Anon Key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFha2VjZm9lc29neW9reHFhcm9vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgwNzUwMTEsImV4cCI6MjA3MzY1MTAxMX0.2PsfBo_-hoh9uCBDeulgvRADhPdxrJHt_bwTXcqbmuM`

### 2. Database Schema Setup

1. **Open Supabase Dashboard**: Go to [supabase.com](https://supabase.com) and sign in
2. **Navigate to SQL Editor**: Click on "SQL Editor" in the left sidebar
3. **Run Schema Script**: Copy and paste the contents of `supabase_schema.sql` into the SQL editor
4. **Execute**: Click "Run" to create all tables, indexes, functions, and triggers

### 3. Authentication Setup

1. **Go to Authentication**: Click on "Authentication" in the left sidebar
2. **Configure Email Settings**: 
   - Go to "Settings" → "Auth"
   - Enable email confirmations if desired
   - Set up email templates for signup/login

### 4. Row Level Security (RLS)

The schema includes RLS policies that:
- Allow users to view/update their own profiles
- Allow all authenticated users to manage inventory data
- Secure data access based on user authentication

## 📊 Database Schema

### Tables Created:

1. **users** - User profiles and roles
2. **products** - Steel product catalog
3. **purchases** - Purchase transactions
4. **sales** - Sales transactions
5. **stock** - Current stock levels
6. **stock_movements** - Audit trail of stock changes

### Key Features:

- **Automatic Timestamps**: `created_at` and `updated_at` fields
- **Foreign Key Constraints**: Proper relationships between tables
- **Stock Management**: Automatic stock updates on purchases/sales
- **Audit Trail**: Complete history of stock movements
- **Analytics Functions**: Built-in functions for reporting

## 🔧 Functions Available

### Analytics Functions:

1. **get_total_purchases_by_date_range(start_date, end_date)**
   - Returns daily purchase totals for date range

2. **get_total_sales_by_date_range(start_date, end_date)**
   - Returns daily sales totals for date range

3. **get_low_stock_products()**
   - Returns products below minimum stock level

### Automatic Triggers:

1. **Stock Updates**: Automatically updates stock when purchases/sales are made
2. **Stock Movement Tracking**: Records all stock changes with audit trail
3. **Timestamp Updates**: Automatically updates `updated_at` fields

## 🔐 Security Features

### Row Level Security (RLS):

- **User Profiles**: Users can only access their own profile
- **Inventory Data**: All authenticated users can manage inventory
- **Secure Access**: All data access requires authentication

### Authentication:

- **Supabase Auth**: Built-in authentication system
- **Email/Password**: Standard email and password authentication
- **Session Management**: Automatic session handling
- **User Roles**: Admin, Manager, Operator roles

## 📱 Real-time Features

### Real-time Subscriptions:

The system includes real-time subscriptions for:
- **Products**: Live updates when products are added/modified
- **Stock**: Real-time stock level changes
- **Purchases**: Live purchase notifications
- **Sales**: Real-time sales updates

### Usage in Flutter:

```dart
// Subscribe to stock changes
final channel = supabaseService.subscribeToStock();

// Listen to changes
channel.onPostgresChanges(
  event: PostgresChangeEvent.all,
  schema: 'public',
  table: 'stock',
  callback: (payload) {
    // Handle real-time updates
    print('Stock updated: $payload');
  },
);
```

## 🚀 Getting Started

### 1. Run the App:

```bash
flutter run
```

### 2. Create Your First Account:

1. **Sign Up**: Use the signup form in the app
2. **Choose Role**: Select Admin, Manager, or Operator
3. **Start Using**: Begin managing your steel inventory

### 3. Default Admin Account:

The first user to sign up will automatically have admin privileges. You can:
- Manage all inventory data
- View analytics and reports
- Access all features

## 📈 Benefits of Supabase Integration

### Cloud Benefits:

- **Scalability**: Handles growing inventory data
- **Reliability**: 99.9% uptime guarantee
- **Security**: Enterprise-grade security
- **Backup**: Automatic backups and point-in-time recovery

### Real-time Features:

- **Live Updates**: See changes instantly across devices
- **Collaboration**: Multiple users can work simultaneously
- **Notifications**: Real-time alerts for stock levels

### Analytics:

- **Built-in Functions**: Pre-built analytics functions
- **Custom Queries**: Run complex queries directly
- **Reporting**: Generate reports with SQL

## 🔧 Troubleshooting

### Common Issues:

1. **Connection Errors**: Check your internet connection and Supabase URL
2. **Authentication Issues**: Verify email confirmation settings
3. **Permission Errors**: Check RLS policies are properly set up

### Debug Mode:

Enable debug logging in your Flutter app:

```dart
// In main.dart
Supabase.initialize(
  url: SupabaseConfig.url,
  anonKey: SupabaseConfig.anonKey,
  debug: true, // Enable debug mode
);
```

## 📞 Support

- **Supabase Docs**: [docs.supabase.com](https://docs.supabase.com)
- **Flutter Supabase**: [pub.dev/packages/supabase_flutter](https://pub.dev/packages/supabase_flutter)
- **Community**: [GitHub Discussions](https://github.com/supabase/supabase/discussions)

---

**Your Steel Factory Inventory System is now powered by Supabase! 🏭✨**

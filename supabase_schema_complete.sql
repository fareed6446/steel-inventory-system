-- =====================================================
-- Steel Factory Inventory Management System
-- Complete Supabase Database Schema
-- =====================================================
-- 
-- This file contains the complete database schema for the
-- Steel Factory Inventory Management System.
-- 
-- Run this entire script in your Supabase SQL Editor.
-- =====================================================

-- =====================================================
-- 1. CLEANUP EXISTING TABLES (if any)
-- =====================================================

-- Drop existing tables in correct order (due to foreign keys)
DROP TABLE IF EXISTS stock_movements CASCADE;
DROP TABLE IF EXISTS stock CASCADE;
DROP TABLE IF EXISTS sales CASCADE;
DROP TABLE IF EXISTS purchases CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;

-- Drop existing functions with CASCADE to handle dependencies
DROP FUNCTION IF EXISTS get_total_purchases_by_date_range(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) CASCADE;
DROP FUNCTION IF EXISTS get_total_sales_by_date_range(TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) CASCADE;
DROP FUNCTION IF EXISTS get_low_stock_products() CASCADE;
DROP FUNCTION IF EXISTS update_stock_on_transaction() CASCADE;
DROP FUNCTION IF EXISTS handle_new_user() CASCADE;

-- =====================================================
-- 2. CREATE TABLES
-- =====================================================

-- Profiles table (Supabase standard for user metadata)
CREATE TABLE profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  full_name TEXT NOT NULL,
  role TEXT DEFAULT 'operator' CHECK (role IN ('admin', 'manager', 'operator')),
  phone TEXT,
  department TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  is_active BOOLEAN DEFAULT true
);

-- Users table (extends Supabase auth.users - for backward compatibility)
CREATE TABLE users (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('admin', 'manager', 'operator')),
  phone TEXT,
  department TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  is_active BOOLEAN DEFAULT true
);

-- Products table (steel inventory catalog)
CREATE TABLE products (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL,
  unit TEXT NOT NULL,
  weight DECIMAL,
  length DECIMAL,
  width DECIMAL,
  thickness DECIMAL,
  grade TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Purchases table (supplier transactions)
CREATE TABLE purchases (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  supplier_name TEXT NOT NULL,
  supplier_contact TEXT NOT NULL,
  quantity DECIMAL NOT NULL,
  unit_price DECIMAL NOT NULL,
  total_amount DECIMAL NOT NULL,
  purchase_date TIMESTAMP WITH TIME ZONE NOT NULL,
  invoice_number TEXT NOT NULL,
  notes TEXT,
  status TEXT DEFAULT 'completed' CHECK (status IN ('pending', 'completed', 'cancelled')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Sales table (customer transactions)
CREATE TABLE sales (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  customer_name TEXT NOT NULL,
  customer_contact TEXT NOT NULL,
  quantity DECIMAL NOT NULL,
  unit_price DECIMAL NOT NULL,
  total_amount DECIMAL NOT NULL,
  sale_date TIMESTAMP WITH TIME ZONE NOT NULL,
  invoice_number TEXT NOT NULL,
  notes TEXT,
  status TEXT DEFAULT 'completed' CHECK (status IN ('pending', 'completed', 'cancelled')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Stock table (current inventory levels)
CREATE TABLE stock (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  product_id UUID REFERENCES products(id) ON DELETE CASCADE UNIQUE,
  current_quantity DECIMAL NOT NULL DEFAULT 0,
  reserved_quantity DECIMAL NOT NULL DEFAULT 0,
  available_quantity DECIMAL NOT NULL DEFAULT 0,
  minimum_stock_level DECIMAL NOT NULL DEFAULT 10,
  maximum_stock_level DECIMAL NOT NULL DEFAULT 1000,
  last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  location TEXT NOT NULL DEFAULT 'Main Warehouse',
  batch_number TEXT,
  expiry_date TIMESTAMP WITH TIME ZONE
);

-- Stock movements table (audit trail)
CREATE TABLE stock_movements (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  product_id UUID REFERENCES products(id) ON DELETE CASCADE,
  transaction_type TEXT NOT NULL CHECK (transaction_type IN ('purchase', 'sale', 'adjustment', 'transfer')),
  transaction_id UUID NOT NULL,
  quantity DECIMAL NOT NULL,
  previous_quantity DECIMAL NOT NULL,
  new_quantity DECIMAL NOT NULL,
  reason TEXT NOT NULL,
  movement_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  notes TEXT,
  user_id UUID REFERENCES auth.users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 3. CREATE INDEXES (Performance Optimization)
-- =====================================================

-- User indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_profiles_full_name ON profiles(full_name);

-- Product indexes
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_name ON products(name);

-- Purchase indexes
CREATE INDEX idx_purchases_product_id ON purchases(product_id);
CREATE INDEX idx_purchases_date ON purchases(purchase_date);
CREATE INDEX idx_purchases_supplier ON purchases(supplier_name);

-- Sales indexes
CREATE INDEX idx_sales_product_id ON sales(product_id);
CREATE INDEX idx_sales_date ON sales(sale_date);
CREATE INDEX idx_sales_customer ON sales(customer_name);

-- Stock indexes
CREATE INDEX idx_stock_product_id ON stock(product_id);
CREATE INDEX idx_stock_location ON stock(location);

-- Stock movement indexes
CREATE INDEX idx_stock_movements_product_id ON stock_movements(product_id);
CREATE INDEX idx_stock_movements_date ON stock_movements(movement_date);
CREATE INDEX idx_stock_movements_type ON stock_movements(transaction_type);

-- =====================================================
-- 4. ENABLE ROW LEVEL SECURITY (RLS)
-- =====================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_movements ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- 5. CREATE RLS POLICIES (Security Rules)
-- =====================================================

-- Profiles table policies (Supabase standard)
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Users table policies (backward compatibility)
CREATE POLICY "Users can view own user record" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own user record" ON users
  FOR UPDATE USING (auth.uid() = id);

-- All authenticated users can manage inventory data
CREATE POLICY "Authenticated users can manage products" ON products
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can manage purchases" ON purchases
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can manage sales" ON sales
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can manage stock" ON stock
  FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can manage stock movements" ON stock_movements
  FOR ALL USING (auth.role() = 'authenticated');

-- =====================================================
-- 6. CREATE ANALYTICS FUNCTIONS
-- =====================================================

-- Function: Get total purchases by date range
CREATE OR REPLACE FUNCTION get_total_purchases_by_date_range(
  start_date TIMESTAMP WITH TIME ZONE,
  end_date TIMESTAMP WITH TIME ZONE
)
RETURNS TABLE (
  date DATE,
  total DECIMAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    DATE(purchase_date) as date,
    SUM(total_amount) as total
  FROM purchases 
  WHERE purchase_date BETWEEN start_date AND end_date
  GROUP BY DATE(purchase_date)
  ORDER BY date;
END;
$$ LANGUAGE plpgsql;

-- Function: Get total sales by date range
CREATE OR REPLACE FUNCTION get_total_sales_by_date_range(
  start_date TIMESTAMP WITH TIME ZONE,
  end_date TIMESTAMP WITH TIME ZONE
)
RETURNS TABLE (
  date DATE,
  total DECIMAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    DATE(sale_date) as date,
    SUM(total_amount) as total
  FROM sales 
  WHERE sale_date BETWEEN start_date AND end_date
  GROUP BY DATE(sale_date)
  ORDER BY date;
END;
$$ LANGUAGE plpgsql;

-- Function: Get low stock products
CREATE OR REPLACE FUNCTION get_low_stock_products()
RETURNS TABLE (
  name TEXT,
  category TEXT,
  unit TEXT,
  available_quantity DECIMAL,
  minimum_stock_level DECIMAL
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    p.name,
    p.category,
    p.unit,
    s.available_quantity,
    s.minimum_stock_level
  FROM products p
  JOIN stock s ON p.id = s.product_id
  WHERE s.available_quantity <= s.minimum_stock_level
  ORDER BY s.available_quantity ASC;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- 7. CREATE TRIGGER FUNCTIONS
-- =====================================================

-- Function: Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function: Handle new user signup (creates profile automatically)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, role, phone, department)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
    COALESCE(NEW.raw_user_meta_data->>'role', 'operator'),
    NEW.raw_user_meta_data->>'phone',
    NEW.raw_user_meta_data->>'department'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function: Update stock on transaction
CREATE OR REPLACE FUNCTION update_stock_on_transaction()
RETURNS TRIGGER AS $$
DECLARE
  current_stock DECIMAL;
  new_quantity DECIMAL;
  transaction_type TEXT;
BEGIN
  -- Determine transaction type and quantity change
  IF TG_TABLE_NAME = 'purchases' THEN
    transaction_type := 'purchase';
    new_quantity := NEW.quantity;
  ELSIF TG_TABLE_NAME = 'sales' THEN
    transaction_type := 'sale';
    new_quantity := -NEW.quantity;
  END IF;

  -- Get current stock
  SELECT current_quantity INTO current_stock
  FROM stock
  WHERE product_id = NEW.product_id;

  -- Update stock
  INSERT INTO stock (product_id, current_quantity, available_quantity, last_updated)
  VALUES (NEW.product_id, COALESCE(current_stock, 0) + new_quantity, COALESCE(current_stock, 0) + new_quantity, NOW())
  ON CONFLICT (product_id)
  DO UPDATE SET
    current_quantity = stock.current_quantity + new_quantity,
    available_quantity = stock.available_quantity + new_quantity,
    last_updated = NOW();

  -- Record stock movement
  INSERT INTO stock_movements (
    product_id,
    transaction_type,
    transaction_id,
    quantity,
    previous_quantity,
    new_quantity,
    reason,
    user_id
  ) VALUES (
    NEW.product_id,
    transaction_type,
    NEW.id,
    ABS(new_quantity),
    COALESCE(current_stock, 0),
    COALESCE(current_stock, 0) + new_quantity,
    CASE 
      WHEN transaction_type = 'purchase' THEN 'Purchase from ' || COALESCE(NEW.supplier_name, 'Unknown Supplier')
      WHEN transaction_type = 'sale' THEN 'Sale to ' || COALESCE(NEW.customer_name, 'Unknown Customer')
      ELSE 'Stock adjustment'
    END,
    auth.uid()
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- 8. CREATE TRIGGERS
-- =====================================================

-- Triggers for updated_at timestamp
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_purchases_updated_at BEFORE UPDATE ON purchases
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_sales_updated_at BEFORE UPDATE ON sales
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Trigger for automatic profile creation on user signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Triggers for automatic stock updates
CREATE TRIGGER update_stock_on_purchase AFTER INSERT ON purchases
  FOR EACH ROW EXECUTE FUNCTION update_stock_on_transaction();

CREATE TRIGGER update_stock_on_sale AFTER INSERT ON sales
  FOR EACH ROW EXECUTE FUNCTION update_stock_on_transaction();

-- =====================================================
-- 9. VERIFICATION QUERIES
-- =====================================================

-- Verify all tables are created
SELECT 
  'Tables Created:' as status,
  COUNT(*) as count
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name IN ('profiles', 'users', 'products', 'purchases', 'sales', 'stock', 'stock_movements');

-- Verify RLS is enabled
SELECT 
  'RLS Enabled:' as status,
  COUNT(*) as count
FROM pg_tables 
WHERE schemaname = 'public' 
  AND tablename IN ('profiles', 'users', 'products', 'purchases', 'sales', 'stock', 'stock_movements')
  AND rowsecurity = true;

-- Verify functions are created
SELECT 
  'Functions Created:' as status,
  COUNT(*) as count
FROM information_schema.routines 
WHERE routine_schema = 'public' 
  AND routine_name IN (
    'get_total_purchases_by_date_range',
    'get_total_sales_by_date_range',
    'get_low_stock_products',
    'update_updated_at_column',
    'update_stock_on_transaction',
    'handle_new_user'
  );

-- Verify triggers are created
SELECT 
  'Triggers Created:' as status,
  COUNT(*) as count
FROM information_schema.triggers 
WHERE trigger_schema = 'public'
  AND event_object_table IN ('profiles', 'users', 'products', 'purchases', 'sales');

-- =====================================================
-- 10. SUCCESS MESSAGE
-- =====================================================

SELECT 
  '🎉 Steel Factory Inventory Database Schema Created Successfully!' as message,
  'All tables, functions, triggers, and policies are ready!' as details,
  'You can now run your Flutter app and start using the system.' as next_step;

-- =====================================================
-- END OF SCHEMA
-- =====================================================

-- Test Supabase Setup Script
-- Run this in your Supabase SQL Editor to verify everything is working

-- Test 1: Check if all tables exist
SELECT 
  table_name,
  table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name IN ('users', 'products', 'purchases', 'sales', 'stock', 'stock_movements')
ORDER BY table_name;

-- Test 2: Check if RLS is enabled
SELECT 
  schemaname,
  tablename,
  rowsecurity
FROM pg_tables 
WHERE schemaname = 'public' 
  AND tablename IN ('users', 'products', 'purchases', 'sales', 'stock', 'stock_movements');

-- Test 3: Check if functions exist
SELECT 
  routine_name,
  routine_type
FROM information_schema.routines 
WHERE routine_schema = 'public' 
  AND routine_name IN (
    'get_total_purchases_by_date_range',
    'get_total_sales_by_date_range',
    'get_low_stock_products',
    'update_updated_at_column',
    'update_stock_on_transaction'
  );

-- Test 4: Check if triggers exist
SELECT 
  trigger_name,
  event_object_table,
  action_timing,
  event_manipulation
FROM information_schema.triggers 
WHERE trigger_schema = 'public'
ORDER BY event_object_table, trigger_name;

-- Test 5: Check if indexes exist
SELECT 
  indexname,
  tablename,
  indexdef
FROM pg_indexes 
WHERE schemaname = 'public' 
  AND tablename IN ('users', 'products', 'purchases', 'sales', 'stock', 'stock_movements')
ORDER BY tablename, indexname;

-- Test 6: Insert a test product (this will be cleaned up)
INSERT INTO products (name, description, category, unit, grade) 
VALUES ('Test Steel Bar', 'Test product for setup verification', 'Steel Bars', 'pieces', 'Grade A')
RETURNING id, name, created_at;

-- Test 7: Check if the test product was inserted
SELECT id, name, category, created_at FROM products WHERE name = 'Test Steel Bar';

-- Test 8: Clean up test data
DELETE FROM products WHERE name = 'Test Steel Bar';

-- Test 9: Verify cleanup
SELECT COUNT(*) as remaining_test_products FROM products WHERE name = 'Test Steel Bar';

-- If all tests pass, your Supabase setup is complete!
-- You should see:
-- - 6 tables created
-- - RLS enabled on all tables
-- - 5 functions created
-- - Multiple triggers created
-- - Multiple indexes created
-- - Test product inserted and cleaned up successfully

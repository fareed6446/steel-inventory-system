-- Fix the trigger error for sales/purchases
-- Run this in your Supabase SQL Editor

-- Drop and recreate the trigger function with proper field handling
DROP FUNCTION IF EXISTS update_stock_on_transaction() CASCADE;

CREATE OR REPLACE FUNCTION update_stock_on_transaction()
RETURNS TRIGGER AS $$
DECLARE
  current_stock DECIMAL;
  new_quantity DECIMAL;
  transaction_type TEXT;
  transaction_description TEXT;
BEGIN
  -- Determine transaction type and quantity change
  IF TG_TABLE_NAME = 'purchases' THEN
    transaction_type := 'purchase';
    new_quantity := NEW.quantity;
    transaction_description := 'Purchase from ' || COALESCE(NEW.supplier_name, 'Unknown Supplier');
  ELSIF TG_TABLE_NAME = 'sales' THEN
    transaction_type := 'sale';
    new_quantity := -NEW.quantity;
    transaction_description := 'Sale to ' || COALESCE(NEW.customer_name, 'Unknown Customer');
  ELSE
    transaction_type := 'adjustment';
    new_quantity := 0;
    transaction_description := 'Stock adjustment';
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
    transaction_description,
    auth.uid()
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Recreate the triggers
DROP TRIGGER IF EXISTS update_stock_on_purchase ON purchases;
CREATE TRIGGER update_stock_on_purchase 
  AFTER INSERT ON purchases
  FOR EACH ROW EXECUTE FUNCTION update_stock_on_transaction();

DROP TRIGGER IF EXISTS update_stock_on_sale ON sales;
CREATE TRIGGER update_stock_on_sale 
  AFTER INSERT ON sales
  FOR EACH ROW EXECUTE FUNCTION update_stock_on_transaction();

-- Success message
SELECT 'Trigger fixed successfully!' as message,
       'Sales and purchases should now work without errors.' as details;

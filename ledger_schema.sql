-- =====================================================
-- Steel Factory Inventory Management System
-- Ledger (Account Statement) System Schema
-- =====================================================
-- 
-- This file contains the complete database schema for the
-- Ledger system that integrates with the existing parties system.
-- 
-- Run this entire script in your Supabase SQL Editor.
-- =====================================================

-- =====================================================
-- 1. CLEANUP EXISTING TABLES (if any)
-- =====================================================

-- Drop existing views first
DROP VIEW IF EXISTS ledger_detailed CASCADE;

-- Drop existing tables in correct order (due to foreign keys)
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS persons CASCADE;

-- =====================================================
-- 2. CREATE TABLES
-- =====================================================

-- Persons table (extends existing parties concept)
CREATE TABLE persons (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  opening_balance DECIMAL(15,2) DEFAULT 0.00,
  currency TEXT DEFAULT 'PKR',
  contact_info JSONB, -- Store email, phone, address as JSON
  business_type TEXT CHECK (business_type IN ('supplier', 'customer', 'both')),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Transactions table (comprehensive transaction tracking)
CREATE TABLE transactions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  person_id UUID REFERENCES persons(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('sale', 'purchase', 'payment_received', 'payment_given')),
  amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
  description TEXT NOT NULL,
  reference_number TEXT, -- Invoice number, receipt number, etc.
  related_transaction_id UUID, -- Link to related purchase/sale if this is a payment
  currency TEXT DEFAULT 'PKR',
  transaction_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 3. CREATE INDEXES FOR PERFORMANCE
-- =====================================================

-- Indexes for persons table
CREATE INDEX idx_persons_name ON persons(name);
CREATE INDEX idx_persons_business_type ON persons(business_type);
CREATE INDEX idx_persons_is_active ON persons(is_active);
CREATE INDEX idx_persons_created_at ON persons(created_at);

-- Indexes for transactions table
CREATE INDEX idx_transactions_person_id ON transactions(person_id);
CREATE INDEX idx_transactions_type ON transactions(type);
CREATE INDEX idx_transactions_transaction_date ON transactions(transaction_date);
CREATE INDEX idx_transactions_created_at ON transactions(created_at);
CREATE INDEX idx_transactions_person_date ON transactions(person_id, transaction_date);

-- =====================================================
-- 4. CREATE FUNCTIONS
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Drop existing function first
DROP FUNCTION IF EXISTS calculate_running_balance(UUID, TIMESTAMP WITH TIME ZONE);

-- Function to calculate running balance
CREATE OR REPLACE FUNCTION calculate_running_balance(
  p_person_id UUID,
  p_transaction_date TIMESTAMP WITH TIME ZONE
) RETURNS DECIMAL(15,2) AS $$
DECLARE
  v_opening_balance DECIMAL(15,2);
  total_credit DECIMAL(15,2);
  total_debit DECIMAL(15,2);
BEGIN
  -- Get opening balance
  SELECT COALESCE(persons.opening_balance, 0) INTO v_opening_balance
  FROM persons WHERE id = p_person_id;
  
  -- Calculate total credits (sales + payments received) up to this date
  SELECT COALESCE(SUM(amount), 0) INTO total_credit
  FROM transactions
  WHERE person_id = p_person_id
    AND type IN ('sale', 'payment_received')
    AND transaction_date <= p_transaction_date;
  
  -- Calculate total debits (purchases + payments given) up to this date
  SELECT COALESCE(SUM(amount), 0) INTO total_debit
  FROM transactions
  WHERE person_id = p_person_id
    AND type IN ('purchase', 'payment_given')
    AND transaction_date <= p_transaction_date;
  
  RETURN v_opening_balance + total_credit - total_debit;
END;
$$ LANGUAGE plpgsql;

-- Function to get person summary
CREATE OR REPLACE FUNCTION get_person_summary(p_person_id UUID)
RETURNS TABLE (
  opening_balance DECIMAL(15,2),
  total_sales DECIMAL(15,2),
  total_purchases DECIMAL(15,2),
  total_payments_received DECIMAL(15,2),
  total_payments_given DECIMAL(15,2),
  remaining_balance DECIMAL(15,2),
  transaction_count BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    COALESCE(p.opening_balance, 0) as opening_balance,
    COALESCE(SUM(CASE WHEN t.type = 'sale' THEN t.amount ELSE 0 END), 0) as total_sales,
    COALESCE(SUM(CASE WHEN t.type = 'purchase' THEN t.amount ELSE 0 END), 0) as total_purchases,
    COALESCE(SUM(CASE WHEN t.type = 'payment_received' THEN t.amount ELSE 0 END), 0) as total_payments_received,
    COALESCE(SUM(CASE WHEN t.type = 'payment_given' THEN t.amount ELSE 0 END), 0) as total_payments_given,
    COALESCE(p.opening_balance, 0) + 
    COALESCE(SUM(CASE WHEN t.type IN ('sale', 'payment_received') THEN t.amount ELSE 0 END), 0) - 
    COALESCE(SUM(CASE WHEN t.type IN ('purchase', 'payment_given') THEN t.amount ELSE 0 END), 0) as remaining_balance,
    COUNT(t.id) as transaction_count
  FROM persons p
  LEFT JOIN transactions t ON p.id = t.person_id
  WHERE p.id = p_person_id
  GROUP BY p.id, p.opening_balance;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- 5. CREATE TRIGGERS
-- =====================================================

-- Trigger to update updated_at for persons
CREATE TRIGGER update_persons_updated_at
  BEFORE UPDATE ON persons
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Trigger to update updated_at for transactions
CREATE TRIGGER update_transactions_updated_at
  BEFORE UPDATE ON transactions
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 6. CREATE VIEWS
-- =====================================================

-- Main ledger detailed view
CREATE VIEW ledger_detailed AS
SELECT 
  t.id as transaction_id,
  p.id as person_id,
  p.name as person_name,
  t.transaction_date as created_at,
  t.type,
  t.description,
  t.reference_number,
  t.amount,
  -- Debit column (purchases + payments given)
  CASE 
    WHEN t.type IN ('purchase', 'payment_given') THEN t.amount 
    ELSE 0 
  END as debit,
  -- Credit column (sales + payments received)
  CASE 
    WHEN t.type IN ('sale', 'payment_received') THEN t.amount 
    ELSE 0 
  END as credit,
  -- Running balance calculation
  calculate_running_balance(p.id, t.transaction_date) as running_balance,
  t.currency
FROM persons p
INNER JOIN transactions t ON p.id = t.person_id
WHERE p.is_active = true
ORDER BY p.name, t.transaction_date ASC, t.created_at ASC;

-- Summary view for all persons
CREATE VIEW persons_summary AS
SELECT 
  p.id,
  p.name,
  p.business_type,
  p.is_active,
  COALESCE(p.opening_balance, 0) as opening_balance,
  COALESCE(SUM(CASE WHEN t.type = 'sale' THEN t.amount ELSE 0 END), 0) as total_sales,
  COALESCE(SUM(CASE WHEN t.type = 'purchase' THEN t.amount ELSE 0 END), 0) as total_purchases,
  COALESCE(SUM(CASE WHEN t.type = 'payment_received' THEN t.amount ELSE 0 END), 0) as total_payments_received,
  COALESCE(SUM(CASE WHEN t.type = 'payment_given' THEN t.amount ELSE 0 END), 0) as total_payments_given,
  COALESCE(p.opening_balance, 0) + 
  COALESCE(SUM(CASE WHEN t.type IN ('sale', 'payment_received') THEN t.amount ELSE 0 END), 0) - 
  COALESCE(SUM(CASE WHEN t.type IN ('purchase', 'payment_given') THEN t.amount ELSE 0 END), 0) as remaining_balance,
  COUNT(t.id) as transaction_count,
  p.created_at
FROM persons p
LEFT JOIN transactions t ON p.id = t.person_id
GROUP BY p.id, p.name, p.business_type, p.is_active, p.opening_balance, p.created_at
ORDER BY p.name;

-- =====================================================
-- 7. ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Enable RLS on tables
ALTER TABLE persons ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

-- RLS policies for persons
CREATE POLICY "Allow all authenticated users to view persons" ON persons
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Allow all authenticated users to insert persons" ON persons
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Allow all authenticated users to update persons" ON persons
  FOR UPDATE TO authenticated USING (true);

CREATE POLICY "Allow all authenticated users to delete persons" ON persons
  FOR DELETE TO authenticated USING (true);

-- RLS policies for transactions
CREATE POLICY "Allow all authenticated users to view transactions" ON transactions
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Allow all authenticated users to insert transactions" ON transactions
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Allow all authenticated users to update transactions" ON transactions
  FOR UPDATE TO authenticated USING (true);

CREATE POLICY "Allow all authenticated users to delete transactions" ON transactions
  FOR DELETE TO authenticated USING (true);

-- =====================================================
-- 8. SAMPLE DATA
-- =====================================================

-- Insert sample persons
INSERT INTO persons (name, opening_balance, business_type, contact_info) VALUES
('ABC Steel Works', 50000.00, 'supplier', '{"email": "info@abcsteel.com", "phone": "+92-300-1234567", "address": "Industrial Area, Karachi"}'),
('XYZ Construction', 25000.00, 'customer', '{"email": "contact@xyzconstruction.com", "phone": "+92-301-9876543", "address": "Gulshan-e-Iqbal, Karachi"}'),
('Metro Steel Suppliers', 75000.00, 'supplier', '{"email": "sales@metrosteel.com", "phone": "+92-302-5555555", "address": "SITE Area, Karachi"}'),
('Premium Builders Ltd', 0.00, 'customer', '{"email": "info@premiumbuilders.com", "phone": "+92-303-7777777", "address": "DHA Phase 2, Karachi"}');

-- Insert sample transactions
INSERT INTO transactions (person_id, type, amount, description, reference_number, transaction_date) VALUES
-- ABC Steel Works transactions
((SELECT id FROM persons WHERE name = 'ABC Steel Works'), 'payment_received', 100000.00, 'Payment for steel rods delivery', 'INV-2024-001', '2024-01-15 10:30:00'),
((SELECT id FROM persons WHERE name = 'ABC Steel Works'), 'purchase', 25000.00, 'Purchase of raw materials', 'PO-2024-001', '2024-01-16 14:20:00'),
((SELECT id FROM persons WHERE name = 'ABC Steel Works'), 'payment_given', 15000.00, 'Payment to supplier', 'PAY-2024-001', '2024-01-17 09:15:00'),

-- XYZ Construction transactions
((SELECT id FROM persons WHERE name = 'XYZ Construction'), 'sale', 85000.00, 'Sale of steel beams', 'INV-2024-002', '2024-01-18 11:45:00'),
((SELECT id FROM persons WHERE name = 'XYZ Construction'), 'payment_received', 50000.00, 'Partial payment for steel beams', 'PAY-2024-002', '2024-01-19 16:30:00'),
((SELECT id FROM persons WHERE name = 'XYZ Construction'), 'purchase', 12000.00, 'Purchase of tools', 'PO-2024-002', '2024-01-20 08:00:00'),

-- Metro Steel Suppliers transactions
((SELECT id FROM persons WHERE name = 'Metro Steel Suppliers'), 'payment_received', 200000.00, 'Payment for bulk steel order', 'INV-2024-003', '2024-01-21 13:20:00'),
((SELECT id FROM persons WHERE name = 'Metro Steel Suppliers'), 'sale', 150000.00, 'Sale of steel sheets', 'INV-2024-004', '2024-01-22 15:45:00'),

-- Premium Builders Ltd transactions
((SELECT id FROM persons WHERE name = 'Premium Builders Ltd'), 'sale', 95000.00, 'Sale of construction materials', 'INV-2024-005', '2024-01-23 10:15:00'),
((SELECT id FROM persons WHERE name = 'Premium Builders Ltd'), 'payment_received', 45000.00, 'Advance payment', 'PAY-2024-003', '2024-01-24 14:30:00');

-- =====================================================
-- 9. VERIFICATION QUERIES
-- =====================================================

-- Test the ledger_detailed view
-- SELECT * FROM ledger_detailed WHERE person_name = 'ABC Steel Works' ORDER BY created_at;

-- Test the persons_summary view
-- SELECT * FROM persons_summary ORDER BY name;

-- Test the summary function
-- SELECT * FROM get_person_summary((SELECT id FROM persons WHERE name = 'ABC Steel Works'));

-- =====================================================
-- SCHEMA CREATION COMPLETE
-- =====================================================

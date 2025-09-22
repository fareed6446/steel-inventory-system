-- =====================================================
-- UNIFIED PARTY-LEDGER INTEGRATION SCHEMA
-- =====================================================
-- This schema integrates the existing parties system with the ledger system

-- =====================================================
-- 1. UPDATE EXISTING PARTIES TABLE
-- =====================================================

-- Add ledger-related fields to existing parties table
ALTER TABLE parties ADD COLUMN IF NOT EXISTS opening_balance DECIMAL(15,2) DEFAULT 0.00;
ALTER TABLE parties ADD COLUMN IF NOT EXISTS currency TEXT DEFAULT 'PKR';

-- =====================================================
-- 2. CREATE UNIFIED TRANSACTIONS TABLE
-- =====================================================

-- Create a unified transactions table that handles both inventory and ledger transactions
CREATE TABLE IF NOT EXISTS unified_transactions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  party_id UUID REFERENCES parties(id) ON DELETE CASCADE,
  
  -- Transaction classification
  transaction_category TEXT NOT NULL CHECK (transaction_category IN (
    'purchase', 'sale', 'payment_received', 'payment_given', 'stock_adjustment'
  )),
  
  -- Related transaction references (for linking purchases/sales to payments)
  related_purchase_id UUID REFERENCES purchases(id),
  related_sale_id UUID REFERENCES sales(id),
  
  -- Transaction details
  amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
  description TEXT NOT NULL,
  reference_number TEXT,
  transaction_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Additional fields
  currency TEXT DEFAULT 'PKR',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 3. UPDATE LEDGER VIEWS TO USE UNIFIED SYSTEM
-- =====================================================

-- Drop existing ledger_detailed view
DROP VIEW IF EXISTS ledger_detailed CASCADE;

-- Create new unified ledger view
CREATE VIEW ledger_detailed AS
SELECT 
  ut.id as transaction_id,
  p.id as person_id,
  p.name as person_name,
  ut.transaction_date as created_at,
  ut.transaction_category as type,
  ut.description,
  ut.reference_number,
  ut.amount,
  -- Debit column (purchases + payments given)
  CASE 
    WHEN ut.transaction_category IN ('purchase', 'payment_given') THEN ut.amount 
    ELSE 0 
  END as debit,
  -- Credit column (sales + payments received)
  CASE 
    WHEN ut.transaction_category IN ('sale', 'payment_received') THEN ut.amount 
    ELSE 0 
  END as credit,
  -- Running balance calculation
  calculate_running_balance(p.id, ut.transaction_date) as running_balance,
  ut.currency
FROM parties p
INNER JOIN unified_transactions ut ON p.id = ut.party_id
WHERE p.is_active = true
ORDER BY p.name, ut.transaction_date ASC, ut.created_at ASC;

-- =====================================================
-- 4. CREATE TRIGGERS FOR AUTOMATIC LEDGER ENTRIES
-- =====================================================

-- Drop existing triggers first
DROP TRIGGER IF EXISTS trigger_create_purchase_ledger ON purchases;
DROP TRIGGER IF EXISTS trigger_create_sale_ledger ON sales;

-- Trigger to create ledger entry when purchase is created
CREATE OR REPLACE FUNCTION create_purchase_ledger_entry()
RETURNS TRIGGER AS $$
DECLARE
  supplier_party_id UUID;
BEGIN
  -- Find or create supplier party
  SELECT id INTO supplier_party_id 
  FROM parties 
  WHERE name = NEW.supplier_name AND type = 'supplier';
  
  IF supplier_party_id IS NULL THEN
    -- Create new supplier party
    INSERT INTO parties (name, type, email, phone, is_active)
    VALUES (NEW.supplier_name, 'supplier', 
            CASE WHEN NEW.supplier_contact LIKE '%@%' THEN NEW.supplier_contact ELSE NULL END,
            CASE WHEN NEW.supplier_contact LIKE '%@%' THEN NULL ELSE NEW.supplier_contact END,
            true)
    RETURNING id INTO supplier_party_id;
  END IF;

  INSERT INTO unified_transactions (
    party_id,
    transaction_category,
    related_purchase_id,
    amount,
    description,
    reference_number,
    transaction_date
  ) VALUES (
    supplier_party_id,
    'purchase',
    NEW.id,
    NEW.total_amount,
    'Purchase: ' || COALESCE(NEW.invoice_number, 'No Invoice'),
    NEW.invoice_number,
    NEW.purchase_date
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_create_purchase_ledger
  AFTER INSERT ON purchases
  FOR EACH ROW
  EXECUTE FUNCTION create_purchase_ledger_entry();

-- Trigger to create ledger entry when sale is created
CREATE OR REPLACE FUNCTION create_sale_ledger_entry()
RETURNS TRIGGER AS $$
DECLARE
  customer_party_id UUID;
BEGIN
  -- Find or create customer party
  SELECT id INTO customer_party_id 
  FROM parties 
  WHERE name = NEW.customer_name AND type = 'customer';
  
  IF customer_party_id IS NULL THEN
    -- Create new customer party
    INSERT INTO parties (name, type, email, phone, is_active)
    VALUES (NEW.customer_name, 'customer', 
            CASE WHEN NEW.customer_contact LIKE '%@%' THEN NEW.customer_contact ELSE NULL END,
            CASE WHEN NEW.customer_contact LIKE '%@%' THEN NULL ELSE NEW.customer_contact END,
            true)
    RETURNING id INTO customer_party_id;
  END IF;

  INSERT INTO unified_transactions (
    party_id,
    transaction_category,
    related_sale_id,
    amount,
    description,
    reference_number,
    transaction_date
  ) VALUES (
    customer_party_id,
    'sale',
    NEW.id,
    NEW.total_amount,
    'Sale: ' || COALESCE(NEW.invoice_number, 'No Invoice'),
    NEW.invoice_number,
    NEW.sale_date
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_create_sale_ledger
  AFTER INSERT ON sales
  FOR EACH ROW
  EXECUTE FUNCTION create_sale_ledger_entry();

-- =====================================================
-- 5. UPDATE FUNCTIONS TO WORK WITH PARTIES
-- =====================================================

-- Drop existing function first (with CASCADE to drop dependent views)
DROP FUNCTION IF EXISTS calculate_running_balance(UUID, TIMESTAMP WITH TIME ZONE) CASCADE;

-- Update calculate_running_balance function to work with parties table
CREATE OR REPLACE FUNCTION calculate_running_balance(
  p_party_id UUID,
  p_transaction_date TIMESTAMP WITH TIME ZONE
) RETURNS DECIMAL(15,2) AS $$
DECLARE
  v_opening_balance DECIMAL(15,2);
  total_credit DECIMAL(15,2);
  total_debit DECIMAL(15,2);
BEGIN
  -- Get opening balance from parties table
  SELECT COALESCE(parties.opening_balance, 0) INTO v_opening_balance
  FROM parties WHERE id = p_party_id;
  
  -- Calculate total credits (sales + payments received) up to this date
  SELECT COALESCE(SUM(amount), 0) INTO total_credit
  FROM unified_transactions
  WHERE party_id = p_party_id
    AND transaction_category IN ('sale', 'payment_received')
    AND transaction_date <= p_transaction_date;
  
  -- Calculate total debits (purchases + payments given) up to this date
  SELECT COALESCE(SUM(amount), 0) INTO total_debit
  FROM unified_transactions
  WHERE party_id = p_party_id
    AND transaction_category IN ('purchase', 'payment_given')
    AND transaction_date <= p_transaction_date;
  
  RETURN v_opening_balance + total_credit - total_debit;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- 6. CREATE UNIFIED PARTIES SUMMARY VIEW
-- =====================================================

CREATE VIEW parties_ledger_summary AS
SELECT 
  p.id,
  p.name,
  p.type as business_type,
  p.is_active,
  COALESCE(p.opening_balance, 0) as opening_balance,
  COALESCE(SUM(CASE WHEN ut.transaction_category = 'sale' THEN ut.amount ELSE 0 END), 0) as total_sales,
  COALESCE(SUM(CASE WHEN ut.transaction_category = 'purchase' THEN ut.amount ELSE 0 END), 0) as total_purchases,
  COALESCE(SUM(CASE WHEN ut.transaction_category = 'payment_received' THEN ut.amount ELSE 0 END), 0) as total_payments_received,
  COALESCE(SUM(CASE WHEN ut.transaction_category = 'payment_given' THEN ut.amount ELSE 0 END), 0) as total_payments_given,
  COALESCE(p.opening_balance, 0) + 
  COALESCE(SUM(CASE WHEN ut.transaction_category IN ('sale', 'payment_received') THEN ut.amount ELSE 0 END), 0) - 
  COALESCE(SUM(CASE WHEN ut.transaction_category IN ('purchase', 'payment_given') THEN ut.amount ELSE 0 END), 0) as remaining_balance,
  COUNT(ut.id) as transaction_count,
  p.created_at
FROM parties p
LEFT JOIN unified_transactions ut ON p.id = ut.party_id
GROUP BY p.id, p.name, p.type, p.is_active, p.opening_balance, p.created_at
ORDER BY p.name;

-- =====================================================
-- 7. SAMPLE DATA MIGRATION
-- =====================================================

-- Insert sample unified transactions for existing parties
-- (This would be run after the schema is updated)

-- =====================================================
-- INTEGRATION COMPLETE
-- =====================================================

-- =====================================================
-- COMPLETE SUPABASE SCHEMA FOR STEEL INVENTORY SYSTEM
-- =====================================================
-- This file contains all database structures needed for the inventory management system
-- Run this entire file in your Supabase SQL Editor

-- =====================================================
-- 1. DROP EXISTING OBJECTS (if any)
-- =====================================================

-- Drop existing triggers first
DROP TRIGGER IF EXISTS trigger_create_purchase_ledger ON purchases;
DROP TRIGGER IF EXISTS trigger_create_sale_ledger ON sales;

-- Drop existing functions
DROP FUNCTION IF EXISTS calculate_running_balance(UUID, TIMESTAMP WITH TIME ZONE) CASCADE;
DROP FUNCTION IF EXISTS get_person_summary(UUID) CASCADE;

-- Drop existing views and tables
DROP VIEW IF EXISTS ledger_detailed CASCADE;
DROP TABLE IF EXISTS unified_transactions CASCADE;
DROP VIEW IF EXISTS unified_transactions CASCADE;

-- Drop existing tables (in reverse dependency order)
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS persons CASCADE;
DROP TABLE IF EXISTS purchases CASCADE;
DROP TABLE IF EXISTS sales CASCADE;
DROP TABLE IF EXISTS stock_movements CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS parties CASCADE;

-- =====================================================
-- 2. CREATE CORE TABLES
-- =====================================================

-- Parties table (suppliers and customers)
CREATE TABLE parties (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('supplier', 'customer')),
    email VARCHAR(255),
    phone VARCHAR(20),
    address TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Products table
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    unit VARCHAR(50) NOT NULL,
    category VARCHAR(100),
    current_stock DECIMAL(15,2) DEFAULT 0,
    min_stock_level DECIMAL(15,2) DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Purchases table
CREATE TABLE purchases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    supplier_name VARCHAR(255) NOT NULL,
    supplier_contact VARCHAR(255),
    invoice_number VARCHAR(100),
    purchase_date DATE NOT NULL,
    total_amount DECIMAL(15,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'cancelled')),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Sales table
CREATE TABLE sales (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_name VARCHAR(255) NOT NULL,
    customer_contact VARCHAR(255),
    invoice_number VARCHAR(100),
    sale_date DATE NOT NULL,
    total_amount DECIMAL(15,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'cancelled')),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Stock movements table
CREATE TABLE stock_movements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    movement_type VARCHAR(50) NOT NULL CHECK (movement_type IN ('purchase', 'sale', 'adjustment')),
    quantity DECIMAL(15,2) NOT NULL,
    reference_id UUID, -- Can reference purchase_id or sale_id
    reference_type VARCHAR(50), -- 'purchase' or 'sale'
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 3. CREATE LEDGER SYSTEM TABLES
-- =====================================================

-- Persons table (for ledger system)
CREATE TABLE persons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    opening_balance DECIMAL(15,2) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Transactions table (for ledger system)
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id UUID NOT NULL REFERENCES persons(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL CHECK (type IN ('sale', 'purchase', 'payment_received', 'payment_given')),
    amount DECIMAL(15,2) NOT NULL,
    description TEXT,
    transaction_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- 4. CREATE UNIFIED TRANSACTIONS VIEW
-- =====================================================

-- Create unified transactions view that combines all transaction types
CREATE VIEW unified_transactions AS
SELECT 
    p.id as party_id,
    p.name as party_name,
    p.type as party_type,
    'purchase' as transaction_category,
    pr.id as related_purchase_id,
    NULL::UUID as related_sale_id,
    pr.total_amount as amount,
    'Purchase: ' || COALESCE(pr.invoice_number, 'No Invoice') as description,
    pr.invoice_number as reference_number,
    pr.purchase_date as transaction_date,
    pr.created_at
FROM parties p
INNER JOIN purchases pr ON p.name = pr.supplier_name AND p.type = 'supplier'

UNION ALL

SELECT 
    p.id as party_id,
    p.name as party_name,
    p.type as party_type,
    'sale' as transaction_category,
    NULL::UUID as related_purchase_id,
    s.id as related_sale_id,
    s.total_amount as amount,
    'Sale: ' || COALESCE(s.invoice_number, 'No Invoice') as description,
    s.invoice_number as reference_number,
    s.sale_date as transaction_date,
    s.created_at
FROM parties p
INNER JOIN sales s ON p.name = s.customer_name AND p.type = 'customer'

UNION ALL

SELECT 
    t.person_id as party_id,
    p.name as party_name,
    'customer' as party_type, -- Assuming persons are customers for now
    t.type as transaction_category,
    NULL::UUID as related_purchase_id,
    NULL::UUID as related_sale_id,
    t.amount,
    t.description,
    NULL::VARCHAR as reference_number,
    t.transaction_date,
    t.created_at
FROM transactions t
INNER JOIN persons p ON t.person_id = p.id;

-- =====================================================
-- 5. CREATE FUNCTIONS
-- =====================================================

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
    total_purchase DECIMAL(15,2),
    total_sale DECIMAL(15,2),
    total_payment_received DECIMAL(15,2),
    total_payment_given DECIMAL(15,2),
    remaining_balance DECIMAL(15,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COALESCE(p.opening_balance, 0) as opening_balance,
        COALESCE(SUM(CASE WHEN t.type = 'purchase' THEN t.amount ELSE 0 END), 0) as total_purchase,
        COALESCE(SUM(CASE WHEN t.type = 'sale' THEN t.amount ELSE 0 END), 0) as total_sale,
        COALESCE(SUM(CASE WHEN t.type = 'payment_received' THEN t.amount ELSE 0 END), 0) as total_payment_received,
        COALESCE(SUM(CASE WHEN t.type = 'payment_given' THEN t.amount ELSE 0 END), 0) as total_payment_given,
        COALESCE(p.opening_balance, 0) + 
        COALESCE(SUM(CASE WHEN t.type IN ('sale', 'payment_received') THEN t.amount ELSE 0 END), 0) -
        COALESCE(SUM(CASE WHEN t.type IN ('purchase', 'payment_given') THEN t.amount ELSE 0 END), 0) as remaining_balance
    FROM persons p
    LEFT JOIN transactions t ON p.id = t.person_id
    WHERE p.id = p_person_id
    GROUP BY p.id, p.opening_balance;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- 6. CREATE LEDGER DETAILED VIEW
-- =====================================================

-- Create ledger detailed view with running balance
CREATE VIEW ledger_detailed AS
SELECT 
    p.id as person_id,
    p.name as person_name,
    t.transaction_date,
    t.type,
    t.description,
    CASE 
        WHEN t.type IN ('purchase', 'payment_given') THEN t.amount 
        ELSE 0 
    END as debit,
    CASE 
        WHEN t.type IN ('sale', 'payment_received') THEN t.amount 
        ELSE 0 
    END as credit,
    calculate_running_balance(p.id, t.transaction_date) as running_balance,
    t.id as transaction_id
FROM persons p
INNER JOIN transactions t ON p.id = t.person_id
ORDER BY p.name, t.transaction_date ASC, t.created_at ASC;

-- =====================================================
-- 7. CREATE TRIGGER FUNCTIONS
-- =====================================================

-- Trigger to create ledger entry when purchase is created
CREATE OR REPLACE FUNCTION create_purchase_ledger_entry()
RETURNS TRIGGER AS $$
DECLARE
    supplier_person_id UUID;
BEGIN
    -- Find or create supplier person in the persons table
    SELECT id INTO supplier_person_id
    FROM persons
    WHERE name = NEW.supplier_name
    LIMIT 1;

    IF supplier_person_id IS NULL THEN
        -- Create new supplier person
        INSERT INTO persons (name, opening_balance)
        VALUES (NEW.supplier_name, 0.00)
        RETURNING id INTO supplier_person_id;
    END IF;

    -- Insert into transactions table
    INSERT INTO transactions (
        person_id,
        type,
        amount,
        description,
        transaction_date
    ) VALUES (
        supplier_person_id,
        'purchase',
        NEW.total_amount,
        'Purchase: ' || COALESCE(NEW.invoice_number, 'No Invoice'),
        NEW.purchase_date
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to create ledger entry when sale is created
CREATE OR REPLACE FUNCTION create_sale_ledger_entry()
RETURNS TRIGGER AS $$
DECLARE
    customer_person_id UUID;
BEGIN
    -- Find or create customer person in the persons table
    SELECT id INTO customer_person_id
    FROM persons
    WHERE name = NEW.customer_name
    LIMIT 1;

    IF customer_person_id IS NULL THEN
        -- Create new customer person
        INSERT INTO persons (name, opening_balance)
        VALUES (NEW.customer_name, 0.00)
        RETURNING id INTO customer_person_id;
    END IF;

    -- Insert into transactions table
    INSERT INTO transactions (
        person_id,
        type,
        amount,
        description,
        transaction_date
    ) VALUES (
        customer_person_id,
        'sale',
        NEW.total_amount,
        'Sale: ' || COALESCE(NEW.invoice_number, 'No Invoice'),
        NEW.sale_date
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- 8. CREATE TRIGGERS
-- =====================================================

-- Create triggers
CREATE TRIGGER trigger_create_purchase_ledger
    AFTER INSERT ON purchases
    FOR EACH ROW
    EXECUTE FUNCTION create_purchase_ledger_entry();

CREATE TRIGGER trigger_create_sale_ledger
    AFTER INSERT ON sales
    FOR EACH ROW
    EXECUTE FUNCTION create_sale_ledger_entry();

-- =====================================================
-- 9. CREATE INDEXES FOR PERFORMANCE
-- =====================================================

-- Parties indexes
CREATE INDEX idx_parties_name ON parties(name);
CREATE INDEX idx_parties_type ON parties(type);
CREATE INDEX idx_parties_active ON parties(is_active);

-- Products indexes
CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_active ON products(is_active);

-- Purchases indexes
CREATE INDEX idx_purchases_supplier ON purchases(supplier_name);
CREATE INDEX idx_purchases_date ON purchases(purchase_date);
CREATE INDEX idx_purchases_status ON purchases(status);

-- Sales indexes
CREATE INDEX idx_sales_customer ON sales(customer_name);
CREATE INDEX idx_sales_date ON sales(sale_date);
CREATE INDEX idx_sales_status ON sales(status);

-- Stock movements indexes
CREATE INDEX idx_stock_movements_product ON stock_movements(product_id);
CREATE INDEX idx_stock_movements_type ON stock_movements(movement_type);
CREATE INDEX idx_stock_movements_date ON stock_movements(created_at);

-- Transactions indexes
CREATE INDEX idx_transactions_person ON transactions(person_id);
CREATE INDEX idx_transactions_type ON transactions(type);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);

-- =====================================================
-- 10. ENABLE ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Enable RLS on all tables
ALTER TABLE parties ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE persons ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

-- Create RLS policies (allow all for now - customize as needed)
CREATE POLICY "Allow all operations on parties" ON parties FOR ALL USING (true);
CREATE POLICY "Allow all operations on products" ON products FOR ALL USING (true);
CREATE POLICY "Allow all operations on purchases" ON purchases FOR ALL USING (true);
CREATE POLICY "Allow all operations on sales" ON sales FOR ALL USING (true);
CREATE POLICY "Allow all operations on stock_movements" ON stock_movements FOR ALL USING (true);
CREATE POLICY "Allow all operations on persons" ON persons FOR ALL USING (true);
CREATE POLICY "Allow all operations on transactions" ON transactions FOR ALL USING (true);

-- =====================================================
-- 11. SAMPLE DATA SECTION REMOVED
-- =====================================================
-- No sample data will be inserted. Start with empty tables.

-- =====================================================
-- 12. CREATE UPDATED_AT TRIGGERS
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at
CREATE TRIGGER update_parties_updated_at BEFORE UPDATE ON parties FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_purchases_updated_at BEFORE UPDATE ON purchases FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_sales_updated_at BEFORE UPDATE ON sales FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_persons_updated_at BEFORE UPDATE ON persons FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- SCHEMA CREATION COMPLETE
-- =====================================================

-- The schema is now complete with:
-- 1. Core tables (parties, products, purchases, sales, stock_movements)
-- 2. Ledger system (persons, transactions)
-- 3. Unified transactions view
-- 4. Running balance calculation function
-- 5. Person summary function
-- 6. Ledger detailed view
-- 7. Automatic ledger entry triggers
-- 8. Performance indexes
-- 9. Row Level Security policies
-- 10. Sample data
-- 11. Updated_at triggers

-- You can now use this schema in your Flutter application with the ledger system fully integrated!

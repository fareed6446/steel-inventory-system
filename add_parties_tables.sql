-- Add Parties and Party Transactions tables to Supabase
-- Run this SQL in your Supabase SQL editor

-- Create parties table
CREATE TABLE IF NOT EXISTS parties (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('supplier', 'customer')),
  party_category TEXT DEFAULT 'company' CHECK (party_category IN ('company', 'person')),
  email TEXT,
  phone TEXT,
  address TEXT,
  city TEXT,
  country TEXT,
  tax_number TEXT,
  registration_number TEXT,
  contact_person TEXT,
  notes TEXT,
  opening_balance DECIMAL(15,2) DEFAULT 0.0,
  currency TEXT DEFAULT 'PKR',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create party_transactions table
CREATE TABLE IF NOT EXISTS party_transactions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  party_id UUID REFERENCES parties(id) ON DELETE CASCADE,
  transaction_type TEXT NOT NULL CHECK (transaction_type IN ('purchase', 'sale', 'payment_received', 'payment_made')),
  transaction_id TEXT NOT NULL,
  amount DECIMAL(15,2) NOT NULL,
  currency TEXT DEFAULT 'PKR',
  description TEXT NOT NULL,
  transaction_date TIMESTAMP WITH TIME ZONE NOT NULL,
  invoice_number TEXT,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_parties_name ON parties(name);
CREATE INDEX IF NOT EXISTS idx_parties_type ON parties(type);
CREATE INDEX IF NOT EXISTS idx_parties_email ON parties(email);
CREATE INDEX IF NOT EXISTS idx_parties_phone ON parties(phone);
CREATE INDEX IF NOT EXISTS idx_parties_active ON parties(is_active);

CREATE INDEX IF NOT EXISTS idx_party_transactions_party_id ON party_transactions(party_id);
CREATE INDEX IF NOT EXISTS idx_party_transactions_type ON party_transactions(transaction_type);
CREATE INDEX IF NOT EXISTS idx_party_transactions_date ON party_transactions(transaction_date);
CREATE INDEX IF NOT EXISTS idx_party_transactions_transaction_id ON party_transactions(transaction_id);

-- Enable Row Level Security
ALTER TABLE parties ENABLE ROW LEVEL SECURITY;
ALTER TABLE party_transactions ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for parties table
CREATE POLICY "Users can view all parties" ON parties
  FOR SELECT USING (true);

CREATE POLICY "Users can insert parties" ON parties
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update parties" ON parties
  FOR UPDATE USING (true);

CREATE POLICY "Users can delete parties" ON parties
  FOR DELETE USING (true);

-- Create RLS policies for party_transactions table
CREATE POLICY "Users can view all party transactions" ON party_transactions
  FOR SELECT USING (true);

CREATE POLICY "Users can insert party transactions" ON party_transactions
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can update party transactions" ON party_transactions
  FOR UPDATE USING (true);

CREATE POLICY "Users can delete party transactions" ON party_transactions
  FOR DELETE USING (true);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_parties_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_parties_updated_at_trigger
  BEFORE UPDATE ON parties
  FOR EACH ROW
  EXECUTE FUNCTION update_parties_updated_at();

-- Create function to automatically create party transactions from purchases
CREATE OR REPLACE FUNCTION create_party_transaction_from_purchase()
RETURNS TRIGGER AS $$
DECLARE
  party_record parties%ROWTYPE;
BEGIN
  -- Find or create party for supplier
  SELECT * INTO party_record FROM parties WHERE name = NEW.supplier_name LIMIT 1;
  
  IF party_record IS NULL THEN
    -- Create new supplier party
    INSERT INTO parties (name, type, currency)
    VALUES (NEW.supplier_name, 'supplier', 'PKR')
    RETURNING * INTO party_record;
  END IF;
  
  -- Create transaction record
  INSERT INTO party_transactions (
    party_id,
    transaction_type,
    transaction_id,
    amount,
    currency,
    description,
    transaction_date,
    invoice_number,
    notes
  ) VALUES (
    party_record.id,
    'purchase',
    NEW.id,
    NEW.total_amount,
    'PKR',
    'Purchase - ' || NEW.product_name,
    NEW.purchase_date,
    NEW.invoice_number,
    'Purchase transaction'
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for purchases
CREATE TRIGGER create_party_transaction_from_purchase_trigger
  AFTER INSERT ON purchases
  FOR EACH ROW
  EXECUTE FUNCTION create_party_transaction_from_purchase();

-- Create function to automatically create party transactions from sales
CREATE OR REPLACE FUNCTION create_party_transaction_from_sale()
RETURNS TRIGGER AS $$
DECLARE
  party_record parties%ROWTYPE;
BEGIN
  -- Find or create party for customer
  SELECT * INTO party_record FROM parties WHERE name = NEW.customer_name LIMIT 1;
  
  IF party_record IS NULL THEN
    -- Create new customer party
    INSERT INTO parties (name, type, currency)
    VALUES (NEW.customer_name, 'customer', 'PKR')
    RETURNING * INTO party_record;
  END IF;
  
  -- Create transaction record
  INSERT INTO party_transactions (
    party_id,
    transaction_type,
    transaction_id,
    amount,
    currency,
    description,
    transaction_date,
    invoice_number,
    notes
  ) VALUES (
    party_record.id,
    'sale',
    NEW.id,
    NEW.total_amount,
    'PKR',
    'Sale - ' || NEW.product_name,
    NEW.sale_date,
    NEW.invoice_number,
    'Sale transaction'
  );
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for sales
CREATE TRIGGER create_party_transaction_from_sale_trigger
  AFTER INSERT ON sales
  FOR EACH ROW
  EXECUTE FUNCTION create_party_transaction_from_sale();

-- Insert some sample parties
INSERT INTO parties (name, type, party_category, email, phone, address, city, country, opening_balance, currency) VALUES
('Steel Suppliers Ltd.', 'supplier', 'company', 'contact@steelsuppliers.com', '+92-21-1234567', 'Industrial Area, Karachi', 'Karachi', 'Pakistan', 0.0, 'PKR'),
('Metal Works Inc.', 'supplier', 'company', 'info@metalworks.com', '+92-21-2345678', 'Factory Zone, Lahore', 'Lahore', 'Pakistan', 0.0, 'PKR'),
('Construction Co.', 'customer', 'company', 'orders@construction.com', '+92-21-3456789', 'Business District, Islamabad', 'Islamabad', 'Pakistan', 0.0, 'PKR'),
('Engineering Solutions', 'customer', 'company', 'sales@engineering.com', '+92-21-4567890', 'Tech Park, Karachi', 'Karachi', 'Pakistan', 0.0, 'PKR'),
('Ahmed Khan', 'supplier', 'person', 'ahmed.khan@email.com', '+92-300-1234567', 'Gulberg, Lahore', 'Lahore', 'Pakistan', 0.0, 'PKR'),
('Fatima Ali', 'customer', 'person', 'fatima.ali@email.com', '+92-301-2345678', 'DHA, Karachi', 'Karachi', 'Pakistan', 0.0, 'PKR');

-- Create view for party balances
CREATE OR REPLACE VIEW party_balances AS
SELECT 
  p.id as party_id,
  p.name as party_name,
  p.type as party_type,
  p.opening_balance,
  p.currency,
  COALESCE(SUM(CASE WHEN pt.transaction_type = 'purchase' THEN pt.amount ELSE 0 END), 0) as total_purchases,
  COALESCE(SUM(CASE WHEN pt.transaction_type = 'sale' THEN pt.amount ELSE 0 END), 0) as total_sales,
  COALESCE(SUM(CASE WHEN pt.transaction_type = 'payment_received' THEN pt.amount ELSE 0 END), 0) as total_payments_received,
  COALESCE(SUM(CASE WHEN pt.transaction_type = 'payment_made' THEN pt.amount ELSE 0 END), 0) as total_payments_made,
  COUNT(pt.id) as transaction_count,
  CASE 
    WHEN p.type = 'supplier' THEN p.opening_balance + COALESCE(SUM(CASE WHEN pt.transaction_type = 'purchase' THEN pt.amount ELSE 0 END), 0) - COALESCE(SUM(CASE WHEN pt.transaction_type = 'payment_made' THEN pt.amount ELSE 0 END), 0)
    ELSE p.opening_balance + COALESCE(SUM(CASE WHEN pt.transaction_type = 'sale' THEN pt.amount ELSE 0 END), 0) - COALESCE(SUM(CASE WHEN pt.transaction_type = 'payment_received' THEN pt.amount ELSE 0 END), 0)
  END as current_balance
FROM parties p
LEFT JOIN party_transactions pt ON p.id = pt.party_id
WHERE p.is_active = true
GROUP BY p.id, p.name, p.type, p.opening_balance, p.currency;

-- Grant permissions on the view
GRANT SELECT ON party_balances TO authenticated;

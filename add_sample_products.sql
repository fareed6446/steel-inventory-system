-- Add sample steel products to test the inventory system
-- Run this in your Supabase SQL Editor after running the main schema

INSERT INTO products (id, name, description, category, unit, weight, length, width, thickness, grade) VALUES
-- Steel Beams
('550e8400-e29b-41d4-a716-446655440001', 'I-Beam 200x100x5.5', 'Standard I-beam for construction', 'Beams', 'pieces', 25.5, 6000, 200, 100, 'S275'),
('550e8400-e29b-41d4-a716-446655440002', 'H-Beam 300x150x6.5', 'Heavy duty H-beam for structural support', 'Beams', 'pieces', 45.2, 12000, 300, 150, 'S355'),
('550e8400-e29b-41d4-a716-446655440003', 'Channel 150x75x5.0', 'C-channel for framing applications', 'Channels', 'pieces', 15.8, 6000, 150, 75, 'S275'),

-- Steel Plates
('550e8400-e29b-41d4-a716-446655440004', 'Steel Plate 10mm', 'Flat steel plate for general fabrication', 'Plates', 'sqm', 78.5, 2000, 1000, 10, 'S275'),
('550e8400-e29b-41d4-a716-446655440005', 'Steel Plate 15mm', 'Thick steel plate for heavy construction', 'Plates', 'sqm', 117.8, 2500, 1250, 15, 'S355'),
('550e8400-e29b-41d4-a716-446655440006', 'Steel Plate 20mm', 'Extra thick plate for structural applications', 'Plates', 'sqm', 157.0, 3000, 1500, 20, 'S355'),

-- Steel Bars
('550e8400-e29b-41d4-a716-446655440007', 'Round Bar Ø12mm', 'Round steel bar for reinforcement', 'Bars', 'kg', 0.888, 12000, 12, 12, 'B500C'),
('550e8400-e29b-41d4-a716-446655440008', 'Round Bar Ø16mm', 'Round steel bar for construction', 'Bars', 'kg', 1.578, 12000, 16, 16, 'B500C'),
('550e8400-e29b-41d4-a716-446655440009', 'Square Bar 20x20mm', 'Square steel bar for fabrication', 'Bars', 'kg', 3.14, 6000, 20, 20, 'S275'),

-- Steel Tubes
('550e8400-e29b-41d4-a716-446655440010', 'Square Tube 50x50x3mm', 'Square hollow section for framework', 'Tubes', 'pieces', 4.37, 6000, 50, 50, 'S275'),
('550e8400-e29b-41d4-a716-446655440011', 'Round Tube Ø60x4mm', 'Round hollow section for structural use', 'Tubes', 'pieces', 5.52, 6000, 60, 60, 'S275'),
('550e8400-e29b-41d4-a716-446655440012', 'Rectangular Tube 80x40x3mm', 'Rectangular hollow section for frames', 'Tubes', 'pieces', 5.37, 6000, 80, 40, 'S275');

-- Initialize stock for all products
INSERT INTO stock (product_id, current_quantity, reserved_quantity, available_quantity, minimum_stock_level, maximum_stock_level, location) VALUES
('550e8400-e29b-41d4-a716-446655440001', 50, 0, 50, 10, 200, 'Main Warehouse'),
('550e8400-e29b-41d4-a716-446655440002', 30, 0, 30, 5, 100, 'Main Warehouse'),
('550e8400-e29b-41d4-a716-446655440003', 75, 0, 75, 15, 300, 'Main Warehouse'),
('550e8400-e29b-41d4-a716-446655440004', 100, 0, 100, 20, 500, 'Main Warehouse'),
('550e8400-e29b-41d4-a716-446655440005', 80, 0, 80, 15, 400, 'Main Warehouse'),
('550e8400-e29b-41d4-a716-446655440006', 60, 0, 60, 10, 300, 'Main Warehouse'),
('550e8400-e29b-41d4-a716-446655440007', 500, 0, 500, 100, 2000, 'Main Warehouse'),
('550e8400-e29b-41d4-a716-446655440008', 400, 0, 400, 80, 1500, 'Main Warehouse'),
('550e8400-e29b-41d4-a716-446655440009', 300, 0, 300, 60, 1200, 'Main Warehouse'),
('550e8400-e29b-41d4-a716-446655440010', 200, 0, 200, 40, 800, 'Main Warehouse'),
('550e8400-e29b-41d4-a716-446655440011', 150, 0, 150, 30, 600, 'Main Warehouse'),
('550e8400-e29b-41d4-a716-446655440012', 180, 0, 180, 35, 700, 'Main Warehouse');

-- Success message
SELECT 'Sample steel products added successfully!' as message,
       'You can now test purchases and sales in your app.' as details;

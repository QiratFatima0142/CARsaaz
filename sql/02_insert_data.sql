-- =====================================================================
-- CarSaaz Management System  -  Sample Data
-- =====================================================================
-- File     : 02_insert_data.sql
-- Purpose  : Populates the CarSaaz schema with realistic dummy data for
--            demonstration, testing, and portfolio use.
-- Order    : Parents before children to satisfy FK constraints.
-- Counts   : 12 brands, 6 showrooms, 18 cars, 15 customers, 15 employees,
--            20 bookings, 12 invoices, 18 products, 15 product sales.
-- =====================================================================

USE carsaaz;

-- ---------------------------------------------------------------------
-- BRAND
-- ---------------------------------------------------------------------
INSERT INTO brand (brand_id, brand_name, country) VALUES
    (1,  'Toyota',         'Japan'),
    (2,  'Honda',          'Japan'),
    (3,  'Suzuki',         'Japan'),
    (4,  'Hyundai',        'South Korea'),
    (5,  'Kia',            'South Korea'),
    (6,  'BMW',            'Germany'),
    (7,  'Mercedes-Benz',  'Germany'),
    (8,  'Audi',           'Germany'),
    (9,  'Ford',           'USA'),
    (10, 'Tesla',          'USA'),
    (11, 'Lexus',          'Japan'),
    (12, 'Porsche',        'Germany');

-- ---------------------------------------------------------------------
-- SHOWROOM
-- ---------------------------------------------------------------------
INSERT INTO showroom (showroom_id, name, address, city, phone) VALUES
    (1, 'CarSaaz Lahore',        'MM Alam Road, Gulberg III',     'Lahore',       '042-111-227-227'),
    (2, 'CarSaaz Karachi',       'Shahrah-e-Faisal, Block 6',     'Karachi',      '021-111-227-228'),
    (3, 'CarSaaz Islamabad',     'Jinnah Avenue, Blue Area',      'Islamabad',    '051-111-227-229'),
    (4, 'CarSaaz Rawalpindi',    'Murree Road, Saddar',           'Rawalpindi',   '051-111-227-230'),
    (5, 'CarSaaz Faisalabad',    'Susan Road, Madina Town',       'Faisalabad',   '041-111-227-231'),
    (6, 'CarSaaz Multan',        'Bosan Road, Cantonment',        'Multan',       '061-111-227-232');

-- ---------------------------------------------------------------------
-- CAR (18 vehicles: 10 new, 8 used)
-- ---------------------------------------------------------------------
INSERT INTO car
    (car_id, brand_id, showroom_id, model_name, color, model_year,
     body_type, engine_cc, fuel_type, car_type, price, availability_status)
VALUES
    (1,  1,  1, 'Corolla Altis Grande',   'White',   2024, 'Sedan',      1800, 'petrol',   'new',  32500.00, 'available'),
    (2,  1,  2, 'Fortuner Legender',      'Black',   2024, 'SUV',        2800, 'diesel',   'new',  78000.00, 'available'),
    (3,  2,  1, 'Civic RS Turbo',         'Red',     2024, 'Sedan',      1500, 'petrol',   'new',  38500.00, 'booked'),
    (4,  2,  3, 'BR-V',                   'Silver',  2023, 'SUV',        1500, 'petrol',   'new',  29500.00, 'available'),
    (5,  3,  2, 'Swift GLX CVT',          'Blue',    2024, 'Hatchback',  1200, 'petrol',   'new',  17500.00, 'available'),
    (6,  3,  5, 'Alto VXL AGS',           'Pearl White', 2024, 'Hatchback',  660, 'petrol', 'new',  11500.00, 'sold'),
    (7,  4,  3, 'Tucson Ultimate',        'Grey',    2024, 'SUV',        2000, 'petrol',   'new',  46500.00, 'available'),
    (8,  5,  4, 'Sportage Alpha',         'Black',   2024, 'SUV',        2000, 'petrol',   'new',  44000.00, 'available'),
    (9,  10, 3, 'Model 3 Long Range',     'Red',     2024, 'Sedan',      NULL, 'electric', 'new',  55000.00, 'available'),
    (10, 10, 1, 'Model Y Performance',    'White',   2024, 'SUV',        NULL, 'electric', 'new',  68000.00, 'booked'),
    (11, 6,  2, '3 Series 330i',          'Blue',    2021, 'Sedan',      2000, 'petrol',   'used', 42000.00, 'available'),
    (12, 7,  3, 'C-Class C200',           'Silver',  2020, 'Sedan',      1500, 'petrol',   'used', 48000.00, 'available'),
    (13, 8,  4, 'A4 Premium Plus',        'Black',   2019, 'Sedan',      2000, 'petrol',   'used', 35000.00, 'available'),
    (14, 11, 1, 'RX 350',                 'White',   2020, 'SUV',        3500, 'petrol',   'used', 52000.00, 'booked'),
    (15, 12, 2, 'Cayenne S',              'Grey',    2018, 'SUV',        2900, 'petrol',   'used', 72000.00, 'available'),
    (16, 9,  5, 'Mustang GT',             'Yellow',  2019, 'Coupe',      5000, 'petrol',   'used', 45000.00, 'available'),
    (17, 1,  6, 'Land Cruiser V8',        'Pearl White', 2017, 'SUV',    4600, 'petrol',   'used', 85000.00, 'sold'),
    (18, 2,  5, 'City Aspire Prosmatec',  'Silver',  2022, 'Sedan',      1500, 'petrol',   'used', 19500.00, 'available');

-- ---------------------------------------------------------------------
-- NEW_CAR (subtype rows for car_type = 'new')
-- ---------------------------------------------------------------------
INSERT INTO new_car (car_id, warranty_months, free_service_count) VALUES
    (1,  36, 5),
    (2,  48, 6),
    (3,  36, 4),
    (4,  36, 4),
    (5,  24, 3),
    (6,  24, 3),
    (7,  60, 6),
    (8,  60, 6),
    (9,  96, 8),
    (10, 96, 8);

-- ---------------------------------------------------------------------
-- USED_CAR (subtype rows for car_type = 'used')
-- ---------------------------------------------------------------------
INSERT INTO used_car
    (car_id, registered_city, license_no, mileage_km, previous_owners, registration_date)
VALUES
    (11, 'Karachi',    'BGA-221',  45000, 1, '2021-03-12'),
    (12, 'Islamabad',  'ISB-4411', 62000, 2, '2020-07-08'),
    (13, 'Rawalpindi', 'RLW-8820', 78000, 1, '2019-01-20'),
    (14, 'Lahore',     'LEA-19A',  52000, 1, '2020-11-05'),
    (15, 'Karachi',    'AYC-331',  89000, 2, '2018-05-14'),
    (16, 'Faisalabad', 'FSD-1212', 71000, 1, '2019-09-02'),
    (17, 'Multan',     'MUL-009',  112000,3, '2017-02-28'),
    (18, 'Faisalabad', 'FSD-7733', 28000, 1, '2022-06-17');

-- ---------------------------------------------------------------------
-- CAR_FEATURES
-- ---------------------------------------------------------------------
INSERT INTO car_features
    (car_id, air_bags, power_steering, air_condition, power_windows, sunroof, gps)
VALUES
    (1,  6,  TRUE, TRUE, TRUE, FALSE, TRUE),
    (2,  8,  TRUE, TRUE, TRUE, TRUE,  TRUE),
    (3,  6,  TRUE, TRUE, TRUE, TRUE,  TRUE),
    (4,  4,  TRUE, TRUE, TRUE, FALSE, TRUE),
    (5,  4,  TRUE, TRUE, TRUE, FALSE, FALSE),
    (6,  2,  TRUE, TRUE, TRUE, FALSE, FALSE),
    (7,  6,  TRUE, TRUE, TRUE, TRUE,  TRUE),
    (8,  6,  TRUE, TRUE, TRUE, TRUE,  TRUE),
    (9,  8,  TRUE, TRUE, TRUE, TRUE,  TRUE),
    (10, 8,  TRUE, TRUE, TRUE, TRUE,  TRUE),
    (11, 8,  TRUE, TRUE, TRUE, TRUE,  TRUE),
    (12, 8,  TRUE, TRUE, TRUE, TRUE,  TRUE),
    (13, 6,  TRUE, TRUE, TRUE, TRUE,  TRUE),
    (14, 8,  TRUE, TRUE, TRUE, TRUE,  TRUE),
    (15, 8,  TRUE, TRUE, TRUE, TRUE,  TRUE),
    (16, 4,  TRUE, TRUE, TRUE, FALSE, TRUE),
    (17, 10, TRUE, TRUE, TRUE, TRUE,  TRUE),
    (18, 4,  TRUE, TRUE, TRUE, FALSE, TRUE);

-- ---------------------------------------------------------------------
-- CUSTOMER
-- ---------------------------------------------------------------------
INSERT INTO customer (customer_id, name, phone, email, address, city) VALUES
    (1,  'Ahmed Raza',       '03001234567', 'ahmed.raza@example.com',     'H-12, DHA Phase 5',          'Lahore'),
    (2,  'Fatima Khan',      '03012345678', 'fatima.khan@example.com',    'Flat 4B, Clifton Block 2',   'Karachi'),
    (3,  'Hassan Ali',       '03023456789', 'hassan.ali@example.com',     'Street 9, F-10/3',           'Islamabad'),
    (4,  'Sara Malik',       '03034567890', 'sara.malik@example.com',     'Cantt Road, House 22',       'Rawalpindi'),
    (5,  'Bilal Chaudhry',   '03045678901', 'bilal.ch@example.com',       'Satellite Town, B-117',      'Faisalabad'),
    (6,  'Ayesha Siddiqui',  '03056789012', 'ayesha.s@example.com',       'Model Town, Block D',        'Lahore'),
    (7,  'Usman Sheikh',     '03067890123', 'usman.sheikh@example.com',   'North Nazimabad, A-44',      'Karachi'),
    (8,  'Zainab Hussain',   '03078901234', 'zainab.h@example.com',       'G-9 Markaz, Flat 12',        'Islamabad'),
    (9,  'Omar Farooq',      '03089012345', 'omar.farooq@example.com',    'Cantt, Officers Colony',     'Multan'),
    (10, 'Hina Tariq',       '03090123456', 'hina.tariq@example.com',     'Iqbal Town, Street 5',       'Faisalabad'),
    (11, 'Daniyal Iqbal',    '03101234567', 'daniyal.i@example.com',      'Bahria Town Phase 8',        'Rawalpindi'),
    (12, 'Mariam Shahid',    '03112345678', 'mariam.s@example.com',       'Johar Town, Block J3',       'Lahore'),
    (13, 'Kamran Akmal',     '03123456789', 'kamran.a@example.com',       'Gulshan-e-Iqbal, Block 7',   'Karachi'),
    (14, 'Sadia Noor',       '03134567890', 'sadia.noor@example.com',     'E-11/2, Street 18',          'Islamabad'),
    (15, 'Rehan Mehmood',    '03145678901', 'rehan.m@example.com',        'New Shalimar Colony',        'Multan');

-- ---------------------------------------------------------------------
-- EMPLOYEE
-- ---------------------------------------------------------------------
INSERT INTO employee
    (employee_id, showroom_id, name, phone, position, salary, hire_date)
VALUES
    (1,  1, 'Tariq Jameel',       '03211112222', 'Manager',      180000.00, '2020-03-15'),
    (2,  1, 'Nida Yasir',         '03211112223', 'Salesperson',   95000.00, '2021-06-01'),
    (3,  1, 'Asif Khan',          '03211112224', 'Technician',   110000.00, '2020-11-10'),
    (4,  2, 'Imran Abbas',        '03222223333', 'Manager',      185000.00, '2019-08-22'),
    (5,  2, 'Komal Aziz',         '03222223334', 'Salesperson',   92000.00, '2022-01-14'),
    (6,  2, 'Shehzad Roy',        '03222223335', 'Accountant',   120000.00, '2021-02-01'),
    (7,  3, 'Hamza Ali Abbasi',   '03233334444', 'Manager',      190000.00, '2019-05-10'),
    (8,  3, 'Maya Khan',          '03233334445', 'Receptionist',  65000.00, '2022-09-05'),
    (9,  3, 'Bilal Khan',         '03233334446', 'Salesperson',   98000.00, '2021-12-01'),
    (10, 4, 'Fahad Mustafa',      '03244445555', 'Manager',      175000.00, '2020-07-15'),
    (11, 4, 'Sana Javed',         '03244445556', 'Salesperson',   94000.00, '2022-03-20'),
    (12, 5, 'Ali Zafar',          '03255556666', 'Manager',      178000.00, '2020-01-08'),
    (13, 5, 'Mahira Khan',        '03255556667', 'Salesperson',   96000.00, '2022-04-11'),
    (14, 6, 'Fawad Khan',         '03266667777', 'Manager',      182000.00, '2019-11-03'),
    (15, 6, 'Ayeza Khan',         '03266667778', 'Technician',   108000.00, '2021-05-19');

-- ---------------------------------------------------------------------
-- BOOKING (20 records across various statuses and dates)
-- ---------------------------------------------------------------------
INSERT INTO booking
    (booking_id, customer_id, car_id, employee_id, booking_date, status, notes)
VALUES
    (1,  1,  3,  2,  '2024-01-08', 'confirmed', 'Financing approved, delivery scheduled'),
    (2,  2,  11, 5,  '2024-01-15', 'confirmed', 'Trade-in applied'),
    (3,  3,  10, 9,  '2024-01-20', 'confirmed', 'Cash payment, full paid'),
    (4,  4,  4,  11, '2024-02-03', 'completed', 'Delivered on time'),
    (5,  5,  5,  13, '2024-02-10', 'completed', 'First-time buyer'),
    (6,  6,  14, 2,  '2024-02-14', 'confirmed', 'Extended warranty added'),
    (7,  7,  2,  5,  '2024-02-22', 'pending',   'Awaiting loan approval'),
    (8,  8,  7,  9,  '2024-03-05', 'confirmed', 'Home delivery requested'),
    (9,  9,  17, 14, '2024-03-12', 'completed', 'Repeat customer discount'),
    (10, 10, 6,  13, '2024-03-18', 'completed', 'Cash purchase'),
    (11, 11, 8,  11, '2024-03-25', 'cancelled', 'Customer withdrew'),
    (12, 12, 1,  2,  '2024-04-02', 'confirmed', 'Corporate fleet deal'),
    (13, 13, 12, 5,  '2024-04-08', 'pending',   'Awaiting inspection'),
    (14, 14, 9,  9,  '2024-04-15', 'confirmed', 'EV charger installation bundled'),
    (15, 15, 15, 14, '2024-04-22', 'pending',   'Test drive scheduled'),
    (16, 1,  13, 11, '2024-05-02', 'confirmed', 'Second purchase from this customer'),
    (17, 3,  16, 9,  '2024-05-10', 'cancelled', 'Customer found elsewhere'),
    (18, 6,  18, 13, '2024-05-18', 'confirmed', 'Certified pre-owned'),
    (19, 8,  7,  9,  '2024-05-25', 'cancelled', 'Duplicate entry'),
    (20, 12, 2,  2,  '2024-06-01', 'pending',   'Reserved with deposit');

-- ---------------------------------------------------------------------
-- INVOICE (generated for confirmed / completed bookings)
-- ---------------------------------------------------------------------
INSERT INTO invoice
    (invoice_id, booking_id, total_amount, tax_amount,
     payment_method, payment_status, invoice_date)
VALUES
    (1,  1,  40425.00, 1925.00, 'financing',     'partial','2024-01-10'),
    (2,  2,  44100.00, 2100.00, 'bank_transfer', 'paid',   '2024-01-17'),
    (3,  3,  71400.00, 3400.00, 'cash',          'paid',   '2024-01-22'),
    (4,  4,  30975.00, 1475.00, 'card',          'paid',   '2024-02-05'),
    (5,  5,  18375.00,  875.00, 'cash',          'paid',   '2024-02-12'),
    (6,  6,  54600.00, 2600.00, 'financing',     'partial','2024-02-16'),
    (7,  8,  48825.00, 2325.00, 'bank_transfer', 'paid',   '2024-03-07'),
    (8,  9,  89250.00, 4250.00, 'bank_transfer', 'paid',   '2024-03-14'),
    (9,  10, 12075.00,  575.00, 'cash',          'paid',   '2024-03-20'),
    (10, 12, 34125.00, 1625.00, 'card',          'paid',   '2024-04-04'),
    (11, 14, 57750.00, 2750.00, 'financing',     'unpaid', '2024-04-17'),
    (12, 16, 36750.00, 1750.00, 'bank_transfer', 'paid',   '2024-05-04'),
    (13, 18, 20475.00,  975.00, 'cash',          'paid',   '2024-05-20');

-- ---------------------------------------------------------------------
-- CAR_PRODUCT (accessories & spare-parts catalogue)
-- ---------------------------------------------------------------------
INSERT INTO car_product
    (product_id, product_name, category, price, stock_quantity, description)
VALUES
    (1,  'Premium Car Wax 500ml',   'cleaning',   22.50, 120, 'High-gloss carnauba wax'),
    (2,  'Leather Seat Covers Set', 'accessory',  65.00,  45, 'Custom-fit premium leather'),
    (3,  'All-Weather Floor Mats',  'accessory',  34.00,  80, 'Rubber 5-piece set'),
    (4,  'Aroma Freshener Pack',    'accessory',   6.50, 250, 'Long-lasting citrus scent'),
    (5,  'Fast USB Car Charger',    'electronic', 18.00, 140, 'PD 20W + QC 3.0 dual-port'),
    (6,  'Interior Cleaning Kit',   'cleaning',   42.00,  25, '7-piece professional kit'),
    (7,  'Magnetic Phone Mount',    'accessory',  12.00, 180, 'Dashboard & windshield'),
    (8,  'Organizer Trunk Box',     'accessory',  27.50,  36, 'Collapsible, 3 compartments'),
    (9,  'Roadside Tool Kit',       'tool',       68.00,  18, '42-piece with case'),
    (10, 'Windshield Sunshade XL',  'accessory',  15.50, 110, 'Reflective UV protection'),
    (11, 'Full Car Cover',          'accessory',  85.00,   8, 'Waterproof, breathable fabric'),
    (12, 'Portable Vacuum Cleaner', 'electronic', 38.50,  22, '120W cordless, 5 nozzles'),
    (13, 'Wiper Blades Premium',    'spare_part', 19.50,  95, 'All-weather silicone'),
    (14, 'Jump Starter 2000A',      'tool',       79.00,  14, '20000 mAh with LED light'),
    (15, 'Bluetooth FM Kit',        'electronic', 32.00,  58, 'Hands-free, aux input'),
    (16, 'Dash Cam 1080p',          'electronic',110.00,  20, 'Loop recording, G-sensor'),
    (17, 'First Aid Safety Kit',    'safety',     24.00, 100, 'DOT-approved 85-piece'),
    (18, 'Tire Pressure Gauge',     'tool',        9.50, 150, 'Digital, 0-100 PSI');

-- ---------------------------------------------------------------------
-- PRODUCT_SALE
-- ---------------------------------------------------------------------
INSERT INTO product_sale
    (sale_id, product_id, customer_id, showroom_id, quantity, unit_price, sale_date)
VALUES
    (1,  1,  1,  1, 3, 22.50, '2024-01-10'),
    (2,  2,  2,  2, 1, 65.00, '2024-01-18'),
    (3,  3,  3,  3, 2, 34.00, '2024-01-22'),
    (4,  5,  4,  4, 2, 18.00, '2024-02-06'),
    (5,  6,  5,  5, 1, 42.00, '2024-02-12'),
    (6,  9,  6,  1, 1, 68.00, '2024-02-17'),
    (7,  11, 7,  2, 1, 85.00, '2024-03-01'),
    (8,  14, 8,  3, 1, 79.00, '2024-03-08'),
    (9,  16, 9,  6, 2,110.00, '2024-03-15'),
    (10, 4,  10, 5, 5,  6.50, '2024-03-22'),
    (11, 7,  11, 4, 1, 12.00, '2024-04-01'),
    (12, 13, 12, 1, 2, 19.50, '2024-04-09'),
    (13, 15, 13, 2, 1, 32.00, '2024-04-16'),
    (14, 17, 14, 3, 1, 24.00, '2024-04-24'),
    (15, 18, 15, 6, 3,  9.50, '2024-05-02');

-- ---------------------------------------------------------------------
-- CAR_IMPORT (for imported vehicles — mostly premium brands)
-- ---------------------------------------------------------------------
INSERT INTO car_import
    (import_id, car_id, showroom_id, import_cost, import_date, origin_country)
VALUES
    (1,  2,  2, 65000.00, '2023-12-05', 'Japan'),
    (2,  9,  3, 48000.00, '2023-12-18', 'USA'),
    (3,  10, 1, 58000.00, '2023-12-22', 'USA'),
    (4,  11, 2, 36000.00, '2023-11-10', 'Germany'),
    (5,  12, 3, 41000.00, '2023-10-28', 'Germany'),
    (6,  13, 4, 30000.00, '2023-09-15', 'Germany'),
    (7,  14, 1, 44000.00, '2023-11-25', 'Japan'),
    (8,  15, 2, 62000.00, '2023-08-30', 'Germany'),
    (9,  16, 5, 38000.00, '2023-10-12', 'USA'),
    (10, 17, 6, 72000.00, '2023-09-20', 'Japan');

-- =====================================================================
-- Sample data loaded successfully.
-- Run 03_queries.sql to explore the data.
-- =====================================================================

-- =====================================================================
-- CarSaaz Management System  -  Demo Queries
-- =====================================================================
-- File      : 03_queries.sql
-- Purpose   : Showcases core and advanced queries that demonstrate the
--             system's analytical and operational capabilities.
-- Sections  : A) Core business queries (Q1 - Q8)
--             B) Advanced analytics  (Q9 - Q20)
-- =====================================================================

USE carsaaz;

-- =====================================================================
-- A. CORE BUSINESS QUERIES
-- =====================================================================

-- Q1 ------------------------------------------------------------------
--  Retrieve all available cars with their brand and showroom.
-- ---------------------------------------------------------------------
SELECT  c.car_id,
        b.brand_name,
        c.model_name,
        c.model_year,
        c.car_type,
        c.price,
        s.name        AS showroom,
        s.city
FROM    car c
JOIN    brand    b ON b.brand_id    = c.brand_id
JOIN    showroom s ON s.showroom_id = c.showroom_id
WHERE   c.availability_status = 'available'
ORDER BY c.price DESC;

-- Q2 ------------------------------------------------------------------
--  Retrieve cars filtered by type (parameter: 'new' or 'used').
-- ---------------------------------------------------------------------
SELECT  c.car_id, b.brand_name, c.model_name, c.model_year,
        c.price, c.availability_status
FROM    car c
JOIN    brand b ON b.brand_id = c.brand_id
WHERE   c.car_type = 'used'             -- change to 'new' as needed
ORDER BY b.brand_name, c.model_name;

-- Q3 ------------------------------------------------------------------
--  Get the full booking history of a specific customer.
-- ---------------------------------------------------------------------
SELECT  bk.booking_id,
        bk.booking_date,
        br.brand_name,
        c.model_name,
        c.price,
        bk.status
FROM    booking bk
JOIN    car     c  ON c.car_id    = bk.car_id
JOIN    brand   br ON br.brand_id = c.brand_id
WHERE   bk.customer_id = 1              -- parameter: customer_id
ORDER BY bk.booking_date DESC;

-- Q4 ------------------------------------------------------------------
--  Show all bookings with full customer + car details (multi-way JOIN).
-- ---------------------------------------------------------------------
SELECT  bk.booking_id,
        bk.booking_date,
        bk.status,
        cu.name      AS customer_name,
        cu.phone     AS customer_phone,
        br.brand_name,
        c.model_name,
        c.price,
        s.name       AS showroom,
        e.name       AS handled_by
FROM    booking  bk
JOIN    customer cu ON cu.customer_id = bk.customer_id
JOIN    car      c  ON c.car_id       = bk.car_id
JOIN    brand    br ON br.brand_id    = c.brand_id
JOIN    showroom s  ON s.showroom_id  = c.showroom_id
LEFT JOIN employee e ON e.employee_id = bk.employee_id
ORDER BY bk.booking_date DESC;

-- Q5 ------------------------------------------------------------------
--  Generate full invoice details for a given booking.
-- ---------------------------------------------------------------------
SELECT  i.invoice_id,
        i.invoice_date,
        cu.name          AS customer_name,
        cu.email,
        br.brand_name,
        c.model_name,
        c.price          AS car_price,
        i.tax_amount,
        i.total_amount,
        i.payment_method,
        i.payment_status
FROM    invoice  i
JOIN    booking  bk ON bk.booking_id  = i.booking_id
JOIN    customer cu ON cu.customer_id = bk.customer_id
JOIN    car      c  ON c.car_id       = bk.car_id
JOIN    brand    br ON br.brand_id    = c.brand_id
WHERE   i.booking_id = 3;               -- parameter: booking_id

-- Q6 ------------------------------------------------------------------
--  Check product inventory, highlighting low-stock items (< 30).
-- ---------------------------------------------------------------------
SELECT  product_id,
        product_name,
        category,
        price,
        stock_quantity,
        CASE
            WHEN stock_quantity = 0        THEN 'OUT_OF_STOCK'
            WHEN stock_quantity < 30       THEN 'LOW_STOCK'
            WHEN stock_quantity < 100      THEN 'MEDIUM'
            ELSE 'HEALTHY'
        END AS stock_level
FROM    car_product
ORDER BY stock_quantity ASC;

-- Q7 ------------------------------------------------------------------
--  Find the most-booked cars (ranked by number of bookings).
-- ---------------------------------------------------------------------
SELECT  c.car_id,
        br.brand_name,
        c.model_name,
        COUNT(bk.booking_id) AS total_bookings
FROM    car     c
JOIN    brand   br ON br.brand_id = c.brand_id
LEFT JOIN booking bk ON bk.car_id = c.car_id
GROUP BY c.car_id, br.brand_name, c.model_name
ORDER BY total_bookings DESC, c.price DESC
LIMIT 10;

-- Q8 ------------------------------------------------------------------
--  List customers with the most bookings (top spenders by activity).
-- ---------------------------------------------------------------------
SELECT  cu.customer_id,
        cu.name,
        cu.city,
        COUNT(bk.booking_id) AS booking_count
FROM    customer cu
LEFT JOIN booking bk ON bk.customer_id = cu.customer_id
GROUP BY cu.customer_id, cu.name, cu.city
ORDER BY booking_count DESC, cu.name
LIMIT 10;


-- =====================================================================
-- B. ADVANCED ANALYTICS
-- =====================================================================

-- Q9 ------------------------------------------------------------------
--  Total revenue (only paid invoices) and number of paid deals.
-- ---------------------------------------------------------------------
SELECT  COUNT(*)             AS paid_invoices,
        SUM(total_amount)    AS total_revenue,
        AVG(total_amount)    AS avg_invoice_value
FROM    invoice
WHERE   payment_status = 'paid';

-- Q10 -----------------------------------------------------------------
--  Total bookings broken down by status.
-- ---------------------------------------------------------------------
SELECT  status, COUNT(*) AS bookings
FROM    booking
GROUP BY status
ORDER BY bookings DESC;

-- Q11 -----------------------------------------------------------------
--  Bookings within a given date range (parameter-style).
-- ---------------------------------------------------------------------
SELECT  bk.booking_id, bk.booking_date, cu.name AS customer,
        c.model_name, bk.status
FROM    booking bk
JOIN    customer cu ON cu.customer_id = bk.customer_id
JOIN    car      c  ON c.car_id       = bk.car_id
WHERE   bk.booking_date BETWEEN '2024-02-01' AND '2024-03-31'
ORDER BY bk.booking_date;

-- Q12 -----------------------------------------------------------------
--  Top 5 most expensive cars currently in inventory.
-- ---------------------------------------------------------------------
SELECT  c.car_id, b.brand_name, c.model_name, c.model_year, c.price
FROM    car c
JOIN    brand b ON b.brand_id = c.brand_id
ORDER BY c.price DESC
LIMIT 5;

-- Q13 -----------------------------------------------------------------
--  Revenue per showroom (from invoiced bookings).
-- ---------------------------------------------------------------------
SELECT  s.showroom_id,
        s.name     AS showroom,
        s.city,
        COUNT(i.invoice_id)    AS invoices_issued,
        SUM(i.total_amount)    AS total_revenue
FROM    invoice  i
JOIN    booking  bk ON bk.booking_id  = i.booking_id
JOIN    car      c  ON c.car_id       = bk.car_id
JOIN    showroom s  ON s.showroom_id  = c.showroom_id
GROUP BY s.showroom_id, s.name, s.city
ORDER BY total_revenue DESC;

-- Q14 -----------------------------------------------------------------
--  Average car price per brand (catalogue insight).
-- ---------------------------------------------------------------------
SELECT  b.brand_name,
        COUNT(c.car_id)      AS cars_in_stock,
        ROUND(AVG(c.price),2) AS avg_price,
        MIN(c.price)          AS cheapest,
        MAX(c.price)          AS priciest
FROM    brand b
LEFT JOIN car c ON c.brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY avg_price DESC;

-- Q15 -----------------------------------------------------------------
--  Booking conversion ratio: confirmed / completed vs cancelled.
-- ---------------------------------------------------------------------
SELECT
    SUM(CASE WHEN status IN ('confirmed','completed') THEN 1 ELSE 0 END) AS successful,
    SUM(CASE WHEN status = 'cancelled'                 THEN 1 ELSE 0 END) AS cancelled,
    SUM(CASE WHEN status = 'pending'                   THEN 1 ELSE 0 END) AS pending,
    ROUND(100.0 *
          SUM(CASE WHEN status IN ('confirmed','completed') THEN 1 ELSE 0 END) /
          NULLIF(COUNT(*), 0), 2) AS success_rate_pct
FROM    booking;

-- Q16 -----------------------------------------------------------------
--  Monthly booking trend (insights for sales forecasting).
-- ---------------------------------------------------------------------
SELECT  DATE_FORMAT(booking_date, '%Y-%m') AS month,
        COUNT(*)                           AS bookings,
        SUM(CASE WHEN status = 'confirmed' THEN 1 ELSE 0 END) AS confirmed,
        SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled
FROM    booking
GROUP BY DATE_FORMAT(booking_date, '%Y-%m')
ORDER BY month;

-- Q17 -----------------------------------------------------------------
--  Total inventory value (price x stock) per product category.
-- ---------------------------------------------------------------------
SELECT  category,
        COUNT(*)                           AS sku_count,
        SUM(stock_quantity)                AS units_in_stock,
        ROUND(SUM(price * stock_quantity), 2) AS inventory_value
FROM    car_product
GROUP BY category
ORDER BY inventory_value DESC;

-- Q18 -----------------------------------------------------------------
--  Top 5 performing brands by number of bookings.
-- ---------------------------------------------------------------------
SELECT  b.brand_name,
        COUNT(bk.booking_id) AS total_bookings,
        ROUND(SUM(c.price), 2) AS total_value_booked
FROM    brand   b
JOIN    car     c  ON c.brand_id  = b.brand_id
LEFT JOIN booking bk ON bk.car_id = c.car_id
GROUP BY b.brand_name
ORDER BY total_bookings DESC, total_value_booked DESC
LIMIT 5;

-- Q19 -----------------------------------------------------------------
--  Customer lifetime value (sum of paid invoices + product sales).
-- ---------------------------------------------------------------------
SELECT  cu.customer_id,
        cu.name,
        COALESCE(inv.car_spend, 0)        AS car_spend,
        COALESCE(ps.product_spend, 0)     AS product_spend,
        COALESCE(inv.car_spend, 0) + COALESCE(ps.product_spend, 0) AS lifetime_value
FROM    customer cu
LEFT JOIN (
    SELECT  bk.customer_id,
            SUM(i.total_amount) AS car_spend
    FROM    invoice i
    JOIN    booking bk ON bk.booking_id = i.booking_id
    WHERE   i.payment_status = 'paid'
    GROUP BY bk.customer_id
) inv ON inv.customer_id = cu.customer_id
LEFT JOIN (
    SELECT  customer_id,
            SUM(quantity * unit_price) AS product_spend
    FROM    product_sale
    GROUP BY customer_id
) ps ON ps.customer_id = cu.customer_id
ORDER BY lifetime_value DESC;

-- Q20 -----------------------------------------------------------------
--  Gross margin per imported car (sale price - import cost).
-- ---------------------------------------------------------------------
SELECT  ci.import_id,
        b.brand_name,
        c.model_name,
        ci.import_cost,
        c.price                      AS listing_price,
        (c.price - ci.import_cost)   AS gross_margin,
        ROUND(100.0 * (c.price - ci.import_cost) / ci.import_cost, 2) AS margin_pct
FROM    car_import ci
JOIN    car   c ON c.car_id   = ci.car_id
JOIN    brand b ON b.brand_id = c.brand_id
ORDER BY margin_pct DESC;

-- =====================================================================
-- End of demo queries.
-- =====================================================================

-- =====================================================================
-- CarSaaz Management System  -  Database Schema (MySQL 8.0+)
-- =====================================================================
-- Course          : Introduction to Database Systems
-- Project Title   : CarSaaz - Automotive Management Platform
-- Normal Form     : 3NF
-- Engine          : InnoDB (transactions + FK enforcement)
-- Character Set   : utf8mb4
--
-- File        : 01_schema.sql
-- Purpose     : Creates the database, all tables, constraints, and
--               indexes required by the CarSaaz system.
-- Execution   : mysql -u root -p < 01_schema.sql
-- =====================================================================

DROP DATABASE IF EXISTS carsaaz;
CREATE DATABASE carsaaz
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE carsaaz;

-- ---------------------------------------------------------------------
-- 1. BRAND           - Reference table for car manufacturers
-- ---------------------------------------------------------------------
CREATE TABLE brand (
    brand_id        INT           NOT NULL AUTO_INCREMENT,
    brand_name      VARCHAR(50)   NOT NULL,
    country         VARCHAR(50)   DEFAULT NULL,
    CONSTRAINT pk_brand        PRIMARY KEY (brand_id),
    CONSTRAINT uq_brand_name   UNIQUE      (brand_name)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. SHOWROOM        - Physical dealership locations
-- ---------------------------------------------------------------------
CREATE TABLE showroom (
    showroom_id     INT           NOT NULL AUTO_INCREMENT,
    name            VARCHAR(80)   NOT NULL,
    address         VARCHAR(120)  NOT NULL,
    city            VARCHAR(60)   NOT NULL,
    phone           VARCHAR(20)   DEFAULT NULL,
    CONSTRAINT pk_showroom      PRIMARY KEY (showroom_id),
    CONSTRAINT uq_showroom_name UNIQUE      (name)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. CAR             - Core inventory (superclass for new/used)
-- ---------------------------------------------------------------------
CREATE TABLE car (
    car_id              INT             NOT NULL AUTO_INCREMENT,
    brand_id            INT             NOT NULL,
    showroom_id         INT             NOT NULL,
    model_name          VARCHAR(60)     NOT NULL,
    color               VARCHAR(30)     NOT NULL,
    model_year          SMALLINT        NOT NULL,
    body_type           VARCHAR(30)     NOT NULL,
    engine_cc           INT             DEFAULT NULL,
    fuel_type           ENUM('petrol','diesel','hybrid','electric','cng')
                                        NOT NULL DEFAULT 'petrol',
    car_type            ENUM('new','used')
                                        NOT NULL,
    price               DECIMAL(12, 2)  NOT NULL,
    availability_status ENUM('available','booked','sold','maintenance')
                                        NOT NULL DEFAULT 'available',
    created_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_car            PRIMARY KEY (car_id),
    CONSTRAINT fk_car_brand      FOREIGN KEY (brand_id)
        REFERENCES brand (brand_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_car_showroom   FOREIGN KEY (showroom_id)
        REFERENCES showroom (showroom_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_car_price     CHECK (price > 0),
    CONSTRAINT chk_car_year      CHECK (model_year BETWEEN 1950 AND 2100)
) ENGINE=InnoDB;

CREATE INDEX idx_car_availability ON car (availability_status);
CREATE INDEX idx_car_type         ON car (car_type);
CREATE INDEX idx_car_brand        ON car (brand_id);
CREATE INDEX idx_car_showroom     ON car (showroom_id);
CREATE INDEX idx_car_price        ON car (price);

-- ---------------------------------------------------------------------
-- 4. NEW_CAR         - Subtype: attributes specific to brand-new cars
-- ---------------------------------------------------------------------
CREATE TABLE new_car (
    car_id                  INT     NOT NULL,
    warranty_months         INT     NOT NULL DEFAULT 24,
    free_service_count      INT     NOT NULL DEFAULT 3,
    CONSTRAINT pk_new_car         PRIMARY KEY (car_id),
    CONSTRAINT fk_new_car_car     FOREIGN KEY (car_id)
        REFERENCES car (car_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_warranty_pos   CHECK (warranty_months >= 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 5. USED_CAR        - Subtype: attributes specific to pre-owned cars
-- ---------------------------------------------------------------------
CREATE TABLE used_car (
    car_id              INT             NOT NULL,
    registered_city     VARCHAR(60)     NOT NULL,
    license_no          VARCHAR(30)     NOT NULL,
    mileage_km          INT             NOT NULL,
    previous_owners     INT             NOT NULL DEFAULT 1,
    registration_date   DATE            NOT NULL,
    CONSTRAINT pk_used_car       PRIMARY KEY (car_id),
    CONSTRAINT uq_license        UNIQUE      (license_no),
    CONSTRAINT fk_used_car_car   FOREIGN KEY (car_id)
        REFERENCES car (car_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_mileage_pos   CHECK (mileage_km >= 0),
    CONSTRAINT chk_owners_pos    CHECK (previous_owners >= 1)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 6. CAR_FEATURES    - 1:1 extension with comfort/safety features
-- ---------------------------------------------------------------------
CREATE TABLE car_features (
    car_id          INT         NOT NULL,
    air_bags        INT         NOT NULL DEFAULT 2,
    power_steering  BOOLEAN     NOT NULL DEFAULT TRUE,
    air_condition   BOOLEAN     NOT NULL DEFAULT TRUE,
    power_windows   BOOLEAN     NOT NULL DEFAULT TRUE,
    sunroof         BOOLEAN     NOT NULL DEFAULT FALSE,
    gps             BOOLEAN     NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_car_features       PRIMARY KEY (car_id),
    CONSTRAINT fk_car_features_car   FOREIGN KEY (car_id)
        REFERENCES car (car_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_airbags_range     CHECK (air_bags BETWEEN 0 AND 12)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 7. CUSTOMER
-- ---------------------------------------------------------------------
CREATE TABLE customer (
    customer_id     INT             NOT NULL AUTO_INCREMENT,
    name            VARCHAR(80)     NOT NULL,
    phone           VARCHAR(20)     NOT NULL,
    email           VARCHAR(120)    DEFAULT NULL,
    address         VARCHAR(150)    NOT NULL,
    city            VARCHAR(60)     NOT NULL,
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_customer         PRIMARY KEY (customer_id),
    CONSTRAINT uq_customer_phone   UNIQUE      (phone),
    CONSTRAINT uq_customer_email   UNIQUE      (email)
) ENGINE=InnoDB;

CREATE INDEX idx_customer_city ON customer (city);

-- ---------------------------------------------------------------------
-- 8. EMPLOYEE
-- ---------------------------------------------------------------------
CREATE TABLE employee (
    employee_id     INT             NOT NULL AUTO_INCREMENT,
    showroom_id     INT             NOT NULL,
    name            VARCHAR(80)     NOT NULL,
    phone           VARCHAR(20)     DEFAULT NULL,
    position        ENUM('Manager','Salesperson','Technician','Accountant','Receptionist')
                                    NOT NULL,
    salary          DECIMAL(10, 2)  NOT NULL,
    hire_date       DATE            NOT NULL,
    CONSTRAINT pk_employee         PRIMARY KEY (employee_id),
    CONSTRAINT fk_emp_showroom     FOREIGN KEY (showroom_id)
        REFERENCES showroom (showroom_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_salary_pos      CHECK (salary > 0)
) ENGINE=InnoDB;

CREATE INDEX idx_employee_showroom ON employee (showroom_id);
CREATE INDEX idx_employee_position ON employee (position);

-- ---------------------------------------------------------------------
-- 9. BOOKING         - Customer reserves a specific car
-- ---------------------------------------------------------------------
CREATE TABLE booking (
    booking_id      INT             NOT NULL AUTO_INCREMENT,
    customer_id     INT             NOT NULL,
    car_id          INT             NOT NULL,
    employee_id     INT             DEFAULT NULL,
    booking_date    DATE            NOT NULL,
    status          ENUM('pending','confirmed','cancelled','completed')
                                    NOT NULL DEFAULT 'pending',
    notes           VARCHAR(255)    DEFAULT NULL,
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_booking             PRIMARY KEY (booking_id),
    CONSTRAINT fk_booking_customer    FOREIGN KEY (customer_id)
        REFERENCES customer (customer_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_booking_car         FOREIGN KEY (car_id)
        REFERENCES car (car_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_booking_employee    FOREIGN KEY (employee_id)
        REFERENCES employee (employee_id)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE INDEX idx_booking_customer ON booking (customer_id);
CREATE INDEX idx_booking_car      ON booking (car_id);
CREATE INDEX idx_booking_date     ON booking (booking_date);
CREATE INDEX idx_booking_status   ON booking (status);

-- ---------------------------------------------------------------------
-- 10. CAR_PRODUCT    - Accessories / spare-parts catalogue
-- ---------------------------------------------------------------------
CREATE TABLE car_product (
    product_id      INT             NOT NULL AUTO_INCREMENT,
    product_name    VARCHAR(80)     NOT NULL,
    category        ENUM('accessory','spare_part','cleaning','electronic','safety','tool')
                                    NOT NULL,
    price           DECIMAL(10, 2)  NOT NULL,
    stock_quantity  INT             NOT NULL DEFAULT 0,
    description     VARCHAR(200)    DEFAULT NULL,
    CONSTRAINT pk_car_product      PRIMARY KEY (product_id),
    CONSTRAINT uq_product_name     UNIQUE      (product_name),
    CONSTRAINT chk_product_price   CHECK (price > 0),
    CONSTRAINT chk_product_stock   CHECK (stock_quantity >= 0)
) ENGINE=InnoDB;

CREATE INDEX idx_product_category ON car_product (category);
CREATE INDEX idx_product_stock    ON car_product (stock_quantity);

-- ---------------------------------------------------------------------
-- 11. INVOICE        - Billing record for a confirmed booking
-- ---------------------------------------------------------------------
CREATE TABLE invoice (
    invoice_id      INT             NOT NULL AUTO_INCREMENT,
    booking_id      INT             NOT NULL,
    total_amount    DECIMAL(12, 2)  NOT NULL,
    tax_amount      DECIMAL(12, 2)  NOT NULL DEFAULT 0.00,
    payment_method  ENUM('cash','card','bank_transfer','financing')
                                    NOT NULL DEFAULT 'cash',
    payment_status  ENUM('unpaid','partial','paid','refunded')
                                    NOT NULL DEFAULT 'unpaid',
    invoice_date    DATE            NOT NULL,
    CONSTRAINT pk_invoice           PRIMARY KEY (invoice_id),
    CONSTRAINT uq_invoice_booking   UNIQUE      (booking_id),
    CONSTRAINT fk_invoice_booking   FOREIGN KEY (booking_id)
        REFERENCES booking (booking_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_invoice_total    CHECK (total_amount >= 0),
    CONSTRAINT chk_invoice_tax      CHECK (tax_amount >= 0)
) ENGINE=InnoDB;

CREATE INDEX idx_invoice_status ON invoice (payment_status);
CREATE INDEX idx_invoice_date   ON invoice (invoice_date);

-- ---------------------------------------------------------------------
-- 12. PRODUCT_SALE   - Sale of accessories/spare-parts to a customer
--                      (was legacy "INVOICE" in the original schema)
-- ---------------------------------------------------------------------
CREATE TABLE product_sale (
    sale_id         INT             NOT NULL AUTO_INCREMENT,
    product_id      INT             NOT NULL,
    customer_id     INT             DEFAULT NULL,
    showroom_id     INT             NOT NULL,
    quantity        INT             NOT NULL,
    unit_price      DECIMAL(10, 2)  NOT NULL,
    sale_date       DATE            NOT NULL,
    CONSTRAINT pk_product_sale          PRIMARY KEY (sale_id),
    CONSTRAINT fk_sale_product          FOREIGN KEY (product_id)
        REFERENCES car_product (product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_sale_customer         FOREIGN KEY (customer_id)
        REFERENCES customer (customer_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_sale_showroom         FOREIGN KEY (showroom_id)
        REFERENCES showroom (showroom_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_sale_quantity_pos    CHECK (quantity > 0),
    CONSTRAINT chk_sale_unit_price_pos  CHECK (unit_price > 0)
) ENGINE=InnoDB;

CREATE INDEX idx_sale_product  ON product_sale (product_id);
CREATE INDEX idx_sale_customer ON product_sale (customer_id);
CREATE INDEX idx_sale_date     ON product_sale (sale_date);

-- ---------------------------------------------------------------------
-- 13. CAR_IMPORT     - Cost/logistics record for imported vehicles
-- ---------------------------------------------------------------------
CREATE TABLE car_import (
    import_id       INT             NOT NULL AUTO_INCREMENT,
    car_id          INT             NOT NULL,
    showroom_id     INT             NOT NULL,
    import_cost     DECIMAL(12, 2)  NOT NULL,
    import_date     DATE            NOT NULL,
    origin_country  VARCHAR(60)     DEFAULT NULL,
    CONSTRAINT pk_car_import           PRIMARY KEY (import_id),
    CONSTRAINT uq_car_import_car       UNIQUE      (car_id),
    CONSTRAINT fk_import_car           FOREIGN KEY (car_id)
        REFERENCES car (car_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_import_showroom      FOREIGN KEY (showroom_id)
        REFERENCES showroom (showroom_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_import_cost_pos     CHECK (import_cost >= 0)
) ENGINE=InnoDB;

CREATE INDEX idx_import_date ON car_import (import_date);

-- =====================================================================
-- Schema creation complete.
-- Run 02_insert_data.sql next to populate sample data.
-- =====================================================================

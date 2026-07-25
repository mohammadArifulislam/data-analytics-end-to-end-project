/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

IF OBJECT_ID('bronze.erp_employees', 'U') IS NOT NULL
    DROP TABLE bronze.erp_employees;

GO

CREATE TABLE bronze.erp_employees (
    employee_id     VARCHAR(100),
    first_name      VARCHAR(100),
    last_name       VARCHAR(100),
    email           VARCHAR(100),
    address         TEXT,
    department      VARCHAR(100),
    phone_number    VARCHAR(100),
    position        VARCHAR(100),
    join_date       DATE,
    birth_date      DATE,
    gender          VARCHAR(10)
)
IF OBJECT_ID('bronze.erp_salaries', 'U') IS NOT NULL
    DROP TABLE bronze.erp_salaries;

GO

CREATE TABLE bronze.erp_salaries (
    salary_id       VARCHAR(100),
    employee_id     VARCHAR(100),
    basic_salary    DECIMAL,
    bounus          DECIMAL,
    join_date       DATE,
    department      VARCHAR(100),
    over_time_hours INT,
    payment_date    DATE
);

GO

IF OBJECT_ID('bronze.erp_products', 'U') IS NOT NULL
    DROP TABLE bronze.erp_products;

GO

CREATE TABLE bronze.erp_products (
    product_id           VARCHAR(100),
    product_name         VARCHAR(100),
    category             VARCHAR(100),
    subcategory          VARCHAR(100),
    production_quantity  INT,
    production_date      DATE
);

GO

IF OBJECT_ID('bronze.crm_customers', 'U') IS NOT NULL
    DROP TABLE bronze.crm_customers;

GO

CREATE TABLE bronze.crm_customers (
    customer_id     VARCHAR(100),
    customer_name   VARCHAR(100),
    email           VARCHAR(100),
    city            VARCHAR(100),
    region          VARCHAR(100),
    country         VARCHAR(100),
    gender          VARCHAR(100),
    platform        VARCHAR(100)
)

GO

IF OBJECT_ID('bronze.crm_sales', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales;

GO

CREATE TABLE bronze.crm_sales (
    sale_id             VARCHAR(100),
    customer_id         VARCHAR(100),
    product_id          VARCHAR(100),
    order_quantity      INT,
    unit_price          FLOAT,
    order_date          DATE,
    shift_date          DATE,
    discount            FLOAT,
    tax                 FLOAT,
    payment_method      VARCHAR(100)
);

GO

IF OBJECT_ID('bronze.erp_costings', 'U') IS NOT NULL
    DROP TABLE bronze.erp_costings;

GO

CREATE TABLE bronze.erp_costings (
    product_id          VARCHAR(100),
    raw_material_cost   FLOAT,
    shiftment_cost      FLOAT,
    maintainance_cost   FLOAT,
    transportation_cost FLOAT,
);

GO


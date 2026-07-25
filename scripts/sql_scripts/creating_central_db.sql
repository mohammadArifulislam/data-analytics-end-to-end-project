/*
=============================================================
Create Central Database, Schemas and Tables
=============================================================
Script Purpose:
    This script creates a new central database named 'BluesLtd'. The script sets up two schemas 
    within the database: 'erp' & 'crm' using 'PostgreSQL' database with localhost.
Note:
    -The 'crm' source tables come from api request so that the tables design should match along with python tables schemas names.
    -The 'erp' source tables come from local csv file from the folders
*/
---creating database 
CREATE DATABASE BluesLtd;

---creating schemas 
CREATE SCHEMA erp;
CREATE SCHEMA crm;

---creating tables
CREATE TABLE erp.employees (
    employee_id     VARCHAR PRIMARY KEY NOT NULL,
    first_name      VARCHAR(100) NOT NULL,
    last_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    address         TEXT,
    department      VARCHAR(100),
    phone_number    VARCHAR(50),
    position        VARCHAR(100),
    join_date       DATE NOT NULL,
    birth_date      DATE,
    gender          VARCHAR(10)
);
CREATE TABLE erp.salaries (
    salary_id       VARCHAR PRIMARY KEY NOT NULL,
    employee_id     VARCHAR NOT NULL,
    basic_salary    DECIMAL(10, 2) NOT NULL,
    bounus          DECIMAL(10, 2),
    join_date       DATE NOT NULL,
    department      VARCHAR(50),
    over_time_hours INT,
    payment_date    DATE,

    FOREIGN KEY (employee_id) REFERENCES erp.employees(employee_id)
);0

CREATE TABLE erp.products (
    product_id           VARCHAR PRIMARY KEY NOT NULL,
    product_name         VARCHAR(100) NOT NULL,
    category             VARCHAR(100),
    subcategory          VARCHAR(100),
    production_quantity  INT,
    production_date      DATE
);
CREATE TABLE crm.customers (
    customer_id     VARCHAR,
    customer_name   VARCHAR,
    email           VARCHAR,
    city            VARCHAR,
    region          VARCHAR,
    country         VARCHAR,
    gender          VARCHAR,
    platform        VARCHAR
);
CREATE TABLE crm.sales (
    sale_id             VARCHAR PRIMARY KEY NOT NULL,
    customer_id         VARCHAR,
    product_id          VARCHAR,
    order_quantity      INT,
    unit_price          FLOAT,
    order_date          DATE,
    shift_date          DATE,
    discount            FLOAT,
    tax                 FLOAT,
    payment_method      VARCHAR
);
CREATE TABLE erp.costings (
    product_id          VARCHAR,
    raw_material_cost   FLOAT,
    shiftment_cost      FLOAT,
    maintainance_cost   FLOAT,
    transportation_cost FLOAT
);

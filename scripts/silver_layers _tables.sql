/*
===============================================================================
DDL Script: Create Silver Layer Tables
===============================================================================
Script Purpose:
    This script drops and recreates the tables in the 'silver' schema.
    The 'silver' schema acts as the refined layer for clean, standardized data.
    Data types here are strict (e.g., DATE) to ensure data quality.

Owner: Mohamed Amir
Date:   2026-02-13
*/

-------------------------------------------------------------------------------
-- Section 1: CRM Tables (Customer Relationship Management)
-------------------------------------------------------------------------------

-- 1.1 Product Information
-- Stores refined product data including product key, name, cost, and lifecycle dates.
DROP TABLE IF EXISTS silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info (
    prd_id       INT,
    prd_key      VARCHAR(50),
    prd_nm       VARCHAR(50),
    prd_cost     INT,
    prd_line     VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt   DATE,
	dwh_create_date TIMESTAMP DEFAULT NOW()
);

-- 1.2 Customer Information
-- Stores refined customer demographics.
DROP TABLE IF EXISTS silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info (
    cst_id             INT,
    cst_key            VARCHAR(50),
    cst_firstname      VARCHAR(50),
    cst_lastname       VARCHAR(50),
    cst_martial_status VARCHAR(50),
    cst_gender         VARCHAR(50),
    cst_create_date    DATE,
	dwh_create_date TIMESTAMP DEFAULT NOW()
);

-- 1.3 Sales Details
-- Stores transactional sales data.
-- NOTE: Date columns have been converted from INT (Excel Serial) to DATE
--       for proper time-based analysis.
DROP TABLE IF EXISTS silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details (
    sls_ord_num  VARCHAR(50),
    sls_prd_key  VARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt DATE,          -- Changed to DATE
    sls_ship_dt  DATE,          -- Changed to DATE
    sls_due_dt   DATE,          -- Changed to DATE
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT,
	dwh_create_date TIMESTAMP DEFAULT NOW()
);

-------------------------------------------------------------------------------
-- Section 2: ERP Tables (Enterprise Resource Planning)
-------------------------------------------------------------------------------

-- 2.1 ERP Customer Data (AZ12)
-- Legacy customer data from the ERP system.
DROP TABLE IF EXISTS silver.erp_Cust_AZ12;

CREATE TABLE silver.erp_Cust_AZ12 (
    CID    VARCHAR(50),
    BDATE  DATE,
    GEN    VARCHAR(50),
	dwh_create_date TIMESTAMP DEFAULT NOW()
);

-- 2.2 ERP Location Data (A101)
-- Stores customer location/country mappings.
DROP TABLE IF EXISTS silver.erp_LOC_A101;

CREATE TABLE silver.erp_LOC_A101 (
    CID    VARCHAR(50),
    Cntry  VARCHAR(50),
	dwh_create_date TIMESTAMP DEFAULT NOW()
);

-- 2.3 ERP Category Data (G1V2)
-- Stores product categories, subcategories, and maintenance flags.
DROP TABLE IF EXISTS silver.erp_CAT_G1V2;

CREATE TABLE silver.erp_CAT_G1V2 (
    ID          VARCHAR(50),
    CAT         VARCHAR(50),
    SUBCAT      VARCHAR(50),
    MAINTENANCE VARCHAR(50),
	dwh_create_date TIMESTAMP DEFAULT NOW()
);
/*
===============================================================================
DDL Script: Create Bronze Layer Tables
===============================================================================
Script Purpose:
    This script drops and recreates the tables in the 'bronze' schema.
    The 'bronze' schema acts as the raw landing zone for data ingestion.
    Data types here are purposely loose (VARCHAR, INT) to prevent load failures.

Owner:  [Your Name]
Date:   2026-02-13
*/

-------------------------------------------------------------------------------
-- Section 1: CRM Tables (Customer Relationship Management)
-------------------------------------------------------------------------------

-- 1.1 Product Information
-- Stores raw product data including product key, name, cost, and lifecycle dates.
DROP TABLE IF EXISTS bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      VARCHAR(50),
    prd_nm       VARCHAR(50),
    prd_cost     INT,
    prd_line     VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt   DATE
);

-- 1.2 Customer Information
-- Stores raw customer demographics.
DROP TABLE IF EXISTS bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info (
    cst_id             INT,
    cst_key            VARCHAR(50),
    cst_firstname      VARCHAR(50),
    cst_lastname       VARCHAR(50),
    cst_martial_status VARCHAR(50),
    cst_gender         VARCHAR(50),
    cst_create_date    DATE
);

-- 1.3 Sales Details
-- Stores transactional sales data.
-- NOTE: Date columns (order, ship, due) are defined as INT to handle 
--       Excel serial dates (e.g., 45335) from the source CSV.
DROP TABLE IF EXISTS bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  VARCHAR(50),
    sls_prd_key  VARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);

-------------------------------------------------------------------------------
-- Section 2: ERP Tables (Enterprise Resource Planning)
-------------------------------------------------------------------------------

-- 2.1 ERP Customer Data (AZ12)
-- Legacy customer data from the ERP system.
DROP TABLE IF EXISTS bronze.erp_Cust_AZ12;

CREATE TABLE bronze.erp_Cust_AZ12 (
    CID    VARCHAR(50),
    BDATE  DATE,
    GEN    VARCHAR(50)
);

-- 2.2 ERP Location Data (A101)
-- Stores customer location/country mappings.
DROP TABLE IF EXISTS bronze.erp_LOC_A101;

CREATE TABLE bronze.erp_LOC_A101 (
    CID    VARCHAR(50),
    Cntry  VARCHAR(50)
);

-- 2.3 ERP Category Data (G1V2)
-- Stores product categories, subcategories, and maintenance flags.
DROP TABLE IF EXISTS bronze.erp_CAT_G1V2;

CREATE TABLE bronze.erp_CAT_G1V2 (
    ID          VARCHAR(50),
    CAT         VARCHAR(50),
    SUBCAT      VARCHAR(50),
    MAINTENANCE VARCHAR(50)
);
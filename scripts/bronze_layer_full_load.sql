/*
===============================================================================
DDL Script: Bronze Layer - Truncate and Load
Author: [Your Name]
Description: Clears all Bronze tables and reloads them from source CSVs.
===============================================================================
*/

-------------------------------------------------------------------------------
-- 1. CRM TABLES (Source: source_crm)
-------------------------------------------------------------------------------

-- 1.1 Product Info
TRUNCATE TABLE bronze.crm_prd_info;

COPY bronze.crm_prd_info FROM 'C:\Users\Ninja Zone\Desktop\Data Engineering\Data warehouse\Project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- 1.2 Customer Info
TRUNCATE TABLE bronze.crm_cust_info;

COPY bronze.crm_cust_info FROM 'C:\Users\Ninja Zone\Desktop\Data Engineering\Data warehouse\Project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- 1.3 Sales Details (The one with the date integers)
TRUNCATE TABLE bronze.crm_sales_details;

COPY bronze.crm_sales_details FROM 'C:\Users\Ninja Zone\Desktop\Data Engineering\Data warehouse\Project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-------------------------------------------------------------------------------
-- 2. ERP TABLES (Source: source_erp)
-------------------------------------------------------------------------------

-- 2.1 Customer AZ12
TRUNCATE TABLE bronze.erp_Cust_AZ12;

COPY bronze.erp_Cust_AZ12 FROM 'C:\Users\Ninja Zone\Desktop\Data Engineering\Data warehouse\Project\sql-data-warehouse-project\datasets\source_erp\Cust_AZ12.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- 2.2 Location A101
TRUNCATE TABLE bronze.erp_LOC_A101;

COPY bronze.erp_LOC_A101 FROM 'C:\Users\Ninja Zone\Desktop\Data Engineering\Data warehouse\Project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',');

-- 2.3 Category G1V2
TRUNCATE TABLE bronze.erp_CAT_G1V2;

COPY bronze.erp_CAT_G1V2 FROM 'C:\Users\Ninja Zone\Desktop\Data Engineering\Data warehouse\Project\sql-data-warehouse-project\datasets\source_erp\CAT_G1V2.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',');


-------------------------------------------------------------------------------
-- 3. QUALITY CHECK (Verify Row Counts)
-------------------------------------------------------------------------------
SELECT 'crm_prd_info' as table_name, COUNT(*) as row_count FROM bronze.crm_prd_info
UNION ALL
SELECT 'crm_cust_info', COUNT(*) FROM bronze.crm_cust_info
UNION ALL
SELECT 'crm_sales_details', COUNT(*) FROM bronze.crm_sales_details
UNION ALL
SELECT 'erp_Cust_AZ12', COUNT(*) FROM bronze.erp_Cust_AZ12
UNION ALL
SELECT 'erp_LOC_A101', COUNT(*) FROM bronze.erp_LOC_A101
UNION ALL
SELECT 'erp_CAT_G1V2', COUNT(*) FROM bronze.erp_CAT_G1V2;
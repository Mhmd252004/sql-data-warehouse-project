/*
===============================================================================
Quality Check: Data Sample
Description: Inspects the first 5 rows of each table to verify schema alignment.
===============================================================================
*/

-- CRM Tables
SELECT * FROM bronze.crm_cust_info LIMIT 5;
SELECT * FROM bronze.crm_prd_info LIMIT 5;
SELECT * FROM bronze.crm_sales_details LIMIT 5;

-- ERP Tables
SELECT * FROM bronze.erp_cat_g1v2 LIMIT 5;
SELECT * FROM bronze.erp_cust_az12 LIMIT 5;
SELECT * FROM bronze.erp_loc_a101 LIMIT 5;

-------------------------------------------------------------------------------
 -- QUALITY CHECK (Verify Row Counts)
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
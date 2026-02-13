--------------------------------------------------------------------------
--- Using Stored Procedure as I use this Script Frequently 
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--- To use it 
--- Run call bronze.load_bronze();
---------------------------------------------------------------------------


CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
BEGIN
    ---------------------------------------------------------------------------
    -- 1. CRM TABLES
    ---------------------------------------------------------------------------
    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading CRM Tables...';
    RAISE NOTICE '------------------------------------------------';

    -- 1.1 Product Info
    RAISE NOTICE '>> Truncating and Loading: bronze.crm_prd_info';
    TRUNCATE TABLE bronze.crm_prd_info;
    COPY bronze.crm_prd_info 
    FROM 'C:/Users/Ninja Zone/Desktop/Data Engineering/Data warehouse/Project/sql-data-warehouse-project/datasets/source_crm/prd_info.csv' 
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    -- 1.2 Customer Info
    RAISE NOTICE '>> Truncating and Loading: bronze.crm_cust_info';
    TRUNCATE TABLE bronze.crm_cust_info;
    COPY bronze.crm_cust_info 
    FROM 'C:/Users/Ninja Zone/Desktop/Data Engineering/Data warehouse/Project/sql-data-warehouse-project/datasets/source_crm/cust_info.csv' 
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    -- 1.3 Sales Details
    RAISE NOTICE '>> Truncating and Loading: bronze.crm_sales_details';
    TRUNCATE TABLE bronze.crm_sales_details;
    COPY bronze.crm_sales_details 
    FROM 'C:/Users/Ninja Zone/Desktop/Data Engineering/Data warehouse/Project/sql-data-warehouse-project/datasets/source_crm/sales_details.csv' 
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    ---------------------------------------------------------------------------
    -- 2. ERP TABLES
    ---------------------------------------------------------------------------
    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Loading ERP Tables...';
    RAISE NOTICE '------------------------------------------------';

    -- 2.1 Customer AZ12
    RAISE NOTICE '>> Truncating and Loading: bronze.erp_Cust_AZ12';
    TRUNCATE TABLE bronze.erp_Cust_AZ12;
    COPY bronze.erp_Cust_AZ12 
    FROM 'C:/Users/Ninja Zone/Desktop/Data Engineering/Data warehouse/Project/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv' 
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    -- 2.2 Location A101
    RAISE NOTICE '>> Truncating and Loading: bronze.erp_LOC_A101';
    TRUNCATE TABLE bronze.erp_LOC_A101;
    COPY bronze.erp_LOC_A101 
    FROM 'C:/Users/Ninja Zone/Desktop/Data Engineering/Data warehouse/Project/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv' 
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    -- 2.3 Category G1V2 (UPDATED FILENAME HERE)
    RAISE NOTICE '>> Truncating and Loading: bronze.erp_CAT_G1V2';
    TRUNCATE TABLE bronze.erp_CAT_G1V2;
    COPY bronze.erp_CAT_G1V2 
    FROM 'C:/Users/Ninja Zone/Desktop/Data Engineering/Data warehouse/Project/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv' 
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE '✅ Bronze Layer Loaded Successfully';
    RAISE NOTICE '------------------------------------------------';

END;
$$;


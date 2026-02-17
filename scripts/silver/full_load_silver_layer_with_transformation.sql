CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_step_start_time TIMESTAMP;
    v_step_end_time TIMESTAMP;
BEGIN
    v_start_time := clock_timestamp();
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Starting Silver Layer Load';
    RAISE NOTICE '================================================';

    ---------------------------------------------------------------------------
    -- 1. Load silver.crm_cust_info
    ---------------------------------------------------------------------------
    v_step_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating and Loading: silver.crm_cust_info';
    TRUNCATE TABLE silver.crm_cust_info;
    
    INSERT INTO silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname, cst_martial_status, cst_gender, cst_create_date)
    SELECT 
        cst_id, cst_key, TRIM(cst_firstname), TRIM(cst_lastname),
        CASE WHEN UPPER(TRIM(cst_martial_status)) = 'M' THEN 'Married'
             WHEN UPPER(TRIM(cst_martial_status)) = 'S' THEN 'Single'
             ELSE 'n/a' END,
        CASE WHEN UPPER(TRIM(cst_gender)) = 'M' THEN 'Male'
             WHEN UPPER(TRIM(cst_gender)) = 'F' THEN 'Female'
             ELSE 'n/a' END,
        cst_create_date
    FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
        FROM bronze.crm_cust_info
        WHERE cst_id IS NOT NULL
    ) t WHERE flag_last = 1;
    
    v_step_end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: %', v_step_end_time - v_step_start_time;

    ---------------------------------------------------------------------------
    -- 2. Load silver.crm_prd_info
    ---------------------------------------------------------------------------
    v_step_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating and Loading: silver.crm_prd_info';
    TRUNCATE TABLE silver.crm_prd_info;

    INSERT INTO silver.crm_prd_info (prd_id, prd_cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt)
    SELECT 
        prd_id,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'),
        SUBSTRING(prd_key, 7, LENGTH(prd_key)),
        prd_nm,
        COALESCE(prd_cost, 0),
        CASE UPPER(TRIM(prd_line))
             WHEN 'R' THEN 'Road'
             WHEN 'S' THEN 'Other Sales'
             WHEN 'M' THEN 'Mountain'
             WHEN 'T' THEN 'Touring'
             ELSE 'Unknown' END,
        prd_start_dt,
        LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1
    FROM bronze.crm_prd_info;

    v_step_end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: %', v_step_end_time - v_step_start_time;

    ---------------------------------------------------------------------------
    -- 3. Load silver.crm_sales_details
    ---------------------------------------------------------------------------
    v_step_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating and Loading: silver.crm_sales_details';
    TRUNCATE TABLE silver.crm_sales_details;

    INSERT INTO silver.crm_sales_details (sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price)
    SELECT 
        sls_ord_num, sls_prd_key, sls_cust_id,
        CASE WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt::TEXT) < 8 THEN NULL ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) END,
        CASE WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt::TEXT) < 8 THEN NULL ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) END,
        CASE WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt::TEXT) < 8 THEN NULL ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) END,
        CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price) ELSE sls_sales END,
        sls_quantity,
        CASE WHEN sls_price IS NULL OR sls_price = 0 THEN sls_sales / NULLIF(sls_quantity, 0)
             WHEN sls_price < 0 THEN ABS(sls_price)
             ELSE sls_price END
    FROM bronze.crm_sales_details;

    v_step_end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: %', v_step_end_time - v_step_start_time;

    ---------------------------------------------------------------------------
    -- 4. Load silver.erp_loc_a101
    ---------------------------------------------------------------------------
    v_step_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating and Loading: silver.erp_loc_a101';
    TRUNCATE TABLE silver.erp_loc_a101;

    INSERT INTO silver.erp_loc_a101 (cid, cntry)
    SELECT
        REPLACE(cid, '-', ''),
        CASE WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
             WHEN cntry IS NULL OR TRIM(cntry) = '' THEN 'Unknown'
             WHEN TRIM(cntry) = 'DE' THEN 'Germany'
             ELSE TRIM(cntry) END
    FROM bronze.erp_loc_a101;

    v_step_end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: %', v_step_end_time - v_step_start_time;

    ---------------------------------------------------------------------------
    -- 5. Load silver.erp_cust_az12
    ---------------------------------------------------------------------------
    v_step_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating and Loading: silver.erp_cust_az12';
    TRUNCATE TABLE silver.erp_cust_az12;

    INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
    SELECT 
        CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid)) ELSE cid END,
        CASE WHEN bdate > CURRENT_DATE THEN NULL ELSE bdate END,
        CASE WHEN gen IS NULL OR TRIM(gen) = '' THEN 'Unknown'
             WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
             WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
             ELSE TRIM(gen) END
    FROM bronze.erp_cust_az12;

    v_step_end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: %', v_step_end_time - v_step_start_time;

    ---------------------------------------------------------------------------
    -- 6. Load silver.erp_cat_g1v2
    ---------------------------------------------------------------------------
    v_step_start_time := clock_timestamp();
    RAISE NOTICE '>> Truncating and Loading: silver.erp_cat_g1v2';
    TRUNCATE TABLE silver.erp_cat_g1v2;

    INSERT INTO silver.erp_cat_g1v2 (id, cat, subcat, maintenance)
    SELECT id, cat, subcat, maintenance
    FROM bronze.erp_cat_g1v2;

    v_step_end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration: %', v_step_end_time - v_step_start_time;

    ---------------------------------------------------------------------------
    -- Final Duration
    ---------------------------------------------------------------------------
    v_end_time := clock_timestamp();
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Total Silver Layer Load Duration: %', v_end_time - v_start_time;
    RAISE NOTICE '================================================';

EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'ERROR OCCURRED DURING SILVER LOAD!';
    RAISE NOTICE 'Error Message: %', SQLERRM;
    RAISE NOTICE 'Error Code: %', SQLSTATE;
    RAISE NOTICE '------------------------------------------------';
    ROLLBACK;
END;
$$;
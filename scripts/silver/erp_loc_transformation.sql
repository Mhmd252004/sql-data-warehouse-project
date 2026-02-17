truncate silver.erp_cust_az12
INSERT INTO silver.erp_loc_a101(cid,cntry)

SELECT
replace(cid,'-','') as cid,
case when trim(cntry) in ('US','USA')  then 'United States'
              when cntry is null or trim(cntry) ='' then 'Unknown'
	          when trim(cntry)='DE' then 'Germany'
	          ELSE trim(cntry) end as cntry

from  bronze.erp_loc_a101
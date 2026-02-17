truncate silver.erp_cust_az12
insert into silver.erp_cust_az12(cid,bdate,gen)
SELECT 
case when cid LIKE 'NAS%' then substring(cid,4,length(cid))
     else cid end as cid ,

	 
case when bdate> CURRENT_DATE then Null
     else bdate end as bdate,

	 
case when gen is null then 'Unknown'
     when upper(trim(gen))  in('F','Female') then 'Female'
	 when upper(trim(gen)) in('M','Male')then 'Male'
	 when trim(gen) = '' then 'Unknown'
	 else gen end as gen
from bronze.erp_cust_az12


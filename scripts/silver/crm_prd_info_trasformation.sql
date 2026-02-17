TRUNCATE silver.crm_prd_info
INSERT INTO silver.crm_prd_info(prd_id,prd_cat_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt)

select prd_id,

REPLACE(SUBSTRING(prd_key,1,5),'-','_')as prd_cat_id,

SUBSTRING(prd_key,7,length(prd_key))as prd_key,

prd_nm,

coalesce(prd_cost,0)as prd_cost ,

case upper(trim(prd_line))
     when 'R' then 'Road'
     when 'S' then 'Other Sales'
	 when 'M' then 'Mountain'
	 when 'T' then 'Touring'
	 else 'Unknown' end as prd_line,
	 
prd_start_dt,

lead(prd_start_dt)over(partition by prd_key order by prd_start_dt) -1 as prd_end_dt
from bronze.crm_prd_info
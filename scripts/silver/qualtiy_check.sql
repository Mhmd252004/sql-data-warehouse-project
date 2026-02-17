-- quality check for nulls and duplicates 
SELECT Count(*)
from silver.crm_cust_info
WHERE crm_cust_info.cst_id is null

select cst_id,count(*)
FROM silver.crm_cust_info
GROUP by crm_cust_info.cst_id
HAVING count(*) >1

-- quality check for strings 
select crm_cust_info.cst_firstname , length(crm_cust_info.cst_firstname)
from bronze.crm_cust_info
where crm_cust_info.cst_firstname != trim(crm_cust_info.cst_firstname)

select crm_cust_info.cst_lastname , length(crm_cust_info.cst_lastname)
from bronze.crm_cust_info
where crm_cust_info.cst_lastname != trim(crm_cust_info.cst_lastname)

select * from silver.crm_cust_info


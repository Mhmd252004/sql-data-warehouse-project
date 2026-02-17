TRUNCATE silver.crm_cust_info
-- insert the transformed data 
INSERT INTO silver.crm_cust_info(cst_id,cst_key,cst_firstname,cst_lastname,cst_martial_status,cst_gender,cst_create_date)
-- remove duplicates, nulls, unwanted spaces from strings 
SELECT cst_id,
cst_key,
trim(cst_firstname) as cst_firstname,
trim(cst_lastname) as cst_lastname,
case when upper(trim(cst_martial_status)) = 'M' then 'Married'
     when upper(trim(cst_martial_status)) = 'S' then 'Single'
	 else  'n/a' end 
,
case when upper(TRIM(cst_gender)) = 'M' then 'Male'
     when upper(TRIM(cst_gender)) = 'F' then 'Female'
	 else  'n/a' end
,
cst_create_date
from(
select * 
,ROW_NUMBER() OVER(PARTITION BY cst_id order by cst_create_date DESC ) as flag_last
from bronze.crm_cust_info
WHERE cst_id is not null
) 
WHERE flag_last=1



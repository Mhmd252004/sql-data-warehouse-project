---- Customer Dimension 
CREATE VIEW gold.dim_customer As 
SELECT 
	row_number() over( order by ci.cst_id  asc) as customer_key,
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	el.cntry as country,
	case when ci.cst_gender != 'n/a' then ci.cst_gender
	     else COALESCE(ec.gen,'n/a') end as gender,
	ci.cst_martial_status as martial_status,
	ci.cst_create_date as create_date,
	ec.bdate as birthdate
from silver.crm_cust_info as ci
LEFT join silver.erp_cust_az12 as ec
ON ci.cst_key=ec.cid
LEFT join silver.erp_loc_a101 as el
on  ci.cst_key=el.cid

----- Product Dim
CREATE  VIEW gold.dim_product AS
SELECT 
    row_number() over(order by pd.prd_start_dt,pd.prd_id asc) as product_key,
	pd.prd_id as product_id,
	pd.prd_key as product_number,
	pd.prd_nm as product_name,
	pd.prd_cat_id as category_id,
	c.cat as category,
	c.subcat as sub_category,
	c.maintenance as maintenance,
	
	pd.prd_cost as product_cost,
	pd.prd_line as product_line,
	
	pd.prd_start_dt as start_date 
	-- pd.prd_end_dt,


from silver.crm_prd_info as pd


left join silver.erp_cat_g1v2 as c
on pd.prd_cat_id=c.id

where pd.prd_end_dt is null -- filter historical data 


----- Sales Fact
create VIEW gold.fact_sales AS
SELECT
sd.sls_ord_num as order_key,
dim_product.product_key ,
dim_customer.customer_key,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as ship_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales,
sd.sls_quantity as quantity,
sd.sls_price as price

FROM silver.crm_sales_details as sd
left join gold.dim_customer 
on sd.sls_cust_id=dim_customer.customer_id
left join gold.dim_product
on sd.sls_prd_key=dim_product.producct_number


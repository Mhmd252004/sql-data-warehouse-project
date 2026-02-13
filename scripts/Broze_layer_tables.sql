DROP TABLE IF EXISTS bronze.crm_prd_info;
create table bronze.crm_prd_info(
prd_id int 
,prd_key varchar(50)
,prd_nm varchar(50)
,prd_cost int
,prd_line varchar(50)
,prd_start_dt date
,prd_end_dt date
);

DROP TABLE IF EXISTS bronze.crm_cust_info;
create table bronze.crm_cust_info(
cst_id int 
,cst_key varchar(50)
,cst_firstname varchar(50)
,cst_lastname varchar(50)
,cst_martial_status varchar(50)
,cst_gender varchar(50)
,cst_create_date date
);

DROP TABLE IF EXISTS bronze.crm_sales_details;
create table bronze.crm_sales_details(
sls_ord_num varchar(50)
,sls_prd_key varchar(50)
,sls_cst_id int
,sls_sales int
,sls_quatity int
,sls_price int
,sls_order_dt date
,sls_ship_dt date
,sls_due_dt date
);

DROP TABLE IF EXISTS bronze.erp_Cust_AZ12;
create table bronze.erp_Cust_AZ12(
CID varchar(50),
BDATE date,
GEN varchar(50)
);

DROP TABLE IF EXISTS bronze.erp_LOC_A101;
create table bronze.erp_LOC_A101(
CID varchar(50),
Cntry varchar(50)
);

DROP TABLE IF EXISTS bronze.erp_CAT_G1V2;
create table bronze.erp_CAT_G1V2(
ID varchar(50),
CAT varchar(50),
SUBCAT varchar(50),
MAINTENANCE varchar(50)
);
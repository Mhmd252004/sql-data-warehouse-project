truncate silver.erp_cat_g1v2
INSERT into silver.erp_cat_g1v2
select id,cat,subcat,maintenance
from bronze.erp_cat_g1v2


select * from silver.erp_cat_g1v2

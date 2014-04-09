--note this script currently performs a full build, could be turned incrementally easily 
--change insert overwrite and remove d_business ddl

CREATE external TABLE stg_business (
    business_id string ,
    business_name string,
    city string,
    state string,
    longitude float,
    latitied float,
    categories string)
  row format delimited fields terminated by '|'
  location '/data/business';
  

create external table d_business (
    business_id string,
    business_name string,
    city string,
    state string,
    longitude float,
    latitied float,
    categories string )
  stored as parquetfile
  location '/data/d_business';
       

insert overwrite d_business (
    business_id ,
    business_name ,
    city ,
    state ,
    longitude ,
    latitied ,
    categories  )
select
  business_id ,
  business_name ,
  city ,
  state ,
  longitude ,
  latitied ,
  categories 
from stg_business;

refresh d_business

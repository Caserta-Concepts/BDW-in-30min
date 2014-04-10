
--commment this DDL if you want to test incremental load
drop table d_business;

create table d_business (
  business_id varchar distkey sortkey,
  business_name varchar(200),
  city varchar(100),
  state varchar(100),
  longitude float,
  latitied float,
  category_list varchar(5000),
  etl_last_modified datetime);


--code below can be used as a design patter for "quick and dirty" incremental load
--it assumes new data to be loaded is present in your input bucket
drop table stg_business;

CREATE TABLE stg_business
(
  business_id varchar distkey sortkey,
  business_name varchar(200),
  city varchar(100),
  state varchar(100),
  longitude float,
  latitied float,
  categories varchar(5000) );
  
COPY stg_business from 's3://<your bucket>/yelp/out/business/' 
 CREDENTIALS 'aws_access_key_id=<id>;aws_secret_access_key=<key>'
 escape 
 delimiter '|' dateformat 'DD/MM/YYYY';
 


delete from d_business where business_id in (select business_id from stg_business);


insert into d_business(
  business_id ,
  business_name,
  city,
  state,
  longitude,
  latitied,
  category_list,
  etl_last_modified)
select 
  business_id ,
  business_name,
  city,
  state,
  longitude,
  latitied,
  categories,
  '2014-04-05 07:47'
from stg_business;

analyze d_business;


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               

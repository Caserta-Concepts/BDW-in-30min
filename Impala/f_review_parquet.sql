--note this script currently performs a full build, could be turned incrementally easily 
--change insert overwrite and remove f_reviews ddl

create external table stg_reviews (   
    review_id  string,
    review_date_id integer,
    business_id  string,
    user_id  string,
    rating  float,
    good_review_count integer,
    bad_review_count integer)
  row format delimited fields terminated by '|'
  location '/data/reviews';   
    

create external table f_reviews (
    review_id  string,
    business_id  string,
    user_id  string,
    rating  float,
    good_review_count integer,
    bad_review_count integer)
  partitioned by (review_date_id integer)
  stored as parquetfile
  location '/data/f_reviews';
    
insert overwrite f_reviews (
    review_id  ,
    business_id  ,
    user_id  ,
    rating  ,
    good_review_count ,
    bad_review_count)
  partition (review_date_id) 
select 
  review_id  ,
  business_id  ,
  user_id  ,
  rating  ,
  good_review_count ,
  bad_review_count ,
  review_date_id 
from stg_reviews;

refresh f_reviews;


--some tests
/*
select business_name, count(1), sum(good_review_count), sum(good_review_count)/cast(count(1) as float)
from f_reviews  f
  join d_business d on f.business_id=d.business_id
where review_date_id between 20111201 and 20111231
  and city='Phoenix' 
group by business_name
having count(1) >200
order by 4 desc
limit 100000



select business_name, count(1), sum(good_review_count), sum(good_review_count)/cast(count(1) as float)
from f_reviews  f
  join d_business d on f.business_id=d.business_id
where review_date_id between 20111201 and 20111231
  and city='Phoenix' 
  and categories like '%Mexican%'
group by business_name
having count(1) >200
order by 4 desc
limit 100000
*/

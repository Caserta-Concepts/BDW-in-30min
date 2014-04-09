--commment this DDL if you want to test incremental load
drop table f_reviews;

create table f_reviews (
    review_id  varchar(50),
    review_date_id int sortkey,
    business_id  varchar(50),
    user_id  varchar(50) distkey,
    rating  float,
    good_review_count integer,
    bad_review_count integer,
    etl_last_modified datetime);

--code below can be used as a design patter for "quick and dirty" incremental load
--it assumes new data to be loaded is present in your input bucket
drop table stg_reviews;

create table stg_reviews (
    review_id  varchar(50),
    review_date_id int sortkey,
    business_id  varchar(50),
    user_id  varchar(50) distkey,
    rating  float,
    good_review_count integer,
    bad_review_count integer);
    

COPY stg_reviews from 's3://caserta-bucket1/yelp/out/reviews/' 
 CREDENTIALS 'aws_access_key_id=AKIAIRD63L75JEDZ6D7Q;aws_secret_access_key=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'
 delimiter '|' dateformat 'YYYY-MM-DD';
 


delete from f_reviews where review_id in (select review_id from stg_reviews);


insert into f_reviews(
    review_id,
    review_date_id,
    business_id,
    user_id,
    rating,
    good_review_count,
    bad_review_count)
select 
    review_id,
    review_date_id,
    business_id,
    user_id,
    rating,
    good_review_count,
    bad_review_count
from stg_reviews;

analyze f_reviews;

--tests
/*
select city, count(1)
from f_reviews  f
  join d_business d on f.business_id=d.business_id
  join d_date dt on f.review_date_id= dt.date_id
where year=2014
group by city
order by 1 desc


select business_name, count(1), sum(good_review_count), sum(good_review_count)/cast(count(1) as float)
from f_reviews  f
  join d_business d on f.business_id=d.business_id
  join d_date dt on f.review_date_id= dt.date_id
where year=2011 and city='Surprise' and category_list like '%Restr%'
group by business_name
having count(1) >200
order by 4 desc


select business_name, count(1), sum(good_review_count), sum(good_review_count)/cast(count(1) as float)
from f_reviews  f
  join d_business d on f.business_id=d.business_id
where review_date_id between 20131201 and 20131231
  and city='Scottsdale' 
group by business_name
having count(1) >200
order by 4 desc
limit 100000
*/



drop table d_date;

CREATE TABLE d_date
(
  date_id int distkey sortkey,
  day varchar(10),
  year int,
  month_num int,
  day_of_week int,
  day_name varchar(10) );
  
COPY d_date from 's3://<your bucket>/yelp/out/date/' 
 CREDENTIALS 'aws_access_key_id=<id>;aws_secret_access_key=<key>'
 escape 
 delimiter '|' dateformat 'DD/MM/YYYY';
 

analyze d_date;

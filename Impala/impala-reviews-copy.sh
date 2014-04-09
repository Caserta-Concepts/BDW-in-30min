hadoop fs -mkdir /data
hadoop fs -mkdir /data/reviews

hadoop distcp 's3://caserta-bucket1/yelp/out/reviews/' /data/


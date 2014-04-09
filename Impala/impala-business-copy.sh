hadoop fs -mkdir /data
hadoop fs -mkdir /data/business

hadoop distcp 's3://caserta-bucket1/yelp/out/business/' /data/

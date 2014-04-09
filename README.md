Big Data Warehouse on the Cloud in 30 Min
============

#High Level Process
This should be fairly complete.  Let me know if you run into any issues.

##Setup

1 -  If you haven't done so already sign up for an AWS account

2 -  Copy all our files from our public S3 bucket to your S3 instance
s3://caserta-public/

Easiest way is to install and configure [AWS Cli](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)

Then issue the cmd from your local terminal
```
aws s3 sync s3://caserta-public  s3://<your-bucket>
```

3 -  Your S3 setup a bucket and key structure will be similar to this  

```
/<your-bucket>  
  /libs   
  /yelp  
    /in
      /users
      /reviews
	  /business 
	/out
	  /reviews
	  /business 
	  /date
	/etl
```			
			


4 - Clone this git repo, edit all paths to point to your bucket (if i have time i'll paramterize)


##EMR
Note the below instructions assume you will be working with Redshift as the final presentation layer.  If you want to play with Impala for extra credit, install Hive and Impala, configure and assign a PEM file (see documentation on how to do that), and turn off Auto-Terminate.

1 - Provision and EMR instance, a small cluster will do fine (just a couple of task nodes, large or xlarge).  6 xlarge were used in testing, any more than that will not significan't improve run time (reviews ETL is only taking 5 minutes)

2 -  Make sure pig is selected as an application, add steps for s2w_business.pig and s2w_reviews.pig, input and output paths will correspond to those setup on S3 in step 2.

3 - Set Auto-Terminate to on or simply remember to Terminate the cluster when you are no longer using it, then create your cluster.

4 - monitor your cluster and when the job is complete, download and review one of the output file parts from reviews and business


##Redshift
1 - First create a Cluster Security Group called demo, add an exeception for your IP or make it public (CIDR/IP:0.0.0.0/0).  Latter is not recommended for production but fine for a quick test if you are having issues.

2 - Create a new Redshift cluster following the wizard. Just a couple of nodes is fine for this data set ()We demonostrated on 4 dw1).  Assign to your demo security group.  The name of the database is not important.  

3 - Once the cluster is created copy the JDBC connection string and log into redshift using the tool of your choice

4 - Run s2w_business, s2w_date, and s2w_reviews.sql

5 - At the bottom of s2w_reviews.sql are a few SQL statements you can use to explore the data.

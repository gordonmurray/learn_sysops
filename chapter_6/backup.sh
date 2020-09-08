#!/usr/bin/env bash  
# The following assumes you have an AWS account with the AWS CLI installed locally  
# It will perform a mysqldump of a database, compress and upload the resulting file  

DATABASE_HOST="localhost"  
DATABASE_USERNAME="user"  
DATABASE_PASSWORD="password"  
DATABASE="myapplication"  
S3_BUCKET="myapplication-backup-bucket"  

# dump the database to a local file  
mysqldump --host=${DATABASE_HOST} --user=${DATABASE_USERNAME} --password="${DATABASE_PASSWORD}" ${DATABASE} --single-transaction > ${DATABASE}.sql  

# compress the sql file using gzip  
gzip ${DATABASE}.sql  

# upload the compressed database file to s3  
aws s3 cp ${DATABASE}.sql.gz s3://${S3_BUCKET}/${DATABASE}.sql.gz  

# list contents of the s3 bucket to confirm the upload  
aws s3 ls s3://${S3_BUCKET}  

# remove the local compressed database file  
rm ${DATABASE}.sql.gz 
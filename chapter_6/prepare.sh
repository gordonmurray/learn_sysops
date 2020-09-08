#!/usr/bin/env bash  
  
# The following assumes you have an AWS account with the AWS CLI installed locally  
# It will download a backup file, create a database, import your data and perform a query that should have at least 1 resulting record.  
  
DATABASE_HOST="localhost"  
DATABASE_USERNAME="user"  
DATABASE_PASSWORD="password"  
DATABASE="myapplication"  
  
S3_BUCKET="myapplication-backup-bucket"  
  
# download a backup file from s3  
aws s3 cp s3://${S3_BUCKET}/${DATABASE}.sql.gz ${DATABASE}.sql.gz  
  
# uncompress the backup file  
gzip -d ${DATABASE}.sql.gz  
  
# create a local database called 'validate'  
mysql --host=${DATABASE_HOST} --user=${DATABASE_USERNAME} --password="${DATABASE_PASSWORD}" -e "create database if not exists validate;"  
  
# import the backup in to the database  
mysql --host=${DATABASE_HOST} --user=${DATABASE_USERNAME} --password="${DATABASE_PASSWORD}" ${DATABASE} < ${DATABASE}.sql 
#!/usr/bin/env bash  
# The following assumes you have mysql or mariadb installed locally
# It will create a database and import the data from the seed file.

DATABASE_HOST="localhost"  
DATABASE_USERNAME="user"  
DATABASE_PASSWORD="password"  
DATABASE="myapplication"  

# create a local database called 'validate'  
mysql --host=${DATABASE_HOST} --user=${DATABASE_USERNAME} --password="${DATABASE_PASSWORD}" -e "create database if not exists validate;"  

# import the sample users table and data
mysql --host=${DATABASE_HOST} --user=${DATABASE_USERNAME} --password="${DATABASE_PASSWORD}" ${DATABASE} < seed_data.sql 

CREATE USER 'user'@'%' IDENTIFIED BY 'mypassword';
GRANT SELECT, INSERT, UPDATE, ALTER, CREATE TABLE, INDEX  ON *.* TO 'user'@'%';
FLUSH PRIVILEGES;
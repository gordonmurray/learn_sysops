#!/usr/bin/env bash  
  
# The following assumes you have a local database already created to query 
# It will perform a query that should have at least 1 resulting record.  
  
DATABASE_HOST="localhost"  
DATABASE_USERNAME="user"  
DATABASE_PASSWORD="password"  
DATABASE="myapplication"  
   
# query the data and store the result in to a file  
mysql --host=${DATABASE_HOST} --database=${DATABASE_USERNAME} --user=${DATABASE_USERNAME} --password=${DATABASE_PASSWORD} --database=${DATABASE} --skip-column-names -e "select count(*) from users" > users_count.txt  
  
# count the number of records in the file created by the previous query  
record_count=$(cat users_count.txt)  
  
# if there are more than 0 records, the backup file is OK  
if [ ${record_count} -gt 0 ]; then  
echo "Database backed up successfully"  
else  
echo "No records, the database didn't back up properly"  
fi  
  
# clean up local files  
rm users_count.txt  
rm myapplication.sql  
  
# drop the database  
mysql --host=${DATABASE_HOST} --user=${DATABASE_USERNAME} --password="${DATABASE_PASSWORD}" -e "drop database if exists validate;" 
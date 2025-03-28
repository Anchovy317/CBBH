# Structured Query Language:
Tye are required to follow de [ISO standard ](https://en.wikipedia.org/wiki/ISO/IEC_9075), we'll be following MySQL/Mariadb syntax for the examples.
- Retrieve data
- Update data
- Delete data
- Create tabled and database
- Add / remove users
- Assign permissions to these users

## Command Line:
The flag -u used to supply the username and -p the password. The -p should be empty, so we are promted to enter th pass.
`mysql -u root -p`

> [!TIP]
> There shouldn't be any spaces between '-p'the password/

Other DBMS users would have certain privilege to which statements they can execute, we can view the [SHOW GRANTS](https://dev.mysql.com/doc/refman/8.0/en/show-grants.html) command which we'll be discussed.
When we do not specify a host, it'll def to the localhost server, We can specify a remote host and port using the -h and -P flags.
The default port in MAriaDB is 3306, but can configured to another port, specified using an uppercase 'p' unlike lowercase 'p' used for pass.
To follow along with the example, try to use the 'msql' tool on ur PwnBox to log in to the DBMS found in the question at the end of the section, using its IP and port.

## Creating a Database:
Once we log in using msql utility, we can start using SQL qeries to interact with the DBMS.
`CREATE DATABASE users;`
MySQL expects commnand-line queries to be terminated with a semi-colon. Above to created a new db named user. We can view the list of db with `SHOW DATABASE, and we can swithc to the user databse with
the USE statements:
SQL statements aren't case sensitive, which means 'USE users', and 'use users' refer to the same command. The db name is case sesitive, we cannoth do 'USE USERS' instead users;
SO is good practice to specify statements in uppercase to avoid confusion.

## Tables:
DBMS stores data in the form of tables, a table madi up of horizontal rows and vertical columns. The intersection dolum is called a cell. Table is created with a fixed set of columns, where each column is of particular
data type.
This data is definees whay kind of value is to be held by a column, common example are numbers, strings, date, time and binary data.
Theree are be data type spcific to DBMS as well. A complete list of data type in MySQL can be found [here](https://dev.mysql.com/doc/refman/8.0/en/data-types.html)

```sql
CREATE TABLE logins(
    id INT,
    username VARCHAR(100),
    password VARVHAR(100),
    date_of_joining DATETIME
);

```
As we can see the CREATE TABLE query first specifies the table name, and them we specify each column by it name an its data type, all comman separated.
The SQL qeries above create a table name logins with four colums. First id, is an integer. The username and pass are set of 100 characters each.
The date_of_joining column of type DATETIME stores the date when an entry was added.

`SHOW TABLES;
 DESCRIBE logins`

## Tables Properties:
Whitin the CREATE TABLES query, there are may [Properties](https://dev.mysql.com/doc/refman/8.0/en/create-table.html) that can be set for the table an each column, we can set the id column to auto-incriment
using the AUTO_INCREMENT.
`id INT NOT NULL AUTO_INCREMENT,`
The NOT NULL constraint ensures that a particular column is never left empty, we ca also use the [UNIQUE] constraint to ensure that the inserted item are always unique, if the username column, we cna ensure that no two
users wll have the same username.
`username VARCHAR(100) UNIQUE NOT NULL,`
Another important keyword id the [DEFAULT] keyword, which is used to specify the def value, Whitin the [data_of_joining] column, we can se the def value to NOW(), which in MySQL returns current date time.
`date_of_joining DATETIME DEFAULT NOW(),`

Once of the most important Properties is [PRIMARY KEY], we can uses to uniquely identify each record in the table, referring to all data of a record within a table for
relational db, as previusly discussed in the previus section

```sql
CREATE TABLE logins (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(100) UNIQUE NOT NULL,
    password  VARCHAR(100) NOT NULL,
    date_of_joint  DATETIME DEFAULT NOW(),
    PRIMARY KEY(id)

);

```

Exercise:
```slq
MariaDB [(none)]> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| employees          |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.044 sec)
```


# SQL Statements:
- INSERT Statement:
Is used to add new records to a givne table:
`INSERT INTO table_name VALUES (column_1...)`
The syntax above requieres the user to fill in values for all the comulns present tables, the example shows how to add a new login tables, with appropiate values for each columns.
We can skip filling columns with def values such as id and date_of_joining. This can be done by specifying the column name insert values into a table.
`INSERT INTO table_name(column3) VALUES (column3_value)`
Skipping columns with the 'NOT NULL' constrainst will result in an error, as it a requeired value.
Also we can inserted a user-pass pair in example abovew while the id and date_of_joining column.
`INSERT INTO logins(username, password) VALUES ('john', 'john123!'), ('tom', 'tom123!');`

- SELECT Statemnt:
Now we can inserted data into a tables let us see how retrieve data with the SELECT statement. Thi statement can also be used for many other purpouse.
`SELECT * FROM table_name`
The asterisk acts as wildcard and selects all the columns, the FROM keyword is used to denote the table to select form it's possible to view data present in specific column as well:
`SELECT column1, column_2 FROM table_name`

- DROP statements:
Use drop to remove tables and database form the server:

The 'DROP' statement will permanently and completely delete the table with no confirmation, so it should be used with caution.

- ALTER statements:
Used to change the name of any table and any its fields or to delete or add a new column to an exsiting table:
`ALTER TABLE loggings  ADD newcolumn INT;`
To rename the column we can use [RENAME COLUMN]
`ALTER TABLE logins RENAME COLUMN newColumn TO newerColumn;`
We can also change a column's datatype with [MODIFY]:
`ALTER TABLE logins MODIFY newerColumn DATE;`
And [DROP] for drop the column:
`ALTER TABLE logins DROP newerColumn;`


- UPDATE Statement:
While ALTER is used to change table Properties, the UPDATE  cna use to update specific records within table, based on certain condinations.
`UPDATE table_name SET column1=newvalue1, column2=newvalue2. ... WHERE <condition>;`
we specify the table name, each column nad its new value and the condition for updating recods.
`UPDATE logins SET password = 'change_password' WHERE id > 1;`

Exercise: What is the department number for the 'Development' department?
```sql
SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| employees          |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.043 sec)

USE employees;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
MariaDB [employees]> SHOW TABLES;
+----------------------+
| Tables_in_employees  |
+----------------------+
| current_dept_emp     |
| departments          |
| dept_emp             |
| dept_emp_latest_date |
| dept_manager         |
| employees            |
| salaries             |
| titles               |
+----------------------+
8 rows in set (0.043 sec)

SELECT * FROM departments;
+---------+--------------------+
| dept_no | dept_name          |
+---------+--------------------+
| d009    | Customer Service   |
| d005    | Development        |
| d002    | Finance            |
| d003    | Human Resources    |
| d001    | Marketing          |
| d004    | Production         |
| d006    | Quality Management |
| d008    | Research           |
| d007    | Sales              |
+---------+--------------------+
9 rows in set (0.045 sec)

```

# Query Results:
- Sorting Resutlts
We can sort the result of any query using [ORDER BY] and specifyign the column to sort by:
`SELECT * FROM logins ORDER BY password;`
By default, the sort is done in ascending orderm by we can also sort the result by ASC or DESC:
`SELECT * FROM logins ORDER BY password DESC;`
It's also possible to sort by multiple coliumns, to have secondary sort for duplicate values in one column:
`SELECT * FROM logins ORDER BY password DESC, id ASC;`

- LIMIT result:
Our query returns a large number of records, we can LIMIT the results to what we want only, using LIMIT and the number of records we want:
`SELECT * FORM logins LIMIT 2;`
If we want to limit result with as offsetm we could specify the offset before the LIMIT count:
`SELECT * FROM logins LIMIT 1, 2;`
> [!NOTE]
> The offset marks the order of the first record to be included, starting form 0, it starts and includes the 2nd record, and returns two values.

- WHERE CLAUSE:
To filter or search for specifi data, we can use condition with the SELECT statement USING the WHERE clause, to fine-tune the resutl:
`SELECT * FROM table_name WHERE <condition>`
`SELECT * FROM logins WHERE id > 1;`
`SELECT * FROM logins where username = 'admin';`
The query above selects the records where the username is admin, we can use th UPDATE statement to update certain records that meet specific condition.
> [!NOTE]
> String and date data types should be surrended by single quote (')or doble quote (") while number can be used directly.

- LIKE Clause:
Another useful SQL clause is LIKE, enabling selecting records by mathcing a certain patterns, the query below retrieve all recods with username starting with admin.
`SELECT * FROM logins WHERE username LIKE 'admin%';`
The % symbol acts as wildcard and matches all characters after admin, it's used to match zero more characters. Similary, the _ symbol is used to match exaclty one character.
The below query matches all username with exaclty three characters in them, whihc in case was tom:
`SELECT * FROM logins WHERE username like '___';`

```sql

MariaDB [employees]> SELECT * FROM employees WHERE hire_date = '1990-01-01';
+--------+------------+------------+-----------+--------+------------+
| emp_no | birth_date | first_name | last_name | gender | hire_date  |
+--------+------------+------------+-----------+--------+------------+
|  10227 | 1953-10-09 | Barton     | Mitchem   | M      | 1990-01-01 |
+--------+------------+------------+-----------+--------+------------+
1 row in set (0.042 sec)
```

## SQL Operators:
- AND Operator:
The AND operator takes in two conditions return true or false based on their evaluation:
`condition1 AND condition2`

The result of the AND operators is true if and only if both condition1 and condition3 evaluate to true:
```sql
mysql> SELECT 1 = 1 AND 'test' = 'test';

+---------------------------+
| 1 = 1 AND 'test' = 'test' |
+---------------------------+
|                         1 |
+---------------------------+
1 row in set (0.00 sec)

mysql> SELECT 1 = 1 AND 'test' = 'abc';

+--------------------------+
| 1 = 1 AND 'test' = 'abc' |
+--------------------------+
|                        0 |
+--------------------------+
1 row in set (0.00 sec)
```
In mysql terms, any non-zero value is considered true, and it usually return the value 1 to signify true.0 is considered false. As we can see in the
example above, the first query returned true as both expression were evaluaated as true. The second query returned query returned false as the second condition
'test' = 'abc' is false.

- OR operator:
Takes in two expression as well, and returns true when one of them evaluates to true:
```sql
mysql> SELECT 1 = 1 OR 'test' = 'abc';

+-------------------------+
| 1 = 1 OR 'test' = 'abc' |
+-------------------------+
|                       1 |
+-------------------------+
1 row in set (0.00 sec)

mysql> SELECT 1 = 2 OR 'test' = 'abc';

+-------------------------+
| 1 = 2 OR 'test' = 'abc' |
+-------------------------+
|                       0 |
+-------------------------+
1 row in set (0.00 sec)
```
The queries above demostrate how the OR  operator works, the first query evaluated to true as the condition 1=1 is true, the secon has two false condition resulting in false input.

- NOT OPERATOR:
The not operator simply toggles a boolean value true is converted to false and vice versa;
```sql
mysql> SELECT NOT 1 = 1;

+-----------+
| NOT 1 = 1 |
+-----------+
|         0 |
+-----------+
1 row in set (0.00 sec)

mysql> SELECT NOT 1 = 2;

+-----------+
| NOT 1 = 2 |
+-----------+
|         1 |
+-----------+
1 row in set (0.00 sec)
```
As seen inthe example above the first query resulted in false cause it's  the inverso of the evaluation of 1=1, which is true, so its inverse is false.
The secons query returned true, as the inverse of 1=2 which is false is true.

- Symbol Operators:
The AND, OR and NOT also be represent as && || !, respectively:
```sql
mysql> SELECT 1 = 1 && 'test' = 'abc';

+-------------------------+
| 1 = 1 && 'test' = 'abc' |
+-------------------------+
|                       0 |
+-------------------------+
1 row in set, 1 warning (0.00 sec)

mysql> SELECT 1 = 1 || 'test' = 'abc';

+-------------------------+
| 1 = 1 || 'test' = 'abc' |
+-------------------------+
|                       1 |
+-------------------------+
1 row in set, 1 warning (0.00 sec)

mysql> SELECT 1 != 1;

+--------+
| 1 != 1 |
+--------+
|      0 |
+--------+
1 row in set (0.00 sec)

```
- Operators in queries:
The following query lists all records where the username is NOT john:
```sql
mysql> SELECT * FROM logins WHERE username != 'john';

+----+---------------+------------+---------------------+
| id | username      | password   | date_of_joining     |
+----+---------------+------------+---------------------+
|  1 | admin         | p@ssw0rd   | 2020-07-02 00:00:00 |
|  2 | administrator | adm1n_p@ss | 2020-07-02 11:30:50 |
|  4 | tom           | tom123!    | 2020-07-02 11:47:16 |
+----+---------------+------------+---------------------+
3 rows in set (0.00 sec)

```
And the next query selects users who have their id greater then 1 AND username NOT equal to john:
`mysql> SELECT * FROM logins WHERE username != 'john' AND id > 1;`

- Multiple Operators Precedence:
List of common operator and their Precedence as see un the [MariaDB documentation](https://mariadb.com/kb/en/operator-precedence/)
    - Division (/), Multiplication (*), and Modulus (%)
    - Addition (+) and substracton(-)
    - Comparision (=, >, <, <=, >=, !=, LIKE)
    - NOT (!)
    - AND (&&)
    - OR (||)
Operations at the top are evaluated before the ones the ones at the bottom of the list:
`SELECT * FROM logins WHERE username != 'tom' AND id > 3 - 2;`
The query has four operation:  !=, AND, >, and -.  From the operator precedence, we know that substracton comes first, so it will first evaluate
3-2 to 1:
`SELECT * FROM logins WHERE username != 'tom' AND id > 1;`
We have to Comparision operators both of these are of the same precedence and will be together.
`mysql> select * from logins where username != 'tom' AND id > 3 - 2;`

Exercise:
In the 'titles' table, what is the number of records WHERE the employee number is greater than 10000 OR their title does NOT contain 'engineer'?
`MariaDB [employees]> SELECT * FROM titles WHERE emp_no > 10000;`

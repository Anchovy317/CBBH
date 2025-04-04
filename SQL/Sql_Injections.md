# Use of SQL in a Web App:
First let us see how web appm use  a database Mysql, to store and retrive data. Ince as DBMS is installle and set up on the back end server and is up and running,
the web app can utilizing it store and retrive data.
Wuth a PHP web app we can connect to our database, and start using Mysql database through MySql sysntax, with PHP:
```php
$conn = new mysli("localhost", "root", "password", "users");
$query = "selec * form logins";
$result = $conn-> query($query)
```
Then the query output will be stored in $result, and we can print to the page or use it in any other way, the php code print all results of the SQL query in new files.
```php
while($row = $result->fetch_assoc() ){
    echo $row["name"]."<brt>";
}
```
Web app also usually user use user inputs when retrieving data, when a user usues the search funtions to search for other users, their search input is passed to the web app,
which use the input to search within the database:
```php
$searchInput = $_POST['findUSer']};
$query = "select * from loginds where username like '%$searchInput'";
$result = $conn->query($query);

```
If we use user-input  within an SQL query, and if not securely coded, it may cause a variety of issues, like SQL Injection vulnerability.

- What is an Injection:
We accept user input and pass it directly to the SQL query without sanitization, sanitization refers to the removal of any special character in user-input, in order to break any injection attempts.
Injection occurs when an app misinterpretes user input as actual code rather than a string, changing the code flow and executing it.
This can occur by escaping user-input bounds injecting a special character('), and then writing code to be executed, like JS code or SQL in SQL Injection.

## SQL Injection:
This occurs when user input is inputted intop the SQL query without properly snaitazing or filtering the input, the previus example showed how user-input cab ve used within an SQL query, and did not use
from of input sanitization:
```php
$searchInput = $_POST['findUSer']};
$query = "select * from loginds where username like '%$searchInput'";
$result = $conn->query($query);

```
In a typical case, the searchInput would be inputted to complete the query, returning the expected outcome. any input type goes into the SQL query:
`select * from logins where username like '%$searchInput `
So we input admin, it becomes '%admin' then if we write any SQL code, it would just be considered as a search term, for the example:
If we input SHOW DATABASE; it would be execute as '%SHOW DATABASE;' The web app will search for username similar to SHOW DATABASE.
In this case we can add a single quote('), which will end the user-input field, and afeter it we can write actual SQL Code.
We search for 1'; DROP TABLE users; the search input would be:
`'%1'; DROP TABLE users;`

As we can see from the sysntax, we can escape the original query's bounds and have our newly injection query execute as well, One the query is run then the user table will get delete.

> [!NOTE]
> For the sake of simplicity, we added anothe SQL query after a semi-colon{;}. Though this is actually not possible with MySQL, it's possible with MSSQL and PostgreSQL.

## Syntax Errors:
The previus example of SQL injection would return an error:
`Error: near line 1: near"": syntax error`
This is because of the last trailing character, where have a single extra quote(') that is not close, which cause a SQL sysntax error when executed:
`select * from logins where username like '%1; DROP TABLE users;`

We had only one trailing, as our input form the search query was near the end of the SQL query. The user input usually goes in the middle os the SQL query, and the rest of the original SLQ query comes after it.
To have a successful injection, we must ensure that the newly modified SQL query is still valid and does not have any syntax errors after our injection.

- Types of SQL Injection:
![Schema](https://academy.hackthebox.com/storage/modules/33/types_of_sqli.jpg)

The output of both the intended and the new query may be printed directly on the font-end, and we can directly read it. This is known as In-band
SQL Injection, has two types: Union Based and Error Based.
With Union Based SQL, we may have to specify the exact location, we can read, so teh query will direct the output to be printed here. As for Error Based
SQL injection, it's used when we can get the PHP or SQL error int he front-end.

In more complicated cases, we may not het the output printed, so we may utilize sql logic to retrive the output character by character. This is kmown as Blind SQL injection,
an it also two types: Boolean base and Time Based.

With Boolean Based SQL inection we can use SQL conditional statements to control whether the page returns any output at all, if our conditional statement return true, Time Based SQL injection, we use
SQL conditional statements that delay the pase respose if the conditional returns true.
As for time base SQL injection, we use SQL conditional statements thjat delay the page response if the conditional statemtent returns true using the Sleep() funtion.

# Subverting Query Logic:
Before we start executing entire SQL queries, we will learn to modify the original by injection the OR operatator and using SQL comments to subvert the original query's logic.

- Auth bypass:
We can log with admin credentioals [admin/p@ssw0rd]. The pagie also displays the SQL query being executed to understand how we will subvert the query logic. Goal is to log in as the admin user
without usein teh existing password. As we can executed is:
`SELECT * FORM logins WHERE userername='admin' AND password = 'p@ssw0wd`;
The pages takes in the credentials, then uses the AND operator to select record matching the given and password, If the MySql database returns matched records, the credentials are valid, so teh PHP code would evaluate the login
attempts condition as true. If the condition evaluates to true, the admin recods is returned, and our login is validate, let us happens when we enter incorrect credentials.
As expected the login failed due to the wrong password leading to a false result form teh AND operations:

- SQLi Discovery:
Before we starting subverting the web app logic and attempting to bypass the auth, we first have to test whether the login from is vulnerable to SQL Injection. We try to add
the below payloads after our username and see if it cause any errors or changes how th pages behaves:

| Payloads | URL Encoded |
| -------------- | --------------- |
|' |%27 |
|" |%22 |
|# |%23 |
|; |%3B |
|)|%29 |

> [!NOTE]
> In some cases, we may have to use the URL encoded version of the payloads. This is when we put our payloads directly int he URL.

So let us start by injecting a single quote:

We ca see the SQL error was thrown instead of te Login failed message. The page threw an error cause the resulting query was:
`SELECT * FROM logins WHERE username''' AND password = 'something'`;
The quote we entered resulted in a odd numbers quotes, causing a sysntax error. One option would be to comment out the rest of the query
and write the remainder of the query as part of our injection to from a working query.

- OR injection:
We would need the query always to return true, regardless ofd the username and pass entered. To bypass the auth.
MySQL decumentation for operations precedence state that the AND Operator would be evaluated before the OR operator. The means that igf there is at least one TRUE condition in the entire query along with an OR opeator, the entire query
will evaluate to TRUE since the OR operator returns TRUE if one of its operands is TRUE.
Condition that will always return true is '1=1', to keep the SQL query working and keep and even number of quotes, insted of using 1=1 we will remove the last quote and use 1=1 so the remaining single
quote from the original query would be in its place.
So if we inject the below condition and have an OR operator it should always return true:
`admin' or '1'='1`

The final query should be as follow:
`SELECT * FROM logins WHERE username='admin' or '1'=1' AND password = 'something';`

This means if the username is admin or if 1=1 return true which always return true and if pass is somethin:
The And operator will be evaluated first, and will returned false, the OR operator would be evaluated, and if either of the statements is true, it would returne true.

- Auth bypass with OR operator:
Lets us try this as the username and see the response:
![pane](https://academy.hackthebox.com/storage/modules/33/inject_success.png)

We were able to log in sucessfully as admin. what if we did no knwo a valid user? try the same request with a differenty username this time.

![panel](https://academy.hackthebox.com/storage/modules/33/notadmin_fail.png)


The login failed causse  notAdmin does not exist inthe table and resulted in a false query overall.

![panel](https://academy.hackthebox.com/storage/modules/33/notadmin_diagram_1.png)
To log in once again, we will need a overall true query. This can be archived injection an OR condition into the pass list, so it will return true.
![panel](https://academy.hackthebox.com/storage/modules/33/password_or_injection.png)

the addition OR condition resulted in a true query overall, as the WHERE clause returns everything in the table, and the user present in teh first row is logged.
Condition will return true, we do not have to provide a test username and password and can directly start the ' injection and log in with just `' or '1'='1`

Exercise:
Try to log in as the user 'tom'. What is the flag value shown after you successfully log in?
Payload
tom' or '1'='1
202a1d1a8b195d5e9a57e434cc16000c

# Using Commnets:
Commmetns  just like any other lenguage, SQl allows the use of comments as well, are used to document queries or ignore a certain part of query. We can use two types
of line commments with MySQL -- and # in addition to an in line comment /**/ the can use as follow:
```sql
 SELECT username FROM logins; -- Selects usernames from the logins table

+---------------+
| username      |
+---------------+
| admin         |
| administrator |
| john          |
| tom           |
+---------------+
```

> [!NOTE]
> In sql using two dashes only is not enough to start comment. There has to be an empty space afeter them, so the comment starts with (-- ) with a space at the end.
> This si something URL encoded (--+) as spaces in URL are encoded as (+) to make it clear we will another (-) at the end (-- -) to show thew use of the space character.

The # symbol can be used as well.
```sql
 SELECT * FROM logins WHERE username = 'admin'; # You can place anything here AND password = 'something'

+----+----------+----------+---------------------+
| id | username | password | date_of_joining     |
+----+----------+----------+---------------------+
|  1 | admin    | p@ssw0rd | 2020-07-02 00:00:00 |
+----+----------+----------+---------------------+

```
> [!TIP]
> If u are inputting ur payload in the URL within a browser, a # symbol is usually consider as a tag, and will not be passed as part of the URL. In order to use # as a commnet within browser we can
> user th '%23' which is an encoded URL.

- Auth bypass with comments:
admin' -- as our username:
`SELECT * FROM logins WHERE username='admin'-- ' AND password = 'something';`

Sql supports the usage of parenthesis if the apop needs to check for particular condition before other, expression within the parenthesis takes precedence over other
operators and are evaluated first:
![panel](https://academy.hackthebox.com/storage/modules/33/paranthesis_fail.png)

To above query ensures that the user's id always greater than 1, which will prevent anyone from loggin in as admin. Lest try to loggin in withBF
valid credentials admin/password for see:

![panel](https://academy.hackthebox.com/storage/modules/33/paranthesis_valid_fail.png)

Lets try with tom user and get login success. We know the previos section on comments that we can use them to comments out the rest of the query so try admin'--.

![panel](https://academy.hackthebox.com/storage/modules/33/paranthesis_error.png)

The login failed due to syntax error, as a closed one did no balance the open parenthesis. To execute the query successfully, we'll have to add a closing parenthesis les try admin'-- like username.

![panel](https://academy.hackthebox.com/storage/modules/33/paranthesis_success.png)

`SELECT * FROM logins where (username='admin')`
Exercise:
Login as the user with the id 5 to get the flag.
` Executing query: SELECT * FROM logins WHERE (username='user' AND id > 1) AND password = 'd41d8cd98f00b204e9800998ecf8427e';`
Then we can user the payload:
'or id=5)#
Then the execution is:
Executing query: SELECT * FROM logins WHERE (username=''or id=5)#' AND id > 1) AND password = 'd41d8cd98f00b204e9800998ecf8427e';

Login successful as user: superadmin

Here's the flag: cdad9ecdf6f14b45ff5c4de32909caec

# Union clause:
So far we have only been manipulating the original query to subvert the web app logic and bypass auth, using th Or operator commnets. Another type of SQL injection is injecting
entire SQL queries along with the original query.
This section will demostrate this by usin the MySql Union clause to de SQL Union Injection.

- Union:
Before we start learning about Union Injection, we should first leant the Sql Clause. The union clause is used to combine results form multiple SELECT statements. This means theat through a UNION injection,
We will able to SELECT and dump data form all across the DBMS, from multiple tables of database. Let us try using the UNION operator in a sample database. First connect to the port tables:
```sql
mysql> SELECT * FROM ports;

+----------+-----------+
| code     | city      |
+----------+-----------+
| CN SHA   | Shanghai  |
| SG SIN   | Singapore |
| ZZ-21    | Shenzhen  |
+----------+-----------+
```
Next, let us see the output of the ships tables:
```sql
mysql> SELECT * FROM ships;

+----------+-----------+
| Ship     | city      |
+----------+-----------+
| Morrison | New York  |
+----------+-----------+
```
Now let us try to use UNION to combine both results:
```sql
mysql> SELECT * FROM ports UNION SELECT * FROM ships;

+----------+-----------+
| code     | city      |
+----------+-----------+
| CN SHA   | Shanghai  |
| SG SIN   | Singapore |
| Morrison | New York  |
| ZZ-21    | Shenzhen  |
+----------+-----------+
```
As we can see, Union combined the output of both SELECT statements into one, so entries form the ports tablke and the ship tbale were combine into a single output with four rows.
Some of the rows belong to the ports table while others belong to the ships table.

> [!NOTE]
> The data types of the selected columns on all positions should be the same.

- Even Columns:
A Union statement can onlu operate on SELECT statementwith an equal number of column, IF we attempt to UNION two queries that have results with a differents number of columns we got error:
To above query results in an error, as the first SELECT retuns one column and the second SELECT returns two. Once we have two queries that return the same number of columns, we can use the
UNION operator to extract data form other table and db.

```sql
SELECT * FROM products WHERE products_id = 'user_input'
```
We can inject a UNION query into the input, such that rows form another table returned:
```sql
SELECT * from products where products_id = '1' UNION SELECT username, password from password-- '
```

- Un-even Columns:
We will find oiut that the original query will usually not have the same number of columns as the SQL query we want to execute , so we will have to work around that.
Suppose we only had one column, We want to select we can put junk data for the remaining required columns so that the total number of columns we are UNIONing with remains the same as the original.
We can use the same string as iru junk data, and the query will return the string as its output for that column. If we UNION with tht string "junk", the SELECT query would be
SELECT "junk" from password, which will always return junk. We can also use numbers. The query SELECT 1 form password will always return 1 as the output.
> [!NOTE]
> When filling other columns with junk data, we must ensure that the data type matches the columns data type, otherwise the query will return an error. For the sake of simplicity, we will use numbers
> as our junk datam whihc will also become handy fot tracking our payloads position, as we will discuss later.

For advanced  SQL injection, we may to simply use 'NULL' to fill other columns, as 'NULL' fits all data types.

The products table has two columns in the above examples. so we have to UNION with two columns. If we only wantes to get one column, we habto to do username, 2, such that we have the same number of columns.

`SELECT * from products where products_id ='1' UNION SELECT username, 2 from passwords`

IF we had more columns in the table of the original query, we have to add more numbers to create the remaining required columns.
`UNION SELECT username, 2,3,4 form password-- `

# Union injection:
Now that we know how to Union clause works and how to use it let us learn how to utilize it our SQL injections.
First we wiull use SQLi discovey steps by injecting a single quote (') and we do get the error.

- Detect number of columns:

Before going ahead and exploiting Union-Based queries, we need to find the number of columns selected by th server. There are two methods of detecting:
    - Using ORDER BY:
    The firt way of detecting the number of columns is through the ORDER BY funtion, which discussed earlier. We have to inject  a query that sorts the results by a column we specified, column 1, column 2, and so on', until we get
    an error saying the column specified does not exist.
    We can start order by 1, sort by firts column, and succeed, as the table must have a least one column. The we will do order by 2 and then order by 3 until we  reach a number that returns an errro, or the page does no who any output.
    The final successsful column we successfully sorted by gives us the total number of columns.
    If we faild ar order by 4, this means the table has three columns, which is the number of columns we were able to sort by successfully.
    `order by 1-- -`
    - Using UNION:
    The other method is to attempts a UNION injection with a diff number of columns until we successfully get the result back. The first method always returns the results until we hit an error, while this method always give an error until
    we get success. We can start by inject 3 columns.
    `cn UNION select 1,2,3-- -`
    We get an error and try with 4 columns:
    `cn UNION select 1,2,3,4-- -`

- Location injection: While the query  may return multiple columns, the web app may only display some of them. We inject our query in a column that is not printed on the page, we will not get its output.
This i why we need to determine which columns are printed to the page, to determina where to place our injection. While injected query returned 1,2,3 and 4, we saw only, 2,3 and 4 displayed
back to us the page as the output data.

It's very common that no every column will be displayed back to the user, the ID field is oftern used to link different table together, byt the user doesn't need to see it.
Theis tells that column 2 and 3, and 4 are printed our injection in any of them.
To test the actiual data from the db 'rather than just number' we can use the [@@version] as test and place in second column:
`cn UNION select1 1, @@version, 3,4-- -`

Exercise:
`cn' UNION select 1,2,user(),4-- -`


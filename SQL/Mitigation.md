# Input Sanitization:
Here the snippet of the code form the auth bypass section we discussed earlier:
```php
<?php
<SNIP>
  $username = $_POST['username'];
  $password = $_POST['password'];

  $query = "SELECT * FROM logins WHERE username='". $username. "' AND password = '" . $password . "';" ;
  echo "Executing query: " . $query . "<br /><br />";

  if (!mysqli_query($conn ,$query))
  {
          die('Error: ' . mysqli_error($conn));
  }

  $result = mysqli_query($conn, $query);
  $row = mysqli_fetch_array($result);
<SNIP>
?>

```
As we can see the script, takes in the user and pass from POST request and passes to the query directly. This will  let attacker inject anything
they wish and exploit the app. Injection can be avoided by sanitizing any user input, redering injected queries useless.
Libraries provide multiple fintions to achieve this, such mysqli_fetch_string() funtion.
```php
<?php
<SNIP>
$username = mysqli_real_escape_string($conn, $_POST['username']);
$password = mysqli_real_escape_string($conn, $_POST['password']);

$query = "SELECT * FROM logins WHERE username='". $username. "' AND password = '" . $password . "';" ;
echo "Executing query: " . $query . "<br /><br />";
<SNIP>
?>
```
As expected, the injection no longer works due to escaping the single quotes. A similar example is the [pg_escape_string()](https://www.php.net/manual/en/function.pg-escape-string.php)

# INput validation:
User input can also be validated based on the data used to query to ensuere that it matches the expected input; consider the following code snippet from the ports page, which we used UNION injection:
```php
<?php
if (isset($_GET["port_code"])) {
	$q = "Select * from ports where port_code ilike '%" . $_GET["port_code"] . "%'";
	$result = pg_query($conn,$q);

	if (!$result)
	{
   		die("</table></div><p style='font-size: 15px;'>" . pg_last_error($conn). "</p>");
	}
<SNIP>
?>
```
We see the GET parameter port_code begin used in the query directly. It's already know that a port code consist only of letters or scapes. We can restrict the user input to only these characters, which will prevent
the injection of queries. A regular expression cna be used validating the input:
```php
<?php
<SNIP>
$pattern = "/^[A-Za-z\s]+$/";
$code = $_GET["port_code"];

if(!preg_match($pattern, $code)) {
  die("</table></div><p style='font-size: 15px;'>Invalid input! Please try again.</p>");
}

$q = "Select * from ports where port_code ilike '%" . $code . "%'";
<SNIP>

?>
```
The code is modified to use the preg_match() funtion, which checks if the input matchesthe given patterns or no.
We can test the following injection:
`'; SELECT 1,2,3,4-- -`

# User privielege:
As discussed initially DBMS sofware allows the creation of users with fine-grained permission. We should ensure that the user querying the db
only has minimun permission.
Superuser and user with admin privielege should never be used with web app. These accounts have access to funtions and ft, which could lead to server compromise.
```sh
MariaDB [(none)]> CREATE USER 'reader'@'localhost';

Query OK, 0 rows affected (0.002 sec)


MariaDB [(none)]> GRANT SELECT ON ilfreight.ports TO 'reader'@'localhost' IDENTIFIED BY 'p@ssw0Rd!!';

Query OK, 0 rows affected (0.000 sec)
 mysql -u reader -p

MariaDB [(none)]> use ilfreight;
MariaDB [ilfreight]> SHOW TABLES;

+---------------------+
| Tables_in_ilfreight |
+---------------------+
| ports               |
+---------------------+
1 row in set (0.000 sec)


MariaDB [ilfreight]> SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA;

+--------------------+
| SCHEMA_NAME        |
+--------------------+
| information_schema |
| ilfreight          |
+--------------------+
2 rows in set (0.000 sec)


MariaDB [ilfreight]> SELECT * FROM ilfreight.credentials;
ERROR 1142 (42000): SELECT command denied to user 'reader'@'localhost' for table 'credentials'


```
- WEB APP Firewall:
WAF are used to detect malicious input aand reject any http request containing them. This helps in preventing SQL injection even when the app logic is flawed.
Can be opensource[ModSecurity] or premium [cloudflare].

- Parameteried Queries:
Another way to ensure that the input is safely parameterized.
```php
<?php
<SNIP>
  $username = $_POST['username'];
  $password = $_POST['password'];

  $query = "SELECT * FROM logins WHERE username=? AND password = ?" ;
  $stmt = mysqli_prepare($conn, $query);
  mysqli_stmt_bind_param($stmt, 'ss', $username, $password);
  mysqli_stmt_execute($stmt);
  $result = mysqli_stmt_get_result($stmt);

  $row = mysqli_fetch_array($result);
  mysqli_stmt_close($stmt);
<SNIP>

?>

```

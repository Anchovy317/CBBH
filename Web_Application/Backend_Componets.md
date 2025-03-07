# Backend Servers:
A Backend server is the hardware and OS in the back en the hosts all tge app necessary to run the web app, The backend server  would
fit in the Data Access Layer(DAL):
Is a part of sofware arch that acts as an intermediaty between the app and database. It handle all the operations realate to retrievig,
inserting, updating and deleting data.
- What is does:
    - Abstraction: Hides the complexity of database queriesm so ur amin app logic doesn't deal with SQL directly.
    - Security: Help to sanitaze inputs to prevent SQL injection and other attck.
    - Maintanability: Makes the code base cliear and ez to modify if changes databses.
    - Performance Optimization: Can handle caching or batching queries to speed thigs up.

## Software:
![Exp](https://academy.hackthebox.com/storage/modules/75/backend-server.jpg)

Other sofware components on the back end server may incude hypervisions, containers and WAF.
There are many popular combinations of 'stacks' for the backend complements. Somo common include:

| Combination   | Components|
|--------------- | --------------- |
|  LAMP   | Linux, Apache, MySQL and PHP   |
|WAMP   | Windows, Apache, MySQL and PHP   |
| WINS   | Windows, IIS, .NET and Sql Server   |
| XAMPP   | Cross-Platafrom, Apache, MySQL, PHP/PERL|
| MAMP |macOS, Apache, MySQL and PHP|

## Hardware
The backend server contains all od the necessary hardware. The power performance capabilities of this hardware determine how stable and responsive
the web app will  be. Many arch especially for huge web app, are designed to distribure thier load over many backend server that collective work
together to perform the same taks and deliver the web app to the end user.

# Web Servers:
Is a app that runs on the backend server, which handles all the HTTP traffic  form the client-side browser, routes it to the requested pages, and finally
responds to the client-side browser, routes it to the requestd pages, and finally responds  to the client-side browser.
TCP ports 80 and 433, and  are reposible for connection end-users to varius part of the web app, in addition to handling their varios responses.

## Workflow:
A typical web accpets HTTP request from the client-side, and responds with dff http responds with dff HTTP responses and codes, like a code 200 OK responsew for
successful reques, a code 404 NOT FOUND when requesting pages that do not exist, code 403 FORBIDDEN for requesting access to restricted pages.
![EXP](https://academy.hackthebox.com/storage/modules/75/web-server-requests.jpg)

All the HTTP status code:

- 1xx Informational Responses:

100 Continue: Server recieved request header; client can proceed with sending the body.
101 Swithching Protocolos: Server Swithching to diff protocol.
102 Processing: Server recived and is processing the request.
103 Early Hints: Potencial response.

- 2xx Success:

200 ok: Request successful
201 Created: Resource successfully created
202 accepted: Request accepted but not yet processed.
203 Non-Authoriztative Information: Response from thrid-Party, not original server.
204 No Content: Request processed, but no content return.
205 Reset Content: Request procesed, client should reset view.
206 Partial Content: Server returns only part of the requested resources
207 Multiple-Status: Multiple response codes dor multiple opeations.
208 Already Reported: Resources Already reported in the response.
226 IM used: Server completed request, using interface manupulations.

- 3xx Redirection:

300 Multiple choices: Multiple options for resources; client must choosen one.
301 Moved Permanently:  Resorce moved; use new URL.
302 Found; Resource temporaly moved
303 See other; redirect another resource using get request.
304 Not Modified; Cached resource is still valid; not nee to redownload.
305 Use Proxy; reource only accesible through a proxy.
306 USed Previusly used now reserverd.
307 temporaly redirect; by keep original HTTP method.
308 Permanent Redirect, keeping the original HTTP.

- 4xx Client error:

400 Bad Request: Maformed or invalid request systax.
401 Unauthorized: Auth required or fail.
402 Payment Required: Reserved for future use.
403 FORBIDDEN: Server understoond the request.
404 Not Found: Request rource doesent exist.
405 MEthod not allowed: HTTP method no supported for the resources.
406 Not Aceptable: Resource can't generate content acceptable to the client.
407 Proxy auth required: must auth with proxy.
408 Request timeout: sercer timed out waiting for the request.
409 Conflict: Conflict with current server.
410 Gone: resources Permanently deleted and not coming back.
411 Lenght Required: Content-Lenght header missing but required.
412 Precondition failed: Server condition in headers not met.
413 Payload too large: request entity is too large for the server to handle.
414 Url to long: Url is too long for the server to process.
415 Unsopported Media Type: Reque's media type is unssopported.
416 Range not Satisfiable: Requested range cant be fullfulled.
417 Expectation Failed: Server cant meet the requerements of the Expect header.
418 IM a teapost easteregg
421 Misderected Request: Resquest sent to the wrong server.
422 Unprocessable Entity: Server Understand reques, but it's invalid.
423 Locked
424 Faild dependency: Request due toa failed dependency
425 To early: Server wont process request to prevent replay attacks.
426 Ugrade required: Requires client to upgrade to dff protocol.
428 Precontidion Required: Server requires certain conditions
429 Too many request
431 Request Header fields too large: request header to big.
451 Unavailable for legal resons.


- 5xx Server Errors:

500 Interact Server error: Generic server error.
501 Not implemented: Server doesn't supp the requested method.
502 Bad Gateway: Server an invalid response from upstream.
503 Service Unavaliable.
504 Gateway Timeout.
505 HTTP version not supp.
506 Variant also Negotiate miscofiguration.
507 Insufficient Storage: store the representation.
508 Loop detected: infinite loop
510 Not extended: Server need mor extensions to fulfill
511 Network Auth required.

Web serbers also accept various types os user input within HTTP requests, including text, JSON, and even binary. Once a web server recieves a web request,
it is then resposible for rounting it to its destination, run any process neeeded for that request, and return the response to the uset on the clien-side.

`curl -I http://...xxx/`
And with curl and page show the source code. Many web server type can develop our won basis server using such python, JS and PHP.

### APACHE:
Apache or httpd is the most common web serve on the interner, hosting more than 40% of all internet website. Apache using Linux destributions and can also be intalled on
Windows and macOS.
Usually use PHP web app development, by also supp other lenguages like [.Net, Python, Perl] and even OS like bash or CGI.
Users can install a wide variety of Apache modules to extend funcionality and supp more lenguages, PHP files, users must install PHP on the backend server, in addition to install
mod_php modules for apache.

### NGINX:
Is the second most common web server on th internet, hosting 30% of all internet website. This server focused serving many concurrent web requests with relatively low memory and CPU
load by utilizing an async arch to do. This is makes very rekiable web server for popular web app, is also opensouce.

### ISS:
Internet Information Services it the third most common web server on th internet, hosting around 15% of all internet web sites, is develop and maintained by Microsoft and maunly runs
on Microsoft Windows Servers, ISS is usually used to host web app delevelop for the Microsoft .NET framework, can also used to host web app develop in other lenguages like PHP, or
host other types of services like FTP.
Is very optimized for ACtive directory integration and includes Windows AUTH.

Other servers: [Apache Tomcat](https://tomcat.apache.org/). and Node.JS for web app.


## Databases:
Utilize to store varius content and information related to the web app, this can be  core web ap assents like img and files, web app content psot and update, or user data like username and pass.
There are many dff types of data, such fas speed in storing retriving data, size when storing large amounts of data, scability as the web app and cost.
### Realtional (SQL)
Stroe their data in tables, rows, and columns, each table can have unique keys, which can link tables toghether and create relationship between in tables.
We can have a users tables in rational table containing columns like id, first name, last nam,e and so on.
The id can be used as the table key, posts may conatin post made by all users, with columns like id, user_id, date, content...
![SLQ](https://academy.hackthebox.com/storage/modules/75/web_apps_relational_db.jpg)

We can link the id from the users table to the user_id in the posts tables ez retrive the user for each post, without having to store all user details with each post.
A table can have more than one key, as another column can be used as a key to link with another table.
**The relationship between tables within a database is called schema**
This becomes very quick and ez to retrieve all about a certain element from all database. We can retrieve all details linked to a certain user from all tables with a single
query.

Most common relational database include:

| Type    | Description|
|--------------- | --------------- |
| MySql    | The most common used database arount the interner, opensource   |
| MSSQL   | Microsoft implementation of realational database   |
| Oracle   | Vey realiable database for big bussiness, and is frequenetly updates innovatve datbase solution to make it faster and more reliable.|
| PostgreSQL   | Another free and open-source relational database, designed to be ez estensible, enabling adding advanced new features without needing a major changes|

Anoteh commont SQL data include: Sqlite, MariaDB, Amazon Aurora and Azure SQL.

### Non-relational (NoSQL)
Does not use tables, rows, columns, primary keys, relationship, or schemas. Database stored using varios models, depending on the type of data.
Due to the lack a defined structure for the data, NoSQL data are very scalable and flexible, dealing with datasents that are not very well defined and structured.
Four common storage models for NoSQL database:
- Key-value
- Document-based
- Wide-column
- Graph

The Key-value model ususally stores data in JS or XML, and has key for each pair.
![Table](https://academy.hackthebox.com/storage/modules/75/web_apps_non-relational_db.jpg)

```JSON
{
  "100001": {
    "date": "01-01-2021",
    "content": "Welcome to this web application."
  },
  "100002": {
    "date": "02-01-2021",
    "content": "This is the first post on this web app."
  },
  "100003": {
    "date": "02-01-2021",
    "content": "Reminder: Tomorrow is the ..."
  }
}


```
Most common NoSQL:
| Type | Description |
| -------------- | --------------- |
| Mongo DB| The most common open-source, uses Document-basd model and stores data in JSON|
| ElasticSearch | Another free and open-source database, is optimized for storing and analyzing huge datasents. |
| Apache Cassandra | Alos open-source, very scalable and is optimized for gracefully handling faulty values  |

### Use in Web-App
Most moderns lenguages and frameworks integrate, store, and retrive data form varius database types. The databse has to be installed and setup in the backend server.
php :`$conn = new mysqli("localhost", "user", "pass");`

Create new database:
```php
$sql = "CREATE DATABASE database1";
$conn->query($sql)
```
We can connect to our new database, and start using the MySql database through Mysql syntax.
```php
$conn = new mysqli("localhost", "user", "pass", "database1");
$query = "select * from table_1";
$result = $conn->query($query);
```
Web app can usually use user-input when retrive data.

```php
$searchInput =  $_POST['findUser'];
$query = "select * from users where name like '%$searchInput%'";
$result = $conn->query($query);
while($row = $result->fetch_assoc() ){
	echo $row["name"]."<br>";
}

```
[Slq injection vulenerabilities](https://owasp.org/www-community/attacks/SQL_Injection)

## Development Frameworks & APIs
Can host web app in various lenguages, there are many common web development frameworks that help in developing core web app filkes and funcionality, The increased complexity of web app,
it may be challenging to create a modern and sophisticated web app from scrach.
Most web app share common funcionality -such as user registration, web dev frameworks make it ez to quicky implement this funcionality and lin them to the front en components, making a fully
funtional web app. Some of the most common web development frameworks include.

- Laravel (PHP) usually used by startups and smaller comapines, as it's powerful yet ez to develop for.
- Express(Node.JS) used by paypal...
- Django(Python)
- Rails

### APIs:
An important aspect os backend app develop is the used od Web [APIs](https://en.wikipedia.org/wiki/API) and HTTP Request parameters to connect the front end and the backend to be
able to send data and forth between front end and backend components and carry out varius funtions with the web app.
For the front end components to interacts with the backend and ask for certain tasks to be carried out, utilize APis to ask the backend component for a specific task with specific
input. The backend components process these requests, perform the necessary funtions, and return a certain response to the frontend.

### Query Parameters:
The default method od sending specific arguments tro web page is though GET POST parameters. Allows the front end components to specify values for certain paramenters, used within the page for the
backend components to process them and response accordingly.
Example: A /search.php page would take an item parameter, which may be used specify the seach item, passing parameter through a GET response is done through the URL
'/search.php?item?=apples', while POST parameters are passed through POST data at the bottom of the POST HTTP request:
```sh
POST /search.php HTTP/1.1
...SNIP...

item=apples

```
### Web APIs
An Applicaton Programming Interface is an interface within an app that specifies how the apps can interecat with other apps, it's allows remote ascess
to funtctionality on backend components. APIs are not exclusibe to web app and are used for sofware app in general.
A weather app, my have certain API retrieve the currrent weather for a certain city, we can request the API URL and pass the city name or city id.
and would return the current weather on a JSON obj.
To enable the use of APIs within a Web-app, developers have to develop this funtionallity on the backend of the web app using the API standard like [Soap or Rest]

### The SOAP:
Simple objects Access standard shares data through XML, where the request is made in XML through an HTTP request, and the response is also returned in XML.
Frontnd components are designed to parse this XML output.
```XML
<?xml version="1.0"?>

<soap:Envelope
xmlns:soap="http://www.example.com/soap/soap/"
soap:encodingStyle="http://www.w3.org/soap/soap-encoding">

<soap:Header>
</soap:Header>

<soap:Body>
  <soap:Fault>
  </soap:Fault>
</soap:Body>

</soap:Envelope>


```
SOAP is very useful for transferring structured data, or even binary data, and often used with serialized obj, all os wich enables sharin complex data between fronend and backend components
and parsing it properly.
Soap may be difficutlt to use for begginers or require long and complicated requests even for smaller queries, like basic search or filter queries.


### REST
Respresentational State Transfer standard shares data through the URL path [serach/user/1] and usually returns the output JS format.
Res APis usually fopuces on page that expect one type of input passed directly through the URL path, without specifying it's name or type.
This is usually for querie s like search, sort or filter. This is why REST Apis usually break web app funcionality into smaller APis and utiilize these smaller API request to allow the web app
to perform more advance actions, making more scalable the app.

Responses to REST API request usually made in JSon format, and the frontend components are the develop to handle this response and render it properly, other
output formats for REST include XML, x-www-form-urlcode, or even raw data. Previusly in the database section, the following is ex of a JS rewsponse to the GET /category/post/ Api request:

```js
{
  "100001": {
    "date": "01-01-2021",
    "content": "Welcome to this web application."
  },
  "100002": {
    "date": "02-01-2021",
    "content": "This is the first post on this web app."
  },
  "100003": {
    "date": "02-01-2021",
    "content": "Reminder: Tomorrow is the ..."
  }
}


```
Rest use varius HTTP methods to perform diff actions on th web app:
- GET
- POST
- PUT
- DELETE

# METHODS AND CODES:
HTTP supports multiple methods for accesing a resources, several requesr methods allow the browser to send informaction form
files to the server, these methos are used, among other thing, to tell server how to process the request we send
and how reply.
We saw dff Http methods used in the HTTP requests we tested in the previous sections, is we use -v ro preview the full request,
the first line contains the http method.[GET / HTTP/1.1], while with browser devtools, in the method column.

## Request Methods:
- GET // Request a specific resources, additional data can passed to the server via query string in the URL [?param=value].
- POST // Sends data to the server, can handle  multiple types of input such a PDFs, and other forms of binary data. This data is appended
 in the request body present after the headers. The POST method is commondly used when sending infromation.
- HEAD // Request the headers that would be returned if a Get request was made to the servver.
- PUT // Creates new resources on the server, allowing this method without proper controls can lead to uploding malicious resources.
- DELETE //  Deletes an existing resources on the webserver, no secured, can lead to Denial of Servive DoS by deleting critical files on the web server.
- OPTIONS // Returns info about the server, such as the methods accepted by it.
- PATCH // Applies partial modification to the resources at specified locations.

The list only highlighths a few the most commonly used HTTP methods.[More methods](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods)

### Response Codes:
- 1xx // Provides informaction and does not affected the processing of the request.
- 2xx // Returned whena request succeeds.
- 3xx // Rerurned when the server redirect the client
- 4xx // Sinigies inproper request from the client, requesting a resource that doees'nt exist or requesting a bad format.
- 5xx // Returned when there is some problem with the HTTP server itself.

The following are some of the commondly seen examples from each of the above HTTP meth:

- 200 ok // Returned on successfil request, and the response body usually contains the requested.
- 302 found // Redirects the client to another URL.
- 400 bad quest // Returned on ecountrering malformed request such as request with missing line terminators.
- 403 forbidden // Signifies that the client does'nt have appropiate access to the resources, also be returned when the server detects malicius input form the user.
- 404 not found  // Returned when the client requests a resources that doese'nt exist on the server.
- 500 internal server error // Returned when the server cannot process the request.
[cloudflare](https://developers.cloudflare.com/support/troubleshooting/http-status-codes/http-status-codes/)
[AWS](https://docs.aws.amazon.com/AmazonSimpleDB/latest/DeveloperGuide/APIError.html)


## GET:
Request to obtain the remote resources hosted at the URL, Once the browser receives the initial page it is requesting; ot may
send other request using varius HTTP methods.

### HTTP basic AUTh:
When we visit the exercise found at the en os the section, it prompts us to enter a usernama and pass. Which utilize HTTP parameters to validate the
user credentials this type of auth utilize a basic HTTP auth, which handle directly by webserver to protect a specific page/directory.
```bash
Anchovy317@htb[/htb]$ curl -i http://<SERVER_IP>:<PORT>/
HTTP/1.1 401 Authorization Required
Date: Mon, 21 Feb 2022 13:11:46 GMT
Server: Apache/2.4.41 (Ubuntu)
Cache-Control: no-cache, must-revalidate, max-age=0
WWW-Authenticate: Basic realm="Access denied"
Content-Length: 13
Content-Type: text/html; charset=UTF-8

Access denied

```
As we can see, we ger Access denied in the response body, and we also get **Basic raslm="Access denied"**
in the WWW-AUTH heafer, which confirms that this page indeed uses basic HTTP auth, as dicussed in the Headers sections,
we can use -u

```bash
curl -u admin:admin http://<SERVER_IP>:<PORT>/

<!DOCTYPE html>
<html lang="en">

<head>
...SNIP...

```
This time we do get the page in the response, other methods of AUTH as username:password@URL as we discussed.

### HTP AUTHORIZATUIN HEADER:

`curl -v http://admin:admin@server:port `
As we are using basic HTTP auth, we see that our HTTP request sets the Authorization header to Basic YWRtaW46YWRtaW4=
which is the base 64 encode value od admin:admin. Id we were using a modern method of auth the Authorization would
be type Bearer and would contain a linger encrypted token.
Set authorization manually with -H flag.
` curl -H 'Authorization: Basic YWRtaW46YWRtaW4=' http://<SERVER_IP>:<PORT>/`

### GET parameters
Once we are auth, we get access to City Search funtions, as page return our result, may be contacting a remote resource to obtain
the info, and the display on the page.
When we click on the request, it gets sent to search.php with the GET parameter search=le used in the URL, This undestant that the search funtion requests
another page for the result.

`curl 'http://<SERVER_IP>:<PORT>/search.php?search=le' -H 'Authorization: Basic YWRtaW46YWRtaW4='
Leeds (UK)`

> [!NOTE]
> The copied command will obtain all headers used in the HTTP request. we can remove most of them and only keep necessary auth headers, like
> the authorization header.

#### Exercice:
```bash

❯ curl 'http://94.237.53.146:54228/search.php?search=p'  -H 'Authorization: Basic YWRtaW46YWRtaW4='
Liverpool (UK)
Stockport (UK)
Plymouth (UK)
Wolverhampton (UK)
Phoenix (US)
Philadelphia (US)
Indianapolis (US)
El Paso (US)
Portland (US)
Memphis (US)

curl 'http://94.237.53.146:54228/search.php?search=flag'  -H 'Authorization: Basic YWRtaW46YWRtaW4='
```
## POST:
We saw how GET request may be used by we applications for funcionaloties like search and accessing pages, whenever web app need to transfer files or move
the user parameters from URL, POST request.
Main benefits:
- Lack of logging: As POST requests may transfer large files, it would not be efficient fopr the server to log all uploaded files as part of request URL, as would be
the case with a file upload.
- Less encoding Requirements: URLs are designed to be share, which means they need to conform to characters that can be  converted to letters, the POST request place data in the
bocdy which can accept binary data. The only characters that need to be encode are those that are used to separate parameters.
- More data can sent: The maximum URL Length varies between browsers , web servers, Content Delivery Network, URL Shortners.

### Login forms:

We can clear Network tab our browser devtools and try to log again, we will se many requests begin sent, can filter the requests by our server IP, so it would
only show requestes going to the web app web server.
In request section we can see the data:
`username=admin&password=admin`

Wit the request data at hand, we can try to send a similar request with cURL, to see whether this would allow us to login as well, as we did the previus section
we can simply righ-click on the request and select `Copy>Copy as curl`.
We user the -X POST flag to send a POST request, we can use -d flag to add the above data.

`curl -X POST -d 'username=admin&password=admin' http://<SERVER_IP>:<PORT>/

> [!TIP]
> Many loginf form would redirect us to a diff page once auth , if we want to follow the redirection with curl we can use -L flag.

### Authenticated Cookie:

If we successfully authenticades, we should have recived  a cookie so our browsers can persist our auth, and we don't need to login
every time we visit the page. We can use the -v -i flags to view the response, which should  contains the Set-Coockie header with out auth cookie.
`curl -X POST -d 'username=admin&password=admin' http://<SERVER_IP>:<PORT>/ -i`

With our auth cookie, we should now be able to interact with the web app without needing to provide our credentials every time. We can set
the above cookie with the -b flag
`curl -b 'PHPSESSID=c1nsa6op7vtk7kdis7bcnbadf1' http://<SERVER_IP>:<PORT>/`
`curl -H 'Cookie: PHPSESSID=c1nsa6op7vtk7kdis7bcnbadf1' http://<SERVER_IP>:<PORT>/

We may also try the same thing with our browser, go storage or Shift+F9, we click the Cookie in the left pane and select our website to view our current cookie.
For add new cookie, we must selected delete all, and the click + icon to add a new cookie.

### JSON DATA:
We interact with the City search funtion, will go to the Network tab in th browser devtools and the click on the trash icon to clear all request.
Search.php `{"search":"london"}`
The POST data appear to be in JSON format, so our request must have specified the Content-Type header to be app/json/.
```js
POST /search.php HTTP/1.1
Host: server_ip
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:97.0) Gecko/20100101 Firefox/97.0
Accept: */*
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Referer: http://server_ip/index.php
Content-Type: application/json
Origin: http://server_ip
Content-Length: 19
DNT: 1
Connection: keep-alive
Cookie: PHPSESSID=c1nsa6op7vtk7kdis7bcnbadf1

```
We do have Content-Type: app/json, try to replicate this request as we did early, but include both the cookie and content-type headers, and search.php.
` curl -X POST -d '{"search":"london"}' -b 'PHPSESSID=c1nsa6op7vtk7kdis7bcnbadf1' -H 'Content-Type: application/json' http://<SERVER_IP>:<PORT>/search.php
["London (UK)"]`

Finally try to repeat the same above request by using Fetch, we can righ-click on the request and select Copy>Copy as Fetch. asn then go the Console tab for execute de code.

```bash
curl -X POST -d '{"search":"flag"}' -b 'PHPSESSID=mfkrls1uo1705kge2qp7k31tqc' -H 'Content-Type: application/json' 94.237.55.96:39084/search.php
["flag: HTB{p0$t_r3p34t3r}"]%

```

## CRUD API
This section will lock at jow such a web app may utilize APis to perform the same thing, and will directly interact with api endpoint.

### APis
There are several types of APis, many are used to interact with a database, such  that we would be able to specify the requested table and the requested row within our API query,
and then use an HTTP method to perform the operation needed, for api.php endpoint, if we wanted to update de city table in the database , and the row we well be uploading has a city name.
`curl -X PUT http://<SERVER_IP>:<PORT>/api.php/city/london ...SNIP...`
### CRUD:
We can ez specify the table and the row we want to perform an operation on throungh such APIs, we may utilize dff HTTP methods to perform diff operations on that row.

- Create // POST // Adds the specified data to the database table
- Read // GET // Reads the specified entity form the database table
- Update // PUT // Updates the data of specified database table
- Delete // DELETE // Removes the specified row from the database

These four operations are mainly linked to the commonly know CRUD APis, byt the same principle is also used in REST APIs and several other types of APIs.
Not all APIs work in the same way, and the user access control will limit what actions we can perform and what result we can see.


#### Read
`curl http://<SERVER_IP>:<PORT>/api.php/city/london`, we can see that the result is sent as a JSON string, to have it formatted in JSON format, we cna pipe the output to the
jq utility, which wll format properly, -s silent.
```js
curl -s http://<SERVER_IP>:<PORT>/api.php/city/london | jq

[
  {
    "city_name": "London",
    "country_name": "(UK)"
  }
]

```
#### Create:
To add a new entry, we can use the HTTP POST request, which is quite similar to what we have performed in the previus section, we can simplu POST our DATA
and it will be added to the table. COntent type header to JSON:
`curl -X POST http://<SERVER_IP>:<PORT>/api.php/city/ -d '{"city_name":"HTB_City", "country_name":"HTB"}' -H 'Content-Type: application/json'`
Now we can read read the conent of the city we added, to see was  successfully added.

#### Update:
Methods PUT and DELETE, PUT is used to update API entries and modify their details, while DELETE is used to remove a specific entity.
> [!NOTE]
> The http PATCH method may also be used to update API entries instead of PUT, PATCH is used to partially update an entry while PUT is update the entire entity.
> We may also use the HTTP OPTIONS method to see which os the two is accepted by the server, and then use the appropiate method accordingly.

Using PUT is quite similar to POST in this case, with the only difference begin that we have to specify the name of the entity we want to edit int he URL, otherwise
the API will not know which entity to edit.
` curl -X PUT http://<SERVER_IP>:<PORT>/api.php/city/london -d '{"city_name":"New_HTB_City", "country_name":"HTB"}' -H 'Content-Type: application/json'`
We see in the example above that we first specified /city/londo as our city, and passed a JSON string thaty contained "city_name":"New_HTB_City" in the request data.
> [!NOTE]
> In some APis, the Update operation may be used to create a new entries as well, we would send our data, and if it does not exist, it would create. In the above example
> if a entry with a london city did not exist, it would create a new entry wiht the detail passed.

#### Delete:
We simply specify the city name for the API adn use the HTTP DELETE method, and would delete the entry.
` curl -X DELETE http://<SERVER_IP>:<PORT>/api.php/city/New_HTB_City`
We are able to perform all 4 CRUD operations. Such action may no be allowd for all users, or would be consider a vulnerability if anyone cna modify or delete any entry. Each user
would have certain privileges on what they can read oir write.
To auth our user to use tha API, we would need to pass a cookie or an auth header(JWT).
`curl -X POST 94.237.63.90:34726/api.php/city/  -d '{"city_name":"flag", "country_name":""}' -H 'Content-Type: application/json'`
https://academy.hackt hebox.com/achievement/349590/35

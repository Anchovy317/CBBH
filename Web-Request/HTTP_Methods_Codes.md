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


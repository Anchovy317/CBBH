# HyperText Tansfer Protocol(HTTP):
Majority of the apps we can use consatantly interact with the internet, both web mobile app. Most communications are made with web requests.
though the HTTP protocol.
HTTP is a application-lebel protocol used to access the World Wide Web reoursce. The term hypertext stands for text containing links
to other resources  and text that the readers can easily interpret.
HTTP communications consist od a client and server, where the client request the server for a resource. The server, process the request and
returns the request resource. The def port for HTTP is 80, though can be changed to any other part, depending on the web server configuration.
The same request are utilized whe we use the internet to visit diff website, we ewnter a fully qualified Domain Name (FQDDN)as a
Uniform Resource Locator(URL) to reach the desired website, like www.hacktheboc.com.

## URL:
Resource over HTTP are accesed via URL, which offers many more specificatios than simplify specificaying a website we can to visit.

- http:// --> scheme: This is used to identify the protocol begin accesed by the client, and ends with a colon and a double slash(: //)
- admin:password@ --> User info: This is a optional component that contains the credentials(separate by:) Used to authetication to the host and separate
from the host with an at sign@.
- inlanefreight.com --> The host the resource location, can be a hostname or the IP addr.
- 80 --> **Port**: The port is separated from the HOST by a colon(:) if not specified, http scheme def to port 80 and https def 433.
- /dashboard.php? --> Path: This points to the resource begin accessed, which can be a file or a folder. If there is note a path speccified, the server returns
the def(index.php)
- login=true# --> The query string: strarts with a question mark[?] and consist of a parameter can be separated by a ampersand&
- status --> Fragment : are proccessed by th browser on the client-side to locate sections within the primary resources

## HTTP FLOW:

![Diagram](https://academy.hackthebox.com/storage/modules/35/HTTP_Flow.png)

The diagram above present the anatomy of an HTTP request at a very high level. Time the URL into a browser, it sends a requests.
to a DMS(Domain Name System) server to resolve the domain and get its IP. THe DNS server looks up the IP addr for ,,, and return it.
All domain names need to be resobe this way, as serve can't communicate without an IP addres.

> [!NOTE]
> Our browser usually first look up records in the local /etc/host fiel, and if the requesteed domain does no exit within it, then
> they would contact other DNS server. We can use the /etc/hosts to manually add recods to dor DNS resolution.

Onece the browser gets the IP linked to the required domain, it sends a GET request to the def HTTP port(80) asking for the root/path.
In this case the contensts os index.html are read and returned by the web server an HTTP response, the response also contains the status code (200)
which indicate that the request was successfully processed. The web browser then renders the **index.html** contents and presents it to the user.

> [!NOTE]
> The module is manualy focused on HTTP web requests.

### CURL:
We be sendinf through two of hte most impotant tools for any web penetration[CURL].
CURL (client URL) is a coomand-line tool and library that primarly  supports HTTP along with many other protocols.
Basic send http request to any URL by using as a argument CURL:
```bash
curl inlanefreight.com

<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>301 Moved Permanently</title>
</head><body>
<h1>Moved Permanently</h1>
<p>The document has moved <a href="https://inlanefreight.com/">here</a>.</p>
<hr>
<address>Apache/2.4.41 (Ubuntu) Server at inlanefreight.com Port 80</address>
</body></html>

```
We see the curl does not render the HTML/jsvaScript/CSS code, but prints it in its raw format. We can manialy
interested in th request and response context, which usually become mus faster and more convenient.

We may also use curl to dowload a page or a file and output the content into a file using the -O flag.

`curl page.com/index.html
 ls --> index.html`

As we can see the output was not printed this time but rathee save into index.html. We noticed that curl still printed
some status while procesing the request. Silent status -s.
We can use the -h to see what other options may use it, or we can use man curl for view full curl manual page.

curl http://94.237.54.190:31264/download.php
HTB{64$!c_cURL_u$3r}

# HyperText Transfer Portocol Secure(HTTPS):
We discussed how HTTP requestes are sent and precessed One of the significant drawnbacks of HTTP is
that all data is transferred in clear-text. This means that anyone between the source and destionation
ca perform a Man-in-the-middle(MiTM) attack to view the transferred data.

# HTTPS OVERVIEW:
We can see the efect of no enforcing secure communications between a web browser and a web app.
We can see that the login credentials can be vied in clear text, this would make ez for someone on the same
net to capture the request and reuses the credentials for malicius purpouse.

As we can see, the data is transferred as a single encrypted stream, which makes it diff for anyone to
capture information such as credential or any other sensitive data.

> [!NOTE]
> Although the data transferred through the HTTPS protocol may be encrypted, the request may still reveal
> visisted URL if it contacted a clear-text DNS server, It is recommended to utilize encryped DNS or utilize a VPN
> service  to ensurce all traffic is properly encrypted.

# HTTPS FLOW:

OPERATIONS AT HIGH LEVEL:
![flow](https://academy.hackthebox.com/storage/modules/35/HTTPS_Flow.png)
If we type **http** instead **https** to website that enforce  HTTPS. Request is sent to 80 port, which
is the unecrypted HTTP protocol.
The sever dectect this and redic the client to secure port 433 instead.
Next, client sent client hello packet, giving information about itself. The sercer reply, followed by a key
exchange to exchange SSL certificates.
The cloent verigi the key certificate and sends one of it owm.
An encrypted handshake is initiated to confirm whether the encryption and transfer are working correctly.

Once the handshake completes successfully, normal http communication is continued, which is encrypted after
that, is very high-level OVERVIEW od the key exchange, which is beyound this module scope.

> [!NOTE]
> Depending on the circunstances, an attacker may be able to perform an HTTP downgrade sttack, which
> downgrade HTTPS communications to http, making the data transfered in clear text.
> This is done by setting up in Man-in-the-middle proxy to transfer all traffic through the attacker's host without
> the user's knowledge.

## Curl for HTTPS:
THis communication standards and perform a secure handshake and the encrypt and decrypt data automatically,
If we ever contact a website with an invalid SSL certificate or an outdate one, the curl by def would mo proceed with the
communucation to protect against the earlier mentioned MITM attack.
`curl https:......`

Modern web browser would do the same, warning the user against visiting a web with a invalid SSL certificate.
TO skip the certificate with curl we can use ***-k***
`curl -k .....`
# HTTP REQUEST AND RESPONSES:

HTTP communication mainly consist of an http rquest and an http reponse. AN http request i smda by the client, and
is processed by the server. THe requests contain all od the details we requiere form the server, including the resouce,
any request data, headers or options we specify, and many other options we will discuss throughout this module.
Once the server recieves the HTTP request, it processed ot and reponds by sending the http reponse, which contains
the response code, as discussed in a later section, and may conatian the resource data if the requester has access to it.

## HTTP REQUEST:
![display](https://academy.hackthebox.com/storage/modules/35/raw_request.png)

The image above shows an http get request to the url:
http://inlanefreight.com/users/login.HTML

The first line of any HTTP request contains three main fields 'separate  by spaces':
- Method -- GET -- The HTTP Method or verb, which specifies the type of action perform.
- Path -- /user/login.html/ -- The path to the resoruce begin ascessed. This field can also be suffixes  with a query string (username=user).
- Version -- HTTP/1.1 -- The third and final field is used to denote the HTTP version.

The next ser od lines contain HTTP header value pairs, like [Host, USer-agente, Cookie], and many other
possible headers. These heeaders are used to specify various attribute of a request. The headers are terminate
with a new line, is necessary for the server to validate the request.

> [!NOTE]
> HTTP version 1.X sends request as clear-text, and uses a new-line character to separate diff fields and different requests.
> HTTP version 2.X on the other hand, sends request as binary data in dictionary from.

## HTTP RESPONSE:
![display](https://academy.hackthebox.com/storage/modules/35/raw_response.png)

The first of an HTTP response contains two field separate by spaces. The first begin the HTTP version (HTTP/1.1), and
the second denotes the HTTP response code (200 ok).
Response codes are used to determinate the requet's status, as will be discussed in a later section. After the first line,
the response lists its headers, similar to an HTTP request.
The response may end with response body, which is separated by a new line after the headers.
The response  may end with response body, which separate by a new line after the headers, the response body is actually defined as HTML code. It can also
respond with other code types such as JSON, website resources such as img, style sheets or scripts.

## CURL:
Curl also allows us to preview the full HTTP request and the full HTTP response, which can become very
handly when performing web penetration tests or writing explois.
```json
curl inlanefreight.com -v

* Host inlanefreight.com:80 was resolved.
* IPv6: 2a03:b0c0:1:e0::32c:b001
* IPv4: 134.209.24.248
*   Trying [2a03:b0c0:1:e0::32c:b001]:80...
* Immediate connect fail for 2a03:b0c0:1:e0::32c:b001: Network is unreachable
*   Trying 134.209.24.248:80...
* Connected to inlanefreight.com (134.209.24.248) port 80
* using HTTP/1.x
> GET / HTTP/1.1
> Host: inlanefreight.com
> User-Agent: curl/8.12.1
> Accept: */*
>
* Request completely sent off
< HTTP/1.1 301 Moved Permanently
< Date: Thu, 20 Feb 2025 19:08:56 GMT
< Server: Apache/2.4.41 (Ubuntu)
< Location: https://inlanefreight.com/
< Content-Length: 317
< Content-Type: text/html; charset=iso-8859-1
<
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>301 Moved Permanently</title>
</head><body>
<h1>Moved Permanently</h1>
<p>The document has moved <a href="https://inlanefreight.com/">here</a>.</p>
<hr>
<address>Apache/2.4.41 (Ubuntu) Server at inlanefreight.com Port 80</address>
</body></html>
* Connection #0 to host inlanefreight.com left intac

```

As we can see. we get the full HTTP request and response. The request simply sent GET / HTTP 1.1
along with thr Host, User-agent and Accept headers. The HTTP response contained HTTP/1.1 401 Unauthorized,
which indicates that we do not have access over the requested resource, as we will see in a upcoming section.
SImilar to the request, the response also cantained several header sent by the server, including
Date, Content-Length, and Context-Type.

## Browser Davtools:
Most modern web browser come with  built-in developer tools which mainly intended for developers to test
their web app. As web penetration tester, these can be a viral assent in any web assessment we perform. as browser
are among the assents we  are most likely to have in every assess and monitor dff types os web requests.
The devtools  contain multiple tabs, each of which has its own use. We will mostly be focusing on the Network tab in this
module as it respinsable.
The request method used (GET) the requested resource, along with the requested path, we can use FIlter URls to search
for a specific request, in case the website loads too many to go though.

# HTTP HEADER:
We have seen examples of HTTP request and response headers in the previus sections, such HTTP headers pass information
between the client and the server, Some headers are only used with either requests or responses, while some other
general headers are common to both.
Headers can have one or multiple values, appended after the header name and separate by a colon, we can divide headers into the following:

1. General Headers
2. Entity Headers
3. Requests Headers
4. Response Headers
5. Security headers


## General headers:
There are used HTTP request and responses, they are contextual and are used to decribe the message rather than its  content.
- Date// Date: Wen, 15 Feb 2022 10:00:00 GMT// Holds the date and time which the message originated. Time to the standard UTC time zone.
- Connection // Connection: close // Dedicates if the current Network connection should stay alive after the request finished. Two commonly used
values for this headers are close and keep-alive, the close value form either the clien or server means that they would like to terminate the connection,
while keep-alive header indicated that the connections should remain open to receive more data and input.

## Entity headers:
Similar to general headers, Entity headers con be common to both the request and response. These headers are used to describe the conetent (entity) transefered
by menssage. The usually found and POST or PUT requests.

- Content-type// text/html// Used to describe the type of resorce begin trasderred, the value is automatically added by the browsers on the client-side and returned
in the server response, The charset field denotes the encoding standards such as UTF-8.
- Media-type// application/pdf // The media type is similar to Content-Type, and describes the data begin transferred, this headers can play a crucual role in making
a server interpret our input. The charset field also be used with this header.
- Boundary // boundary="b4e4fbd93540" Act as marker to separate content when there is more than one in the same message.
- Content-Length // Content-Length: 385 // Holds the size of the entity begin passed. The heafer is necessary as the server uses it to read data from the message body ,
and auto generated by th browser and tools like cURL.
- Content-Encoding: // Content-Encoding: gzizp// Data can udergo multiple trasformations before begin passed.

## Request Headers:
The client sends Request Headers in an HTTP transation, these header are used in an HTTO request and ddo no realte to the conent of the message:
- Host//www.xxxxx.com// Used to specify the host begin for the resource, can eb a domiain name or an IP addr, Http servers can be configured  to the host different websited, which
are reveled based on the hostname, this makes the host header and important enumeration target, as indicate existence os other on the target server.
- User-agent// User-Agent:curl/7.77.0// Is used to describe the client requesting resources, this headers can reveal a lot of the client, brouser, version.
- Referer // Referer:http://www.xxx.com // Denotes where current request is comming from, clicking a link from google search result would make https://google.com the refere.
- Accept// Accept: */* // Decribes which media types the client can understand, it can contain multiple media types separates by commas.
- Cookie// Cookie:PHPSESSID=b4e4fbd93540// Pair in the format name=value. Is a piece of data stored on th client-side and the server, which actgs as identifier.
- Authorization// Authorization: Basic cGFzc3dvcmQK // Another method for the dercer to identify the clients, after successful auth, the server return a token unique to the client.
Tokens are stored only the client-side an retrived by the server per request.

## Response Headers:
Can be used in an HTTP response and do no related to the content, reponse headers such as Age, location, server are used to provide more context about the response.
- Server // Apache/2.2.24 (WIN32) // Contains information about the HTTP server which processed the request.
- Set-Cookie // Set-Cookie:PHPSESSID=b4e4fbd93540// Contains the cookie needed for client identification.
- WWW-AUTH // WWW-Authenticate: BASIC realm="localhost" // Notify the client about the type of auth required to access the requested resources.

## Security Headers:
Are a class of response headers used to specify certain rules and policies to be followed by the browser while accessing the website.
- Content-Security-Policy // Content-Security-Policy: script-src 'self'// Dictates the website's policy injected resources, preventing attack XSS.
- Strict-Transport-Security // Strict-Transport-Security: max-age=31536000 // Prevents the browser from accessing the web over plain text http protocolm and force
all communication to be carried over the secure HTTPS protocol, this prevent sniffing weeb traffic and accesing protected information such as pass.
- Referrer-Policy // Referrer-Policy: origin // Dictates whether the browser should include the value specified bia the referer header or not.

[More](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers)

FOR THE RESPONSE HEADER USE `curl -I ` for the both response and headers `curl -i`, also allows set the request headers with the -H and the user agent
`curl -A 'Mozilla/5.0'`
In the network section od devtools we can see the headers too.


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


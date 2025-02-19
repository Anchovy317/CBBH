# HyperText Tansfer Protocol(HTTP):
Majority of the apps we can use consatantly interact with the internet, both web mobile app. Most communications are made with web requests.
though the HTTP protocol.
HTTP is a application-lebel protocol used to access the World Wide Web reoursce. The term hypertext stands for text containing links
to other resources  and text that the readers can easily interpret.
HTTP communications consist od a client and server, where the client request the server for a resource. The server, process the request and
returns the request resource. The def port for HTTP is 80, though can be changed to any other part, depending on the web server configuration.
The same request are utilized whe we use the internet to visit diff website, we ewnter a fully qualified Domain Name (FQDDN)as a
Uniform Resource Locator(URL) to reach the desired website, like www.hacktheboc.com.

## URL
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

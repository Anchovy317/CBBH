# Introduction:
As web app are becoming very common and beggin utilize for most businessnes, the importance of protecting them against malicius attaks also become more critical, AS modern web app become more complex and
advanced, so do the types of attacks utilized against them. This leads to a vast attack surface for most bussiness today, which is why web attacks are the most common types of attacks against companies.
- Web Attack:
    - HTTP Verb Tampering:
    The first web attack discussed in this module is Http Verb tempering, this attaack exploits web servers that accept many http verbs and methods. This can be exploted by sending malicius requests using unexpected methods,
    which may lead to bypassing the web app auth mechanims or even bypassing its security controls against other web apps, HTTP Verb tampering attacks are ont of may others HTTP attacks that can be used to exploit
    web server configuration.
    - Insecure Direct Obj References(IDOR):
    The second attack discussed in this module is Insecure Direct Object References, is among the most common web vulnerablilities and can lead to accessing data that should not be accessible by attackers. What  makes this attacks very common
    is essentially that lack of a solid access control system on the back-end.
    As web app store files and information, they may use sequential numbers or user IDs to identify each item. Suppose the web app lacks a robust access control mechins and exposes direct references to files and reources.
    - XML External Entity XXE Injection:
    Many web apps process XML data as part of their funcionality. Supose a web app utilizes outdate XML libraries to parse and process XML input data from the front end user.
    These files may be configuration file that may contain sensitive information like pass or even the source code.

# Insecure Direct Object References:
The HTTP protocol works by accepting varius HTTP methods as verbs at the beginning og an HTTP requests. Depending on the web server configuration, web app may be scripted to accept certain HTTP methods for their varius funtionalities and perform a particular action based
on the type of the requests.
While programmers mainly consider the two most commonly uyser HTTP methods, GET and POST, any client can send any other methods on their HTTP requests and then see how the web server handlers these methosds, suppose both the web app and the back-end web server are
configured only to accept GET and POST request. Sending a different requests will cause a web server error page to be displayed, which is no servere vulnerablility in itself . If the web server configuration are not restricted to onlu accept the HTTP methods required by the web server, and the
web appp is no developed to handle types of HTTP requests then we may be able to exploit this insecure configuration to gain access to funcionalities we do not have access even bypass certain security controls.

- HTTP Verb Tampering:
To understand HTTP verb tempering, we must first learn about the differnet methods accepts by the HTTP protocol.
Methods:
    - GET: method requests a representation of the spcified resource, request usin GET only reitrive data and should not contain a request content.
    - HEAD: method asks for reponse identical to a get request, but without a response body.
    - OPTIONS: Methods describe the comunication options for the target resource.
    - TRANCE: Methos perform describe the communication options for the target resource.
    - PUT: Method replace all current respresentation of the target resource with the request content.
    - DELETE: Method deletes the specified resource.
    - POST: Submits an entity to the specified resource, often causing a change in state or side effect the server.
    - PATCH : Methods applies partial modifications to a resource.
    - CONNECT: Method establishes a tunnel to the server identified by the target resource.


### Insecure Configurations:
Web server configurations cause the first type of HTTP Verb Tampering vulnerablilities, A web server's auth configuration may be limited to specific HTTP methods, which would leave some HTTP methods accessible without authentication.
`xml--> <LIMIT GET POST> Required valid-user</Limit>`
As we can see, even though the configuration specifies both GET and POST request for the auth method, an attacker may still use a different HTTP method, to bypass this auth mechanism altogether, as we'll see in the next section.
- Insecure coding:
Practices caue the other types of HTTP Verb Tampering vulnerablilities. This can occur when a web developer applies specifiec filters to mitigate particular vulnerabilities while not convering all HTTP methods with that filter.
```php
<?php
$pattern = "/^[A-Za-z\s]+$/";

if(preg_match($pattern, $_GET["code"])) {
    $query = "Select * from ports where port_code like '%" . $_REQUEST["code"] . "%'";
    ...SNIP...

?>
```

We can see that the sanitization filter os only begin tested on th GET parameter, if the GET request do not contain any bad characters. then the query would be executed. When the query is executed, the $_REQUEST["code"] parameters are begin used, which may also contain POST request, leading to an incosiscity in the use of HTTP verb. An attacker may use a POST request to perform SLQ injection, in which case the GET parameter would be empty.

## Bypassing Basic Authetication:
Is usually a realitvely straightfoward process, we just need to try alternate HTTP methods to see how they are handle by th web server and the web app. While many automated vulnerability
scanning tools can consistently identity HTTP Verb Tampering vulnerablilities cause by insecure server configurations, they usually miss identifying HTTP vulnerabilites cause the insecure coding.
This first type of HTTP Verb Tampering vulnerability is mainly coaused by Insecure Web Server Configurations, and exploiting this vulnerability can allow us to bypass the HTTP Basic Auth prompt on certain page.
- Identity:
When we start the exercise at the end of this section, we see that we have a basic [File manager] web app, in which we can add new file by typing their names and hiting enter:
Suppose we try to delete all files cliking on the red Reset button, we see that this funcionality seems to be restricted for auth users only, as we get the following HTTP BAsic Auth.
We dont have any credentials, we will get a 401 Unathorized page.
Lest  see whether we can bypass this with HTTP Verb Tampering attacks, we need to identify which pages are restricted by this auth, examine http request after clicking the reset buttion or look at the URL that the button navigate after cliking, we that is at /admin/reset.php.
- Exploit:
As the page we need to identify the http request method used by the web app, we can intercept the request in burp and examine.
As the page uses GET we can send a POST request and see whether the web page allows POST request, We can rigth-click on th intercept request in Burp and select change method, asn will automatically  change the request into a POST requesr:
Once we do so we can click Forward and examine the page in our browser, we still get prompted to log in  and will get 401 Unathorized page if we don't provide the credentials.
It seems like the web sercer configurations do cover both GET and POST  request. as we have previusly learned, we can utilize many other HTTP methods, most notably the HEAD method, which is identical to a GET request but does no returned the body in the HTTP response.
`curl -i -X OPTIONS http://SERVER_IP:PORT/`
The reponse shows Allow: POST,OPTIONS,HEAD,GET, which means that the web server indeed accepts HEAD request, which is def configuration gor may web servers.
Once we change POST to HEAD and foward the request, we will we no longer get a longlun prompt for a 401 Unauthorized page and get an empty  output instead, as expected with a HEAD request.  We go back to the file manager web app, we will se that all files have inded been deleted, meaning a successfully the Reset functionality without having admin access or any creadentials.

## Bypassing Security Filter:
The other and more common of HTTP Verb Tampering vulnerability is caused by Insecure Coding errors made during  the development of teh web app, which lead to web app not covering all HTTP methods in certain funtionalities. This is commonly found in security filters that detect malicius requests.
- Identify:
In the File MAnager web app, if we try create a new file name with characters in its name, this message shows that the web app uses certainn filters on the back-end to identify injection attempts and then blocks any malicius requests, no metter what we try, the web app properly blocks our requests
and is secured against injection attempts.
- Exploit:
Try and exploit vulnerbility, let's intercept the request in Burp and then use change request to change other, to confirm whether we bypassed the security filter, we need to attempt exploiting the vulnerability the filter is protecting a Command-injection vulnerbility. We cna inject a command that create two files and then check both files are created.

## Verb Tampering:
After seeing a few ways to exploit Verb tampering vulnerbility, let's see how we can protect ourselves against these types of attacks by preventing Verb Tampering, insecure configuration and insecure coding are what usually introduce Verb Tampering vulnerbility.
- Insecure Configurations:
HTTP verb tempering vulnerabilities can occur in most modern web servers, including Apache, Tomcat, and ASP.NET. The vulnerability usually happens when we limit a page's auth to a particular set of HTTP verb/methos.
The following is an example of a vulnerable configuration for an Apache web server, which is located in the site configuration.
Example of configuration of apache server:
```xml
<Directory "/var/www/html/admin">
    AuthType Basic
    AuthName "Admin Panel"
    AuthUserFile /etc/apache2/.htpasswd
    <Limit GET>
        Require valid-user
    </Limit>613760507
</Directory>
```
As we can see, this configuration is setting the auth configuration for the admin web directory, as the <LIMIT GET> is begin used. The requiered valid user setting will onluy apply to Get request, leving the page through POST request.
The following example shows the same vulnerability for a Tomacat web server configuration, web.xml file for certain Java web app:
```xml
<security-constraint>
    <web-resource-collection>
        <url-pattern>/admin/*</url-pattern>
        <http-method>GET</http-method>
    </web-resource-collection>
    <auth-constraint>
        <role-name>admin</role-name>
    </auth-constraint>
</security-constraint>
```
We can see that the auth is begin limited only to the GET method with http-method, which leaves the page accessible through other HTTP mehthods.
The following is an example for an ASP.NET configuration found in the web.config file of a web app:
```xml
system.web>
    <authorization>
        <allow verbs="GET" roles="admin">
            <deny verbs="GET" users="*">
        </deny>
        </allow>
    </authorization>
</system.web>
```

The allow and deny scope is limited to the GET method, which leaves the web app accessible though other HTTP methods. The above examples shows that is si not secure to limit the auth configuration to a spcific HTTP verb. This is why we always avoid restricting auitherization to a particuar http mehtod an
always  allow/deny all HTTP verbs and methods.
If we want to specify a single method, we can use safe keywords, like LimitExcept in Apache, http-method-omission in Tomcat, and add/remove in ASP.NET, which cover all verbs except the specified ones.
We should generally consider disabling/denying all HEAD requests unless specifically required by the web application.

- Insecure Coding:
While identify and patchinh insecure web server configuration is relatively ez, doing the same for insecure code is much more challeging. This is cuase identify this vulnerablility in the code, we nee to find inconsistence in the use of http parameter across funtions, as in some instances this may lead to unprotected
funtionalities and filters.
Conseder the following PHP code form our File Manager exercise:
```js
if (isset($_REQUEST['filename'])) {
    if (!preg_match('/[^A-Za-z0-9. _-]/', $_POST['filename'])) {
        system("touch " . $_REQUEST['filename']);
    } else {
        echo "Malicious Request Denied!";
    }
}
```

If we were only considering Command injection, we would sat that this is securely coded, the preg_match funtions properly looks for unwanted specioal character and does not allow the input to go into the command if any special characters are found. The fatal error made in this case is not due to Command injection but due to
the incosistent use of HTTP method.
We see that teh preg_match fileter onlyu checks for special characters in POST parameters with $_POST['filename']. The final sytem command uses the the $_REQUEST['filename'] variable, which covers both GET and POST paramaeter. When we were sending our malicius
input thorugh a GET requests, it did not get stopped by the preg_match funtions, as th POST parameters were empty and hence did not contain any special characters, once we reach the system funtions, it used any parameters found the request, and out GET parameters
were used in the command, eventually leading to Command Injection.

To avoid HTTP Verb Tampering Vulnerability in our code, we must be consistent with our use of HTTP methods and ensuere that the same method is always used for any specific funtionality acrros the web app.
- PHP --> $_REQUEST['param']
- Jave --> request.getParameter('param')
- C# --> Request['param']


# Introduction:
Web app is a interactive app that run on web browser, Web aoo usually adopt  a client-server arch to run handle interaction.

Website:
- Static Page
- Same for everyone
Web App:
- Dynamic Pages
- Interactive
- Dff view for each user
- Funtional
Another significatn difference is that web app are fully funtional and can perform varios funtionalities  for the end-user, while
Website lack this type of funtionality.
- Begin modular
- Running on any display size
- Running on any platform wihtout begiun optimized.

## Web App vs Native Operating System Applications:
Web app are plataform-independent and can run in a browser on any operating system. These we app do no have be installed cause are execute
remotely on the remote server.
Other advantage are user accesing a web app use the same version and the same web app, Web app can be updated in a single location(webserver)
with developing dff builds for each plataform, which dramatically reduces meantence and supp costs removing the need to communicate changes
to all user individually.

Os apps can utilize native operation system libraries and local hardware, apps are build to utilize native OS libraries, are much faster to load
and interact with, there are more capable.

## Web Application Distribution:
- WordPress
- OpenCart
- Joomla

'Cloades source' web app, which are usually devep by organization and then sold another organization or used a subscriptio plan model.
- Wix
- Shopify
- DoNotNuke

## Security Risk of Web Applications:
Any organization looking to secure thayr internet-facing web app should undergo frequent web app test and implemten secure coding practice at every
development life cycle stage. One of the most current and widely used methods for testing web apps is the [OSAP](https://github.com/OWASP/wstg/tree/master/document/4-Web_Application_Security_Testing)
One of the most common procedures is to start a web app front end components, such as HTML,CSS and Javascipt, and attempt to find vulnerabilities such as
[Sensitive Data ](https://owasp.org/www-project-top-ten/2017/A3_2017-Sensitive_Data_Exposure) or [Cross-Site-Scripting](https://owasp.org/www-project-top-ten/2017/A7_2017-Cross-Site_Scripting_(XSS))

## Attacking Web Applications:
Is not very common to find externally facing host directly exploitabnle via a know public exploit, web app provide a bas attack surface and their dynamic nature
means that are constantly changing. A relatively simple code change may introduce  a catastriphic vulnerability or a series if vulnerabilities that can be chained together to gain acess to
sesitive data or remote code execution  on the webserver or the hosts in the eviroment, such a database server.
Is not uncommon to find flaws that can lead to code execution, such as a file upload form that allows for the upload of malicius code or a file inclusion vulnerabilities thjaty can be
leverage(apalancada) to obtain remo code executin.
Sql Injection often find vulnerabilities on web app thaty use Active Directory for auth, can usually not leverage this to extract pass, we can often pull most
or all Actuve Directory user email addr, which are the same useraname.
This Data can then used to preform a password spraying[is a type of brute force attack in which a malicius actor uses a single pass against targeted user accounts before moving on to attemps a secoond pass].


| Flaw | Real-world Scenario|
|--------------- | --------------- |
| Sql Injection  | Obtain active directory usernames and performing a pass spraying attack against VPM |
| File Inclusion | Reading Source code to find a hidden page or directly which exposes additional funcionallity can use to gain remote code|
| Unrestricted File Upload | Web app that allows a user to upload a profice pic that allows any file type to be upload|
| Insecure Direct Object Referencing | When combined with a flaw such as broken access control, this can often be used to access another user's file or funcionality |
| Broken Access control | If account registration funcionallity is designed poorly, a user may perform prvilege escalation when registering. |


# Web App layout:

| Category |Description|
| -------------- | --------------- |
|Web app Infrastructure| The structure requeried components, such as a database, needed for the web app to funtions as interded|
|Web app Components |The components that make up a web app represent all components that tht web app interacts with [UI/UX, Client and Server] |
|Web ap Arch |Compromiste all the relationship between the varius web app components |


## Web app Infrastructure:
Web app can use many different Infrastructure setup, called models:
- Client-Server
- One Server
- Many Servers - One database
- Many Servers - Many database

###  Client-Server:
Web ao often adopt the client-server model. Web app have two types of components, those in the font end, which are usually interpreted and execute in the client-side, and
components in the back end, usually compiled, interpreted and executed by the hosting server.

When a client visit the web app URL, the server uses the main web app interface[ui]. Once the user clicks on the button or request a specific funtion, the browser sends
HTTP web request to the server, which interpretes this request and perform the necessary task to complete de request.
Once the server has the required data, it sends the result back to the client's browser displaying the result in the human-readable way.
**This website we are currently interacting with is algo web app, developed and hosted by HTB server, asn we acces it and interact with it using our web client**
![Example](https://academy.hackthebox.com/storage/modules/75/client-server-model.jpg)

### One Server:
Web app hosted in this server is compromised in this arch, then all web app data will be compromised, respresent and all eggs in one brasket approach since
if any of the hosted web app are vulnerable
![Example](https://academy.hackthebox.com/storage/modules/75/one-server-arch.jpg)

### Many Servers - One Database:
This model can allow sever web app tp access a single database to have access to the same data without syscing the data between them, apps can be replications
of one main app or they can be separate web app that share common data.
This model's main advantage(from a security point of view) is segmentation, where each of the main component os a web app is located an hosted separtely, one server
compromise all server compromised but the web app is not directly affected.
![Example](https://academy.hackthebox.com/storage/modules/75/many-server-one-db-arch.jpg)

### Many servers - Many Databases:

This model builds upon the Many Servers One-Database, with  the database server, each web server app data is hosted in a separate databe.
The web app can only access private data and only common data is shared across web app.
This design is also widely used for redundancy purpouse, so if any web server or databases goes offline, a backup will run in its place to reduce
downtime as mush as possibl.  This may be more difficult to implement and may requere tools like load balancerts to funtions.
- Load balancers: are a devices or sofware that distribute incoming network traffic across multiple server to ensuer that not
single sever become overwhelmed. Loadbalancer spreads those request across multiple servers, if one fail the load balancer redirects traffic
to the remaining healthy server.
    - Layer 4 load Balancers: Operate at the transport layes, rounting the trafic base on IP addr and port.
    - Layer 7 loaf balancers: Operate at the app layer, making decisions based on the HTTP headers, cookies or URL path.
This balancers supp diff algorithms:
    - Round Robin: Each server gets request in turn
    - Least Connection: New request go to the server with the fewest actvie connection.
    - IP Hash: Route request based on the client's IP addr.

Aside form these models, therea are other web apps models sucha as serverless web apps or web applications that utilize microservices.
![Example](https://academy.hackthebox.com/storage/modules/75/many-server-many-db-arch.jpg)

## Web App Componets:

1. Client
2. Server
    - Webserver
    - Web app logic
    - Database
3. Services(microservices)
    - 3rd Party Integrations
    - Web App integrations
4. Funtions (Serverless)

## Web App Arch:
-Layers:
    - Presentation Layers: Consiste of UI components  that enable communication iwth th aspp and the system.
    - Application Layer: This ensures that all the client request are correctly processed.
    - Data layer: Works closely with tha app layer to deteminate exactly where the required data is storage.

![Example](https://docs.microsoft.com/en-us/dotnet/architecture/modern-web-apps-azure/media/image5-12.png)

[PHP-GCI](https://www.php.net/manual/en/install.unix.commandline.php)
[ISAPI](https://learn.microsoft.com/en-us/previous-versions/iis/6.0-sdk/ms525172(v=vs.90)
)

### Microservices:
- Registration
- Search
- Payments
- Rating
- Reviews
The componts  comunicate with the client and with each other, the communication between these microservices is statelss, which means that thge request
and response are independient. This is cause the store fata is stored separately formn the respective microseviece.
The use of microservices is consider [service-oriented arch(SOA)](https://en.wikipedia.org/wiki/Service-oriented_architecture), built as a collecton of different
automated funtions focused on single bussiness.
Another essential and efficient microservices component is that they can be written in dff programming lenguage and still interac, benefits:
    - Agility
    - Flexible scaling
    - Easy Deployment
    - Reusable code
    - Resilience
[AWS](https://d1.awsstatic.com/whitepapers/microservices-on-aws.pdf)

### Serverless:
Cloud provide such as AWS, GCP, AZURE. These plataforms provide de app frameworks to bulid such web app without having to werry about the servers themselves.
These web app then run in statelss computing container, this are flexibility to build an deploy apps and servicers without having a manage infraestructure.

## Architecture:
The general arch of web app and each web app specific design is important when performing a pentest on any web app, an individual web app vulnerability may no
necessary be caused by programming erro byut by design error ots arch.
[RBAC](https://en.wikipedia.org/wiki/Role-based_access_control), users may be able to access some admin freatures thayt are no intended to be directly accesible
to them or even access other user private information.


# Front End vs Back end

The front end of a web app conaints the user's componets directly through their web browser, These components meke up the source code os the web page we view, usually
include HTML,CSS,JS
In the modern web apps, front end components should adapt to any screen size and work with any browser.
Some task:
- Visual Concpet Web design
- User interface (UI) design
- User experience (UX) design

The backend of a web app drives all the core web app funcionalities, all of which is executed at the backend serverm which processes everything required for thge web app to run.
MAIN COMPONENTS:
1. Backend Servers:
The hardware and operationg system that hosts all other componets and are usually run on operation system like Linux, Windows or using containesr.
2. Web Servers: Http request and connections, Apache nguinx and IIS.
3. Databases: Webapp data MySQL, MSSQL, Oracle, PostgreSQL, while examples of non-relational databases include NoSQL and MongoDB.
4. Development frameworks: Some well-known frameworks include Laravel (PHP), ASP.NET (C#), Spring (Java), Django (Python), and Express (NodeJS JavaScript).

![example](https://academy.hackthebox.com/storage/modules/75/backend-server.jpg)
Is also possible  to host each component os the backend isolate server, or isolatew conatainer, by utilizing services such as dockers.

Some of the main jobs performed by back end components include:
- Develop the main logic and services of the back end of the web application
- Develop the main code and functionalities of the web application
- Develop and maintain the back end database
- Develop and implement libraries to be used by the web application
- Implement technical/business needs for the web application
- Implement the main APIs for front end component communications
- Integrate remote servers and cloud services into the web application

Even withoit access to back-end code, app can still vulnerable to attack like SQL injection and Command Injection. When we hace fron-end
source code we can conduct **Whitebox** pentesting through code reviews. Back-end code is typically inaccessible, limiting us to **Blackbox**
pentest, unless the vulnerabilities like Local file inclusion expose the source code.

The top 20 most common mistakes web developers make that are essential for us as penetration testers are:

1. Permitting Invalid Data to Enter the Database
2. Focusing on the System as a Whole
3. Establishing Personally Developed Security Methods
4. Treating Security to be Your Last Step
5. Developing Plain Text Password Storage
6. Creating Weak Passwords
7. Storing Unencrypted Data in the Database
8. Depending Excessively on the Client Side
9. Being Too Optimistic
10. Permitting Variables via the URL Path Name
11. Trusting third-party code
12. Hard-coding backdoor accounts
13. Unverified SQL injections
14.	Remote file inclusions
15. Insecure data handling
16. Failing to encrypt data properly
17. Not using a secure cryptographic system
18. Ignoring layer 8
19. Review user actions
20. Web Application Firewall misconfigurations

These mistakes lead to the OWASP Top 10 vulnerabilities for web applications, which we will discuss in other modules:
1. Broken Access Control
2. Cryptographic Failures
3. Injection
4. Insecure Design
5. Security Misconfiguration
6. Vulnerable and Outdated Components
7. Identification and Authentication Failures
8. Software and Data Integrity Failures
9. Security Logging and Monitoring Failures
10. Server-Side Request Forgery (SSRF)

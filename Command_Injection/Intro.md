# Command injection:
A commman Injection is among the most critiacal types of vulnerabilitites. It allows us to execute system commands directly on the back-end hosting server, which could lead to compromising the entire network.
If we app uses user-controlled input ot execute a system command on the back-end to reitrive and return specific output, we may be able
to inject a malicius payloads to subvert the intended command and execte our command.

- Whatr are Injections:
Injection are considered the number 3 risk in OSAWP, given their high impact and how common they are. Injection occurs when user-controller input is misterpreted as part of the web query or code begin exectued,
which may lead to subverting the intended outcome of the query to a different outcomes that is useful to the attackers.
Types of injections:
- OS commnad injection
- Code injection
- Slq injection
- Cross-Site Scripting/HTML injection

There arte many others types of injection than abve, like LDAP Injection, NoSQL Injection, HTTP Header Injection, XPath Injection, Imap Injection.
Whener user input is used within a query without propertly sanitized, it may be possible to escape the boundries of the user input string to the parent query and manipulate it to change its instead purpouse.

## OS commnad injections:
When it comes to OS command INjection, the user input we control must directly or indirecly go into a web query that exectute system commands. All web programminf have differents funtions that enable the developer to execute
operation commands directly on the back-end server whenever they need to.
- PHP Example:
We may use the [exec, system, shell, passthru or popen] funtions to execute commands directly on the back-end server, each having a slightly different use case.
```php
<?php
if(isset($_GET['filename'])){
    system("touch /tmp/ ." $_GET['filename']. ".pdf");
}
?>
```

A particular web app has a funcionality that allows users to create a new, .pdf document that gets created in th /tmp  directly with a file name supplied by the user and then be used by the web app for document prcessing purpouse.
AS the user input from the filename parameter in the GET request is used directly with the touch command, the web app vulnerables to OS command injection.
This flaw can be exploited to execute arbitrary system commnads on the back-end.

- NodeJS:
This is nit unique to PHP only, but can occurs in any web development framework or lenguage. If a web app is develop in NodeJS, a develop may use [child_process.exec or child_process.spawn] for the same purpouse.
```js
app.get("/createfile", funtion(req, res){
    child_process.exec('touch /tmp/${req.query.filename}.txt');
    })
```
The above code is also vulnerable to a command injection vulnerability, as it uses the filename parameter from the GET request as part of the command without sanitizing it firts.
PHP and NodeJS web app can be exploted using the same command injection methods.

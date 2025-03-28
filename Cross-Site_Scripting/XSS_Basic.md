# Intro:
As wev app more advanced more common, so do web app vulnerabilities. Amog the most common types of web app are XSS. This takes advantages of a flaw in user input
sanitazion to "write" JS code to the page and execute it on the client side, leading to several types of attacks.
- What is XSS?
A typical web app works by reveving the HTML code formthe back-end server and redering it on the client-side internet. When a vulnerable web app does not properly snaitaze user input, a malicius
user inject extra JS code in a input field, so once another user views the same page, they unknowlgly execute malicius js code.

XSS vulnerabilities are solely executed on the client-side and hence do not directly addect the back-end server, can only affect the user executing the vulnerability.
The direct of XSS vulnerabilities on the back-end server mey be relatively low, but they are very commonly found in web app, so this equetes to medium risk.
which we should always attempt to reduce risk detecting, remediating, and proacting preventing these types od vulnerabilites.
![Scheme](https://academy.hackthebox.com/storage/modules/103/xss_risk_chart_1.jpg)

## XSS attacks:
Can faciliatate wide range of attacks, which can be anything that can be executed through browser JS code. A basic example of an XSS attack is having a target
user unwittingly send their session cookie to the attacker's web server. Another example is having the target's browser execute API calls  that lead to a malicius action, like changing
the user's pass to a pass of the acctacker's chossing. There are many other types of XSS attacks form bitcoins.
As XSS attacks execute JS code within browser, they are limited to the browser JS engine. They cannot execute system-wide JS code to do something like systems-level code execution.
They are also limited to the same domain of the vulnerable website. Begin able to execute JS in a user's browser  may still leas to a wide variety of attacks as mentioned above.
If a skilled researcher identifies binary vulnerability in a webn they can execute CSS to a JS exploit on th target's browser, which eventually breaks out of the browser
sandbox and execute code on the user machine.
CSS my be found almost all modern web app and have been actively exploited for the past two decades,[Samy Worm](https://en.wikipedia.org/wiki/Samy_(computer_worm)) which was a browser-based
worm that exploited a stored XSS vulnerability in the social networking  website MySpace back in 2005.
It execute when viewing an infected webpages by posting a message on the victims My space.
The message itself also contained the same JS payload to re-post the pages.
- Types of XSS:

1. Stored(Persistent) XSS --> Tye most critical types of XSS, which occurs whgen user input stored on the back-end type database and the displayed upon retrieval.
2. Reflected(Non-Persistent) XSS --> Occurs when user input is displayed on the page after begin precessd by the backend server, by without stored.
3. DOM-based  XSS --> Another Non-Persistent XSS type occurs when user input is directly when user input a directly shown in the browser and is completely processed on the
client-side, without reaching the backend server.

## Stored XSS:
Before we learn how to discover XSS vulnerabilites and utilize them for various attacks, we must first understand the diffenet types of XSS vulnerabilites and thir differnece to know which to use in each attack.
First the most critical type of XSS vulnerability Stored XSS or Persistent XSS. If our injected XSS payload gest stored in th back-end data and retrieved upon visiting the page, this meand that our Attack is persistent
and may affect any user that visit the page.
This maked this type of XSS the most critical, as the affects a much wider audience since any user who visits the page would be a victim of this attack.
Stored XSS may no be ez removable, and the payload may need removing form the back-end db.
## XSS Testing Payloads:
`<script>alert(window.origin)</script>`
We use this payload as it a very ez-to-spot method to know when our XSS payload has been successfully executed, The page allows any input and does not perform any snitazion on it. The alert should pop up with the URL os the page
it is begin executed on, directly after we input our payload or when refresh the page.
We can see, we did indeed get the alertm which means that the page is vulnerable to XSS, since our payload is executed successfully.
`<div></div><ul class="list-unstyled" id="todo"><ul><script>alert(window.origin)</script></ul></ul>`

> [!TIP]
> Many modern web app utilize cross-domain IFrames to handle user input, so that even if the web form is vulnerable to XSS. it would be  a vulnerabilites on  the main web page.
> This os why are showing the value of window.origin in the alert.box, intead of static value like 1.

As some modern browsers may block the alert() JS funtion in specific locations, it may be handly to know a few other basic XSS payloads to verify the existence of XSS.
Is [<plaintext>] which will stop renderin the Html code that comes after it adn display it aas plaintext. Another ez-to-spot payload ` <script>print()</script> ` that weill pop up the browser print dialog.
Which is unlikely to be blocked by any browser.
To see whether the payload is presistent and stored on th back-end, we can refresh the page and see whether we get the alert again.
We would see that we keep getting the alert even throughout page refreshes, confirming that htis is indeed a [stored/persistent XSS] vulnerabilites.

## Reflected XSS:
There are two types od Non-Persistent XSS vulnerabilites: Reflected XSS, which gets processed by the back-end serve, and DOM-based XSS, which is completely processed on the client-side and never reaches the back-end.
Non-Persistent XSS vulnerabilities are temporary and not are  presistent through page refreshes, our attacks only affect the targeted user and will no affect other user who visit the page.
Reflected XSS vulnerabilities occur when our input reaches the back-end server and gets returned to us without begin filetered or sanitazed. There are many cases in which our entire input might get returned to us,
like error messages or confirmation messages.
We may attempt using payloads to see whether they execute, as these are usually temporary messages, once we move from the page, the would not execute againm and hence they are Non-Persistant.
As we can see, we get TASK 'test' could not be added, which includes our input test as part of the error message, if our input wea not filtered or sanitazed, the page might  be vulnerable to XSS.
`<div></div><ul class="list-unstyled" id="todo"><div style="padding-left:25px">Task '<script>alert(window.origin)</script>' could not be added.</div></ul>`
As we can see, the single quoutes indeed contain our XSS payloads `'<script>alert(window.origin)</script>'.`
If we visit the Reflected page again, the error message no longer appears, and our XSS payload is not executed, which means that this XSS vul is not persistent.
But if we the XSS vulnerability is Non-Persistent, how would we target the victims with it?.

This depends on which HTTP request is used to send our input to the server, we can check this through the Firefox  TOOLS by clicking [CTRL+SHIF+I] and selecting the Network.
As we can see, the first row showes that our request was GET request. GET request sends their parameters and data as part of the URL, [target a user, we can send them a URL containing our payload].
To get URL, we can copy url from the URL bar in Firefox after sending our XSS payload, or we can right-click on the  GET request in the Network tab and select Copy>Copy URL.

## DOM XSS
The third and final type of XSS is another Non-Persistent type called DOM-based XSS. While Reflected XSS sends the input data to the back-end server thorgh HTTP request,
DOM XSS is completely processed on the client-side throuhg JS. DOM XSS occurs when JS is used to change the page source through th Document Object Model[DOM].
We can run the sercer bellow t see a exmaple of a web app vulnerable to DOM XSS. We can try adding a test item, and we see the web app ios similar to the TO-DO list we app:
The network tab in the Firefox Developer Tool, and re-add the test item, we would notice that no HTTP request are begin made;
We can see the input parameter in the URL is using a hashtag # for the item added, which measn that this is a client-side parameter wehat is completely processed on the browser. this indicates that the input
is begin processed ata the client-side through JS and never reaches the back-end it is a [DOM-based XSS].

IF we look at the page source by hitting[CTRL + U], we'll notice that our test string is nowhere to be found. This is cause the JS code is updating the page when we click the ADD button, which is afeter that aoge source is retrieve by our
browser, hence the base page source will not show our input, and if we refreshed the page will not retained.
See the render on the tab inspect.

### Source and Sink
To further understand the nature of the DOM-based XSS vulnerability, we must undestand the concept of the SOurce and Sink of the obj displayed on the page. The source is the JS object
that takes the user input, and it can be any input parameter like URL parameter on an input field as saw.
The SINK is the funtion rhat writes the use input to a DOM Object on the page. Id the Sink funtion does not properly sanitaze the user input, it would be vulenrable to an XSS attack. Some of the commonly JS funtion:
```js
document.write()
DOM.innerHTML
DOM.outerHTML
```
The jquery library fuintions that write to DOM obj are:
```js
add()
after()
append()
```
If a sink funtion writes the exact input without any sanzitazation, and no other means of sanitazion were used, then we know that the page should be vulnerable to XSS.
We can look the source code of th script.js and see the parameter [task=]
```js
var pos = document.URL.indexOf("task=");
var task = document.URL.substring(pos + 5, document.URL.length);

```
And we can use the innerHTML funtion to write the task variable in the dodo DOM:
`document.getElementById("todo").innerHTML = "<b>Next Task:</b> " + decodeURIComponent(task);`

### DOM ATTACK:
If we try the XSS payload we have been using the previusly. This  is cause  the innerHTML funtion does not allow the use of the <script> tag with it as a security featuers.
`<img src="" onerror=alert(window.origin)>`
The above line create a new HTML img, which has a onerror attribute that can execute JS code when the img is not found.

## XSS Discovery:
We should have a good understaning of what an XSS vulnerability is, the three types of XSS, and how each type differs form the others, we should also understand how XSS works throught injection JS code into the client-side page source,
thus executing additional code, whoch we'll later learn how to utilize ro our advantage.
In this section, we will go through varius  ways of detecting XSS vulnebilities within a web app. In web app vulnerbilities, detecting them.
- Automateed Discovery:
Almost all web app vulnerabilities scanner like [NEssus, Burp PRO, or zap] have various capabilities for detecting all three types od XSS vulb.
These scanners usually do two types:
    1. A passive Scan, which review client-side code for potential DOM-based vulnerabilities.
    2. Active scan: Which sends various types of payloads to attempt to trigger an XSS though payload injection in the page source.

While paid tools usually have higher level of accurrancy in detecting XSS vulnerabilities, we can still find open-source tools that can assist us indentifying potential XSS vulnerabilities.
Such tools usually work by identfying input field in web pages, sending variopus types od XSS payloads, and then comparing the rendered  page  source to see if the same payload can be found in it.
Which indicateh a successfully XSS injecton. This will not always accuratee as sometimes, even if the same payload was injected, it might not lead to a successful injection due to various reasons.

Some common open-source tools can asssist  xSS discovery [XSS Strike, Brute XSS and XSServer]
[XSStrike](https://github.com/s0md3v/XSStrike)

As we can see the tool identifies the paramter as vulnerable XSS from the first payload. Try to verify the above payload by testing it on one of the previous exercise. May also try testing out the other tools and run them on the same exercise
to se how capable are in detecting XSS vulnerabilities.

### Manual Discovery:
When ir comes the manual XSS discovery, the diff of finding the XSS vulnerabilility depends on the level of security of the web app, basic XSS vulnerabilities can usually be found through testing various XSS payloads, but identifying advance XSS vulnerabilities
requires advanced code review.
- XSS payloads:
The most basic method of looking for XSS vulnerabilities is manually testing varius XSS payloads against and input in given web pages.
We can find huge lists of XSS payloads, like [PAyloadAllthething](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/XSS%20Injection/README.md)
or [Payloadlist](https://github.com/payloadbox/xss-payload-list), we can then begin testing these payloads one by one copying each one and adding it in our form, and seeing whether and alert box pops up.

> [!NOTE]
> XSS can inject into any input in the HTML page, which is no exclusive to HTML input fields, but may also be in HTTP headers like the Cookie or User-Agent.

Notice that the majority of the above payloads do not work with our example web app, even though we are dealing with the most basic type XSS vulnerabilities, this cause payloads are written for wide variety of injection point or are designed to evade certain security measure.
This is why is not very efficient to resort to manually copying/pastiong XSSm as even if a web app is vulnerable, it takes us a while to identify the vulnerabilility, especially if we have many inputs field test.
This is why it may be more efficient to write our own script to automate sending these payloads and then comparing the page source to see how our payloads were rendered.

- Code review:
The most reliable method of detecting XSS vulnerabilities is manual code review, which should cover both back-end and front-end code. If we undestand  precesiley how our input begin handled all the way until ot reaches the web browser, we can write a custom
payload that should weork with high cofidence.


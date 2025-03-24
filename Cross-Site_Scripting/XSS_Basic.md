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
Non-Persistent XSS vulnerabilities are temporary.

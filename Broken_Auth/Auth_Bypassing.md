# Authentication Bypass via Direct Access:
- Direct access:
The most straighfoward wae of bypassing auth is to request the protected resource directly form an unauthenticated context. An unantheticated attacker can access protected information if the web app
does not properly verify that the request is authenticated.
Let us assume that we know that the web app redirects users to the [admin,php] endpoint after successful auth, providing protected information onlu to auth users, if the web app relies solely on the login
page to auth users, we can access the protected resource directly by accessing the [/admin.php] endpoint.

To ilustrate the vulnerability, let us assume a web app uses the following snippet of PHP code to verify whether user is auth:
```php
if(!$_SESSION['active']){
    header("Location; index.php");
}
```
This code redirects the user to index.php if the session is not active, if the user is no auth, the php script does not stop execution, resulting in protected information within the page begin sent in the response body:
As we can see, teh entire page contained in the response body, if we attempt to access the page in out web browser, the browser follows the redirect and display the login prompt instead of the protected admin page.
We can ez trick the browser into displaying the admin page by intercepting the response and changing the status code form 302 to 200. Enable Intercpt in burp.
Browse to the [admin.php] endpoint in the web browser, on the request and select [DO intercept > Response to this request] ro intercept browser.
As we see the entire admin page is cointained the respose body, if we attempt to access the pafe in out web browser, the browser follows the redirect and display the login prompt instead of the protected admin page. We can ez trick the
browser into displaying the admin page bny intercepting the respose and changing the status code form 302 to 200. To do this, enable intercept in Burp. Browser to the [/admin.php] endpoint in the web browser.
Rigth-click on the request and select Do intercept > Response to this resquest. To prevent the protected information from begin returned in the body of the redirect response, the PHP script needs to exit after issuing the redirect.

```php
if(!$_SESSION['active']) {
	header("Location: index.php");
	exit;
}

```

# Authentication Bypass via Parameter Modification:
This type of vulnerability is closely related to auth issues such as Insecure Direct Object Refernce [IDOR].
- Parameter Modification:
Let us take a look at our target web app, we are provide with credentials htb-stdnt, we redirect [/admin.php?user_id=111].
To investigate purpouse of the user_id parameter, let us remove it from our request /admin.php. We are redirect to the login screen at /index.php, even though our session in the PHPSESSID  cookie still valid:
We can assume that the parameter user_id is related to auth, we can bypass authentication entirely by accessing the URL /admin.php?user_id=111 directly:
Based on the parameter name user_id we can infer the parameter specifies the ID of the user accessing the page, if we can guess or brute-force the user ID if an admin, we might be able to access the page with admin privilege, thus
revealing the admin information. We can use the tech discussed in the brute-force attacks sections to obtain an admin ID, we can obtain admin privilege by specifying the admin's user ID in teh user_id parameter.

Exercise:
1. Create a wordlist of number and after that the use fuzz for locate the id of admin:
```ssh
seq -f "%.0f" 0 100000 > num_wordlist.txt
ffuf -u "http://83.136.252.123:55916/admin.php?user_id=FUZZ" -w num_wordlist.txt -fs 14484 -c

        /'___\  /'___\           /'___\
       /\ \__/ /\ \__/  __  __  /\ \__/
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/
         \ \_\   \ \_\  \ \____/  \ \_\
          \/_/    \/_/   \/___/    \/_/

       v2.1.0-dev
________________________________________________

 :: Method           : GET
 :: URL              : http://83.136.252.123:55916/admin.php?user_id=FUZZ
 :: Wordlist         : FUZZ: /home/Anchovy/num_wordlist.txt
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
 :: Filter           : Response size: 14484
________________________________________________

372                     [Status: 200, Size: 14465, Words: 4165, Lines: 429, Duration: 39ms]
0                       [Status: 302, Size: 0, Words: 1, Lines: 1, Duration: 3312ms]
```


# Attacking Session Tokens:
We focused in abusing flawed implementations of web app auth, vulnerability related to auth can arise not only from the implemetation of the auth itself but also from the handling
of session tokens. Session tokens are unique identifiers a web app uses to identify a user, the session token tied to user session.

- Brute-force attack:
We can brute force a valid session token similary to how we were able to brute-force valid pass-reset tokens, Can happend if a session token is to short to obtain static data
that does not provide randmness to the token.
As we can seen, four-characters string can ez be brute-force. we can use the tech and command all possible session tokens and hijack all active sessions.

This sceenario is relatively uncommon in the real word, the session token is 32 characters long it seems, to enumerate other users valid sessions.
[2c0c58b27c71a2ec5bf2b4b6e892b9f9
2c0c58b27c71a2ec5bf2b4546092b9f9
2c0c58b27c71a2ec5bf2b497f592b9f9
2c0c58b27c71a2ec5bf2b48bcf92b9f9
2c0c58b27c71a2ec5bf2b4735e92b9f9]

As we can see, all session tokens are very similar, 23 are the sma for all five captured session. The session token consists static string 2c0c58b27c71a2ec5bf2b4 followed by for random characters and the
static string 92b9f9. This reduce the randmness of all sessons tokens, 28 out of 32 characters are static, there are 4 characters need to enumerate to brute-force.

- Attacking Predictable Session Tokens:
The simplest form of predictable session tokens cotains encode data we can taper with.
` echo -n dXNlcj1odGItc3RkbnQ7cm9sZT11c2Vy | base64 -d
user=htb-stdnt;role=user`
As we can see the cookie contains information about the user and the role tied to the session, there is no security measures in place that prevents us from tampering with the data. We can forge our own session token  by
manipulating the data and base64-encoding it to match:
`echo -n 'user=htb-stdnt;role=admin' | base64
dXNlcj1odGItc3RkbnQ7cm9sZT1hZG1pbg==`
In hex:
```sh
echo -n 'user=htb-stdnt;role=admin' | xxd -p
757365723d6874622d7374646e743b726f6c653d61646d696e
```

## Futher Session Attacks:
- Session Fixation: is an attack that enables an attackers to obtan victim valid session, a web app vulnerable to session fixation does not assign a new session token after a successful auth.
If an attacker can coerence the victim into using a session token chosen by the attacker, session fixation enables an attacker to steal the victim's session and access their account.
Assume a web app vulnerable to session fixation uses a session token on the HTTP cookie sessio, The web app sets the user's session cookie to a value provide in the sid GET paramter. Under these cirecustances a session fixation attack
could look like this:
1. An attaker obtains a valid session token by ayth to web app, let us assume the session token is a1b2c3d4e5f6. Afterward, the attacker invalidates their session by logging out.
2. The Ataccker tricks the victim to us the know session token by sending the link: http://vulnerable.htb/?sid=a1b2c3d4e5f6. When the victim clicks this link, the web application sets the session cookie to the provided value, i.e., the response looks like this:
3. The victim auth to the vulnerable web app, the victim's browser already stores the attacker-provided session cookie, so it sent alogn with the login request. The victim uses the attacker-provided session token since the web application does not assign a new one.
4. Since the attacker knows the victim's session token a1b2c3d4e5f6, they can hijack the victim's session.

- Improper Session Timeout:
Web application must define a proper [Session Timeout](https://owasp.org/www-community/Session_Timeout) for a session token. After the time interval defined in the session timeout has passed, the session will expire, and the session token is no longer accepted.
If a web application does not define a session timeout, the session token would be valid infinitely, enabling an attacker to use a hijacked session effectively forever.


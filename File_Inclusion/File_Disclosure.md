# Local File Inclusion (LFI):
Now we understand what file Inclusion Vulnerabitilies are and how they occur, we can start learning how we can exploit these Vulnerabitilies in different scenario to be avle to read the coentent of local file
on the back-end server.

- Basic LFI:
The exercise we have at the end of this section shows as a example of web app that allows userers to set their language to either English or Spanish.
We can select the lenguage we see tha content text changes. We also notice that the URL includes language parameter that is now set thte language we selected, there are several ways the
content could be changed to match the language specified.
It may pulling the content form a different database table based on the specified parameter, or it may be loading amn entirely different version of the web app.
If the web app is indeed pulling a file that is now begin included in the pafe, we may be able to change the file begin pulled to read the content of a different local file.
Two common readeable files that are avaliable on most back-end servers are [etc/passwd] on Linux and [C:\Windows\boot.ini] on Windows.

- Path Traversal:
In the erlier example, we read a file by specifying its absolute path. This would work if the whole input was used within the include() funtion whitout any additions.

> include($_GET['language']);
In this case if we try to read [etc/passwd] then the [include()] funtion would fetch that file directly. Web developers may append poor prepend a string to the language parameters. The language parameters may be used for the
filename and may be added after a directory as follow:

> include("./language/", $_GET['language']);
If we attempt to read [etc/passwd], then the path passed to include() would be [./language//etc/passwd] and as this file does not exist we will not be able to read anything.

> [!NOTE]
> We are only enabling PHP errors on the web apps for educational purpouse, se we can properly understand how the web app is handling our input. Fo production web apps, such a errors should never be shown.
We can ez bypass this restictions by traversing directories usin relative paths. We can add ../ before our file name, which refers to the parameter directory.
If the full path the language directory is [/var/www/html/language], then using [../index.php] would refer to the index.php file in teh parameter dir [/var/www/html/index.php].
So we can use the trick to go back several dir until we reach the root path and then specify our absolute file path and file.
This time we were able to read the file regardless of the dir we were in. This trick would work even if thge entire parameter was used in the [include()] funtion, se we can def to this tech. If we were at the root path / and used ../ thenm we woidl stil remain
in the root path.

> [!TIP]
> It can ve useful to be effiecient and not add unnecessary ../ several times, especially if we were writpung a report or writing an exploit. So always tru to find the minimun number of ../ that works and use it. May also be able to calculate how many directories u are
> alway form the root path and use that many.


- File Prefix:
We used the language parameter after the dir, so we could traverse the path to read the passwd. On some occassion, our input may be append after different string. It may be used with a prefix to get the full filename:
> include("lang_" . $_GET['language']);
We try to traverse the dir with ../../../etc/passwd. the final would be [lang_../../etc/passwd], which is invalid:
As expected the error tells us that this file dies not exist, os instead directly using path traversal, we can prefix a / before our payload, and this should consider the prefix as dir, then we should bypass the filename and be able traverse dir.

> [!NOTE]
> This may not always work, any prefix append to our input pmay break some file inclusion teech we will discuss in upcoming sectins, like PP wrappers and filters or RFI.

- Append Extensions:

> include($_GET['language'] . ".php");
This is quite common, we would not have to write the extension every time we need to change the language, may also be safer as it may restict us to only including PHP files. If we try to read /etc/passwd, then file included would be /etc/passwd.php

- Second Order Attacks:
This occurs cause many web apps funtionalities may be insecurely pulling files form athe back-end server based on user-controlled parameter.
A web app may allow us to dowload our avatar throgh a URL like [/profile/$username/avatar.png]. If we craft a malifius LFI usernames then it may be possible to change the file begin pulled to another local file on the server and grab it instead of avatar.
We would be poisoning a db entry with malicius LFI payload in our username, another web funtionality would utilize this poisoned entry to perfom our attack.
Second order Attack.

- Exercise:
1. Using the file inclusion find the name of a user on the system that starts with "b".
`http://94.237.121.185:39293/index.php?language=/../../../../usr/share/flags/flag.txt`
2. Submit the contents of the flag.txt file located in the /usr/share/flags directory.
`http://94.237.121.185:39293/index.php?language=/../../../../etc/passwd`

___

# Basic bypasses:
We saw several types of attacks that we can us for different types of LFI Vulnerabitilies. We may be facing a web app that applies varios protection against
so our notmal LFI payloads would not work, unless the web app is properly secured agains malicius LFI user input, we may be able to bypass the protection in place reach file inclusion.

- Non-Recursive Path Traversal FIlters:
One of the most basic filters against LFI is a search and replace filter, where it simply deletes substrings of [../] to avoid path traversal.

> $language =- str_replace('../', '', $_GET['language']);
The above code is supposed to prevent path traversalm and hence renders LFI useless, if we try the LFI payloads we tried in the prev section:
We see that all ../ substrings were removed, which resulted in a final path beigin ./language/etc/passwd. This filter is very insecure, as it's not recursevely removing the ../ substring, as it runs a songle
on the input string and does not apply the filter on the ourput string. If we use ....// as our payload, then the filter would remove ../ and the output string would be ../ which means we may still perform path traversal.
The inclusion was successfull this time, and we're able to read /etc/passwd successfully. The ....// substring is not the only bypass we can use, as we may use ..././ or ...\/ and serveral other recursive LFI payloads.

- Encoding:
Some web filters may pervent input filters that inclide certain LFI-realted characteres, like a dot . or a slash / used for path traversal. Some of these filters may be bypassed by URL encoding our input, such that it woild not longer
include these bad characteres, but would still be decoded back to our path traversal string once it reaches the vulnerable funtion. Core PHP filters on version 5.3.2 and earlier were specifically vulnerable to this bypass, but even on newer
version we may find custom filters that may be bypassed through URL encoding.
If teh target web app did not allow . and  / our input, we can URL encoded ../ into %2e%2e%2f, which may bypass the filter. We can use any online URL encoder utility or use the Burp decoder tool.

- Approaved Paths:
Some web apps may also use a Regular expression to ensecure that the file begin included is under specfic path. The web apps we have been dealing with may only accept paths that are under the ./language directory.

```php
<?
if(preg_match('/^\.\/languages\/.+$/', $_GET['language'])) {
    include($_GET['language']);
} else {
    echo 'Illegal path specified!';
}
?>
```
To find the approved path, we can examino the requests sent by the existing forms, and see what path they use for normal web funtionality. We can fuzz we dir under the same path, and try different ones util we get the match. We may use path
traversal and start our paylaod with the approved path, and then use ../ to go back to the root and read file we specify:

- Append Extension:
To ensecure that the file we include is the expected extension. With modern version of PHP, we may not be able to bypass this and will restricted to only reading files in that extension, which may still be useful, as we will see in the next section.
There are a couple other tech we may use but they are obsolote with modern version of PHP and only work with PHP version before.
    - Path truncation:
    If a longer string is passed, it will simply be truncated, and any characters after the maximum length will be ignored. Furthermore, PHP also used to remove trailing slashes and single dots in path names, so if we call (/etc/passwd/.) then the /.
    Whenever we reach the 4096 character limitation, the appended extension (.php) would be truncated, and we would have a path without an appended extension. Finally, it is also important to note that we would also need to start the path with a non-existing directory for this technique to work.

An example:

> ?language=non_existing_directory/../../../etc/passwd/./././././ REPEATED ~2048 times]
`echo -n "non_existing_directory/../../../etc/passwd" && for i in {1..2048}; do echo -n "./"; done`

- NULL bytes:
null byte injection, which means that adding a null byte (%00) at the end of the string would terminate the string and not consider anything after it. This is due to how strings are stored in low-level memory, where strings in memory must use a null byte to indicate the end of the string, as seen in Assembly, C, or C++ languages.
To exploit this vulnerability, we can end our payload with a null byte (e.g. /etc/passwd%00), such that the final path passed to include() would be (/etc/passwd%00.php).

- Exercise:
1. The above web application employs more than one filter to avoid LFI exploitation. Try to bypass these filters to read /flag.txt
`http://83.136.251.68:55063/index.php?language=languages///....//....//....//....//flag.txt`

# PHP filters:
Many popular web apps are developed in php, along various custom web apps built with different PHP frameworks, like laravel or symfony. If we identify an LFI vulnerability in PHP web apps, then we can utilize different PHP Wrapppers to be able to extend our LFI Explotattion, and even potentially reach remote code execution.
PHP Wrappers allow us to access different I/O streams at the app level, like standard input/output, file descriptors, and memory streams. This has a lot of uses for PHP developers. As web pentest, we cna utilize these wrappers to extend our explotation attacks and be able to read PHP decelopers.
- Input Filters:
[PHP Filters](https://www.php.net/manual/en/filters.php) are type of PHP wrappers, where we can paas different types and have it filtered by the filter specify. To use PHP streams, we can use the php:// scheme in our string, and we can access the PHP filter weapper with php://filer/.
The filter wrapper has several parameters, but the main ones we requier for our attack are resource and read. The resource parameter is requierd for filter wrapper, and with it can specify the stream we would like to apply the filter on while read parameter can apply different filters on the input resorces.
There are four different types of filters avaliable for use which are [String filetrs](https://www.php.net/manual/en/filters.string.php), [Conversion FIlters](https://www.php.net/manual/en/filters.convert.php), [Copression filters](https://www.php.net/manual/en/filters.compression.php) and [Encryption Filters](https://www.php.net/manual/en/filters.encryption.php).

- Fuzzing for PHP Files:
The first step would be to fuzz for different avaliable PHP pages woth a tool like FUFF or gobuster:
`ffuf -w /opt/useful/seclists/Discovery/Web-Content/directory-list-2.3-small.txt:FUZZ -u http://<SERVER_IP>:<PORT>/FUZZ.php`

> [!TIP]
> Unlike nromal web apps usage, we are not restricted to pages with HTTP reponse code 200, as we have local fle inclusion access, so we should be scanning for ell codes including '301', '302', and '403' pages, and we should be able to read their source code as well.

Even after reading the sources of any identified files we can scan them for other referenced PHP files, and then read those as well, until we able to capture most ofd the web app source or have an accurate ima what it does.

- Standard PHP Inclusion:
Lest try to include the config.php page, as we can see we go empty result in place of our LFI string, since the config most likely onlu sets up the web app configuration and does not render any HTML.
The base64 php filter gets useful, as we can use it to base64 encode the PHP file, and we would get the encode source code instead of having it begin executed and rendered.

> [!NOTE]
The same applies to web apps language other than php, as long as the vulnerable funtion can executed files, we would directly get the source code, and would not need to use extra files/funtions to read source code.

- Source Code Disclosure:
After disclosing their source with the base64 PHP fileter. To read source code of config.php usin the base64 filter, convert.base64-encoded fo the read parameter and config for the resource parameter:
`php://filter/read=convert.base64-encode/resource=config`. We intentionally left the resource file at teh end of our string, as the .php extension is automatically  append to the end of oir input string, specified config.php.

- Exercise:
1. Fuzz the web application for other php scripts, and then read one of the configuration files and submit the database password as the answer
```sh
ffuf -u http://94.237.121.174:51102/FUZZ.php -w Downloads/directory-list-2.3-medium.txt
http://94.237.121.174:51102/index.php?language=php://filter/read=convert.base64-encode/resource=configure

`<?php

if ($_SERVER['REQUEST_METHOD'] == 'GET' && realpath(__FILE__) == realpath($_SERVER['SCRIPT_FILENAME'])) {
  header('HTTP/1.0 403 Forbidden', TRUE, 403);
  die(header('location: /index.php'));
}

$config = array(
  'DB_HOST' => 'db.inlanefreight.local',
  'DB_USERNAME' => 'root',
  'DB_PASSWORD' => 'HTB{n3v3r_$t0r3_pl4!nt3xt_cr3d$}',
  'DB_DATABASE' =
```



# Identyfying Filters:
As we have seen in  previus secction, even if developers attemtp top secure the web app against injections, it may still be exploitable if it was not securely coded.
Another type of injection mitigation is utilizing characters and words on the back-end to detecte injection attempts and deny the request if any request contained them.
Yet another layer on top of this is utilizing we app firrewall, which may a broader scope various methods of injections fetectioon a prevent other attacks like SQL injections
or XSS attacks.

- Filter/WAF detection:
First visiting the web app in the exercise at the end section, we see the same Host Checker web app heve been ecxploiting but now we can  see of we tryu try the previus operatores like[ ;,&&,||]
we get the error message invalid input:
This indicates that somethinbg we sent triggered sa security mechanims in place that denied our request. This errror message can be desplayed in varius ways. We can see it in the filed  where the output
is displauyed, meaning it was detected and prevented by th PHP weeb app itself. IF  the error message desplayed a dff page, with information like our IP oiiur request, this may indicates that it was denied by a WAF.

Other than the IP: we sent:
1. A semi-colom character ;
2. A space character
3. A whoami command
The web app either detected a blacklisted character or detected a blacklisted command, or both. Let us see how bypass.

## Blacklisted character:
A web app may have a liust of blacklisted characters, and if the command contains them, it would deny the request. The PHP code may look something like the following:
```php
<?php
$blacklist = ['&', '|', ';', ...SNIP...];
foreach($blacklist as $characterss){
    if(strops($_POST['ip'], character) != false){
        echo "invalid input"
    }
}
?>
```
- Identify Blackisted characters:
Lets reduce our request to one character at time and see when its get blocked. We know the 127.0.0.1 payload does work so try adding a semicolons.

# Bypassing  Space Filters:
We'll see that the most of the injection operators ar indeed blacklisted. The new-line character is usually not blacklisted, as it may be needed in th payload itself. We know that the new-line charachetr work in appending
our commands both in Linux and Windows, so let try:

Even though our payload did include a new line character, our request was no denien, and we did get the output of the ping command, which means this character is not blacklisted, and we can use it as our injection operator.
- Bypass Blacklisted Spaces:
Now we have a working injection operators, let us modify our original payload and send it again as [127.0.0.1%0a whoami]
We still get an invalid input error message, meaning theat we still have other filter bypass. The space characher is indeed blacklisted as well, a space commonly blacklisted character, eespecially if the input shoul not cotain any spaces
like IP.

- Using tabs:
Tabs [%09] intead of spcases is a tech that may work, as both linux and windows accept commands with tabs between arguments, and they are executed te saem[127.0.0.1%0a%09] and susscesfully bypass the space character filter by using tab instead.

- Using $IFS
Usin Linux eviroment  variable my also work since its def value is a space and a tab, which would work between command arguent, Use [${IFS}] where the spaces should be, the variable should be remplace with spaces.
`127.0.0.1%0a${IFS}`

- Using Brace Expansion:
We ca use Bash Brace expansion ft, which automatically adds spaces between arguements wrapped braces: {ls, -la}

# Bypassing Other Blacklisted character:
Beside injection operators and spaces characters a very commonly blacklisted character is the slash (/) or backslash(\) character, as it's necessary to specify directories in Linux or Windows.
We can utilize several tech to produce any character we want while avoiding the use of blacklisted characters.
- Linux:
There are many techniques we can utilize to have slashes in out payload. One such tech we can use for replaces slashes or any characher in Linux Evirment Variable like we did with ${IFS}. While is directly replaces with a space, there's no such of enviroment
variable for slashes or semi-coloms. These characher may be used in an enviroment variable, and we can specify start and length of our string exactly match this character.
`echo ${PATh}`
So if we start at the 0 chatacher, adn only tale a strin of length 1, we'll end up with only the / character, which we can use in our payload.
`echo ${PATH:0:1} --> / `

> [!NOTE]
> When we use th above command in our payload, we'll not add echo, as wee are only using in this case to show the outputted character.

We can do the same with the $HOME or $PWD enviroment variables as well, We can also use the same concept to get the semi-colon character, to be used as an injection operators.

Lest try to use eviroment variable to add a semi-colon and space to our payload `127.0.0.1${LS_COLORS:10:1}${IFS}` as out payload and see if we can bypass de filter.

- Windows:
The same concept works on Windows as well, CMD windows variable (%HOMEPATH%-> \User\htb-student), and then specify a starting position (~6 -> \htb-student), and finally specifying
a negative and psosition, which in this case is the lenght og the username  htb-student(-11 -> \)
We ca achieve the same variable in Windows PS. We can also use the GET-childItem Env: Powershell command to print all eviroment variables and then pick one of them to produce a character we need.

- Character shifting:
There are other tech to produce the requiered character without using, like shifting characters. The following Linux command shift the character we pass by 1. All we have to do is find the character in the ASCII table.
Exercise:
Use what you learned in this section to find name of the user in the '/home' folder. What user did you find?
`ip=127.0.0.1%0a{ls,${PATH:0:1}home}`

# Bypassing Blacklisted Commands:
There are different methods when it comes to bypassing blacklisted commands, usally consist of a set of words, and we can obfuscate our commands and make them look different, we may be able to bypass the filter.
Varius methods of commands obfuscation that very complexity, as we will touch upon later with command obfuscation tools. We will cover a few basic techniques that may enable us to change to look of our command  to bypass filters manually.
- Commands Blacklist:
We have so farr succcessfully bypassed the character filter for the space and semi-colon character in our payload. Lest us go back to our very first payload and re-add the whoami command to see if gets executed:
We can see even though we used characters that are not blocked by the web app, the request gets blocked again once we added our command. This is likely due to another type of filter, which is command blacklist filter.
A Basic command:
```php
$blacklist = {'whoami', 'cat', ...};
foreach($blacklist as $word){
    if (strpos('$_POST['ip]', $word) !== false){
        echo"invalid input";
    }
}
```
One very common and ez obfuscation technique is inserting  certain characters whitin our command that are usually ignoered by command shell like bash or Powershell and will execute the same command as if they were not ther. Some of these characters
are a single-quote ' and a double-quote " in addition to other.
The ez to use are a quote, and they work on both linux and windows servers. IF we want to obfuscate the whoami command we can insert a single quote between its character:
`w'h'o'am'i` is the same with double-quote `w"h"o"am"i"`
The important things to remember are that we connot mix types of quotes and the number of quotes must be even. We can use that payload `127.0.0.1%0aw'h'o'am'i'`.
- Linux only:
We can insert a few other Linux-only characters in the middle of commands, and the bash shell would ignore them and execute the command. These characters include the backslash \ and the positional parameter character $@. This works exactly as it did with the
quotes, the number of characters do not have to be eve, and we can insert just one of them if we want to:
`who$@ami w\ho\am\i`
- Windows Only:
There are some windows-only characters we can insert in the middle of commands that do not affect the outcome, like a caret(^) as we can see: `wh^ami`

`127.0.0.1%0a{c'a't.${PATH:0:1}home${PATH:0:1}1nj3c70r${PATH:0:1}flag.txt}`

# Advanced COmmand Obfuscation:
In some instances, we may be dealing with advanced filtering solutions, like WAFs, and basic evasion tech mau not necessary work. We can utilize more advanced techniques for such ocassions, which make detection the injected commands mush less likely.
- Case Manipulation:
One command obfuscation technique we can use is case manipulation, like inverting the characher cases of the command or alternating between cases [WhOaMI]. This usually works cause a command blacklist may not check for different case variation of single word, as Linux systems are case-sensitive.
If we are dealing with Windows server we can change of the characters of the command and send it.`WhOaMi`. When it comes to Linux and bash shell, which are-sensitive, as mentioned earlier, we have to get a bit creative and find a command
that turns the command into an all-lowercase word.`$(tr"[A-Z]" "[a-z]"<<<"WhOaMi")`
As we can see the command did work even though the word we provide was whoami. This command tr replace all upper-case characher with lower-case characters, which results in an all lower-case character command. If we try to use the above command iwht the [Host cheker] web app. we'll see that it still
gets blocked:
It's cause the command above contains spaces, which is a filtered characher in our web app, as we have seen before. We must always be sure no to use any filtered charachers.
Replace the space with tabs[%09], we see that the command work perfect.
`127.0.0.1%0a$(tr%09"[A-Z]"%09"[a-z]"<<<"WhOaMi")` $(a="WhOaMi";printf %s "${a,,}")

- Reversed Commands:
Another command obfuscation technique we will discuss is reversing commands and having a command template that switches them back and execute them in real-time. We'll be imaohw intead the whoami to avoid triggering the blacklisted command.
We can get creative with such techniques and create oiur own Linux/Windows commands that eventually execute the comman without ever containg the actual command words.
`echo 'whoami' | rev`.
Then we can execute the original command by reversing it back in a sub-shell($()):
`$(rev<<<'imaohw`
We see theat even though the command does not contain the actual whoami word, it does work the same and provide the expected output. WE can also test this command with our exercise.

> [!TIP]
> If you wanted a characher filter with the above method, you'd have to reverse them as well, or include them when reversing the original command.

Windows:
```sh
-> "whoami"[-1..-20] -join ''
-> iex "$('imaohw'[-1..-20] -join '')"

```

- Encoded Commands:
The final technique we will discuss is helpful for commands containing filtered characters or characters that may be URL-decoded by the server. this may allow for the command to get messed up tge time it reaches thge shell and eventually fails to execute.
Instead of copying an exist command, to get messed up by the time it reaches the shell and eventually fails to execute.
We can try to create our unique obfuscation command, it's mus less likly to be denied by a filter or a WAF.
The command we created will be unique to each case, depending on what charactera are allowed and the level of security on the sever.

Tools for encoding:
- base64
- xxd
`echo -n 'cat /etc/passwd | grep 33' | base64`
And create command for decode the string in sub-shell($()).
`bash<<<$(base64 -d<<<Y2F0IC9ldGMvcGFzc3dkIHwgZ3JlcCAzMw==)`

As we can see the above command executes the command perfectly, we did not include any filtered characters and avoided encoded characters that may lead the command to fail to execute.

> [!TIP]
> Note that we are using <<< to avoid using a pipe |, which is a filtered characters.

Even if some commands were filtered, like bash or base64, we could bypass that filter with the techniques we discussed in the previus section or use other alternative like sh for command
executation and opessl for b64 decoding or xdd for hex decoding.

WIn:`[Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes('whoami'))`
We may also achive the same thing on LINUX, but we wouild have to convert the string form utf-8 to utf-16 before we base64.
`echo -n whoami | iconv -f utf-8 -t utf-16le | base64
dwBoAG8AYQBtAGkA`
We can decode the b64 string and execute it with PS sub-shell [iex"$()"]:
` iex "$([System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String('dwBoAG8AYQBtAGkA')))"`

Exercise:
Find the output of the following command using one of the techniques you learned in this section: find /usr/share/ | grep root | grep mysql | tail -n 1
First terminal encode:
```sh
echo -n "find /usr/share/ | grep root | grep mysql | tail -n 1"| base64
ZmluZCAvdXNyL3NoYXJlLyB8IGdyZXAgcm9vdCB8IGdyZXAgbXlzcWwgfCB0YWlsIC1uIDE=
# After that we can enter in the section with
127.0.0.1%0abash<<<$(base64%09-d<<<ZmluZCAvdXNyL3NoYXJlLyB8IGdyZXAgcm9vdCB8IGdyZXAgbXlzcWwgfCB0YWlsIC1uIDE=)
# Get the directory
/usr/share/mysql/debian_create_root_user.sql
```

# Evasion tools:
If we are daling with advanced security tool, we may not able to use basic manual obfuscation tech. Ti may be the best to resort to automated obfuscation tools.

- Linux BAshfuscator:
A handy tool we can utilize for obfuscation bash commands is [Bashfuscator](https://github.com/Bashfuscator/Bashfuscator).
Once we install the bashfuscator with yay -S bashfuscator-git, we can try to use like this command:
`bashfuscator -c 'cat /etc/passwd'`
Running the tool pick an obfuscation technique, which can output a command length ranging form a few hundred characters to over a million characters.
We can use some flags the help menu to produce a shorter and simpler obfuscation command:
```sh
bashfuscator -c 'cat /etc/passwd' -s 1 -t 1 --no-mangling --layers 1
[+] Mutators used: Token/ForCode
[+] Payload:

${!#} <<< "$(Zv=(a \  w c t \/ d e p s);for xy in 3 0 4 1 5 7 4 3 5 8 0 9 9 2 6;{ printf %s "${Zv[$xy]}";};)"

[+] Payload size: 109 characters

# Then we can outputted command with bash -c to see whether if does execute
bash -c ...
```
We can see that the obsuscated command works, all while looking completely obfuscation, and does not resemble our original command. We may also
notice that the tool utilize many obfuscation tech, including the ones we proviusly discussed and many others.

- Windows
SImilar for windows are the tool [DOSfuscation](https://github.com/danielbohannon/Invoke-DOSfuscation)


# Command injection prevention:
We should now have a solid understading of how comman injection vulnerability occur and how certain mitigations like character and command filters may be bypassing.
- System Commands:
We should always avoid usiong funtions  that execute system commands, especially if we are using input with them. Even when we are not directly inputting user input
into these funtions, a user may be able indirectly influence them, which may eventually lead to command injection vulnerability.

Instead of using system command execution funtions, we should use build funtions to perform  the neeeded funtionality, as back-end languages usually have secure implementation of these types of
funcionalities.
IF we neeed it to execute a system command , and no built-in funtion can be found the same funcionlity, we should never directly use the user input with these funtions but should always
and validate an sanitize the user input on the back-end.

- Input validation:
Using built-in funtions or system command execution funtions, we should always validate and then sanitize the user input. Validation is done to ensure it matches the expected format fo the input, such
that the request is denied it does no match.
Input validation should be done on the front-end and on the back-end.

```php
if (filter_var($_GET['ip'], FILTER_VALIDATE_IP)) {
    // call function
} else {
    // deny request
}
```
```js
if(/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(ip)){
    // call function
}
else{
    // deny request
}
```
- Input Sanitization:
The most critical part for preventing any injection vulnerability is input sanitization, which means removing any non-necessary special characher form the user input.
```php
$ip = preg_replace('/[^A-Za-z0-9.]/', '', $_GET['ip']);

```
As we can see, the above regex only allows aphanumericas charachers and allows a dot characher as required for IPs. Any other charachers will be removed form the string can done with JS.
`var ip = ip.replace(/[^A-Za-z0-9.]/g, '');`
We can use DOMpurify for nodejs:
```js
import DOMPurify from 'dompurify';
var ip = DOMPurify.sanitize(ip);
```

In certain cases, we may want to allow all special charachers then we can use the same [filter_var] funtion we used with input validation, and use th [escapeshellcmd] filter to escape any special characher, so they cannot
cause any injection. In nodejs, we can simply use the escape(ip) fuintion. However, as we have seen in this module, escaping special characters is usually not considered a secure practice, as it can often be bypassed through various techniques.

- Server configuration:
    - Use the web server built-in web app firrewall in addition to an external WAF
    - Abide by the Principle of least privilege [PoLP](https://en.wikipedia.org/wiki/Principle_of_least_privilege) by running the web server as low privileged for user.
    - Prevent certain funtions form being executed by the web server.[PHP disable_functions=system,...]
    - Limit the scope accessible by the web app to its folder [open_basedir = '/var/www/html']
    - Reject doubl-encoded request and non-ASCII charachers in URLs.
    - Avoid the use of sentitive/outdated libraries and modules [PHP CGI]

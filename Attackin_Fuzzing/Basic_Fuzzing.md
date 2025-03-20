# Directory fuzzing:
As we can see the example, the main two options are -w for wordlist and -u for URL, we can assign a wordlist to keyboard to refer to it where we want to fuzz, we can pick
our wordlist and assign the keyword FUUZZ to it adding :FUZZ adter it.
` ffuf -w /opt/useful/seclists/Discovery/Web-Content/directory-list-2.3-small.txt:FUZZ`
Next we eant to be fuzzing for web directories, we can place the FUZZ keyword where the Directory would be within our URL:
`fuf -w <SNIP> -u http://SERVER_IP:PORT/FUZZ`
Final command:
`ffuf -w /opt/useful/seclists/Discovery/Web-Content/directory-list-2.3-small.txt:FUZZ -u http://SERVER_IP:PORT/FUZZ`

We see that ffu tested for almost 90k URls in less than 10 seconds, speed may vary depending ot internet speed and ping.
We can even make it go faster if we are in hurry by increasing the number of thereads to 200, with -t 200 but this is nor recommended, specially when used on the remote site and cause a Denial of service, or
bring down ur internet connection on severe cases.

# Page Fuzzing:
Now undestanding the basic use ffuf through the utilization of wordlist and keywords
> [!NOTE]
> We can spawn the same target from  the previus section for this secion's examples as well.

## Extension Fuzzing:
We found that we has access to /blog, but the Directory returned an empty page, and we cannot manually locate any links or pages. We'll once again utilize web fuzzing to see if
the Directory contains any hidden pages. We must find out types of pages the website like .html, .aspx, .php or something eles.

Once common way to indentify that is by finding the server type through the HTTP reponse headers and guessing the extension. If the server is apache, then may be  .php or was ISS,
then it could be .asp or .aspx and so on. This method is not very practical. So we will again utlize ffuf to fuzz extension, similar to how we fuzzed for directories.
Instead of placing the FUZZ keyword where the directory name would be, we would place it where  extension woulb be .FUZZ, and use wordlist for common extension.
`ffuf -w /opt/useful/seclists/Discovery/Web-Content/web-extensions.txt:FUZZ <SNIP>`
Before we start fuzzing, we must specify which file that extension would be at the edn of, we can always use two wordlist and have unique keyword for each, and then do FUZZ_1 FUZZ_2 to fuzz for both.
The wordlist we chose already contains a dor., we will not hace to add the dot after "Index" in out fuzzing.
Command:
`ffuf -w /opt/useful/seclists/Discovery/Web-Content/web-extensions.txt:FUZZ -u http://SERVER_IP:PORT/blog/indexFUZZ`
We do get a couple of hits, by only .php us response with code 200, we now know that this website runs on PHP start fuzzing for PHP files.

## Pages fuzzing:
We'll now use the same concept of keyword we've uising with ffuf, use .php as the extension, place our FUZZ keyword where filename should be, and use the same wordlist we used for fuzzing dir.
`ffuf -w /opt/useful/seclists/Discovery/Web-Content/directory-list-2.3-small.txt:FUZZ -u http://SERVER_IP:PORT/blog/FUZZ.php`

# Recursive Fuzzing:
We have been fuzzing for directories, then going under these directories, and then fuzzing for files, if we had dozens of directories, each with their own subdirectories and files,
this would take a very long time to complete, to be aple automate this we use Recursive fuzzing.

## Recursive Flags:
Automatically starts another scan under any newly identified directories that may have on their pages untl it has fuzzed the main website and all of its subdirectories.
Some websites may have big 3 tree of sub-direcories, like [/login/user/content/uploads... etc], and this will expand the scanning tree and may take a very long time to scan them all.
This is why it's always advised to specify a depth to our recursive sca, such that it will not scan directories that are deeper, than that depth, Once we fuzz the first directories, we can than pick the most intesting directories
and run another scan to direct our scan better.
In ffuf, we can enable recursive scanning with the -recursion flag, and we  specify th depth the [-recursion-depth] flag. If we specify -recursion-depth 1, it will not only fuzz the main directories and their direct  sub-directories.
If we sub-sub-directories, are identified(like /login/user), it will not fuzz for pages. When using recursion in ffuf, we can specify our extension with -e.php.
Finally, we will also add the flag -v output the full URLs, it may be diff to tell which .php files lies under which directories.
`fuf -w /opt/useful/seclists/Discovery/Web-Content/directory-list-2.3-small.txt:FUZZ -u http://SERVER_IP:PORT/FUZZ -recursion -recursion-depth 1 -e .php -v`



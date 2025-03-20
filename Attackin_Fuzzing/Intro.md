# Introduction:
There are many tools and methods to utilize directory and parameter fuzzing/brute-forcing, We will see the ffuf tool:
- Topics:
    - Fuzzing for directories.
    - Fuzzing for the files and extensions
    - Identifying hidden vhosts
    - Fuzzing for php parameters
    - Fuzzing for parameter values
This tool provide us with a handly automated way to fuzz web app individual component or web page, means we use to send requests to the webserver
if thge page with the name form our list exists on the webserver.

## FUZZING:
The term fuzzing  refers to testing tech that send various types od user input to a certain interfaces to study how ir would react. if we were fuzzing for SQL injection, we would
send random specia characters and seiing how server would react. If we were fuzzing foir a buffer overflow, we would be sending long strigs and incrementiong thair lenght to se is
the binary would break.
We usually utilize pre-define wordlist of commonly used terms for each type od test for web fuzzing to see if the webserver would accept them, this is done cause web servers do no usually
provide a directory of all avaliable links and domains, and so we would have to check for various links and see which ones return pages.
If we visit https://www.hackthebox.eu/doesnotexist, we would get an HTTP code 404 Page Not Found, and see the below page:
<img class="website-screenshot" data-url="https://www.hackthebox.eu/doesnotexist" src="/storage/modules/54/web_fnb_HTB_404.jpg" alt-"404 error page with 'Are you lost?' message and 'Back to Home' butto

### Wordlist
To determinate which pages exists, we should have a wordlist containung commonly used words for web directory and pages, very similar to a [Password Dictionary Attack], which we will discuss later in the module.
Somo of the most commonly used wordlist can be found under Seclist repository.

> [!TIP]
> Taking a look at this wordlist we will notice that it contains copyright commets at the beginning, which can be considered as par od the wordlist and clutter the result, we can use the following ffuf to get
> rid of these lines wuth the [ic flag].


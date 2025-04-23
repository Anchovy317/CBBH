# HYDRA
IS a fastest network login craker that supports numerous attacks protocols, ot versatile tools can brute-force a wide range of service  including
web app, remote services like SSH and FTP. Hydra's popularity stems form its:
1. Speed and efficiency: Hydra utilized parallel connections to perform multiple login attempts simultaneously, significantly speeding up to cracking process.
2s. Flexibility: Hydra supports many protocols and services, making it adaptable to various attacks scenarios.
3. Ease of use: Hydra is relatively ez to use despite its power, with a strainghtfoward command-line interface and clear syntax.

- Installation:
 `hydra -h`
 `sudo pacman -S hydra`

- Basic Usage:
```sh
hydra -h
Hydra v9.5 (c) 2023 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).
Syntax: hydra [[[-l LOGIN|-L FILE] [-p PASS|-P FILE]] | [-C FILE]] [-e nsr] [-o FILE] [-t TASKS] [-M FILE [-T TASKS]] [-w TIME] [-W TIME] [-f] [-s PORT] [-x MIN:MAX:CHARSET] [-c TIME] [-ISOuvVd46] [-m MODULE_OPT] [service://server[:PORT][/OPT]]
```
| Parameter | Explanation | Usage Example |
| ------------- | -------------- | -------------- |
| -l LOGIN or -L FILE| Login options: single user -l file contaning a list username -L | hydra -l admin ... or hydra -L usernames.txt ... |
| -p PASS or -P FILE | Pass options: Provide either a single pass -p or file containg a list of pass -P | hydra -p pass or hydra -P pass.txt|
| -t Tasks  | Define the number of parellel task to run speeding up the attack |hydra -t 4 |
| -f| fast mode: stop attack after the first successful login is found | hydra -f ... |
| -s PORT| Speciallya non-def port for the target service| hydra -s 2222 |
| -v o -V |Verbose output: Display detailed information about the attack progeress | hydra -v or hydra -V |
| service:// server |Sepecify the services[ssh, http, ftp] and target server's addr or hostname | hydra ssh://ip |
| /OPT |Service-specfic options: provide any additional options required by the target services |hydra http-get://example.com/login.php -m "POST:user=^USER^&pass=^PASS^"  |

- Hydra Services:
Essentially defines the specific protocols or services that hydra can target, they enable hydra to interact with different auth mechanisms used by systems, apps, and network system.
Each module is designed to undestand a particular protocol's comunications patterns and auth requiremets, allowing Hydra to send appropiate login request and interpret the response used services:

| Hydra services |Service/Protocol | Description | Example Command |
| --------------- | --------------- | --------------- | --------------- |
| FTP| File transfer ftp | Used to brute force login credentials for FTP services, files over transfer |  hydra -l admin -P /passwd_list.txt ftp://ip |
| SSH | Secure Shell | Targets servives to brute credentials, commonly used for secure remote logins systems | hydra -l root -P /passwd_list.txt ssh://ip |
| HTTP-get/post |HTTP web Service | Used to brute-force login credentials for http web login creadentials for http web login forms using GET or POST | hydra -l admin -P /passwd_list.txt http-post-form "/login.php:user=^USER^&pass=^PASS^:F=incorrect" |
| smtp | Simple Mail transfer Protocol | Attacks email servers by brute-forcing login credentials for smtp to senf mails | hydra -l admin -P /passwd_list.txt smtp://mail.sercer.com |
| Pop3 | Post office protocol |Targets email retrieval services to brute-force creadentials | hydra -l user@example.com -P /passwd_list.txt pop3://mail.server |
| imap|Internet Message Access Protocol |Used to brute-force credentials for IMap services, which allow users to access their mail remotely | hydra -l user@example.com -P passwd_list.txt imap://ip |
| mysql| Mysql database |Attemps to bryte force login credentials to Mysql db | hydra -l root -P /passwd_list.txt msql://1p|
| mssql|Micrsoft SQL Server |Targets Micrsoft SQL servers to brute-force db login creadentials| hydra -l root -P /passwd_list.txt mssql://ip |
| vnc| Virtial network Computing VNC | brute-force VNC services, used for remote desktop access | hydra -P /passwd_list.txt vnc://ip |
| rdp |Remote desktop Protocol RDP |Targets Micrsoft RDP services for remote login brute-forcing | hydra -l admin -P /passwd_list.txt rdp://ip |


- Brute-Forcing HTTP Authentication:
Imagine u're tasked with testing the security of a website using basic HTTP auth at www.example.com. U have a list of potential usernames stored in [username.txt] and corresponding pass in pass.txt.
`hydra -L username.txt -P password.txt www.example.com http-get`
This command instructs hydra to:
- Use the list of usernames form the usernames.txt file.
- Use the list of password form the password.txt file.
- Target the web example.com
- Employ the http-get module to test the http auth.

## Targeting multiple SSH servers:
Consider a situation where u have identified several servers that may be vulnerable to SSH brute-force attacks, compile their IP addr into a file named targets.txt and know thaht these
sercers might use the def username 'root' asn pass 'toor'. To efficiency test all these servers simultaneously:
`hydra -l root -p toor -M targets.txt ssh`

This command instructs hydra to:
- Use the username 'root'.
- Use te password 'toor'.
- Target all IP address listed in the targets.txt file.
- Employ the ssh module for the attacks.

- Testing FTP credentials on a Non-Standard Port:
#Image you need to assess the security of an FTP server hosted at [fpt.example.com] which operates on a Non-Standard port 2121, have list of potential usernames and pass
stored in userames.txt and password.txt, respectively. To test these creadentials against the FTP services:
`hydra -L username.txt -P password.txt -s 2121 -V ftp.example.com ftp`
This coomadn isntructs hydra to:
- Use th list of username from the [username.txt] file.
- Use the list of password form the [password.txt] file.
- Target the FTP service on ftp.exmaple.com via port 2121.
- Use the ftp module and procvide verbose output -V for detailed for detailed monitoring.


## Brute-Forcing a web login form:
Suppose u're tasked with brute-forcing a login form on a web app at www.example.com. Ypu know the username is 'admin' and the form parameters for the login are
[user=^USER^&pass=^PASS^] command:
`hydra -l admin -P password.txt www.example.com http-post-form "/login:user=^USER^&pass=^PASS^:S=302"`

This command instruct hydra to:
- Username 'admin'.
- Use th list of pass form the password.txt file.
- Target the login form at /login on www.example.com.
- Employ the http-post-form module with the specified form parameters.
- Look for a successful login indicated by th http status code 302.

- Advanced RDP Brute-Forcing:
Imagein u're testing a Remote Desktop RDP service on a server with ip. Suspect the user is 'administrator', and that the pass consist of 6 to 8 characters, including letters, uppercase letters,
and number.
`hydra -l administrator -x 6:8:abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 192.168.1.100 rdp`

This command instruct:
- Username 'administrator'
- Generate and test pass ranging from 6 to 8 characters, using the specified characters set.
- Target the RDP service on the ip.
- Employ the rdp module for the attack.

# Basic  HTTP Auth:
Web app often employ auth mechanism to protect sensitive data and funtionalities, http auth or simply basic auth, is rudimetrary yet common method for securign resources on the web.
Though ez to implement, its inherent security vulnerablilities make it frequent for brute-forcing.
Basic Auth is challenge-response protocol where a web server demands user credentials before grating access to protected resources. The process begins when a user attemps to access resticted area. The servers responds
with a 401 Unathorized status and a WWW-Authenticate header promting the user's browser to present a login dialog.

Once the user provides their username and pass, the browser concatenates them into a single string, separated by a colon. This sting is the encoded using Base64 and included in the Auth header of subsquent requests, following
the format [BAsic <encoded_credentials> ]. The server decodes the credentials, verifies them agaist its db, and grants or denies access acocordingly.
```http
GET /protected_resource HTTP/1.1
Host: www.example.com
Authorization: Basic YWxpY2U6c2VjcmV0MTIz
```
- Exploting Basic Auth with Hydra:
Start the target system via the the question section at the bottom of the page.
We will use the http-get hydra services to brute-force the basic auth target. In this scenario, the spawned target instance employs Basic HTTP Auth. We already know the username is basic-auth-user. Since we know the username, we can simplify
the hydra command and focus solely on brute-forcing the pass.
```sh
curl -s -O https://git.selfmade.ninja/zer0sec/SecLists/-/raw/eee1651de7906112719066540ca2c5bf688cf9f2/Passwords/2023-200_most_used_passwords.txt
# Then hydra commnand
hydra -l basic-auth-user -P 2023-200_most_used_passwords.txt 127.0.0.1 http-get / -s 81
```

Break down the command:
- [-l] basic-auth-user: Specifies that the username for the login attempt is 'basic-auth-user'.
- [-P] 2023-200_most_used_passwords.txt: List for brute-forcing.
- 127.0.0.1: IP of the local machine.
- http-get /: this tells hydra that the target service is an HTTP server and the attack should be performed using HTTP get request.
- [-s] 81: This overrides the def port for the HTTP services and sets it to 81.

Exercise:
`hydra -l basic-auth-user -P 2023-200_most_used_passwords.txt 83.136.251.68 http-get / -s 55070`


# Login Forms:
Beyond the realm of Basic HTTP Auth, many web app employ custom login from as their primary auth mechanism, While visually diverse, often share common underlying
mechanics that makes them targets for brute forcing.
- Understanding Login Form:
Login forms may appear as simple solociting ur username and pass, they represent a complex inerplay of client-side and server-side tech. Login form are essentially HTML
forms embedded within a webpage. These forms typically include inlut fields (<input>) for capturing the username and pass, along with a submit buttom to initiate the auth process.

## Basic Login Form Example:
Most login form follow a similar structuere. Example:
```xml
<form action="/login" method="post">
  <label for="username">Username:</label>
  <input type="text" id="username" name="username"><br><br>
  <label for="password">Password:</label>
  <input type="password" id="password" name="password"><br><br>
  <input type="submit" value="Submit">
</form>
```
This form when submitted, sends a POST request to the /login endpoint on the server, incluiding the entered username and pass as form data.
```xml
POST /login HTTP/1.1
Host: www.example.com
Content-Type: application/x-www-form-urlencoded
Content-Length: 29

username=john&password=secret123
```
- The POST method indicates that data is being sent to the server to create or update a resources.
- /login is the url endpoint handling the login request.
- The Content-Type header specifies how the data is encoded in the request body.
- The Content-Length header indicates the size of the data begin sent.
- The request body contains the user and pass, encoded as key-value pairs.

When a user interacts with a login form, their browser handles the initial processing. The browser captures the entered credentials, often employing JS for client-side
validation or input sanitazation. Submission, the browser construct an HTTP POST request, this request encapsulates the form data- including the user and pass, within it body,
often encoded as [application/x-www-form-urlencoded or multipart/form-data.]

## http-post-form:
Hydra's http-post-form services is spcifically designed to target login forms, It enables the automation of POST requests, dynamically inserting username and pass combinations into the
request body. Leveragging capabilities, attackers can effeciently test numerous credentials  combinations agains a login form, potentially uncovering valid logins.
The general structure of a Hydra command using http-post-form looks like this:
`hydra [options] target http-post-form "path:params:condition_string"`

- Understanding the condition string:
Sccess and failure conditions are crucial for properly identifying calid and invalid login attempts. Primary relies on falure conditions [F= ...] to determinate when a login attempt has login,
attempt has failed, but you can also spcify a success conditions (S=...) to indicate when a login successful.

The failure condition(F=...) is used to check for a specific string in the server's response the signals a failed login attempt. This is the most common approach cause many websites returns an error mesage, when
the login fails. If a login formn returns the message 'invalid credentials' on a failed attempts, u can configure hydra like:
`hydra ... http-post-form "/login:user=^USER^&pass=^PASS^:F=Invalid credentials"`

In this case hydra will check each response for the string [invalid credentials] it finds this pharse, it'll marks the login attempt as a failure and move on the next username/password pair.
This approach is  commonly used cause failure message are usually ez to identify.
Sometimes u may not have a clear fail message but instead have a distict success conditions, If the app redirects the user after a successful login(HTTP status code 302), or display
spcific content, can configure hydra to look for that success condition using S=.
[hydra ... http-post-form "/login:user=^USER^&pass=^PASS^:S=302"]
In this case hydra returns an HTTP 302 status code a successful login. Is a successful login in content like 'Dashboard' appering on the page, u can configure hydra to look for that keyword as success conditions:
`hydra ... http-post-form "/login:user=^USER^&pass=^PASS^:S=Dashboard"`
Hydra will now register the login as successful if it finds the word 'Dashboard' in the server response.

- Manual Inspection:
Accessing the IP:PORT, the basic login form is presenbt. Using browser's developer tools, u can view the underlying HTML code for this form. Components:
```xml
<form method="POST">
    <h2>Login</h2>
    <label for="username">Username:</label>
    <input type="text" id="username" name="username">
    <label for="password">Password:</label>
    <input type="password" id="password" name="password">
    <input type="submit" value="Login">
</form>

```

The HTML revela a simple login form:
- Method: POST - Hydra will need to sent POST request to the server.
- Fields:
    - Username: The input field named username will be targeted.
    - Password: The input field names password will be targeted.

## Browser developer tools:
Inspecting the form, browser dev tools and navigate to the 'network' tab. Submit a sample login attempt with any credentials. this will allow u to see the POST request sent to the server, In the network tabs, find
the request corresponding to the form submission and check th form data, headers, and the server's response.
This information definitive confirmation of both the target path (/) and the parameters names.
- Proxy interception:
More complex scenarios, interceptiong the network traffic with a proxy tool like burp or zap can be invaluable. Configure ur browser to route its traffic though the proxy interact with the
login form. The proxy will capture the POST request, allowing u to dissect it every component, including the precise parameter and values.
    - Form parameters: These are teh essential fields that hold the username and pass. Replace placeholdsers within these parameters with values from ur wordlist.
    - Additional FIleds: If the form includes other hidden fields or tokens, they must alos be included in the parms string, thse can have values or dynamic placeholders if their values change with each request.
    - Success Conditions: This defines the criteria Hydra will identify a successful login. HTTP status code [302] it the presence or absence of specific text in the server's response.
Let's apply this to our scenarios discovered:
- The form submits data to the root path (/).
- The username field is named username.
- The password field is name password.
- Invalid credentials is displayed upon failed login.

The params string would be:
[/:username=^USER^&password=^PASS^:F=Invalid credentials]

- / the path where the form is submitted.
- username=^USER^&password=^PASS^: The form parameters with placeholders for Hydra.
- F=Invalid credentials: the failure condition hydra will consider a login attempt unsuccessful if it sees this string in the response.
We will be using top-usernames-shortlist.txt for the username list, and 2023-200_most_used_passwords.txt for the password list.

This params string is incoparated into the hydra command as follow. Hydra will systematically substitute ^USER^ and ^PASS^ with values from your wordlists, sending POST requests to the target and analyzing the responses for the specified failure condition.
```sh
# First dowload the worlist
curl -s -O https://raw.githubusercontent.com/danielmiessler/SecLists/refs/heads/master/Usernames/top-usernames-shortlist.txt
 hydra -L top-usernames-shortlist.txt -P 2023-200_most_used_passwords.txt -f 94.237.53.203 -s 37078 http-post-form "/:username=^USER^&password=^PASS^:F=Invalid credentials"
```
The crafting the correct parms string is crucial for a successful hydra attack. Accurate information about the form's structure and behavior is essential for contructing this string
effeciently.

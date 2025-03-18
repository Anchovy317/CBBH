# Fingerprinting:

Focused on extracting technical about the tech powering website or web app, similar to how a Fingerprintint unquely identifies a person, the digital seginature  of web servers,
operational system, and sofware components can reveal critical information about a target's infraestructure and potential security weaknesses.
This knowledge empowers attackers to tailor attacks and exploit vulnerabilities specific to indetified tech.
Fingerprinting serves as a cornerstone of web reconnaissance for several reasons:
- Target Attacks: By knowing the specific tech in use, attackers can focus their efforts on exploits and vulnerabilities that are knows to affect those systems.
This signigicantly increases the chances of successful compromise.
- Identifying Misconfiguration: Fingerprinting can expose Misconfiguration or outdated sofware, def settings, or other weaknesses that might no be apparent through other reconnaisace methods.
- Prioritising targets:  when faced with multiple potential targets, Fingerprinting helps Prioritise efforts by Identifying systems more likely to be vulnerable or hold valuable information.
- Building a Comprehsive Profile: Combining Fingerprint data with other reconnaissance finding creates a holistic view of the targets infraetructure, aiding in undestanding its overall
security posture an potential attack vectors.

## Fingerprinting Teachniques:
- Banner Grabbing: Involves analysing the banner presented by web servrs and other services, these banners often reveal the server softwart, version number and other details.
- Analysing HTTP header: Transmited with every web page request and response contain a wealth of infromation. The server header typically dicloses the web server sofwatre, while[X-powerred-By] header
might reveal additional tech like scriptiong languages or frameworks.
- Probing for Specific Response: Sending specially  crafted request to the target can elicit unique response that reveal specific tech or versions.
- Analysing Page Content: Including its structure, script, and other elemets, can often provide clues about undelying tech, there may be a copyright header that indicates
specific sofware begin used.

- TOOLS:
    - Wappalyzer: Browser extension and online service tech profilling.
    - BuiltWIth: Web tech profiler that provides detailed reports on a website's tech stacks.
    - WhatWeb: Comman-line tool for website Fingerprinting.
    - Nmap: Versatile network scanner can be used for varius reconnaissance tasks.
    - Netcraft: Offers a range of web security services, Including website Fingerprinting and security recpoting.    - wafw00f: Comman-line tool specifically designed for indetifying web app firewall.


### Fingerprinting inlanefreight.com
- Banner grabbling: We can use the curl -I .... flag or --head to fetch only the HTTP headers.
```sh
curl -I inlanefreight.com
HTTP/1.1 301 Moved Permanently
Date: Tue, 18 Mar 2025 09:00:57 GMT
Server: Apache/2.4.41 (Ubuntu)
Location: https://inlanefreight.com/
Content-Type: text/html; charset=iso-8859-1
```
Is running apache 2.4.41 specifically the Ubuntu version. This information is our first cluem hiting at the undelying tech stack.
```sh
curl -I https://www.inlanefreight.com
HTTP/1.1 200 OK
Date: Tue, 18 Mar 2025 09:02:38 GMT
Server: Apache/2.4.41 (Ubuntu)
Link: <https://www.inlanefreight.com/index.php/wp-json/>; rel="https://api.w.org/"
Link: <https://www.inlanefreight.com/index.php/wp-json/wp/v2/pages/7>; rel="alternate"; type="application/json"
Link: <https://www.inlanefreight.com/>; rel=shortlink
Content-Type: text/html; charset=UTF-8
```
We can see the interesting path contains wp-json, wp- prefix common to Wordpress.

### wafw00f:
Web app firewalls are security solutions designed to protect web app form various attaks, before preceeding th futher Fingerprinting.
```sh
❯ wafw00f inlanefreight.com
                   ______
                  /      \
                 (  Woof! )
                  \  ____/                      )
                  ,,                           ) (_
             .-. -    _______                 ( |__|
            ()``; |==|_______)                .)|__|
            / ('        /|\                  (  |__|
        (  /  )        / | \                  . |__|
         \(_)_))      /  |  \                   |__|
                    ~ WAFW00F : v2.3.1 ~
    The Web Application Firewall Fingerprinting Toolkit

[*] Checking https://inlanefreight.com
[+] The site https://inlanefreight.com is behind Wordfence (Defiant) WAF.
[~] Number of requests: 2

```
Reveals that the website is protected by th Wordfence Web app firewall development by Defiant. This means the site has an additional security layer that could block or filter our reconnaissance attempts.
In real scenario it would be crucial to keep this in mind as u procced with further investigation. as u might nee to adapt tech to bypassing or evede the WAF's detection machine.

## Nikto
Is a powerful open-source web servers scanner, to its primary funtion as a vulnerability assesment tool, Nikto's fingerprinting capabilities provide insights into a website tech stack.
```sh
nikto -h inlanefreight.com -Tuning b
- Nikto v2.5.0
---------------------------------------------------------------------------
+ Multiple IPs found: 134.209.24.248, 2a03:b0c0:1:e0::32c:b001
+ Target IP:          134.209.24.248
+ Target Hostname:    inlanefreight.com
+ Target Port:        80
+ Start Time:         2025-03-18 10:12:36 (GMT1)
---------------------------------------------------------------------------
+ Server: Apache/2.4.41 (Ubuntu)
+ /: The anti-clickjacking X-Frame-Options header is not present. See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options
+ /: The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type. See: https://www.netsparker.com/web-vulnerability-scanner/vulnerabilities/missing-content-type-header/
+ Root page / redirects to: https://inlanefreight.com/
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ Apache/2.4.41 appears to be outdated (current is at least 2.4.57). Apache 2.2.34 is the EOL for the 2.x branch.
+ 1204 requests: 0 error(s) and 3 item(s) reported on remote host
+ End Time:           2025-03-18 10:13:29 (GMT1) (53 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
```
[-h] flah specifies the target host, the -Tuning b flag tells Nikto to only run the sofware identification modules.
The reconnaissance scan on  inlanefreight.com reveal several key finding:
- IPS: te web resolves to both IPv4 ad IPv6 addr [134.209.24.248, 2a03:b0c0:1:e0::32c:b001]
- Server Tech: the website runs on Apache/2.4.41
- Wordpress Presence: the scan identified a Wordpress installation, including the login page. This suggests the site might be a potential target for common Wordpress related exploits.
- Information Disclousere: The presence of a licence.txt file could reveal additional details about the website's sofware.
- Headers Several Non-standatd or insecure headers were found, including a missing [Strict-Transport-Secutiry Header] and header and potentially insecure [x-redirect-by] header.




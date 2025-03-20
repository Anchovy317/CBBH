# DNS records:
Once we accessed the page under [/blog] we got message saying [Admin panel move to academty.htb]. If we visit, we get [can't connect to the server at www.academy.htb].
This is cause the exercise we do are not public website that can be accessed y anyone but local website within HTB. Browsers only understand how to go the IPs, and if we thgem with a URL, they try to map the URL
to an IP by looking into the local /etc/hosts file and the public DNS Domain Name System. If the URL is no in either, it would not know how to connect to it.
If we visit IP directly, the browser goes to that IP directly and knows how to connect to it. By in this case, we tell to go the [academy.htb] do it looks into the [/etc/hosts] file and doesn't find any mention
of it. It ask the public DNS about it and does not find any mention of it, since it's not a public website, and eventially fails to connect.
`sudo sh -c 'echo "SERVER_IP  academy.htb" >> /etc/hosts'`

We get the same website we got when we visit the IP directly, so academy.htb is the same domain we have been testing so far, can verify that by visiting /blog/index.php, ans se we can access the page.
If dont find anything about admin or panels, even when we did a full recursive scan on our target. We start looking for sub-domain under *,academy.htb and see if we find anything, which is what we will attempt in the next section.

# Sub-domain fuzzing:
A sub-domain is any website underlysing another domain, photos.google.com is the photos sub-domain of google.com.
In this case, we are simplu checking different website to see if they exist by checking if they have a public DNS record that would redirect us to working server IP.
- wordilist
- Target

In the seclists repo, there is a specific section for subdomain wordlist, consisting of common words usually used for subdomains, we can find it in [/opt/../../DNS].
` ffuf -w /opt/useful/seclists/Discovery/DNS/subdomains-top1million-5000.txt:FUZZ -u https://FUZZ.inlanefreight.com/`
`ffuf -w /opt/useful/seclists/Discovery/DNS/subdomains-top1million-5000.txt:FUZZ -u http://FUZZ.academy.htb/`

In tthe academy.htb dont have anything this means that there are no public sub-domain under academy.htb, as it does not have public DNS record, as previously mentioned. Even through we did wadd academy.htb to our /etc/hosts file,
we only added main domain, so when ffuf is looking for other subdomains, it will not find them in  /etc/hosts, and will ask the public DNS which obviously will not have them.

# VHost fuzzing:
As we saw in the previous sections, we were able to fuzz public  sub-domain using public DNS records, when it came to fuzzing sub-domain that do no have public DNS record or subdomain under website that are not, public, we could  not use
the same method.

## VHost bs subdomains
The key diff between VHost and subdomin is that VHOST is bascally a 'sub-domain' served on the same server and has the smae IP, such that a single IP coul be serving two or more different websites.
[VHOST may or may not have public DNS record].

IN may cases, many webs would actually have sub-domain that are not public and will not publish them in public DNS recods, and hence if we visit them inb a browser, we would fail to connect, as the public DNS would not know their IP.
We use the sub-domain fuzzing, we would only be able to identify public sub-domain  but will not identify any subdomin that are not pub.
This is where we utlize [Vhost fuzzing] on a IP we already have.

Flag: -H "Host:FUZZ.xxx.xxx"

## Filetering Results:
We have not using any filetering our ffuf, and the result are automatically filetered by default by their HTTP code, which filters out code 404 NOT FOUND, and keeps the rest.
Fuff provides the option or filter out specific HTTP code, responds size, or amount of words.
```sh
MATCHER OPTIONS:
  -mc              Match HTTP status codes, or "all" for everything. (default: 200,204,301,302,307,401,403)
  -ml              Match amount of lines in response
  -mr              Match regexp
  -ms              Match HTTP response size
  -mw              Match amount of words in response

FILTER OPTIONS:
  -fc              Filter HTTP status codes from response. Comma separated list of codes and ranges
  -fl              Filter by amount of lines in response. Comma separated list of line counts and ranges
  -fr              Filter regexp
  -fs              Filter HTTP response size. Comma separated list of sizes and ranges
  -fw              Filter by amount of words in response. Comma separated list of word counts and ranges

```
In this case, we cannot use matching as we don't know what the respose size from other VHOST would be, we know the response size of the incorrect result, which as seen form the test above is 900, and we can filter it out with -fs 900.
`ffuf -w /opt/useful/seclists/Discovery/DNS/subdomains-top1million-5000.txt:FUZZ -u http://academy.htb:PORT/ -H 'Host: FUZZ.academy.htb' -fs 900`

Dont forget add 'admin.academy.htb' on /etc/hosts.
If ur exercise has been restarted, ensure u still have the correct port when visiting the website.


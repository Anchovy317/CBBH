# DNS:
The Domain NAme System(DNS) acts as the internet's GPS, guilding ur online journey from memorable landmasks(domain names) to precise numerical coordinates (IP).
Much like how GPS translates a destination name into latitude and longitude for navigation, DNS translate human-readeable domain names.
Imagine navigating a city by the exact latitude of every location u want to visit, it would be incredibly cumbersome and inefficient.

## How DNS Works:
Imagine u want visit a website like www.example.com.
1. Your computer ask for Directory(DNS Query): When u enter the domain name, ur pc first checks its memory to see if the IP addr form a previus visit. if not, it reseaches out to a
DNS resolver, usually provided by ur sevice provider(ISP).

2. The DNS resolver checks it man (Recursive lookup): The resolver also has a cache, and id doesn't find the IP addr there, it starts a jounrey through the DNS hireachy. Its begins by asking
a root name server, which is like the librairian of the internet.

3. Root Name Server Points the Way: The root server doesn't know the exact addr by know who does- the top level domain (TLS) name server responsable for
the domain's ending it points the resolve in the right direction.
4. TLD Name Server Narrws It Down: The TLD name serve is like a reginal map, it knows which auth name server is resposible for the specif doamin ur are looking for and sends rhe resolver there.
5.  Authoritative Name Server Delivers the addr: The Authoritative name server is the final stop. it's like the street addr of the website u want, it holds the correct IP addr an sends it back to resolve.
6. The DNS resolver returns the info: the resolver the Ip addr gives it to ur pc, it also remembers it for a while in case u want to revisit the website soon.
7. Ur PC connects: Now that ur pc know the IP addr, it can connect directly to the web server hosting the website, an can start browsing.

## THE hosting site:
The host file is a simple text file used to map hostname to ip addr, providing a manual method of domain name resolution that bypassing the DNS process, while DNS automatees the transition of domain names to ip
addr, the host file allows for direct, local overrides.
The hosts file locates [C:\\Windows\System32\drivers\etc\hosts] and in linux [etc/hosts].

- Common usus includes redirecting a domain to a local server for development:
`127.0.0.1 myapp.local`
- Testing conectivity by specifying an IP addr:
`192.168.1.20 testserver.local`
- Blocking unwanted website by redirecting their domains to a non existents IP:
`0.0.0.0 unwanted.site.com`

## It's like replay race:
Dns Porcess  as a replay race, pc starts with the domain name and passes it along to the resolver, the resolver then passes the request tot he root server, TLD server, and finally, the auth serverm each one getting
closer to the destinantion,

## Key DNS Concept:

In the Domian Name system, a zone is distint part of the doamin namespace that a specific entity or admin manages, As a virtual container for a set od domain names.
The zone file, a text residing on DNS server, defines the reources records within this zone, providin crucial information for translating domain names into IP.
```sh
$TTL 3600 ; Default Time-To-Live (1 hour)
@       IN SOA   ns1.example.com. admin.example.com. (
                2024060401 ; Serial number (YYYYMMDDNN)
                3600       ; Refresh interval
                900        ; Retry interval
                604800     ; Expire time
                86400 )    ; Minimum TTL

@       IN NS    ns1.example.com.
@       IN NS    ns2.example.com.
@       IN MX 10 mail.example.com.
www     IN A     192.0.2.1
mail    IN A     198.51.100.1
ftp     IN CNAME www.example.com.

```

This file defines auth name server[NS record], mail[MX], and Ip(A record) for various hosts. DNS servers store varius resources records, eahc serving a specific purpouse in the domain name resolutin process:
Concepts:
| DNS COncept | Description| Example |
| --------------- | --------------- | --------------- |
|  Domain Name | A human-readable label dor a web or other internet rources   | www.example.com |
|   IP address | A unique numerical id to each device connected to the internet   | 192.0.0.1  |
| DNS resolver  | A server that translate domain names into IP  | DNS server or pub resolver like Google DNS   |
| Root Name Server  | Top-level server in the DNS hireachy  | 13 servers worldwide[a.root-servers.net]   |
| TLD Name Server   | Servers responsible for specific Top-level domain  | Verisign for .com, PIR for .org  |
| Auth name Server  | Server that holds the acual IP addr for domain  | Often Hosting provides or doamain reguistrars  |
| DNS record types|Dff types of information stored in DNS| A, AAAA, CNAME, MX, NS, TXT, etc.|

Fundamental concepts of DNS,  into the building blocks of DNS information0- varius record types, these records associted with domain names each serving a specific purpouse:

| Record type | Full name |Description| Zone File Examples|
| --------------- | --------------- | --------------- | --------------- |
| A  | Addr record  | Maps a hostname to it Ipv4 addr  | www.example.com in a 192.0.2.1|
| AAAA|IPv6 addr record|Maps a hostname to IPv6 addr| 	www.example.com. IN AAAA 2001:db8:85a3::8a2e:370:7334|
| CNAME| Conocial Name record| Create a alias for a hostname, pointing to another host| blog.example.com. IN CNAME webserver.example.net.|
|MX |Mail Exchange Record |Specific the mail servers resposible for handling email for the domain |example.com. IN MX 10 mail.example.com. |
|NS |Name server record |Delegates a DNS zone to specific Authoritative name server |example.com. IN NS ns1.example.com. |
|TXT |Text record| Text record Stores arbitrary text information, often used for domain verification or security policies | example.com. IN TXT "v=spf1 mx -all" (SPF record)|
|SOA |Start of authority record |Specificies admin information about  a DNS zone, including the primary name  server, resposible person's emailm adn other parameter | example.com. IN SOA ns1.example.com. admin.example.com. 2024060301 10800 3600 604800 86400 |
| SRV|Service Record |Defines the host and port number for specific services | _sip._udp.example.com. IN SRV 10 5 5060 sipserver.example.com.|
|PTR |Pointer record |Used for reverse DNS lookups, mapping an IP addr to a host |1.2.0.192.in-addr.arpa. IN PTR www.example.com. |

The [IN] in  the examples stands for internet, tis class in DNS records thats specifes the protocol family, most cases y'll see "IN" as the denotes the internet protocol suites
used for most domain names.
Is essence, [IN] is simply a convention that indicates that record applies to the standard internet protocols we use today.

## Why DNS MAtters for Web Recon:
DNS is not merely a tech protocol for translation domain names; it's critical  component of a target's infraestructure that can be leveranged to uncover vulb and gain access  during pentests.
1. Unvcovering Assents: DNS records can reveal wealth of information, including subdomains, mail servers, and name records. A CNAME record point
to a oudate server [dev.example.com CNAME oldserver.example.net] could lead to vulnerafble system.
2. Mapping the Network infraestructure: Can create a comprensive map of the target's network infraestructure by analysing DNS data, identifyung the name server [NS] for a domain
can revel the hosting provider used, while A record for  loadbalancer.example.com con pinpoint a load balancer.
3. Monitoring for changes: Continuously Monitoring DNS records can reveal changes in the target's infrastructure over time. The sudden apparence od a new subdomain (vpn.example.com)
might indicate a new entry point into the network, while a TXT record containing a value like _1password=... strongly suggests the organization is usin 1Password, which could
be leveraged for social engeniering attacks or targets phising campingns.

## Digginf DNS:
Having established a solid undestanding of DNS fundamentals and it's various record types.
- DNS Tools:
DNS reconnaissacce involves utilizing speciealized tools designed to Query DNS server and extract valueables information. Most common tools:
    - Dig --> Versatile Dns lookup that supp various query types and detailed output --> Manual DNS queries, zone transfers, trobleshooting DNS issues and in-depth analysis of DNS records.
    - nslookup --> Simpler DNS lookup tool, primarily for A, AAAA, and MX records --> Basic DNs queries, quick chescks of domain resolution and mail server records.
    - Host --> Stremilined Dns lookup tool with concieste output --> Checks A, AAAA, and MX records.
    - Dnsemun --> Automated DNS enumeration tool, dictionary attacks, brute-forcing, zone transfers --> Dicoverin subdomains and gathering DNS information efficiently.
    - Fierce --> DNS reconnaissacce and subdomain enumeration tool with Recursive search and wildcard detection --> User-friendly interface Dns reconnaissacce, identifying subdomains and potential targets.
    - theHarverest --> OSINT tool that gathers information form various sources, including  DNS records --> Collectiong email addr employee information, and other data associated with domain form multiple sources.
    - Dns recon --> Combine multiples DMS reconnaissacce techniques and suppots various outpiit formats --> Comprehensive DNS enumeration, identifying subdomains, and gathering DNS records for further analysis.


### The domain information groper:
The dig command(domain Information groper) is versatile and powerful utility for querying DNS server and retrieving various types of DNS records.
Commands:

| Command  | Description |
| -------------- | --------------- |
| dig domain.com  | Performs a def A record lookup for the domain.|
| dig domain.com A |Retrives the IPv4 addr (A record) associated with the domain.|
| dig domain.com AAAA | Retrieves the IPv6 addr (AAAA record) associated with the domain.|
| dig domain.com MX |Finds the mail servers(MX records) resposible for the domain. |
| dig domain.com NS |Idetifies the auth name server or the domain. |
| dig domain.com  TXT|Retrieves any TXT Records associated with the domain. |
| dig domain.com  CNAME | Retrieves the cannonical name[CNAME] record for the domain.|
| dig domain.com  SOA| Retrieves the start of authority SOA record for the domain.
| dig  @1.1.1.1 domain.com |Specifies a specific name server to query; in this case 1.1.1.1 |
| dig  +trace domain.com |Shows the full path of DNS resolution |
| dig  -x 192.168.1.1 |Performs a reverse lookup on the Ip addr to find associated host name, may need to specify a name server. |
| dig   +short domain.com| Provides a short, concise anwer to the query.|
| dig   +noall +answer domain.com|Desplays only the answer section of the query output. |
| dig   domain.com ANY| Retrieves all avaliable DNS record for the domain |

> [!CAUTION]
> Some servers can detect and block excessive DNS queries, use cautions and respect rate limit, and always obtain the permission before performing extensive DNS reconnaissacce on a target.


```sh
dig google.com

; <<>> DiG 9.20.6 <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 47824
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 512
;; QUESTION SECTION:
;google.com.			IN	A

;; ANSWER SECTION:
google.com.		257	IN	A	142.250.185.14

;; Query time: 12 msec
;; SERVER: 80.58.61.250#53(80.58.61.250) (UDP)
;; WHEN: Mon Mar 17 08:37:09 CET 2025
;; MSG SIZE  rcvd: 55
```

1. Header:
[>>HEADER<<- opcode: QUERY, status: NOERROR, id: 47824], this line indicates the type of query, the successful status(Non Error) and unique identifier (47824) for the specific query.
- [;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1], describes the flag in the DNS headers;
    - qr: Query Response Flag - indicates this is response.
    - rd: Recursice Desired Flag - means recursion was requested.
    - ad: Autheic Data flag means the resolver consider the data auth.
    - The reamaining numbers indicates the number of entries in each section od the DNS response: 1 question, 1 answer, 0 auth records, and 0 additional records.
- WARNING: recursion request but no avaliable: This indicates that recusrion was requested, but the sercer does not supp it.

2. Question Section:
- ;google.com.IN A: This line specificies the question: What is the Ipv4 addr for google.com?"
3. Answer Section:
- google.com.		257	IN	A	142.250.185.14; This is the answer tot he query, indicates that the IP address associated with google.com is 142.250.185.14/ The '0' respresent the TTL
indicating how the resullt can be cached before begin refreshed.

4. Footer:
- Query time: 12 msec: This shows the time it took for the query to be processed and the response to be recieved (12 milisec).
- SERVER: 80.58.61.250#53(80.58.61.250) (UDP): this identifies the DNS server that provides the answer and the protocol used UDP.
- WHEN: Mon Mar 17 08:37:09 CET 2025: This is thge timestamp of when the query was made.
- MSG SIZE  rcvd: 55: 54: This indicates the size of the DNS message recieved(54 bytes)


And opt pseundosection can sometimes exists in a dig query, this is dua a extension Mechanism for DNS(ENDS), which allows for additional features such as larger message size and DNS Security Extension(DNSSEC) supp.
```sh
dig +short hackthebox.com
109.176.239.70
109.176.239.69
```

## Subdomains:
When exploring DNS records, we've primary fococused on the main damain and its associated information. Beneath the surface os this primary domain ies a petential network of subdomains, these subdomains are extensions
of the main domain, often created the organise and separate dff sections os funtionalities os a website. A company might use blog.example.com fir its blog,
shop.example.com  for the online store, or mail.example.com for the mail service.
### Why is Important:
1. Development and Stagin Eviroments: Companies often use subdomains to test new ft or update before deployingthem to the main site, due to relaxed secuirity mesures, these enviroments sometimes contains
vulnerabilities or expose sensitive information.
2. Hidden Login Portals: Subdomains might host admin panels or other login ages that are no meant  to be publicly accessible. Attackers seeking unauthorised
access can find these as attractive targest.
3. Legacy Applications: Forgetten we apps might reside on subdomains, potentially containing outdated software with know vulnerabilities.
4. Sesitive Information: Subdomains can inavertently expose confidential dociuments, internal data or configuration filesthat could be valuable attackers.

### Subdomain Enumeration:
Is the process og systematically identifying and listing these subdomains, DNS perspective, are typically represented by A (or AAAA for IPv6) records, which map subdomain name to its corresponding
IP addrs. CNAME records might be used to created alieses for subdomains, pointing them to other domains or subdomains. Two types enumeration:
1. Active subdomain enumeration:
This involves directly interacting with the target domain's DNS servers to unconver Subdomains. One method is attenmpting a DNS zone transfer, where as misconfigured server might inadvertenly leak
a complee subdomain. Due to tightened security mesasure this is rarely successful.
A more common active tech is brurte-force enumeration, which involves systematically testing a list of potential subdamin names againts thje target name.[dnsenum, ffuf, gosbuste].
2. Passive Subdomain Enumeration:
This reslies on external sources of information to dicover subdomains without directly querying the target's DNS server. One value resource is Certificate Transparency(CT logs). public
respositories os SSL/TLS Certificates. These certificates often include a lis os associated subdomains in their subject Alternative name (SAN) field, providing a trasure trove od potential targets.

## Subdomain brute-forcing:
Is a powerful active subdomains discorvery that leverages pre-defined lists os potential subdomains names. This approach systematically test these names against the target domain to identify valid subdomains.
The process breaks down into four steps:
1. Wordlist selection: The process begin with selectiong a worlist containing potential subdomain names:
    - General purpouse: Containing a broad range of common subdomain name(dev, staging, blog, mail, addr, test). Thsi approach is useful when u'nt knwo the target naming conventions.
    - Targeted: Focused in specific industries, tech, or naming patterns relevant to the target, this approach is more efficientand reduces the chancs of false positive.
    - Custom: Can create ur own Wordlist based on specific, keywords, patterns or intelligence gather from other sources.
2. Interation and Querying: A script tool iterates through the wordlist, appending each word or pharse to the main domain, to create potetial subdomain name.
3. DNS lookup: Is performed for each potential subdomain to check if it resolves to an IP addr, this is typically done using the A or AAAA record type.
4. Filtering and Validation: If subdomain resolves successfully, it's added to a list of valid subdomain. Further validation steps might be taken to confirm the subdomain's existence and funtionallity.

Tools:
- [dnsenum](https://github.com/fwaeytens/dnsenum)
- [fierce](https://github.com/mschwager/fierce)
- [dnsrecon](https://github.com/darkoperator/dnsrecon)
- [amass](https://github.com/owasp-amass/amass)
- [assentfinder](https://github.com/tomnomnom/assetfinder)
- [puredns](https://github.com/d3mondev/puredns)

### DNSEnum:
Is a versatile  and widely-used command-line tool written in perl, is comprehensive toolkit for DNS reconnaissacce, providig varius funtinalalities to gather information about a target domain DNS infrastructure
and potential subdomains:
- DNS record Enuemeration: dnsemum can retrieve varius DNS records, A, AAAA, NS, MX, and TXT records, providing a comprenhsive overview og the target's DNS configuration.
- Zone Transfer Attampts: The fool automatically attemps zone transfers form dicovered name servers, most of servers are configurated to prevent unauthorise zone transfers, a successful attempt can reveal a treasure trove of DNS information.
- Subdomain  brute-forcing: supports brute-force enumeration of subdamains using wordlist, this involves systematically testing potential subdomain names againts the target domain to identify valid ones.
- Google Scraping: The tool can scrape Google seach results to find additional subdomains  that might not be listed in DNS records directly.
- Reverse lookup: Can perform reverse DNS lookup to identify domains associated with a given IP addr, potentially revealing other website hosted on the same server.
- WHOIS lookups: The tool can also perform WHOIS queries to gather information about domain ownership and registration details.

Using the Seclist subdamains-topmillion-5000.txt:
`dnsenum --enum inlanefreight.com -f /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt -r`

In the command:
- dnsemum --enum ....: we specify the targer domain we want to enumerate, along with a shortcut for somo tuning options --enum.
- -f ../../../DNS/subdamains-topmillion-5000.txt: indicate the path to the Seclist wordlist we'll use for brute-forcing.
- -r: this optin enables recursive subdamains brute-forcing, meaning that if dnsemum finds a subdomain, will then try to enumerate subdamins of the subdamains.

```sh
dnsenum --enum inlanefreight.com -f Dictionaries/SecLists/Discovery/DNS/subdomains-top1million-5000.txt
Smartmatch is deprecated at /usr/bin/dnsenum line 698.
Smartmatch is deprecated at /usr/bin/dnsenum line 698.
dnsenum.pl VERSION:1.2.4
Warning: can't load Net::Whois::IP module, whois queries disabled.
-----   inlanefreight.com   -----
Host's addresses:
__________________
inlanefreight.com.                       199      IN    A        134.209.24.248
Name Servers:
______________
ns1.inlanefreight.com.                   300      IN    A        178.128.39.165
ns2.inlanefreight.com.                   300      IN    A        206.189.119.186
Mail (MX) Servers:
___________________
Trying Zone Transfers and getting Bind Versions:
_________________________________________________
Trying Zone Transfer for inlanefreight.com on ns2.inlanefreight.com ...
AXFR record query failed: Connection timed out
Trying Zone Transfer for inlanefreight.com on ns1.inlanefreight.com ...
AXFR record query failed: Connection timed out
Scraping inlanefreight.com subdomains from Google:
___________________________________________________
 ----   Google search page: 1   ----
Google Results:
________________
  perhaps Google is blocking our queries.
 Check manually.
Brute forcing with Dictionaries/SecLists/Discovery/DNS/subdomains-top1million-5000.txt:
________________________________________________________________________________________
www.inlanefreight.com.                   300      IN    A        134.209.24.248
ns1.inlanefreight.com.                   289      IN    A        178.128.39.165
ns2.inlanefreight.com.                   300      IN    A        206.189.119.186
blog.inlanefreight.com.                  300      IN    A        134.209.24.248
ns3.inlanefreight.com.                   300      IN    A        134.209.24.248
support.inlanefreight.com.               300      IN    A        134.209.24.248
my.inlanefreight.com.                    300      IN    A        134.209.24.248
customer.inlanefreight.com.              300      IN    A        134.209.24.248
inlanefreight.com class C netranges:
_____________________________________
 134.209.24.0/24
 178.128.39.0/24
 206.189.119.0/24
Performing reverse lookup on 768 ip addresses:
_______________________________________________
0 results out of 768 IP addresses.
inlanefreight.com ip blocks:
_____________________________

```

## DNS Zone Transfers:
A DNS zone Transfer is essentially a wholesale copy all DNS records within a zine form one name server to another, this process is essential for maintaing consistency and redundancy acroos
DNS server. If not adquealtely secured, unauthorised parties can dowload the entirre zone file, revealing a complete list of subdomains, thir associeated IP addr amd other sentive data.
![zone](https://mermaid.ink/svg/pako:eNqNkc9qwzAMxl9F-JSx7gV8KISWXcY2aHYYwxdjK39obGWKvBFK333ukg5aGNQnW9b3Q_q-g3LkUWk14mfC6HDb2YZtMBHyGdFR9JanCvkL-WG9vh-4C38FDeX74w52J-0oUHxQRHhjG8ca-W5mXAgy4YqpoXotM8EReygqsSxANZRJWuJOpoXSEw0gC3ku3QTfvlQLfBZh9DeOdbELbCgMPQr-58u1LZsnKEq3j_Tdo28wYJS8iVqpgBxs57PjhxPLKGnzr1E6XzNxb5SJx9xnk1A1Rae0cMKVYkpNq3Rt-zG_0uCtnLM6t6DvhPh5zvM31uMPG8qm-A)

1. Zone Transfer request(AXFR): The secundary DNS server initiates the process by sending a zone transfer request to the primary server. initiates the process by sending
a zone transfer request to the primary server, The request typically uses the AXFR(full zone transfer) type.
2. SOA Record Trasfer: Upon recieving the request(and potentially ayth the secondary server), the primary  server responds by sending its start a authority(SOA) record/
The SOA record contains vital information about the zone, including it serial number, which helps the secondary server determine if its zone data is current.
3.  DNS Records Transmission: the primary server then transfers all the DNS records in the zone to the secondary server, one by one. This includes like A, AAAA., MX, CNAME, NS
and others that define the domain's subdomains, mail servers, name servers, and other configuration.
4. Zone transfer complete: One all records have been transmitted, the primary server signal the end of the zone transfer. This notification informs the secodary server that it has recieves a complete
copy of the zone data.
5. Acknowledgement (ACK): The secondary server sends a Acknowledgement message to the primary server, confirming the successful and processing
of the zone data. This complete transfer process.


### The zone transfer vulnerabilitiesL:
While zone transfer are essential for legitimates DNS magnement, misconfigured DNS server can tranform this process into significant security vulnerability, the core issues lies in the access controls governing
who can initite zone transfer.
In teh early days of hte internet, allowing any client to request a zone transfer from a DNS server common practice, this open approach simplified admin but opened a gapin security hole. It meant that anyone, including
malicius actors, could ask DNS server for a complete copu of its zone file, which contains weath of sensitive information.
The information gleaned form an aunathorised zone transfer can be invaluvle to an attacker, it revels comprehensive map of targt's DNS infrastructure including:
- Subdomains: A complete list of subdomains, many of which might not be linked form the main website or ez discoverable through other means. These hidden subdomains could host development servers, stragin enviroment, administrative panels,
or sentive resources.
- IP addr: The IP addr associated with each subdomins, providing potential targets for futher reconnaissace or attacks.
- Name server records: detailes about the Authoritative name servers for the domain, reveling the hosting provider and potential misconfiguration.

### Exploting Zone Transfers:
U can use dig command to request a zone transfer:
`dig axfr @nsztm1.digi.ninja zonetransfer.me`
This command intructs dig to request a full zone transfer faorm the DNS server responsible for zonetransfer.me. If the server is misconfigured and allos the transfer, you'll recieve a complete list of DNS records for the domain, including
all subdomains.
```sh
dig axfr @nsztm1.digi.ninja zonetransfer.me

; <<>> DiG 9.20.6 <<>> axfr @nsztm1.digi.ninja zonetransfer.me
; (1 server found)
;; global options: +cmd
zonetransfer.me.	7200	IN	SOA	nsztm1.digi.ninja. robin.digi.ninja. 2019100801 172800 900 1209600 3600
zonetransfer.me.	301	IN	TXT	"google-site-verification=tyP28J7JAUHA9fw2sHXMgcCC0I6XBmmoVi04VlMewxA"
zonetransfer.me.	7200	IN	MX	0 ASPMX.L.GOOGLE.COM.
zonetransfer.me.	7200	IN	MX	10 ALT1.ASPMX.L.GOOGLE.COM.
zonetransfer.me.	7200	IN	MX	10 ALT2.ASPMX.L.GOOGLE.COM.
zonetransfer.me.	7200	IN	MX	20 ASPMX2.GOOGLEMAIL.COM.
zonetransfer.me.	7200	IN	MX	20 ASPMX3.GOOGLEMAIL.COM.
zonetransfer.me.	7200	IN	MX	20 ASPMX4.GOOGLEMAIL.COM.
zonetransfer.me.	7200	IN	MX	20 ASPMX5.GOOGLEMAIL.COM.
zonetransfer.me.	7200	IN	A	5.196.105.14
zonetransfer.me.	7200	IN	NS	nsztm1.digi.ninja.
zonetransfer.me.	7200	IN	NS	nsztm2.digi.ninja.
zonetransfer.me.	300	IN	HINFO	"Casio fx-700G" "Windows XP"
_acme-challenge.zonetransfer.me. 301 IN	TXT	"6Oa05hbUJ9xSsvYy7pApQvwCUSSGgxvrbdizjePEsZI"
_sip._tcp.zonetransfer.me. 14000 IN	SRV	0 0 5060 www.zonetransfer.me.
14.105.196.5.IN-ADDR.ARPA.zonetransfer.me. 7200	IN PTR www.zonetransfer.me.
asfdbauthdns.zonetransfer.me. 7900 IN	AFSDB	1 asfdbbox.zonetransfer.me.
asfdbbox.zonetransfer.me. 7200	IN	A	127.0.0.1
asfdbvolume.zonetransfer.me. 7800 IN	AFSDB	1 asfdbbox.zonetransfer.me.
canberra-office.zonetransfer.me. 7200 IN A	202.14.81.230
cmdexec.zonetransfer.me. 300	IN	TXT	"; ls"
contact.zonetransfer.me. 2592000 IN	TXT	"Remember to call or email Pippa on +44 123 4567890 or pippa@zonetransfer.me when making DNS changes"
dc-office.zonetransfer.me. 7200	IN	A	143.228.181.132
deadbeef.zonetransfer.me. 7201	IN	AAAA	dead:beaf::
dr.zonetransfer.me.	300	IN	LOC	53 20 56.558 N 1 38 33.526 W 0.00m 1m 10000m 10m
DZC.zonetransfer.me.	7200	IN	TXT	"AbCdEfG"
email.zonetransfer.me.	2222	IN	NAPTR	1 1 "P" "E2U+email" "" email.zonetransfer.me.zonetransfer.me.
email.zonetransfer.me.	7200	IN	A	74.125.206.26
Hello.zonetransfer.me.	7200	IN	TXT	"Hi to Josh and all his class"
home.zonetransfer.me.	7200	IN	A	127.0.0.1
Info.zonetransfer.me.	7200	IN	TXT	"ZoneTransfer.me service provided by Robin Wood - robin@digi.ninja. See http://digi.ninja/projects/zonetransferme.php for more information."
internal.zonetransfer.me. 300	IN	NS	intns1.zonetransfer.me.
internal.zonetransfer.me. 300	IN	NS	intns2.zonetransfer.me.
intns1.zonetransfer.me.	300	IN	A	81.4.108.41
intns2.zonetransfer.me.	300	IN	A	167.88.42.94
office.zonetransfer.me.	7200	IN	A	4.23.39.254
ipv6actnow.org.zonetransfer.me.	7200 IN	AAAA	2001:67c:2e8:11::c100:1332
owa.zonetransfer.me.	7200	IN	A	207.46.197.32
robinwood.zonetransfer.me. 302	IN	TXT	"Robin Wood"
rp.zonetransfer.me.	321	IN	RP	robin.zonetransfer.me. robinwood.zonetransfer.me.
sip.zonetransfer.me.	3333	IN	NAPTR	2 3 "P" "E2U+sip" "!^.*$!sip:customer-service@zonetransfer.me!" .
sqli.zonetransfer.me.	300	IN	TXT	"' or 1=1 --"
sshock.zonetransfer.me.	7200	IN	TXT	"() { :]}; echo ShellShocked"
staging.zonetransfer.me. 7200	IN	CNAME	www.sydneyoperahouse.com.
alltcpportsopen.firewall.test.zonetransfer.me. 301 IN A	127.0.0.1
testing.zonetransfer.me. 301	IN	CNAME	www.zonetransfer.me.
vpn.zonetransfer.me.	4000	IN	A	174.36.59.154
www.zonetransfer.me.	7200	IN	A	5.196.105.14
xss.zonetransfer.me.	300	IN	TXT	"'><script>alert('Boo')</script>"
zonetransfer.me.	7200	IN	SOA	nsztm1.digi.ninja. robin.digi.ninja. 2019100801 172800 900 1209600 3600
;; Query time: 52 msec
;; SERVER: 81.4.108.41#53(nsztm1.digi.ninja) (TCP)
;; WHEN: Mon Mar 17 11:13:00 CET 2025
;; XFR size: 50 records (messages 1, bytes 2085)
```
zonetransfer.me is service specially setup to desmostrate the risk zone transfer so that the dig command will return the full zone record.

## VIRTUAL HOST:
Once the DNS directs traffic to the correct server, the web server configuration becomes crucial in detemining how the incoming requests are handle. Web servers like Apache, Ngix
or ISS are designed to host multiple website or app on a single server, archive this though virtual hosting, which allows them to differentiate between domains, subdomains or even
separates website with district content.

### How Virtual Host works: Undestanding vhost and subdomains:
At the core of virtual hosting is the ability of web servers to distinguish between multiple webistes or apps sharing the sma IP addr, this achieved by leveraing the HTTP host header, a piece of information included
in every HTTP request sent by a web browser.
The key diffirence between VHost and subdomains is their relationship to the Domain Name system (DNS) and the Web server's configuration:

- Subdomains: these are extensions of a main domain name. Subdomains typically havve their own DNS records, pointing to either the same IP  addr an the main domain or different one. They can be used
to organise different sectionsor services.

- Virtual hosts:(VHosts): Virtual hosts are configuration within a web server that allow multiple website or app to be hosted on a single server. They can be assiciated with top-level domains or subdomains.
Each virtual host can have its own separate configuration, enabling precise control over how requests are handled.

If a virtual host does not have a DNS record, can still access it by modifying the hosts file on ur local machine. The hosts file allows you to map a domain name to an IP addr manually, bypassin DNS resolution.
Website often have subdomains that are no public and won't appear in DNS record. These subdomains are only accessible internally or through specific configurations.
[VHost fuzzing] is a techniques to dicover public and non-public subdomains and VHosts by testing varius hostnames against a known IP addr.
Example host:
```apacheconf
# Example of name-based virtual host configuration in Apache
<VirtualHost *:80>
    ServerName www.example1.com
    DocumentRoot /var/www/example1
</VirtualHost>

<VirtualHost *:80>
    ServerName www.example2.org
    DocumentRoot /var/www/example2
</VirtualHost>

<VirtualHost *:80>
    ServerName www.another-example.net
    DocumentRoot /var/www/another-example
</VirtualHost>
```

### Server VHost Lookup:
![Scheme](https://mermaid.ink/svg/pako:eNqNUsFuwjAM_ZUop00CPqAHDhubuCBNBW2XXrzUtNFap3McOoT496WUVUA3aTkltp_f84sP2rgcdaI9fgYkgwsLBUOdkYqnARZrbAMk6oFd65HHiTd8XyPvfku9WpYA1dJ5eXS0tcW4ZOFMqJEkdU4y6vNnqul8PvRO1HKzeVFpp9KLumvbdmapAsItoy1KmRlX3_fwAXTd4OkLakuoOjVqiZAj_7_PaJJEPVvK1QrElJYK1UcDg1h3HmOEmV4LSlEC0-CA6i24Zb406IRhizuM7BV6BVFCit4FNuh77GX9DeGfmEu-s_mD4b5x5PH2Y4aqhfVNBftufomsGemJrpFrsHncqkOHy7SUWGOmk3jNgT8yndEx1kEQt96T0YlwwIlmF4pSJ1uofHyFJgf52cchirkVx6t-aU-7e_wG--_4bQ)

1. Browser Request a Website: When you enter a domain name into ur browser, it initites an HTTP request to the web server associated with that domain's IP addr.
2. Host Header Reveal the Domaim: The browser icludes the domain name in the request's host header, which acts as a label to inform the web server which is begin requested.
3. Web server Determinates the Virtual Host: The web server recieves the request, examines the host header, and consult its virtual host configuration to find a matchin entry for the requested domain name.
4. Serving the right Content: Upon Identifying the correct virtual host config, the web server retrives the corresponding files and reources associated with that website
from its document root and sends them back to the browser as the HTTP response.

### Types od Virtual Hosting:
1. Name-Based Virutal Hosting: This method relies solely on the [HTTP host header] to distinguish between web, It's the most common and flexible method, as it doesn't require
multiple IP addr. It's cost-effictive, ez to setup, and supports most modern web server, it requires the web server to supp name-based virtual hosting and can have limitations
with certain protocols like SSL/TLS.
2. IP-Based Virtual Hosting: This type os hosting assings a unique IP addr to each website hosted on the sever. The server determinees which website to serve based on the IP addr to which
the request was sent. Rely on th host header, can be used with any protocol, and offers better isolation between isolation website. It requires multiple IP addr, which can be expensive and less scalable.
3. Port-Based Virtual Hosting: Different wesite are associated with different ports on the same IP addr, one website might be accessible on port 80, while another
is on port 8080. Port-based virtual Hosting can be used when IP addr are limited, but it's not as common ir user-friendlu as name-based virtual hosting
and might require user to specify the port number in the URL.

- Virtual Host Discovery Tools:
While manual analysis of HTTP Headers and reverse DNS lookup can be effective, specialides virtual host dicovery tools automate and steamline the process, making it more
efficient and comprehensive. These tools employ varius techniques to probe the target server and uncover potential virtual hosts.

Several tools are avaliable to aid in the dicovery of vh:

| Tools  | Description | Features |
| --------------- | --------------- | --------------- |
| Gobuster  | A multi-purpouse tools often for directory/file brute-forcing. but also effective for virtual host discovery  |Fast, support multiple HTTP can use custom Wordlist.   |
| Feroxbuster  |Similar to gobuster, but with a Rust-Based implementation, know for its speed and flexibility   | Supports recursion, wildcard discovery and varius filters.  |
|  ffuf |Another fast web fuzzer that can be used for vh dicovery by fuzzing the HOst header   |Customizable wordlist and filtering options.   |

#### Gobuster:
Is versatile tool commonly used for directly and file brute-forcing, but is also excesls at virtual host discovery, it systematically send HTTP requests with diff
host headers to a target IP addr and the analyses the reponses to identify valid virtual host.
Couple host headers:
1. Target Indentification: identify web server's IP addr, this can be done through DNS lookup or other reconnaissacce tech.
2. Wordlist preparation: Prepare the wordlist containing potential virtual host name, can use a precompiled wordlist, such seclist, or create cutom one base.

`gobuster vhost -u http://<target_IP_address> -w <wordlist_file> --append-domain`

    - u flag specifies the target URL
    - W the wordlist
    - --append-domain append the base domain to each word list.


The --append-domain flag is required to append the base domain to each word in the wordlist when performing virtual host discovery. This flag ensures that Gobuster correctly constructs
the full virtual hostnames, which is essential for the accurate enumeration of potential subdomains. In older versions of Gobuster, this functionality was handled differently, and the --append-domain flag
was not necessary. Users of older versions might not find this flag available or needed, as the tool appended the base domain by default or employed a different mechanism for virtual host generation.

Other arguments that are worth knowing:
[-t] to increase the number or threads for faster scanning
[-k] can ignore SSL/TLS certificate errors.
[-o] save the output a file for later analysis.
` gobuster vhost -u http://inlanefreight.htb:81 -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-110000.txt --append-domain`

> [!TIP]
> Virtual host dicovery can generate significatn traffic and might be detected by intrusion detection system(IDS) or web app firewall(WAF).

- Exercise
` ffuf -u http://94.237.51.23:57792/ -H "Host: FUZZ.inlanefreight.htb" -w Dictionaries/SecLists/Discovery/DNS/subdomains-top1million-110000.txt -fs 10198 -mc 200`
` ffuf -u http://94.237.51.23:57792/ -H "Host: FUZZ.inlanefreight.htb" -w Dictionaries/SecLists/Discovery/DNS/subdomains-top1million-110000.txt -fs 116 -mc 200 `
We can see the size of the file are 116

## Certificate Tranparecy Logs:

In the spraling mass of the internet, trust is fragile commodity, one of the conerstones os this trust is the [Secure Sockets Layer/Transport Layer Security SSL/TLS] protocol, which
encrypts communication between ur browser and a website. At the heart of SSL/TLS lies the digital certificate, a small file that verifies a website's identify and allows for secure, encrypted communication.

- What are Certificate Transparecy Logs?
CT logs are public, append-only lefgers that record the issuance of SSL/TLS certificate. Whenever a Certificate Authority (CA) issues a new certificate, it must submit it to multiple CT logs.
Independent organisations maintain these logs and are open to inspect.
The CT log as a global registry of certificates, they provide a transparent and verifiable record every SSL/TLS certificate issued for a web; Crucial porpouse:
    - Early Detection of Rogue Certificates: Monitoring CT logs, security researches and website owner can quickly identify suspicious  or misissued certificates. A rogue is a unauthorized
    or fraudulent digital certificate issued by a trusted certificates auth. Detecting these early allows for swift action to revoke the certificates before they can used be for malicius  purpouse.
    - Accontability for Certificate Authorities: CT logs hold CAs accountable for their issuance practices. If a CA issues a certificate that violates the rules or standards, wll be publicly visible in the logs,
    leading to potencial sanctions or loss of trust.
    - Strengthening the Web PKI(Public Key infrastructure): The Web PKI Is the trust system underpinning secure onlice comunication. CT logs help to enhace the security and integrity of the web PKI by providing
    a mechanism for public oversight and verification of ceritificates.


### How Certificate Tranparency logs work:

1. Certificate Issuance: When a website owner request an SSL/TLS certificate from a Certificate Authority (CA), this perform due diligence to verify the owner's identity and domain ownership, Once verified the CA issues
a pre-certificate, a preliminry certificate version.
2. Log Submission: The CA then submits this pre-certificate to multiple CT logs. Each log is operated by a diff organisation, ensuring redundancy and decentralisation, The logs are essentially append-only, meaning that once
a certificate is added, it cannot be modifid or deleted, ensuring the integrity od the historical record.
3. Signed Certificate Timestamp(SCT): Upon receiving the pre-certificate, each CT log generates a [Signed Certificate TimeStamp(SCT)]. This SCT is cryptographic proof that the certificate was submitted
to the log at specific time. The SCT is then included in the final certificate issued to the website owner.
4. Browser Verification: When a user's browser connect to a website, it checks the certificate's SCTs. These are verified against the public CT logs
to confim that the certificate was issued and logged correctly. If the SCTs are valid, the browser establishes a secure connection; it may display a warning to the user.
5.  Monitoring and Auditing: CT logs are continuously monitored by varius entitites, including secutiry researches, website owner, and browsers vendors. These monitors look for anomalies
or suspicius certificates, such those issued for domains they don't won or certificates violating industry standards.

- The Merkle Tree Structure:
To ensure CT log's integrity and tamper-proof nature, they employ a Merkle tree cryptographic. This structure organises the certificaties in a tree-like fashion, where each leaf node represent a certificate,
and each non-leaf node represent a hash of its child nodes. The root tree, is a single hash representating entire log.
    - root hash the topmost node, a single hash represeting the entire log's state.
    - Hash 1 & Hash 2: Intermediate nodes, each  hash od two child nodes
    - Cert 1 - 4: leaf nodes representing individual SSL/TLS certificatites for dff subdomains of the web.
The structure allows for efficient verification of any certificate in the log. Providing the Merkle path for a particular certificate, anyone can verify that is included in th log without dowloading the entire log.
Cert 2(blog.web.com) would need:
    1. Cert 2's hash: This directly verifies the certificate itself.
    2. Hash 1: Verifies the Cert'2 hash is correctly paired with Cert 1's hash.
    3. Root hash: confirms that hash 1 is a valid part of the overall log structure.

### CT Logs and web recon:
Certificate Transparency logs offer a unique advantage in subdomain enumeratioin compared to other methods. Unilike brute-forcing  or wordlist approaches,which rely on guessing
or predicting subdomain names, CT logs provide a definitive record of certificates issued for a domain and its subdomains.
This means ure not limited by the scope of ur wordlist or the effectiveness od brute-forcing algorithm. Instead  gain the access to historiacal and comprenhsive view of a
domain's subdomains, including those that might not be actively used or ez guessable.
CT logs can unveil subdomains associated with old or expired certificates, these subdomains might host outdate software or configuration, making them potentially vulnerable to explotation.

- Searching CT logs:

crt.sh: User-friendly web interface, simple search by domain, displays certificate detail, SAN entries -- Quicj and ez search, identifying subdomains, checking certificate issiance history.
Censys: Powerful search engine for internet connected device, firletting by domains,  IP, attributes. -- In-depth od certificates, identifying misconfigurations, finding realted certificates and hosts.

crt.sh lookup offer convient web interface, canalse leverage its APi for automated searches directly from ur terminal:
```sh
curl -s "https://crt.sh/?q=facebook.com&output=json" | jq -r '.[]
 | select(.name_value | contains("dev")) | .name_value' | sort -u

*.dev.facebook.com
*.newdev.facebook.com
*.secure.dev.facebook.com
dev.facebook.com
devvm1958.ftw3.facebook.com
facebook-amex-dev.facebook.com
facebook-amex-sign-enc-dev.facebook.com
newdev.facebook.com
secure.dev.facebook.com
```
- curl -s "https://crt.sh/?q=facebook.com&output=json": This command fetches the JSON output from crt.sh for certificates matching the domain facebook.com.
- q -r '.[] | select(.name_value | contains("dev")) | .name_value': This part filters the JSON results, selecting only entries where the name_value field (which contains the domain or subdomain) includes the string "dev".
The -r flag tells jq to output raw strings.
- sort -u: This sorts the results alphabetically and removes duplicates.



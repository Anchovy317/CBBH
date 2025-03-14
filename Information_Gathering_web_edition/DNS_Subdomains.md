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

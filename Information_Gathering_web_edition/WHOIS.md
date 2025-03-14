Whois is a widely used query and response protocol designed to access db that store information about registred internet resources, associeate
with domain names, WHOIS can also provide details about ip addr blocks and autonomous systems.
```sh
whois www.xxx.com
```
Each WHOIS record typically contains the follow info:
- Domain Name
- Registrar: the company whre the domain was registred.
- Registrat Contact: the person or organization that registred.
- Adminitrative Contact
- Technical Contact
- Creation and Expiration Db
- Name Servers

## History:
Is intrinsicalluy linked to the vision and dedication of Elizabeth Feiler, a computer science who played a pivotal role in shaping the early internet.
In 1970s, Freinler and her team at the Stanford Research  Institute Network Information Center recognised the need for a system to track and amnege the growing
number of network resourvces on ht ARPNET, the precursor to the modern internet.
## Why WHOIS Matters for web recon:
- Identifuing Key Personnel: Records oftern revel the name, email addrs, and phone number of individual responsible for managing the doamian, this information can be leveraged
for social engeeniring attacks or to identify potential targets for phishing.
- Discovering Network Infraestructure: Tech detaisls like name servers and IP addr provide clues about targets net Infraestructure.
- Historical Data Analysis: Accessing Historical WHOIS recorsr through services like WHoisFreak cna reveal changes in ownership, contact information, or techical details over time.

## Utilising WHOIS:

### Scenario 1: Phishing Investigation
And email security gateaway flags a suspicius email sent to multiple employees within a company, the email claims to be from the company bank and urges recipiets to clik a link.
A security analyst investigate the email and begins by performing WHOIS.
The WHOIS record reveal the following:
- Registration Date
- Regisrtrant
- Name servers
This combination os factors raises significant red flags analyst. The recent registration date, hidden registrant information, and suspicius hosting strongly suggest a phishing campaing.
Thhe analyst promptly alerts the company's IT department to block the domain and warns employees abaout the scam.

### Scenario 2: Malware Analysis
A security researchr is analying a new strain of malware that has infected several system within a network, the malware communicaties with a remote server to recieve command and exfiltate stolen data, to
gain insight into the threat actor's Infraestructure, the research perfoms a WHOIS  lookup on the domain associated with the command-and-control C2 server.
- Registrant
- Location
- Registrar

### Scenario 3: Threat Intelligence Report
Cybersecurity firm tracks the activities od sophistyicated threat actor group for targeting financial Institutions.
Analysts gather whois data on multiple domains associated with the groups past camping to compile a comprehnsice therat intelligence.
- Registration Dates
- Registrant
- Name Server
- Takedown History

Theese insights allows analyst to create a detailed profile of the thread actor's tactics, tech, and procedures TTPs. The report includes indicators of compromised(IOCs) based
on the WHOIS data, which other organisations can use to detect and block.

### Using WHOIS
Command whois:
whois facebook.com

1. Domain Registration:
    - Registrar: RegistrarSafe, LLC
    - Creation Date : 1997-03-29
    - Expiry Date: 2033-03-30
2. Domain Owner:
    - Registrant/Admin/Tech Organization: Meta
    - Registrant/Admin/Tech Contact: Domain admin
3. Domain Status:
    - ClientDeleteProhibited, clientTrasnferProhibition, clientUpdateProhibited, serverDeleteProhibited, serverTransferProhibited and ServerUpdateProhibbite.
4. Name Servers:
    - A.NS.FACEBOOK.COM, B.NS.FACEBOOK.COM, C.NS.FACEBOOK.COM, D.NS.FACEBOOK.COM



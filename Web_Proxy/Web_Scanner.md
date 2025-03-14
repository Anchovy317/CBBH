# Burp Scanner:
And essential feature of web proxy tools is their scannerm come with burp scanner a powerful scanner for varius types od web vulnerability, using a crewler
for building the web structure, and Scanner for passive and active scanning.

## Target scope:
1. Start scan on specific request from Proxy History.
2. Start a new scan on a set of targets
3. Start scan on items in-scope.

To start a scan on a specific request from Proxy, we can right-click in we locate in the history, and then select Scan to be able to configure the scan before we run
or select [Passive/Active Scan] to quicky start a scan with the def configuration.

![Scan](https://academy.hackthebox.com/storage/modules/110/burp_scan_request.jpg)
We may aslo click in New Scan on the Dashboard tab, which  would open the new scan configuration window to configure a scan on a set of custom targets.
Instead of creating a custom scan from scratch [target Scope]. can be utilized with all Burp ft to define custom ser of targets that will processed.
> [!NOTE]
> We will be scanning the web app form the exercise found at the end of the next section.

If we got [target> site map], it will a listing of all directories and files burp has detected in various requests:
![site map](https://academy.hackthebox.com/storage/modules/110/burp_site_map_before.jpg)
We may also need to exclude a few items from scope if scanning them may be dangerous or may end our session like logout funtion, To exclude an item form our scope , we can right-click on any in scope item and select Remove From scope.
We can go to (Target>Scope) to view the details our scope. We may also add/remove other items and use advanced scope control to specify regex to be include/exclude.

## Crawler:
Once we have our scope ready, we can go to the dashboard tab and click on New Scan to configure our scan, which would be auto populated wiht our scope items.
![crawl](https://academy.hackthebox.com/storage/modules/110/burp_new_scan.jpg)

We can see that Burp gives us two scanning options: [Crawl and Audit], web crawler navigate a website by accessing any links found in its pages, acessing forms and scanning
any request it makes to build a comprehsive map od the web. Burp Scanner presents us witha map of target, showing all publicy accessible data in a single place. If we Selected Crawl and Audit,
Burp will run its scanner after ir Crawler.
Lest select Crawl as start and go to the Scan configuration tab to configure our scan. We may choose to click on New to build  a custom configuration.
For the sake of simplicity, we'll click on the Select from library buttom, which gives us a few present configuratrion we can pick from.

We'll select the Crawl strategy - fastest option and continue to the App login, We can add a set of credentials for Burp attempts in Any login form/fields can find.
We also record a set of steps by performing a manual loginin the pre-configuration browser, such that Burp steps the follow to gain a login access.
This can be essential if we were running our scan using a auth user, which llos us to cover parts os the web app that Burp may otherwise not have access.
We may also click on the View details button on the tasks to see more details about the running scan or click in the gear icon to customize oir scan configuration futher.


## Passive Scanner:
Now that the site map is fully built, we may select to scan this target for potential vulnerabilities When we choose the Crawl and Adit option on the New Scan dialog, Burp will perform two types od scans:
A passive vulnerability Scan And Active Scan vulnerability.
Unlike an Active Scan, a Passive scan does not send any new requests but analyzes the source of pages already visited in the target/scope and then tries to identify potential vulnerabiliies.
This is very useful for quick analysis of specific target, like missing HTML code tags or potential  Dom-Based XSS vulnerabiliies, without sending any requests to test and verify these vulnerabiliies,
a passive scan can only suggest a list potential vulnerabiliies, Burp Passive Scanner does provide a leber Confidence for each identifed vulnerabily,which also helpful for priotirizing potencial vulnerability.

To do the passive scan [Target>site map] or  request in Burp Proxy History,  then right and select do passive scan oir Passively scan this targert.
The passive scan will start running, and its aks can be senn in the dash  tab as well. View Detailro review identified vulnerabilites and then select the Issue Activity tab:
![Detail](https://academy.hackthebox.com/storage/modules/110/burp_passive_scan.jpg)
We can view all identified issiues in the Issues activity pane on the Dashboard tab, as we can see, it shows the list os the potential vulb, severity, and their confidence.
We want to look for vulnerabilities with HIGH severity and Certain confidence

## Active Scanner:

We finally reach  the most power part of Burp scanner, which is its Active vulnerabilities Scanner:
1. It start by running a crawl and web fuzzer.
2. Run a Passive on all idetified.
3. Check each od the identified vulnerabilities from the Passive Scan and sends requests to verify them.
4. Perform a JS analysis to identify futher potententional vulb.
5. Fuzzer varius identified insertions points and parametrer to look common vulb like XSS, command injectiion, SQL injection and other common web vulnerabilities.

We can start an active scan similary to how to began a Passive by selecting the Do active scan from the menu on a request in Burp Proxy History.
We can run can or our scope the New scan button in the Dashboard, which would allow us to configure our active scan, we will select the Crawl and Audit option, which would perform all os the above points.
May also et the crawl configuration an the audit configuration, audit enable us to select  what type of vulnerabilities we want to scan, where the scanner would
attempt inserting the payloads, in button.
Audit checks - critical issues only.
Once we select out configuration, we can cclick on ok and start scan, and should be added in the Task pane in the Dashboard tab:
![scan](https://academy.hackthebox.com/storage/modules/110/burp_active_scan.jpg)
The scan will run all the stepst mentioned above, which is why will take significally longer to finish than our early scans depending on the configuration.
As the scan is runnung we can view the various request it making clicking on the View detailts buttom and selecting the logger tab.
Once scan is done, we can look at the issues activity  pane in the Dashboard tab to view and filter all of the issues identified so far.
We can see Burps identified and OS command injection vulnerability, which is ranked high severity firm confidence.

## Reporting:
Target > site map, right click on our target and select Issues > Report issues for this host.
![report](https://academy.hackeethebox.com/storage/modules/110/burp_scan_report.jpg)

Come Extensions:
- Bapp Store
.NET beautifier 	            J2EEScan 	    Software Vulnerability Scanner
Software Version Reporter 	    Active Scan++ 	Additional Scanner Checks
AWS Security Checks 	        Backslash Powered Scanner 	Wsdler
Java Deserialization Scanner 	C02 	Cloud Storage Tester
CMS Scanner 	                Error Message Checks 	Detect Dynamic JS
Headers Analyzer 	            HTML5 Auditor 	PHP Object Injection Check
JavaScript Security 	        Retire.JS 	CSP Auditor
Random IP Address Header 	    Autorize 	CSRF Scanner
JS Link Finder

- ZAP MARKETPLACE


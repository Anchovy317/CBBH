# Handling SQLmap errors:
We may face many problems when setting up SQLMAp or using HTTP request.

- Display errors:
The first step is usually to switch the --parse-errors, to parse to DBMS errors and display them as part of the proram run:
```sh
...SNIP...
[16:09:20] [INFO] testing if GET parameter 'id' is dynamic
[16:09:20] [INFO] GET parameter 'id' appears to be dynamic
[16:09:20] [WARNING] parsed DBMS error message: 'SQLSTATE[42000]: Syntax error or access violation: 1064 You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '))"',),)((' at line 1'"
[16:09:20] [INFO] heuristic (basic) test shows that GET parameter 'id' might be injectable (possible DBMS: 'MySQL')
[16:09:20] [WARNING] parsed DBMS error message: 'SQLSTATE[42000]: Syntax error or access violation: 1064 You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near ''YzDZJELylInm' at line 1'
...SNIP...
```
Whit this option, Sqlmap will automatically print the DBMS error, thus giving us clarity on what the issues may be so that we can properly fix it.

- Store the Traffic:
The -t option stores the whole traffic content to an output file:
`sqlmap -u ... --batch  -t /tmp/traffic.txt`, As we can see from above output, the /tmp/traffic.txt file now contains all sent the recieved HTTP requests. We can now manually investigate these request to see where the issue is ocurring.
- The verbose output:
Another useful flag is the -v option, which raises the verbosity level:
`sqlmap -u ... -v 6 --batch`, As we can see the -v 6 will directly print all errors and full HTTP request to the terminal so that we can follow along with everything SQLmap is doing in real-time.

- Using proxy:
We can utilize the --proxy option to redirect the whole traffic a MiMT proxy. This will route all SQLMAP traffic through burp, so that we can later manually investigate all requests, repeat them and utilize all ft of Burp with these request.

# Attack Tuning:
In most cases, SQLmap should run out the box with provided target detail. There are options to fine-tune the SQLi injecion attemps to help SQLmap inb the detection phase. Every payload sent to the target consist of:
    - vector[UNION ALL SELECT 1,2,VERSION()]: central part of the payload, carrying the useful SQL code to be executeed at the target.
    - Bondaries[<vector-- ->]: prefix and suffix formations, used for proper injection of the vector into the vulnerable SQL statements.

- Prefix/Suffix:
There is a requirement for special prefix and suffix values in rare cases, not covered by the regular SLQMAP run.
[--prefix, --suffix]
`sqlmap -u "www.example.com/?q=test" --prefix="%'))" --suffix="-- -"`

This will result in an enclosure of all vecotor values between the static prefic and the suffix -- -,
```sh
$query = "SELECT id,name,surname FROM users WHERE id LIKE (('" . $_GET["q"] . "')) LIMIT 0,1";
$result = mysqli_query($link, $query);
```
The vector UNION ALL SELECT 1,2,VERSION(), bounded with the prefix %')) and the suffix -- -, will result in teh following valid SQL statemt at the target.

- Level/risk:
Sqlmap combines a predefined set of most common boundaries alin with the vectors having a high chance of success in case of vulnerable target. There is a possibility for users to use bugger sets of boundaries and vectors already incorporatd into the SQLmap.

For such demnands, the options --level and --risk should be used:
    - level (1-5, def 1) extends both vecotrs and boundaries begin used, based on their expectancy of success.
    - risk(1-3 def 1) extendsthe used vectors set based on their risk of causing problems at the target side.
The best way to check for differences between used boundaries and payloads for differents values of  --level and --risk, is the usage -v option to set the verbosity
level. In verbosity 3 or higher message containit the used [PAYLOAD] will be desplayed as follow:
`sqlmap -u www.example.com/?id=1 -v 3 --level=5`
On the other hand, payloads used with the def --level value a considerably smaller set of boundaries:
`sqlmap -u www.example.com/?id=1 -v 3`
As for vecotors, we can compare used payloads as follow:
`sqlmap -u www.example.com/?id=1`
` sqlmap -u www.example.com/?id=1 --level=5 --risk=3`
As for the number of payloads, by def the number of payloads used for testing a single parameter goes up to 72, while in the most detailed case [--level 5 and --risk=3] the number of payloads incerase 7865.
As SQLmap is already turned to check for the most common boundaries and vectors, regualr users are advised not to touch these options cause it will make it the whole detection process considerably slower.
In special cases of SQLi vulnerabilities, where usage OR payloads is a must we may have to raise the risk level ourselves
This is because OR payloads are inherantly dangerous in a def run, where underlying vulnerable SQL statements are actively modifying the db content.

## Advaced Tuning:
- Status codes:
When dealing with a huge target response with a lot of dynamic content, subtle difference between TRUE and FALSE responses could be used for detection purpouse. If the difference between TRUE AND FALSE response can
seen in the HTTP codes the option [--code] be used to fixate the detection of TRUE responses to specific HTTP code [--code=200]

- Titles:
In the differences between responses can be seen by inspecting the HTTP page title the switch --title could be used to instruct the detection mechanims to base the comparision on the content of the HTML tag.

- Text-only:
When dealing with a lot of hidden content, such as certain HTML page behaviours tages, we can use the --text-only switch, which removes all the HTML tags, and bases the comparison only on th textual.

- Techniques:
In somo special cases, wer have to narrow down the used payloads only tyo a certain types. IF the time-based blind payloads are causing torible in teh form of responses, timeouts, or if we want to force the usage of specific SQLi payloads types, the
option --techniques can specify the SQLi tech top be used.

- UNION SQLi Tuning:
UNION SQLi payloads requeire extra user-provided information to work. IF we cab manually fid the exatct number of columns of the vulnerable SQL query, we can provide this number to SQLMap with the option  --union-cols.
The def "dummy" filling values used by SQLMAP -NULL and random integer are not compatible with values form results of the vulnerable SqL query. [--union-char='a'].
Furthermore, in case there is a requirement to use an appendix at the end of a UNION query in the form of the FROM <table> (e.g., in case of Oracle), we can set it with the option --union-from (e.g. --union-from=users).

Exercise:
1. Case 5
sqlmap -r /home/../../..//c.txt --batch --dump -T flag5 -D testdb --no-cast --dbms=MySQL --technique=T --time-sec=10 --level=5 --risk=3 --fresh-queries

2. Case 6
sqlmap -r /home/../../../../c.txt --batch --dump -T flag6 -D testdb --no-cast --level=5 --risk=3 --prefix='`)'
3. Case 7
sqlmap -r /home/../../../../Case.txt --batch --dump -T flag7 -D testdb --no-cast --level=5 --risk=3 --union-cols=5 --dbms=MySQL

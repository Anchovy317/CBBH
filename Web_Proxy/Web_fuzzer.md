# Burp Intruder
Both Burp and ZAP provide addition ft other than def web proxy, wich are essential for web app penetration testing. Two os the most imp are the web fuzzers and web scanner.
The build-in web fuzzer are powerful tools that act was web fuzzing , enumeration, and brute-forc tools.
Burp web fuzzer is called Burp INtruder, and can be used to fuzz pages, directories, sub-domains, parameters, values, and many other things.
Though it is much more advanced than most CLI-based fuzzing tools.
## Target:
Start up and pre-configuration browser and then visit the web app form the exercise at the end of thos section, we ca proxy history then right click and select
Send to Intruder, or use [CTRL+I].
## Positions:
The secoend tab, is where we place the payload position pointer, which is the point where words from our wordlist will placed and interated over.
Whiich is similar to ffuf or gobuster.
To check whether a web directory exists, our fuzzing should be in 'GET /DIRECTORY/', such that existing pages would return 200 ok, otherwise we'd get 404 Not found.
We'll need to select DIRECTORY as the payload posotion, by either wrappiong it wiht § or selection the word DIRECTORY.

> [!TIP]
> The DIRECTORY in this case is the pointer nam, which can be anything, and can be used to refer to each pointer, in case we are using more then position iwht dff wordlists for each.
The final thingto select in the target tab is the Attack Type. The attack type defiines how may payload pointers are used and determinates which payload is assigned to which position.
we'll stick to the first type, Sniper, which uses only one position.
[burp](https://portswigger.net/burp/documentation/desktop/tools/intruder/configure-attack/positions#attack-type)
> [!NOTE]
> Be suere to leave the extra two lines at the end of the request, otherwise we may get an error response from the server.

## Payload:
We get to choose and customie our payloads/wordlist. Is what would interacted, over, and each element/line of it would be placed and tested one by one in the payload position.
Cofigure:
- Payload Sets
- Payload Options
- Payload Processing
- Payload Encoding

### Payload sets:
The first are the sets, for identifies the payload number, depending on the attack type and number of payloads we use in the payload psosition pointers.
We only have one payload set, as we choose the 'sneper' attack type with only one payload position. If we choose the 'Cluster Bomb' attack type, and add several payload posotion, we
should ger more payload sets to choose from dff options.
- Simple list: The basic and most fundamental type, we provide the wordlist, and intrude iterates over each line.
- Runtime file: Simple list, but loads line-by-line as the scan runs to avoid ecessive mamory usage by Burp.
- Character subtitution: Lest us specify a list of characters and their replacements, and Burp intruder trues all potencial permutation.

### Payloads options:
Must to specify the payload Option, which is dff for each payload type we select in Payload sets, simple list we have to create or load wordlist. We can input each item manually by clicking add,
which would build our wordlists on the fly, more common option is click on load, and the select a file to load int Burp Intruder.
We can add another wordlist manually add a few items, and they would be appended to the same list of items, we can use this to combine multiple wordlist or create customized wordlist.
Add from liust menu.
> [!TIP]
> For very large wordlist to use Runtime file as the Payload types instead os simple list, so that Burp Intruder won't have to load the entire wordlist advance, may throttle memory.

### Payload Processing:
Another option can we apply is Payload Processing, which allows us to determinate fuzzing rules over the loaded wordlist. If we wanted to add an extension after payload item, or we wanted
filter the wordlist based on specific criteria, we can do so with payload processing.
We can clicking on the Add button and then selection Skip od matches regex, wich allows  us to procvide a regex pattern for a items e want to skip.
![regex](https://academy.hackthebox.com/storage/modules/110/burp_intruder_payload_processing_1.jpg)

### Payload encoding:
Enabling or disabling a payload URL-encoding.
![url](https://academy.hackthebox.com/storage/modules/110/burp_intruder_payload_encoding.jpg)

## Options:
We can customize our attack options from the Options tab, there arte many options we can customize for attack [retried on failure and pause before retry].
Another useful option is the Grep-Match, which can enables us to flag specific requests depending on their responses, as we are fuzzing web directories, we are
only interated in the response is 200 OK. We'll first enable it and the click clear to clear the current list.
200 ok to match any requests with this string and click add to add the new rule.
![grep](https://academy.hackthebox.com/storage/modules/110/burp_intruder_options_match.jpg)
We may also utilize the Grep-Extract option, which is useful if the HTTP responses are lengthy, and we're only interested in a certain part of the response.
Try other Intruder option.
> [!NOTE]
> We may also use the Resource Pool tab to specify how much network resources intruder will use, which may be useful for very large attacks.

## Attack:
Not the everything is properly setup, we can click Start Attack and wait. These attack is very slow and take considerable amount of time.
We can also see the 200 ok column, which shows request that match the 200 ok grep value we specified in th options tab. We can click on the sort by it, such that we'll have matching results at thje top,.
We may now manually visit the page  <http://SERVER_IP:PORT/admin/>.


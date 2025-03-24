# Code Analysis:
After deofuscated the code we can find the secret.js file containing only one funtion generatedSeral.
## HTTP Request:
- Code variables:
The funtion starts by defininf a variable [xhr] which created an obj of XMLhttpRequest. As we may no know exactly what XMLHttpRequest does on JS, After second variable defined is the URL variable, which coanints a URL to /seral.php.

- Code funtions:
WE see that xhr.open is used with "POST" and URL. We can google this funtion once again, and we see that is opens the HTTP request defined  'GET or POST' to the URL. and the next line xhr.send  the request.
The developers may have implemented this funtions whenever they need to generated a serial, like when clicking on certain 'Generate Seria' button.
Since we did not see any similar HTML elementts thats generate serial, the developers must no have used this funtion yet and kept it for future use.
With the use of coed deofuscation and code Analysis, we were able to uncover this funtion, can now attemps to replicate its funtionality  to see and handle on the server-side ehwn sending post request.

- HTTP request:
We found out that the secret.js main funtions is sending an empty POST request to /seria.php we will attempt to do the same using curl to send POST request to /serial.php.
- Post request:
To send a Post request, we should add the -X POST flag to our commnad, and it should send a POST request.
`curl -s http://server-ip/ -X POST`
POST request usually conaintns POST data, we use -d ["param1=sample"] flag include our data for each parameter.

## Decocing:
We fot strange block of text that seems to be encoded.
```sh
 curl http://SERVER_IP:PORT/serial.php -X POST -d "param1=sample"
ZG8gdGhlIGV4ZXJjaXNlLCBkb24ndCBjb3B5IGFuZCBwYXN0ZSA7KQo=
```
This is another importatn aspect of obfuscation that we referred to in More Obfuscation in the Advanced Obfuscation section, many tech can futher obfuscate the code and make its less redeable by humands and less detecteable by systems.
Will very often find obfuscated code coataing encode text blocks that get decoded executionm.
Encoding methods:
- base64
- hex
- rot13

base64:
```sh
 echo http://hackthebox.eu/ | base64
aHR0cDovL2hhY2t0aGVib3guZXUvCg==
~
❯ echo aHR0cDovL2hhY2t0aGVib3guZXUvCg | base64 -d
http://hackthebox.eu/
```

### HEX
Another common encoding method is hex encoding, which encoded each character into uts hex order in the ASCII table.
- Spotting HEX:
Any string encoded in hex encoding, which encodes each character into its hex order in ASCII. Hex be comprised od hex charactes only, which are 16 chharacters only: 0-9 and a-f.
HEX:
For encode any string into hex use 'xxd -p' command
```sh
echo http://google.com | xxd -p
687474703a2f2f676f6f676c652e636f6d0a
```
Decode:
For decode using 'xxd -p -r'
```sh
echo 687474703a2f2f676f6f676c652e636f6d0a | xxd -p -r
http://google.com
```
### Caesar/Rot13
Shifting by 1 character makes a become b and b become c. The most common os rot13 13 times foward.
### Spootting Caesar/Rot13
This encoding method makes any text looks random example rot13, http://www becomes uggc://jjj, which still holds some resemblances and may be recognized as such.

```sh
❯  echo https://www.hackthebox.eu/ | tr 'A-Za-z' 'N-ZA-Mn-za-m'
uggcf://jjj.unpxgurobk.rh/
~
❯ echo uggcf://jjj.unpxgurobk.rh/ | tr 'A-Za-z' 'N-ZA-Mn-za-m'
https://www.hackthebox.eu/

```

### Other types of encoding:
These are the mis common sometimes we'll come across other encoding methods, which may require some experience  to identify an decode.
Tools:
Cipher identifier.



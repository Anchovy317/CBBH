# Intro to Web Proxies:
Testing web requests to backend servers make up  the bulk Web App Penteting, which includies concepts thats apply to both web and mobile app.
To capture  the rquests and traffic passing between app and backend maniputlate these types of requests purpouese, web proxies.

## What are Web proxies?
Tools that can be setup between a browser/mobile app and backend server to capture and view all the web request begin sent between both ends, essentially,
acting as man-in-the-middle tools. While other Net sniffing app, like wireshark, operate by analyzing all local traffic tro see whaty is passing through a net.
Web proxies are consider among the most essential tools for any pentest. Onece a web proxy is set up, we can see all the HTTP requests made by an app application and
all of the resposne sent by the backend.
We can intercept a specific request to modify its data and see how that backend server handles them.

## Uses of Web Proxies:
While the primary use of web proxies is to capture and replay HTTP requests, they have many other features that enable diff uses for web proxies.
- Web App vulnerability scanning
- Web fuzzing
- Web app mapping
- Web request analysis
- Web configuration testing
- Code review

### Burpsuite
Is the most common web proxy for web pentesting, it has ans excellent user interface ffor varius features and even provides a build-in Chromium browser to test app,
feture avaliable in the comercial version Burp/Pro Enterprise, but even the free version is an extremely powerfull testing tool to keep in our arsenal.
Some of the paid-only ft:
- Active web app scanner
- GAs intruder
- The ability to load certain Burp Extensions

## OWASP ZED ATTACK PROXY(ZAP):
Is another web proxy tool for web penetration testing, Zap is free open-source project initialited by Open web app security Project and maintained by the comunity, so it has
no paid-only ft like burp. ZAP provides varius basic and advance  features that can be utilized for web pentesting, also has certain strenghts over Burp, which we will cover throught
this module.

# Setting Up:
For setting up the Burpsuite u can dowlowad in the page [Burp](https://portswigger.net/burp/releases), and must dowload the java jar  `jave -jar <path/to/burpsite.jar>`
And for the [Zap](https://www.zaproxy.org/download/) and also the java jar command or by doble-cliclking.

# Proxy Setup:
On burpsuite u can go [Proxy>intercept] and open browser, In many cases we want to use a real browser pentest, to use firefox with our proxy tool, we must first configure
ot to use them as the proxy.
> [!NOTE]
> We wanted to serce the web proxy on dff port, we can do that in Burp unde [Proxy>Options] or in ZAP under (Tools>Options> Local proxies).
Instead os manually switching the proxy, we can utilizew the firefox extension [Foxy Proxy] to ez and quick change the firefox proxy.
Options foxy proxy url port 8080.
## Installing CA Certification
We must install this CA, if we dont do this set, some HTTPss traffic may not routed in  [http://burp], click generate Dynamic SLL Certification and generate.
- Ask every time and Querty OSCP responder servers to confirm the curretn validation of certificate.
An see the Certification manager and imort the ssl in authorities.
Finally must select Trust this CA to identify website and Trust this Ca to identify email user and click ok.

# Intercept Request:
In Burp wee can navigate to Proxy tab, and request ineterception should be on by def. Once we turn the request interception on we can start up the pre-configuration
browser an visit the target web after spawing it the exercise at the en of the section.
In ZAP we can CTRL+B to toggle ot on or off, zap has the ft called Heads Up Display(HUB) which allows us to control the most os the main ZAP features form right the pre-config.
We can choost the step to send the request and examine its resposne and break any futher requests, or we can choose to continue and le the page send the remaining request.
> [!TIP]
> First time to use ZAP will be present with HUB turtorial, may consider taking this tutorial after the section, as it will teach u the basic.

## Manipulatin Intercept Request.
Once we intercept the request, it will remain hanging until we foward it as we did above, we can examine the reques manipulate it to make nay changes we want, and then send its destinatin.
Numerous off apps for this web testing for:
1. Sql Injection
2. Command injection
3. Upload bypass
4. Autentication bypass
5. XSS
6. XEE
7. Error handling
8. Deserialization

Let us turn the request interception back on the tool of our choosing, ser the IP value on the page, then click ping button.
```js
POST /ping HTTP/1.1
Host: 46.101.23.188:30820
Content-Length: 4
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
Origin: http://46.101.23.188:30820
Content-Type: application/x-www-form-urlencoded
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
Referer: http://46.101.23.188:30820/
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9
Connection: close

ip=1

```
We can only specify numbers in the IP field using the browser, as web page prevents us from sendinf any non-numeric characters using Front-end JS.
With the power of intercepting and manipulating HTTP requests, we can try using other characters to "break" the app.

# Intercepting Responses:
We may need to intercept the HTTP response from the server before they  reach the browser, can be useful when we want to change how specific web page looks, like enabling certain
disabled field or showing certain hidden fields, which may hel to testing.

## Burp:
We can enable response interceptions byu going [Proxy>Options] and enabling Intercept Response under Intercept server Responses, after that we can enable the
request interception once more and refresh the page with [CTRL+SHIFT+R] in our browser. We should see the intercepted request, and we can click foward.IInro.md
Try to changing the type="number" on line 27 to type="text", which should enable to write any value we want.
And changing the maxlenght="3" to maxlenght="100".
```html
<input type="text" id="ip" name="ip" min="1" max="255" maxlength="100"
    oninput="javascript: if (this.value.length > this.maxLength) this.value = this.value.slice(0, this.maxLength);"
    required>
```
## ZAP
We can similarly use this feature to show all hidden fields or buttons. Burp also has a similar feature, which we can enable under Proxy>Options>Response Modification, then select one of the options, like Unhide hidden form fields.
Another similar feature is the Comments button, which will indicate the positions where there are HTML comments that are usually only visible in the source code. We can click on the + button on the left pane and select Comments to add the Comments button,
and once we click on it, the Comments indicators should be shown. For example, the below screenshot shows an indicator for a position that has a comment, and hovering over it with our cursor shows the comment's content.

# Automatic Request Modificaton:
We can choose to match any text within any text our requets, either in the request header or request body, and then replace them with diff text. Les replace our User-Agent with HackTheBox Agent 1.0, which may be handly in case where we may be dealing with filters that block
certain User-Agents.

- Burp Match and Replace:
[Proxy> Options> Match and Remplace] and click on Add in Burp.
![Match and Replace](https://academy.hackthebox.com/storage/modules/110/burp_match_replace_user_agent_1.jpg)

- Type Request header: Since the change we want to make wll be inthe request header and not its body
- Match: ^User-Agent.*$ : The regex pattern that matches the entire line with User-Agent in it.
- Replace User-Agent: Htb agent 1.0: This is the value thay will remplace the line we mathced above.
- Regex match: True: We don't know the exact User-Agent string we want to replace, so we'll use regex to match any value thaty matches the pattern we specified above.

One we enter the above options and click OK, our new Match Remplace option will be added and enanbled and wll start auto remplacing the User-Agent header in our
request with our new User-Agent.

![User-Agent](https://academy.hackthebox.com/storage/modules/110/burp_match_replace_user_agent_2.jpg)

## Automatic response modification:
The same concept can be used with HTTP responses as well, previous you may have noticed when we intercepted the responses that the modification
we made to OP field were temporary and were not applied when we refreshed the page unless wee intercepted the response and added them again.
Let us go back [Proxy>Options> Match and Replace] in Burp to add another rule. This time will use the type os [Response body] since the change
we want to make exists in the response's body and not in the headars.
![Response](https://academy.hackthebox.com/storage/modules/110/burp_match_replace_response_1.jpg)

Once we refesh the page with [CTRL+SHIFT+R], see that we can add any input to the input field, and this should persist between page refreshes as well.

# Repeating Request:
In the previous sections, we bypassing th input validation to use a non-numeric input to reach command injection on the remote server, if we would do this for each command, it
would take us forever to eneumerate a system, as each command would require  5-6 steps to get executed.
- Proxy History:[Proxy>HTTP History]
In ZAP HUB, we can find it the bottom History pane or ZAP's main UI at the bottom History as well.
Both tools also provide filtering and sorting options for requests history, Try to see how filters work on both tools.
> [!NOTE]
> Both tools maintain WebSockets history, which shows all connectction intiated by the web app even after begin loaded, like asysnchornous update and data fetching, WebSockets can be
> useful when performing advanced web penetration testing, and are out of the scope o this module.

- Repating Requests:
Burp; once locate the request we want to repeat, we can click [CTRL+R] and navigare to the Repeater tab or click [CTRL+SHIFT+R] to go it directly.
> [!TIP]
> We can also right-click on the request select Change Request Method to change the HTTP Method between POST/GET without having to rewrite the entire requests.

Let us to modify our request and send, in all options, we see that the requests are modifiable, and we can select the text want to change and replace it with we want, and
then click the Senf button:
![rep](https://academy.hackthebox.com/storage/modules/110/burp_repeat_modify.jpg)

# Encoding/Decoding:
As we modify asn send custom HTTP requests, we may have to perform varius  tpes of encoding and decoding to interact with the webserver properly.

- URL Encoding:
It's essential to ensure thaty our request data is URL-encoded and our request headers are correctly set, we may get a server in the response, this
is why encoding and decoding data becomes essential as we modify and repeat web request.
 - Spaces: May indicate the end of request data id not encoded
 - &: Otherwise interpreted as a parameter delimiter.
 - #: Otherwise interpreted as a fragment identifier.

To URL-encode text in Burp Repeater, we can select that text and right-click on it, then select[Convert>Selection>URL>URL encode key characerts]. or by
selecting the text and clicking [CTRL+U].

- URL Decoding:
Is no the only type of encoding we will encounter, is very common for web-app to encode their data, so we should be able quickly decode that data to examine the original text.
Back-end servers may expected data to be encoded in a particular format or with spacific encoder, se we need able to quickly encode.
Tools:
    - HTML
    - Unicode
    - Base64
    - ASCII Hex
To access the full encoder in burp, we can go to the decoder tab. Decode as > Base64. We can also use the Burp Inspector tool to perform encoding and decoding which
can be found in varius places like Proxy or Repeater.

- Encoding:
The text holds the value {"username": "guest", "is_admin": "false"}, if we were performing a penetration test on a web app and find that the cookie holds this value , we may want
to test modifying it to see changes our user privilege.
change guest to admin and false to true, and try to encode it again using its original encoding method (base64):
![Burp](https://academy.hackthebox.com/storage/modules/110/burp_b64_encode.jpg)

> [!TIP]
> Decoder output can ve directly encoded/decode with dff encoder, select the new encoder method in the output pane at the bottom, and it will be encoded/decoded.

# Proxying Tools


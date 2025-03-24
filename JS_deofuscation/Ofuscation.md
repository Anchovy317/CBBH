# Content moduele:
1. Locatoion Javascript code.
2. Intro to code ofuscation.
3. How to desofuscation JS code.
4. How to decode encode messages.
5. Basic code Analysis.
6. Sending basic HTTP requests.

## Source code:
Most of the websites utilize JS to perform their funtion, while [HTML]  is used to determinate the website main fields and parameter, and CSS is used
to determinate its design, JS is used to perform  any funtion necessary to run the website.
Even though all of this sorce code is avaliable at the client-side, it's rendered by our browser, so we dont not often pay attention to the HTML sorce code.

## Code Obfuscation:
Dessofuscation, we must first learn about code Obfuscation,
- What is obfuscation:
Is a technique used to make script more diff to read by hummans but allows it to funtion the same form a technical poiunt of veiw, though  permformace mat be slower.
This is usually achived automatically by using ofuscation tool, which takes code as an input, and attempts to re-write the code on way that is much more diffcilt to read.
Code ofuscators often turn the code into a dictionary of all the words and symbols used within the coode and them attempts to rebuild the original code during the execution
by referring to each word and symbol from the dictionary.
![Example](https://academy.hackthebox.com/storage/modules/41/obfuscation_example.jpg)


- Uses  cases:
One common  reasin is to hide the original code and its funtions to prevent it from begin reused or copied without the developers permission.
Another reason is to provide a security layer when dealing with auth or encryption to prevent attacks on vulnerabilities.
[It must be noted that doing auth or encryption on the client side is not recommended, as code is more prone to attacks this way.]
The most  common usage of obfuscation, is for malicius actions, its common for attackers and malicius actors to obfuscate their malicius  scripts
to prevent intrusion Detection and Prevention systems form detecting their scripts.

### Basic obfuscation:

As there many tools for various lenguages that do automated code obfuscation. like [JSconsole](https://jsconsole.com/).
- Minifying JS code:
A common way reducing the readability of snniped of JS code while keeping  it fully funtional is JS minification. Code minification means having the entire code in a single
line. code miinification is more useful for longer code, as if our code only consider od single line.
[minifier](https://www.toptal.com/developers/javascript-minifier)
Is saved with the extension .min.js.

> [!NOTE]
> Code minification is not exlusive to JS. and can be applied to mant other lenguages as can be seen in javascript-minifier.

- Packing JS code:
Lets obfuscarte our line of code it more obcuer and diff to read, firts try [Beautytool](https://beautifytools.com/javascript-obfuscator.php)
```js
eval(function(p,a,c,k,e,d){e=function(c){return c};if(!''.replace(/^/,String)){while(c--){d[c]=k[c]||c}k=[function(e){return d[e]}];e=function(){return'\\w+'};c=1};while(c--){if(k[c]){p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c])}}return p}('5.4(\'3 2 1 0\');',6,6,'Module|Deobfuscation|JavaScript|HTB|log|console'.split('|'),0,{}))
```
Then see that our code became mus more ofuscate and diff to read, we can copy and run in jsoncosole, to verify that it still does it main funtion:

> [!NOTE]
> Note: The above type of obfuscation is known as "packing", which is usually recognizable from the six function arguments used in the initial function "function(p,a,c,k,e,d)".

A packer obfuscation tool usually attempts to convert all word and symbol of the code into a list or dictionary and then refer to them using the [p,a,c,k.e] can be diff  from one packer to another.
While packer does a great job reducing  the code's readbility, we can see its main string written in clear text, which may reveal so its funtionality.

## Advanced Obfuscation:
The code still contains strings in cleartext, which may reveal its original fntioanlality.
- Obfuscator:
[obfuscator.io](https://obfuscator.io/) We change the encoding to Base64 as see bellow, and click obfuscate.

This code is obviulsly more obfuscated, and we can't see any remmants of our original code, we can now try to running it in jsoncosole to verify that is still perform its oroginal funtons. PLaying with
obfuscate setting in obfuscate.io to generate even more obfuscated code, an then try rerunning it in jsoncosole to verify it still perfrom.
Now we should have a clear idea of how code obfuscation works. there are still many variations of vcode obfuscates the code differently takes:
> [!NOTE]
> The above code was snniped as the full code is to long, but the full code should successfully run.

Using thje same tool in JSF, and then rerunning it, we'll notice that the code may take some time to run, which shows how code obfuscation could affect the performance.
Other tools for obfuscators.
[JJencoded](https://utf-8.jp/public/jjencode.html)
[AA Encoded](https://utf-8.jp/public/aaencode.html)

## Deobfuscation;
- Beautify:
Current code we have is all written in a single line, this know as [minifier] js code. In oreder ot properly format the code we need to Beautify our code. The most basic method for doing si is thorugh our browser dev tool.
If we were using firefox, we can open the browser debugger, and then click on our script secret.js, this show the script in its original formatting.
- Deobfuscate:
We can find many good tools to Deobfuscation hs code and turn into something we can understand, good tool is [UnPacker](https://matthewfl.com/unPacker.html)
> [!TIP]
> Ensure u dont not leave empty lines before the script, as it may affetct the deofuscated code and run Unpacker by click unpack.

Another way of unpacking such code is find return value and used cosole.kig to print.
Secure coding 101 information.


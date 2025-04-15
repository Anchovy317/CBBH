# Introduction:
Server-side includes SSI is a technology web app use to create dynamcally content on HTML pages. SSI is supported by many popular web servers suas as Apache and ISS.
The use of SSI can oftenbe inferred form the file extension. Typical file extesion include .shtml, shtm, and .smt. We server can be configured
to suppoert SSI directivees in arbitrary file extension. We cannot coclusively conclude whether SSI is used only from the file extesion.

- Ssi Directives:
SSI utilize directives to add dynamically generated to static HTML pages. These directives consist of the components:
    - name: directive name
    - parameter name: one or more parameters
    - Value: one or more parameter values
An SSI directieve has the following syntax:
`<!--#name param1="value1" param2="value" --> `

- printenv:
This directive prints environment variable, it does not take any variable:
`<!--#printenv-->>`
- config:
This directive changes the SSI configuration by specifying corresponding parameters. It can be used to change the error message using the [errmsg] parameter:
`<!--#config errmsg="Error!"-->>`
- echo:
This directive prints the value of any variable given in the var parameter. Multiple variables vn be printed by specifying multiple var parameters:
    - DOCUMENT_NAME: current file name.
    - DOCUMENT_URL: Current file's url
    - LAST_MODIFIED: timestamp of the last modification of the current file
    - DATE_LOCAL: Local server time

`<!--#echo var="DOCUMENT_NAME" var="DATE_LOCAL" -->`

- exec:
This directive executes the command given in the cmd parameter:
`<!--#exec cmd="whoami" -->>`

- Include:
This directive includes the file specified in the virtual parameter. Only allows for the inclusion of files in the web root dir.
`<!--#include virtual="index.html" -->>`

- SSI Injection:
This injection occurs when an attacker can inject SSI directives into that is subsequently served by the web server, resulting in the execution of the injected SSI directives.
This scenario can occur in a variaty of circustances, when the web app contains a vulnerable file upload vulnerability that enables an attacker to upoad the file containg maliciuos
SSI directives into the web root dir.

# Explotation SSI INjection:
Information on page [/page.shtml] whcih display some general information:
We can guess that the page supp SII based on the file extension. Our username is inserted into the page without prior sanitization, it might be
vulnerable to SSI injection. Confirm this by providing a user of `<!--#printenv-->>`.
The directive is executed, and the environment variable are printed. We have successfully confirmed and SSI injection vulnerability. Let us confirm that we can execute arbitrary commands
using the exec directive by providing the username `<!--#exec cmd="id" -->>`
Exercise: Exploit the SSI Injection vulnerability to obtain RCE and read the flag.
`<!--#exec cmd="cat ../../../flag.txt"-->`

- Preventing SSI INjection:
As with any injection, developers must carefull validate and sanitaze user input to prevent SSI. This is pariticulary important when the user input is used within SSI directives or written
to file that may contain SSI directives according to the web server configuration. It's vital to configuration the web server to restric the use of SSI to particular  file extension and potentially
directories.
Might possible to turn off the [exec] directive.

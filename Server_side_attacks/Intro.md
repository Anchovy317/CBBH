# Intro:
Server side attacks target the app or service provided by a server, wherareas a client-side attack takes place at the clint's machine, not the server iself.
For instances, vulnerabilities like Cross-Site(XSS) target the web browser, the client. Server-side attacks target the web server.
Classese:
- Server-side Request Forgery(SSRF)
- Server-side Template INjection (SSTI)
- Server-side INcludes (SSI) Injection
- Extensible Stylesheet languages Traformation (XLST) Server-side injection

## Server-side Request Forgery (SSRF):
Is a vulnerability where an attacker can manipulate a web app intop sending unathorized requests from the server, This vulnerability often occurs when an app makes HTTP request to other
servers, can enable an attacker to access internal system, and retive sensitive information.

## Server-side Template Injection (SSTI):
Web app can utilize templating engines and server-side  templates to generate responses sua as HTML content dynamically. This generation is often based on user input, enblaging the web app to respond
to user input dynamically.

## Server-side Inclides (SSI) Injection:
Similar to server-side templates, includes SSI can be used to generate HTML responses dynamically, SII directives instruct the web server to include additional contetn dynamically. These
directives are embedded into HTML files. SSI can be used to include content that is present in all HTML pages, such as headers or footer.

## XSLT Server-side Injection:
Server-side injection is a vulnerability that arise when an attacker can manipulate XSLT Traformation performated on the server. XSLT is a languafes used to trafrom XML documents into other
formats, such as HTML, and is commonly employed in web app to ghenerate content dynamically.


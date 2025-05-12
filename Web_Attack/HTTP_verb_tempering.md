# Introduction:
As web app are becoming very common and beggin utilize for most businessnes, the importance of protecting them against malicius attaks also become more critical, AS modern web app become more complex and
advanced, so do the types of attacks utilized against them. This leads to a vast attack surface for most bussiness today, which is why web attacks are the most common types of attacks against companies.
- Web Attack:
    - HTTP Verb Tampering:
    The first web attack discussed in this module is Http Verb tempering, this attaack exploits web servers that accept many http verbs and methods. This can be exploted by sending malicius requests using unexpected methods,
    which may lead to bypassing the web app auth mechanims or even bypassing its security controls against other web apps, HTTP Verb tampering attacks are ont of may others HTTP attacks that can be used to exploit
    web server configuration.
    - Insecure Direct Obj References(IDOR):
    The second attack discussed in this module is Insecure Direct Object References, is among the most common web vulnerablilities and can lead to accessing data that should not be accessible by attackers. What  makes this attacks very common
    is essentially that lack of a solid access control system on the back-end.
    As web app store files and information, they may use sequential numbers or user IDs to identify each item. Suppose the web app lacks a robust access control mechins and exposes direct references to files and reources.
    - XML External Entity XXE Injection:
    Many web apps process XML data as part of their funcionality. Supose a web app utilizes outdate XML libraries to parse and process XML input data from the front end user.
    These files may be configuration file that may contain sensitive information like pass or even the source code.

# Insecure Direct Object References:
The HTTP protocol works by accepting varius HTTP methods as verbs at the beginning og an HTTP requests. Depending on the web server configuration, web app may be scripted to accept certain HTTP methods for their varius funtionalities and perform a particular action based
on the type of the requests.
While programmers mainly consider the two most commonly uyser HTTP methods, GET and POST, any client can send any other methods on their HTTP requests and then see how the web server handlers these methosds, suppose both the web app and the back-end web server are
configured only to accept GET and POST request.

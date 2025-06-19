# Introduction to Web Servicie and APIs:

Web services provide a standard means of interoperating between diffenent sofware app, running on a variety of platforms and frameworks. Web service
are characterixed by their interoperability and extensibility, as wll as their machine-processable desciption to use of XML.

Web Services enable apps to comunicate with each other. The app can be entirely diffenent. Scenario:
1. One app written in Jave is running on a Linux host and is using an Oracle db.
2. Another app written is C++ is running on  a Windows host and is using a SQL Server DB.

An app programming interface API is a set of rules that enables data transission btw diffent sofware. The tech specification of each API dictates the data exchanges.
Consider the Example:
A piece of sofware needs to access the info, such as ticket prieces for specific dates. To obtain the requiered information, it'll make a call to the API
of another sofware. The other sofware will return any data/funtionality requested.

The interface thourgh which these two pieces of sofware exchanges data is what the Api specifies.
- Web services vs API:
The  Web services and app programming interface (API) should not be used intechangeably in every case.
    - Web Services are  a type of apps programmin interfaves (API). the Opposite is not always true.
    - Web Services need a network to archieve their obj. APIS can archieve thir goal even offline.
    - Web Services rerely allow external dev access, and there are a lot of APIs that welcome external dev thinkering.
    - Web Services usually utilize SOAP for security reasons. APis can be found using diferents designs, such as XML-RPC, JSON-RPC, SOAP, and REST.
    - Web Services usually utilize the XML format for data encoding. APis can be found using diffents formats to store data, wiht the most popular JS Obj Notations(JSON).

- Web Service Approaches/Tech:
1. [XML-RPC](https://xmlrpc.com/spec.md) uses XML for encoding/decoding the remote procedure call (RPC) and the respective parameter(s). HTTP is usually the transport of choice.
The payload in XML is essentially a single <methodCall> structuere, <methodCall> should contain a <methodName> sub-item, that is related to the method to be called.
The <methodCall> must contain a <params> sub-item.
```html
  --> POST /RPC2 HTTP/1.0
  User-Agent: Frontier/5.1.2 (WinNT)
  Host: betty.userland.com
  Content-Type: text/xml
  Content-length: 181

  <?xml version="1.0"?>
  <methodCall>
    <methodName>examples.getStateName</methodName>
    <params>
       <param>
 		     <value><i4>41</i4></value>
 		     </param>
		  </params>
    </methodCall>

  <-- HTTP/1.1 200 OK
  Connection: close
  Content-Length: 158
  Content-Type: text/xml
  Date: Fri, 17 Jul 1998 19:55:08 GMT
  Server: UserLand Frontier/5.1.2-WinNT

  <?xml version="1.0"?>
  <methodResponse>
     <params>
        <param>
		      <value><string>South Dakota</string></value>
		      </param>
  	    </params>
   </methodResponse>
```


2. JSON-RPC:
The [JSON-RPC](https://www.jsonrpc.org/specification) uses to involke funtionality. HTTP is usually the transport of choice.

```html
  --> POST /ENDPOINT HTTP/1.1
   Host: ...
   Content-Type: application/json-rpc
   Content-Length: ...

  {"method": "sum", "params": {"a":3, "b":4}, "id":0}

  <-- HTTP/1.1 200 OK
   ...
   Content-Type: application/json-rpc

   {"result": 7, "error": null, "id": 0}
```

The {"method": "sum", "param":{"a":3, "b":4, "id":0}} obj is serialized using JSON. Note three properties: [methods, params and id.method] contains the name of the method to involke.
[Param] contains an array carrying the argument to be passed, the id contains an identifier established by the client.

3. SOAP [Simple Object Access Protocol]:

SOAP is also uses XML but provides more funtionalities than XML-RPC, SOAP diefines both header structure and a payload  strucuture. The former identifies the action
that SOAP nodes are expected to take on the message, while the latter  deals with the carried information. A Web Service Language(WSDL) declaration is optimal.
The WSDL specifies how a SOAP Services can be used. Anotomy of a SOAP Message:
- soap:envelope: Require block tag to differenruate SOAP from normal XML. This tag is requires a [namespace] atribute.
- soap:header: Optional block - Enables SOAP's extensibility through SOAP module.
- soap:body : Required block - Contains the produre, parameters, and data.
- soap:Fault: Optional block - Used within soap:body for error message upon a failed API call.

```http
  --> POST /Quotation HTTP/1.0
  Host: www.xyz.org
  Content-Type: text/xml; charset = utf-8
  Content-Length: nnn

  <?xml version = "1.0"?>
  <SOAP-ENV:Envelope
    xmlns:SOAP-ENV = "http://www.w3.org/2001/12/soap-envelope"
     SOAP-ENV:encodingStyle = "http://www.w3.org/2001/12/soap-encoding">

    <SOAP-ENV:Body xmlns:m = "http://www.xyz.org/quotations">
       <m:GetQuotation>
         <m:QuotationsName>MiscroSoft</m:QuotationsName>
      </m:GetQuotation>
    </SOAP-ENV:Body>
  </SOAP-ENV:Envelope>

  <-- HTTP/1.0 200 OK
  Content-Type: text/xml; charset = utf-8
  Content-Length: nnn

  <?xml version = "1.0"?>
  <SOAP-ENV:Envelope
   xmlns:SOAP-ENV = "http://www.w3.org/2001/12/soap-envelope"
    SOAP-ENV:encodingStyle = "http://www.w3.org/2001/12/soap-encoding">

  <SOAP-ENV:Body xmlns:m = "http://www.xyz.org/quotation">
  	  <m:GetQuotationResponse>
  	     <m:Quotation>Here is the quotation</m:Quotation>
     </m:GetQuotationResponse>
   </SOAP-ENV:Body>
  </SOAP-ENV:Envelope>

```

> [!NOTE] May accross slightly diff SOAP evelopes. Their anatomy will be the same.

3.  WS-BPEL(Web Services Business Process Execuition Language):

- Web services are essentially SOAP Web Services with mor funtionality for describing and incolking Business processed.
- WS-BPEL web services heavily resemble SOAP services. They will not be included in this module's scope.

4. RESTful (Representational State Transfer):

- REST web services usually use XML or JSON. WSDL declarationns are supp but uncommon. HTTP is the transport of choice, and HTTP verbs are used to access/change/delete resources and use data.

```http
  --> POST /api/2.2/auth/signin HTTP/1.1
  HOST: my-server
  Content-Type:text/xml

  <tsRequest>
    <credentials name="administrator" password="passw0rd">
      <site contentUrl="" />
    </credentials>
  </tsRequest>

    --> POST /api/2.2/auth/signin HTTP/1.1
  HOST: my-server
  Content-Type:application/json
  Accept:application/json

  {
   "credentials": {
     "name": "administrator",
    "password": "passw0rd",
    "site": {
      "contentUrl": ""
     }
    }
  }


```



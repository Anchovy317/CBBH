# Backend Servers:
A Backend server is the hardware and OS in the back en the hosts all tge app necessary to run the web app, The backend server  would
fit in the Data Access Layer(DAL):
Is a part of sofware arch that acts as an intermediaty between the app and database. It handle all the operations realate to retrievig,
inserting, updating and deleting data.
- What is does:
    - Abstraction: Hides the complexity of database queriesm so ur amin app logic doesn't deal with SQL directly.
    - Security: Help to sanitaze inputs to prevent SQL injection and other attck.
    - Maintanability: Makes the code base cliear and ez to modify if changes databses.
    - Performance Optimization: Can handle caching or batching queries to speed thigs up.

## Software:
![Exp](https://academy.hackthebox.com/storage/modules/75/backend-server.jpg)

Other sofware components on the back end server may incude hypervisions, containers and WAF.
There are many popular combinations of 'stacks' for the backend complements. Somo common include:

| Combination   | Components|
|--------------- | --------------- |
|  LAMP   | Linux, Apache, MySQL and PHP   |
|WAMP   | Windows, Apache, MySQL and PHP   |
| WINS   | Windows, IIS, .NET and Sql Server   |
| XAMPP   | Cross-Platafrom, Apache, MySQL, PHP/PERL|
| MAMP |macOS, Apache, MySQL and PHP|

## Hardware
The backend server contains all od the necessary hardware. The power performance capabilities of this hardware determine how stable and responsive
the web app will  be. Many arch especially for huge web app, are designed to distribure thier load over many backend server that collective work
together to perform the same taks and deliver the web app to the end user.

# Web Servers:
Is a app that runs on the backend server, which handles all the HTTP traffic  form the client-side browser, routes it to the requested pages, and finally
responds to the client-side browser, routes it to the requestd pages, and finally responds  to the client-side browser.
TCP ports 80 and 433, and  are reposible for connection end-users to varius part of the web app, in addition to handling their varios responses.

## Workflow:
A typical web accpets HTTP request from the client-side, and responds with dff http responds with dff HTTP responses and codes, like a code 200 OK responsew for
successful reques, a code 404 NOT FOUND when requesting pages that do not exist, code 403 FORBIDDEN for requesting access to restricted pages.
![EXP](https://academy.hackthebox.com/storage/modules/75/web-server-requests.jpg)

All the HTTP status code:

- 1xx Informational Responses:

100 Continue: Server recieved request header; client can proceed with sending the body.
101 Swithching Protocolos: Server Swithching to diff protocol.
102 Processing: Server recived and is processing the request.
103 Early Hints: Potencial response.

- 2xx Success:

200 ok: Request successful
201 Created: Resource successfully created
202 accepted: Request accepted but not yet processed.
203 Non-Authoriztative Information: Response from thrid-Party, not original server.
204 No Content: Request processed, but no content return.
205 Reset Content: Request procesed, client should reset view.
206 Partial Content: Server returns only part of the requested resources
207 Multiple-Status: Multiple response codes dor multiple opeations.
208 Already Reported: Resources Already reported in the response.
226 IM used: Server completed request, using interface manupulations.

- 3xx Redirection:

300 Multiple choices: Multiple options for resources; client must choosen one.
301 Moved Permanently:  Resorce moved; use new URL.
302 Found; Resource temporaly moved
303 See other; redirect another resource using get request.
304 Not Modified; Cached resource is still valid; not nee to redownload.
305 Use Proxy; reource only accesible through a proxy.
306 USed Previusly used now reserverd.
307 temporaly redirect; by keep original HTTP method.
308 Permanent Redirect, keeping the original HTTP.

- 4xx Client error:

400 Bad Request: Maformed or invalid request systax.
401 Unauthorized: Auth required or fail.
402 Payment Required: Reserved for future use.
403 FORBIDDEN: Server understoond the request.
404 Not Found: Request rource doesent exist.
405 MEthod not allowed: HTTP method no supported for the resources.
406 Not Aceptable: Resource can't generate content acceptable to the client.
407 Proxy auth required: must auth with proxy.
408 Request timeout: sercer timed out waiting for the request.
409 Conflict: Conflict with current server.
410 Gone: resources Permanently deleted and not coming back.
411 Lenght Required: Content-Lenght header missing but required.
412 Precondition failed: Server condition in headers not met.
413 Payload too large: request entity is too large for the server to handle.
414 Url to long: Url is too long for the server to process.
415 Unsopported Media Type: Reque's media type is unssopported.
416 Range not Satisfiable: Requested range cant be fullfulled.
417 Expectation Failed: Server cant meet the requerements of the Expect header.
418 IM a teapost easteregg
421 Misderected Request: Resquest sent to the wrong server.
422 Unprocessable Entity: Server Understand reques, but it's invalid.
423 Locked
424 Faild dependency: Request due toa failed dependency
425 To early: Server wont process request to prevent replay attacks.
426 Ugrade required: Requires client to upgrade to dff protocol.
428 Precontidion Required: Server requires certain conditions
429 Too many request
431 Request Header fields too large: request header to big.
451 Unavailable for legal resons.


- 5xx Server Errors:

500 Interact Server error: Generic server error.
501 Not implemented: Server doesn't supp the requested method.
502 Bad Gateway: Server an invalid response from upstream.
503 Service Unavaliable.
504 Gateway Timeout.
505 HTTP version not supp.
506 Variant also Negotiate miscofiguration.
507 Insufficient Storage: store the representation.
508 Loop detected: infinite loop
510 Not extended: Server need mor extensions to fulfill
511 Network Auth required.

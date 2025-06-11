# Introduction to Session:
A user session can be defined as a sequence of request originating from same client and the associate during a specific time period. Modern web web app need to maintain
user sessions to keep track information and status about each user.
User session facilities the assigment of access or auth rights, localization...

HTTP is a stateless community protocol, and as such any request-response trasaction is unralated to other trasition. This means that each request should carry
all needed information for the server to act upon it appropriately, and the session state reside on the client's side only.

- Session identifier Security;
A unique session identifier or token is the basic upon which user session are generated and distinguisjed. We should clarfy that if an attacker obtains a session identifier a multiple tech:

1. Captured though passive traffic/racket sniffing.
2. Identified in logs.
3. Predicted.
4. Brute force.



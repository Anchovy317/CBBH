# What's Authentication:
Is define as "The process of verifying a claim that a system entity or system has a certain attribute value" in [RFC 4949]. In information security, auth is the
process of confiming an entity's identity, ensuring they are who they claim to be. ON the other hand, auth is an "aproval that is garanted to a sysytem entity to access
a system resources"; while this module will no cover auth deeplu, understanting the major difference between it and auth is vital to approach
this module with the appropiate mindset.

Auth is probably the most widespread security measure and the first defense against uanthorized access, As web appp penetration testers, we aim to verify if auth is implement
securily. This module will focus on varius explotation methods and tech against login form to bypass auth and gain unaunthorized access.

- Common Authentication Methods:
Information technology systems can implement diffent auth methods. They can be devided into the following three major categories:
    - Knowledge-based Authentication
    - Ownership-based Authentication
    - Inherence-based Authentication

- Knowledge:
Auithenticathic based on Knowledge factotrs relies on something that the user knows  to prove their identity. The user provides information such as pass, passphrarse, PINs, or answer to security questions.

- Ownership:
Authentication based on ownership factors on something the user possesses. The user proves their identity by proving the ownershup of physical or device, such as ID cards, security tokens, or smartphones
Authentication apps.

- Inherance:
Authentication based on inherance factors relies on something the user is or does. This include biometric factors such as fingerprint, facial patterns, and voice rocognition or signatures.
Biomethic auth is highly effective since biometric traits are inherently tied to an individual user.

- Single-Factor Auth vs Multi-factor Auth:
Single-Factor auth reiles solely on a single methods, password solely relies on Knowledge of the password, it's a single-factor authentication method.
Multi-factor [MFA] involbves multiple auth methods. If a web app requires a pass and time-based one-time pass (TOTP), it relies on Knowledge of the pass and ownership of the TOTP decive
for auth.

# Attacks on Authentication:
- Attacking Knowledge-based Authentication:
Knowledge-based auth is prevalent and comparatively ez to attack. We'lll mainly focus on Knowledge-based auth in this module. This methos suffers form relience on static personal indormation that
can be potential obtained, or brute-forced. Attackers have become adept at explotating weaknesses in Knowledge-based auth systems through varius means including social enginieering and data breaches.

- Attacking Ownership-based Authentication:
One significant of Ownership-based aith is tis reistance to many common cyber threats, suach as phising or pass-guessing attacks. AIthentication methods bassed on pysical posession, such as hardware tokern or smarts
cards, are inherentlyu more secure. This is cause physical item are more difficult for attackers to acquiere or replicate compared to information that can be phisied, or obtained though data breaches. Challenges sua as the cos and
logistics of ditributing managing physical tokens or devices can somethismes limit the wedies spread adoption of Ownership-based auth, paroculaly in large-scale deployments.

- Attacking Inherence-based Authentication:
Provides convenience and user-fiendliness. User don't need to remeber complex pass or carry physical tokensm, they simply provide biometric data, such as fingerprint or facial scan. This streamlined auth process
enharaces user experience and reduces the likelhood of security breaches resulting form weak pass or stole token. Biometric [article](https://www.vpnmentor.com/blog/report-biostar2-leak/)


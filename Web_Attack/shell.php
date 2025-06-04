<?php
if(isset($_GET['content'])){
 error_log("\n\n" . base64_decode($_GET['content']));
}
?>

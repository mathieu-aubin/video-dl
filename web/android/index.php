<?php
header('HTTP/1.1 301 Moved Permanently');
if($_GET['url'] != "") {
header("Location: http://video.daniil.it/?url=$_GET['url']"); 
} else header('Location: http://video.daniil.it/'); 
?>

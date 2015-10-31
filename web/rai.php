<?php
$url = 'http://video.daniil.it/?url='.$_GET['url'];
header("HTTP/1.1 301 Moved Permanently"); header("Location: $url"); 

?>


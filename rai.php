<!DOCTYPE HTML> 
<html>
<head>
</head>
<body bgcolor="#FF66FF"> 
<form method="get" action="#"> 
  <b><center><i>Type (or paste) in the video URL: <input type="text" name="url" value="">
</i></center></b>
  <br><br>
</form>
<?php
if(isset($_GET['url'])) { 
    $url = ($_GET["url"]);
    $message = shell_exec("/var/www/rai-php.sh $url");
    print_r($message);
}
?>

<p align="right"><i><a href="https://github.com/danog/rai.tv-bash-dl">Source on Github</a></i></p>
</body>
</html>

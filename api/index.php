<?php
// Video download script, php version - Copyright (C) 2015 Daniil Gentili
// This program comes with ABSOLUTELY NO WARRANTY.
// This is free software, and you are welcome to redistribute it
// under certain conditions; see https://github.com/danog/video-dl/raw/master/LICENSE.

ini_set("log_errors", 1);
ini_set("error_log", "/tmp/php-error_api.log");
error_log( "Hello, errors (api)!" );

if(($_GET['p']) == 'websites') {
    echo "Rai, Mediaset, Witty TV, LA7 and all of the websites supported by youtube-dl.";
} elseif(($_GET['p']) == 'allwebsites') {
    $yt = shell_exec('youtube-dl --list-extractors');
    echo "rai.it
video.mediaset.it
wittytv.it
la7.it
$yt";
} elseif((isset($_GET['url']) && $_GET['url'] != "") || php_sapi_name() == "cli") {
/*    $locale = 'it_IT.utf-8';
    setlocale(LC_ALL, $locale);
    putenv('LC_ALL='.$locale);
*/
    include 'db_connect.php';
    $pdo = new PDO("$db", "$user", "$pass");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
    $url = $_GET["url"];
    
    
    $stmt = $pdo->prepare('SELECT final FROM video_db WHERE url  = :url');
    $stmt->bindParam(':url', $url, PDO::PARAM_STR);
    $stmt->execute();
    $final = $stmt->fetchColumn();
    
    error_log("$final");
    if (empty($final) || "$final" == "") {
     $param = $_GET["p"];
     $db = $_GET["nodb"];
     $cmd = "bash /var/www/video/api/api.sh".' '.escapeshellarg($url).' '.escapeshellarg($param).' '.escapeshellarg($db);
     $message = shell_exec("$cmd");
     $final = preg_replace("/(^[\r\n]*|[\r\n]+)[\s\t]*[\r\n]+/", "\n", $message); 
     $final = trim($final, "\n");
     if ($final != "") {
      echo "$final";
      $stmt = $pdo->prepare("INSERT INTO video_db (url, final) VALUES (?, ?)");
      $rows = $stmt->execute(array($url, $final));
     } else {
      $cmd = "bash -x /var/www/video/api/api.sh".' '.escapeshellarg($url).' '.escapeshellarg($param).' '.escapeshellarg($db)." 2>&1";
      $message = shell_exec("$cmd");
      $error = preg_replace("/(^[\r\n]*|[\r\n]+)[\s\t]*[\r\n]+/", "\n", $message); 
      $error = trim($error, "\n");
      $to = 'daniil.gentili.dg@gmail.com';
      $headers = "From: noreply@daniil.it\n";
      $email_subject = "Video download error: $url";
      $email_body = "An error occurred while downloading the following url: $url\n$error\n\n";
      $headers .= "Reply-To: daniil.gentili.dg@gmail.com";
      mail($to,$email_subject,$email_body,$headers);
     };
    } else { echo "$final"; };
} else {
    echo '<!DOCTYPE HTML>
<html>
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
 <title>Video download API server!</title>
 <link rel="apple-touch-icon" sizes="57x57" href="/favicons/apple-touch-icon-57x57.png">
 <link rel="apple-touch-icon" sizes="60x60" href="/favicons/apple-touch-icon-60x60.png">
 <link rel="apple-touch-icon" sizes="72x72" href="/favicons/apple-touch-icon-72x72.png">
 <link rel="apple-touch-icon" sizes="76x76" href="/favicons/apple-touch-icon-76x76.png">
 <link rel="apple-touch-icon" sizes="114x114" href="/favicons/apple-touch-icon-114x114.png">
 <link rel="apple-touch-icon" sizes="120x120" href="/favicons/apple-touch-icon-120x120.png">
 <link rel="apple-touch-icon" sizes="144x144" href="/favicons/apple-touch-icon-144x144.png">
 <link rel="apple-touch-icon" sizes="152x152" href="/favicons/apple-touch-icon-152x152.png">
 <link rel="apple-touch-icon" sizes="180x180" href="/favicons/apple-touch-icon-180x180.png">
 <link rel="icon" type="image/png" href="/favicons/favicon-32x32.png" sizes="32x32">
 <link rel="icon" type="image/png" href="/favicons/android-chrome-192x192.png" sizes="192x192">
 <link rel="icon" type="image/png" href="/favicons/favicon-96x96.png" sizes="96x96">
 <link rel="icon" type="image/png" href="/favicons/favicon-16x16.png" sizes="16x16">
 <link rel="manifest" href="/favicons/manifest.json">
 <meta name="msapplication-TileColor" content="#ff66ff">
 <meta name="msapplication-TileImage" content="/favicons/mstile-144x144.png">
 <meta name="theme-color" content="#ff66ff">

 <style>
  body {
      background-color: #ff66ff;
      font-weight: bold;
      margin-left: auto;
      margin-right: auto;
      margin-top: 3px;
      margin-bottom: 3px;
      text-align: center;
  }
 </style>
</head>
<body>
 <img src="//daniil.it/img/profile.png" alt=""><br><a href="http://daniil.it">Video download API server created by Daniil Gentili</a><br><a href="http://daniil.it/video-dl/#api">How to use this api</a><br><a href="https://github.com/danog/video-dl/tree/master/api">Source code on GitHub</a>
</body>
';
}
?>

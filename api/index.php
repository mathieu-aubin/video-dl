<?php
if(($_GET['p']) == 'websites') {
    echo "Rai, Mediaset, Witty TV, LA7 and all of the websites supported by youtube-dl.";
} elseif(($_GET['p']) == 'allwebsites') {
    $yt = shell_exec('youtube-dl --list-extractors');
    echo "rai.it
video.mediaset.it
wittytv.it
la7.it
$yt";

} elseif(isset($_GET['url'])) {
/*    $locale = 'it_IT.utf-8';
    setlocale(LC_ALL, $locale);
    putenv('LC_ALL='.$locale);
*/
    $file = __FILE__;
    $url = $_GET["url"];
    $param = $_GET["p"];
    $db = $_GET["nodb"];
    $cmd =  "bash /var/www/video/api/api.sh" . ' ' . escapeshellarg($url) . ' ' . escapeshellarg($param) . ' ' . escapeshellarg($db);
    $message = shell_exec("$cmd");
    $final = preg_replace("/(^[\r\n]*|[\r\n]+)[\s\t]*[\r\n]+/", "\n", $message);
    $final = trim($final, "\n");
    echo "$final";
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

<?php
if(($_GET['p']) == 'websites') {
    print_r('Rai, Mediaset, Witty TV, LA7, any generic non super-protected website.');
} elseif(isset($_GET['url'])) {
    $file = __FILE__;
    $url = ($_GET["url"]);
    $param = ($_GET["p"]);
    $cmd =  "bash /var/www/video/api/api.sh" .  ' ' . escapeshellarg($url) .  ' ' . escapeshellarg($param);
    $message = shell_exec("$cmd");
    print_r($message);
} else {
    echo '<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>Video download API server!</title>
<link rel="apple-touch-icon" sizes="57x57" href="/apple-touch-icon-57x57.png">
<link rel="apple-touch-icon" sizes="60x60" href="/apple-touch-icon-60x60.png">
<link rel="apple-touch-icon" sizes="72x72" href="/apple-touch-icon-72x72.png">
<link rel="apple-touch-icon" sizes="76x76" href="/apple-touch-icon-76x76.png">
<link rel="apple-touch-icon" sizes="114x114" href="/apple-touch-icon-114x114.png">
<link rel="apple-touch-icon" sizes="120x120" href="/apple-touch-icon-120x120.png">
<link rel="apple-touch-icon" sizes="144x144" href="/apple-touch-icon-144x144.png">
<link rel="apple-touch-icon" sizes="152x152" href="/apple-touch-icon-152x152.png">
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon-180x180.png">
<link rel="icon" type="image/png" href="/favicon-32x32.png" sizes="32x32">
<link rel="icon" type="image/png" href="/android-chrome-192x192.png" sizes="192x192">
<link rel="icon" type="image/png" href="/favicon-96x96.png" sizes="96x96">
<link rel="icon" type="image/png" href="/favicon-16x16.png" sizes="16x16">
<link rel="manifest" href="/manifest.json">
<meta name="msapplication-TileColor" content="#ff66ff">
<meta name="msapplication-TileImage" content="/mstile-144x144.png">
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
<img src="http://lol.daniil.it/index_htm_files/19.jpg" href="http://daniil.it"></img>
<br><a href="http://daniil.it">Video download API server created by Daniil Gentili</a><br>
<a href="http://git.daniil.it/video-dl/#api">How to use this api</a><br>
<a href="https://github.com/danog/video-dl/tree/master/web/api">Source code on GitHub</a>
</body>';
}
?>

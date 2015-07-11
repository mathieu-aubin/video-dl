<!--
: "
-->
<!DOCTYPE HTML> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>Download videos!</title>

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

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-50691719-7', 'auto');
  ga('send', 'pageview');

</script>

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
.left {
    float: left;
    font-style: italic;
    font-size: xx-small;
    font-weight: lighter;
}
.right {
    float: right;
    font-style: italic;
    font-size: xx-small;
    font-weight: lighter;
}
</style>

<script type="text/javascript">
//<![CDATA[
  (function() {
    var shr = document.createElement('script');
    shr.setAttribute('data-cfasync', 'false');
    shr.src = '//dsms0mj1bbhn4.cloudfront.net/assets/pub/shareaholic.js';
    shr.type = 'text/javascript'; shr.async = 'true';
    shr.onload = shr.onreadystatechange = function() {
      var rs = this.readyState;
      if (rs && rs != 'complete' && rs != 'loaded') return;
      var site_id = 'dc6c8f9c2fd4c46b544da1ace521c9b3';
      try { Shareaholic.init(site_id); } catch (e) {}
    };
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(shr, s);
  })();
//]]>
</script>



<meta name="keywords" content="pasty.link, mediaset, mediaset.it, rai, link, download, video, Rai.tv, paste, senza Silverlight, scaricare, scaricare video rai, without Silverlight, streaming, vlc, videos, mediaset, Mediaset, il segreto, il segreto Mediaset, video mediaset, la7, la7 TV, scaricare video">
</head>

<!-- Nice Morfix-coloured background... -->

Download videos from <a href="http://rai.tv" target="_blank">Rai</a>, <a href="http://www.rai.tv/dl/replaytv/replaytv.html#" target="_blank">Rai Replay</a>, <a href="http://video.mediaset.it" target="_blank">Video Mediaset</a>, <a href="http://la7.it" target="_blank">La7</a>, <a href="http://wittytv.it" target="_blank">Witty TV</a> and more websites!

<br>

<form action="http://video.daniil.it" method="get">
Paste the URL of the video:<br><input type="text" name="url" placeholder="URL of the video"><input type="submit" value="Download the video!">
</form> 

<?php
if(isset($_GET['url'])) {
    $file = __FILE__;
    $url = ($_GET["url"]);
    $mail = $url;
    $cmd =  "bash " .  escapeshellarg($file) .  ' ' . escapeshellarg($url) .  ' ' .  escapeshellarg($quality) .  ' ' . escapeshellarg($param);
    $message = shell_exec("$cmd");
    print_r($message);
} else {
    $mail = "insert_link";
}
?>

<br><br>
<div class="left"><a href="https://github.com/danog/rai.tv-bash-dl/">Source code on GitHub.</a></div>
<div class="right"><a href='mailto:daniil.gentili.dg@gmail.com?subject=Video not working&body=The video:%0D%0A<?= $mail ?>%0D%0Adoes not work, could you please fix it?%0D%0AThanks!'>Not working?</a></div>


</body>
</html>
<!--
"
# Rai.TV download script
# Created by Daniil Gentili (http://daniil.it)
# This program is licensed under the GPLv3 license.
# Web version.
[ "$*" = "" ] && exit 1

[ "$1" = "dontmindme" ] && exit 1

[ "$1" = "" ] && exit 1

api="$(bash /var/www/video/api/api.sh $1 | sed '/^\s*$/d')"
[ "$api" = "" ] && { echo "<h1><center>Error.</center></h1>" ; exit 1; }

titles=$(echo "$api" | sed -n 1p)
title=$(echo "$titles" | cut -d \ -f 1)

videoTitolo=$(echo "$titles" | cut -d' ' -f2- | sed 's/è/\&egrave;/g;s/é/\&eacute;/g;s/ì/\&igrave;/g;s/í/\&iacute;/g;s/ù/\&ugrave;/g;s/ú/\&uacute;/g')

api=$(echo "$api" | sed '1d' | awk '{print NR, $0}')

URLS="$(echo "$api" | awk 'NF>1{print $NF}')"

formats="$([ "$URLS" != "" ] && for a in $URLS; do info=$(echo "$api" | grep "$a" | sed 's/http.*//')

 echo "<h2><a href=\"$a\">$info</a></h2>
<br>";done)"

formats="$(echo "$formats" | awk '!x[$0]++')"
[ "$formats" = "" ] && { echo "<h1><center>Error.</center></h1>" ; exit 1; }

echo "<h1><i>Video download script.</i></h1>
<h2><i>Created by <a href=\"http://daniil.it\">Daniil Gentili</a></i></h2>
<br>
<h1>Title:</h1> <h2>$videoTitolo</h2>
<br>
<h1>Available versions:</h1>
$formats
"

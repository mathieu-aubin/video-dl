<!--
: "
-->
<!DOCTYPE HTML> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=Windows-1252"/>
<title>Download videos!</title>
<link rel="shortcut icon" type="image/png" href="http://video.daniil.it/favicon.png"/>

<script type="text/javascript">var switchTo5x=true;</script>
<script type="text/javascript" src="http://w.sharethis.com/button/buttons.js"></script>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-50691719-7', 'auto');
  ga('send', 'pageview');

</script>
<meta name="keywords" content="pasty.link, mediaset, mediaset.it, rai, link, download, video, Rai.tv, paste, senza Silverlight, scaricare, scaricare video rai, without Silverlight, streaming, vlc, videos, mediaset, Mediaset, il segreto, il segreto Mediaset, video mediaset, la7, la7 TV, scaricare video">
</head>

<body bgcolor="#FF66FF"> 

<!-- Nice Morfix-coloured background... -->

<b><center>Download videos from <a href="http://rai.tv">Rai</a>, <a href="http://www.rai.tv/dl/replaytv/replaytv.html#">Rai Replay</a> e <a href="http://mediaset.it">Mediaset</a>, <a href="http://la7.it">La7</a>, <a href="http://wittytv.it">Witty TV</a> and more websites!</b></center>

<br>

<form action="#" method="get">
<center><b>Paste the URL of the video:<br></b><input type="text" name="url" placeholder="URL of your video"><input type="submit" value="Download the video!"></center>
</form> 

<?php
if(isset($_GET['url'])) {
    $file = __FILE__;
    $url = ($_GET["url"]);
    $quality = ($_GET["q"]);
    $param = ($_GET["p"]);
    if(!isset($_GET['q'])) {
        $quality = dontmindme;
    };
    $cmd =  "bash " .  escapeshellarg($file) .  ' ' . escapeshellarg($url) .  ' ' .  escapeshellarg($quality) .  ' ' . escapeshellarg($param);
    $message = shell_exec("$cmd");
    print_r($message);
}
?>

<br>
<p>
<span class='st_sharethis_large' displayText='ShareThis'></span>
<span class='st_facebook_large' displayText='Facebook'></span>
<span class='st_twitter_large' displayText='Tweet'></span>
<span class='st_linkedin_large' displayText='LinkedIn'></span>
<span class='st_pinterest_large' displayText='Pinterest'></span>
<span class='st_email_large' displayText='Email'></span>
<small><i><object align="right"><a href="https://github.com/danog/rai.tv-bash-dl/">Source code on GitHub.</a>
<br>
<a href='mailto:daniil.gentili.dg@gmail.com?subject=Video non funzionante&body=The video insert_link doesn't work, could you please fix it?%0D%0AThanks!'>Not working?</a>
</object></i></small></p>

</body>
</html>
<!--
"
# Rai.TV download script
# Created by Daniil Gentili (http://daniil.eu.org)
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

echo "<center><h1><i>Video download script.</i></h1>
<h2><i>Created by <a href=\"http://daniil.it\">Daniil Gentili</a></i></h2>
<br>
<h1>Title:</h1> <h2>$videoTitolo</h2>
<br>
<h1>Available versions:</h1>
$formats
</center>"

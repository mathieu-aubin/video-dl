<!--
: "
-->
<!DOCTYPE HTML> 
<html>
<head>
<title>Scaricare video Rai.TV.</title>
</head>
<body bgcolor="#FF66FF"> 
<!-- Nice Morfix-coloured background... -->
<b><center>Scaricare video Rai.TV.</center></b>

<form action="#" method="get">
<center><b>Incollare l'indirizzo del video:<br></b><input type="text" name="url" value=""><input type="submit" value="Scarica il video!"></center>
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

<small><i><p align="right"><a href="https://github.com/danog/rai.tv-bash-dl/">Codice sorgente su GitHub</a></p></i></small>

</body>
</html>
<!--
"
# Rai.TV download script
# Created by Daniil Gentili (http://daniil.eu.org)
# Web version: can be incorporated in websites.
[ "$*" = "" ] && exit 1
function kill() {
echo "<p><a>Questo non è un indirizzo Rai.TV.</a></p>"; exit 1
}

[ "$*" = "" ] && exit 1

dl=$(echo $1 | grep -q http: && echo $1 || echo http:$1)

curl -w "%{url_effective}\n" -L -s -S $dl -o /dev/null  | grep -qE 'http://www*.rai.*/dl/RaiTV/programmi/media/*|http://www*.rai.*/dl/RaiTV/tematiche/*|http://www*.rai.*/dl/*PublishingBlock-*|http://www*.rai.*/dl/replaytv/replaytv.html*|http://*.rai.it/*|http://www.rainews.it/dl/rainews/*|http://mediapolisvod.rai.it/*|http://*.akamaihd.net/*' || kill


# OK, here we have all the functions.

function error() {
echo "$URLS" | awk 'END {print $NF}'
}

function var() {
eval $*
}

function geturl() {
# Get a working url
dl=$(echo $1 | grep -q http: && echo $1 || echo http:$1)

# Get the destination of the URL with a mobile user agent

url=$(curl -w "%{url_effective}\n" -L -s -S $dl -o /dev/null -A "Mozilla/5.0 (iPad; CPU OS 7_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53")

# Choices!

echo $url | grep -q csmil

if [ "$?" = "0" ]; then 
 # Check all creativemedia servers

 base=$(eval echo {http://creativemedia1.rai.it,http://creativemedia2.rai.it,http://creativemedia3.rai.it,http://creativemedia4.rai.it,http://creativemediax1.rai.it,http://creativemediax2.rai.it,http://creativemediax3.rai.it,http://creativemediax4.rai.it}$(echo $url | sed "s/\.csmil.*//" | sed 's/.*\/i//' | sed '0,/\,/s//\{/' | sed -r 's/,([^,]*)$/\}\1/'))

 for u in $base;do wget -S --spider $u 2>&1 | grep -q 'HTTP/1.1 200 OK' && URLS="$URLS
$u"; done

else
 # Check all creativemedia servers

 base=$(eval echo {http://creativemedia1.rai.it,http://creativemedia2.rai.it,http://creativemedia3.rai.it,http://creativemedia4.rai.it,http://creativemediax1.rai.it,http://creativemediax2.rai.it,http://creativemediax3.rai.it,http://creativemedia4.rai.it}$(echo $url | sed "s/\/master.m3u8.*//" | sed 's/.*\/i//' ))

 for u in $base;do wget -S --spider $u 2>&1 | grep -q 'HTTP/1.1 200 OK' && URLS="$URLS
$u"; done

fi

# But use just one server.

echo $URLS | grep -q creativemedia1.rai.it && n="1"
echo $URLS | grep -q creativemedia2.rai.it && n="$n
2"
echo $URLS | grep -q creativemedia3.rai.it && n="$n
3"
echo $URLS | grep -q creativemedia4.rai.it && n="$n
4"
echo $URLS | grep -q creativemediax1.rai.it && n="$n
x1"
echo $URLS | grep -q creativemediax2.rai.it && n="$n
x2"
echo $URLS | grep -q creativemediax3.rai.it && n="$n
x3"
echo $URLS | grep -q creativemediax4.rai.it && n="$n
x4"

n=$(echo "$n" | awk 'END {print $NF}')

URLS="$(echo "$URLS" | grep creativemedia$n)"

[ -z $title ] && todl=$(echo $URLS | sed 's/.*\///') ||
todl=$(echo $title.$(echo $URLS | awk -F. '$0=$NF'))

# Quality checks

four="$(echo "$URLS" | grep .*_400.mp4)"
six="$(echo "$URLS" | grep .*_600.mp4)"
eight="$(echo "$URLS" | grep .*_800.mp4)"
twelve="$(echo "$URLS" | grep .*_1200.mp4)"
fifteen="$(echo "$URLS" | grep .*_1500.mp4)"
eighteen="$(echo "$URLS" | grep .*_1800.mp4)"

normal=$(echo "$URLS" | grep -v .*_400.mp4 | grep -v .*_600.mp4 | grep -v .*_800.mp4 | grep -v .*_1200.mp4 | grep -v .*_1500.mp4 | grep -v .*_1800.mp4)


formats="$(

[ "$four" != "" ] && echo "<h2><a href="$four">Download</a></h2>
<br>"


[ "$six" != "" ] && echo "<h2><a href="$six">Bassa qualit&#224; (mp4)</a></h2>
<br>"



[ "$eight" != "" ] && echo "<h2><a href="$eight">Qualit&#224; medio-bassa (mp4)</a></h2>
<br>"


[ "$twelve" != "" ] && echo "<h2><a href="$twelve">Qualit&#224; media (mp4)</a></h2>
<br>"



[ "$fifteen" != "" ] && echo "<h2><a href="$fifteen">Qualit&#224; medio-alta (mp4)</a></h2>
<br>"


[ "$eighteen" != "" ] && echo "<h2><a href="$eighteen">Alta qualit&#224; (mp4)</a></h2>
<br>"



[ "$normal" != "" ] && echo "<h2>Qualit&#224; normale</h2>"; for u in $normal; do echo "
<a href="$u">Download</a>
<br>"; done
)"


}


function rai() {
# Store the page in a variable
file=$(wget $1 -q -O -)

# Get the title
$(echo "$file" | grep videoTitolo)
title="${videoTitolo//[^a-zA-Z0-9 ]/}"
title=`echo $title | tr -s " "`
title=${title// /_}

# Get the relinkers
eval "$(echo "$file" | grep videoURL | sed "s/var//g" | tr -d '[[:space:]]')"

eval "$(echo "$file" | grep estensioneVideo | sed "s/var//g" | tr -d '[[:space:]]')"
set +u

# Get the destination URL.
geturl $(echo $videoURL_MP4 || echo $videoURL_H264 || echo $videoURL_WMV || echo $videoURL || echo $estensioneVideo) $2 $3
set +u
}


# And here we have the final URL check and the working part.



curl -Ls -o /dev/null -w %{url_effective} $dl | grep -qE 'http://www*.rai.*/dl/RaiTV/programmi/media/*|http://www*.rai.*/dl/RaiTV/tematiche/*|http://www*.rai.*/dl/*PublishingBlock-*|http://www*.rai.*/dl/replaytv/replaytv.html*|http://*.rai.it/*|http://www.rainews.it/dl/rainews/*' && rai $dl $2 $3 || geturl $dl $2 $3

echo "<center><h1><i>Script Rai.TV</i></h1>
<h2><i>Creato da <a href="http://daniil.eu.org">Daniil Gentili</a></i></h2>
<h1>Titolo:</h1> <h2>$videoTitolo</h2>
<h1>Versioni disponibili:</h1>
$formats
</center>"

# A bit messed up, I know. But at least it works (right?).
-->
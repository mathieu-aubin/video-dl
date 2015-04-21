<!--
: '
-->
<!DOCTYPE HTML> 
<html>
<head>
<title>Rai.tv video download</title>
</head>
<body bgcolor="#FF66FF"> 
<!-- Nice Morfix-coloured background... -->
<b><center>Rai.TV video download.</center></b>

<form action="#" method="get">
<center><b>Type (or paste) in the URL of the video:<br></b><input type="text" name="url" value=""><input type="submit" value="Get download URL"></center>
</form> 


<?php
if(isset($_GET['url'])) { 
    $file = __FILE__;
    $url = ($_GET["url"]);
    $message = shell_exec("bash $file $url");
    print_r($message);
}
?>

<br>

<small><i><p align="right"><a href="https://github.com/danog/rai.tv-bash-dl/">Source on GitHub</a></p></i></small>

</body>
</html>
<!--
'

# Rai.TV download script
# Created by Daniil Gentili (http://daniil.eu.org)
# Uses Andrea Lazzarotto's (http://andrealazzarotto.com) server (http://video.lazza.dk) to decode URLs.
# Web version: can be incorporated in websites.
[ "$*" = "" ] && exit 1
function kill(){
echo "<p><a>This is not a Rai.tv URL.</a></p>"; exit 1
}

curl -Ls -o /dev/null -w %{url_effective} $1 | grep -qE 'http://www*.rai.*/dl/RaiTV/programmi/media/*|http://www*.rai.*/dl/RaiTV/tematiche/*|http://www*.rai.*/dl/*PublishingBlock-*|http://www*.rai.*/dl/replaytv/replaytv.html*|http://*.rai.it/*|http://www.rainews.it/dl/rainews/*' || kill


echo "<center><p><i>Rai.TV download script</i></p>
<p><i>Created by <a href="http://daniil.eu.org">Daniil Gentili</a></i></p>
<p><i>Uses <a href="http://lazza.me">Andrea Lazzarotto's</a> server (http://video.lazza.dk) to decode URLs.</i></p>"




function var() {
eval $*
}


file=$(wget $1 -q -O -)

$(echo "$file" | grep videoTitolo)

eval "$(echo "$file" | grep videoURL | sed "s/var//g" | tr -d '[[:space:]]')"

vars=$(compgen -A variable | grep videoURL)

for f in $vars;do var="$var
<p><a href="$(wget http://video.lazza.dk/rai/?r=$(eval echo `echo $f | sed -r 's/[^ ]+/$&/g'`) -q -O -)">$f</a></p>
 "; done

formats="$(echo "$var" | sed -e 's/\<videoURL\>/Normal quality (mp4)/g' | sed -e 's/\<videoURL_MP4\>/High quality (mp4)/g' | sed -e 's/\<videoURL_H264\>/Normal quality (h264)/g' | sed 's/\<videoURL_M3U8\>/Normal quality (m3u8)/g' |  sed 's/\<videoURL_wmv\>/Normal quality (wmv)/g')"

echo "<h1>Title:</h1> <p>$videoTitolo</p>
<h1>Available formats:</h1>
<p>$formats</p>
<br>
</center>
"

-->

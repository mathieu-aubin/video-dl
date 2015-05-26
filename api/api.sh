#!/bin/bash
# Rai.TV download script
# Created by Daniil Gentili (http://daniil.it)
# This program is licensed under the GPLv3 license.
# Web version: can be incorporated in websites.
[ "$*" = "" ] && exit 1

[ "$1" = "" ] && exit 1
[ "$1" = "dontmindme" ] && exit 1


dl="$(echo $1 | grep -q '^//' && echo http:$1 || echo $1)"
dl="$(echo "$dl" | sed 's/#.*//')"

urltype="$(curl -w "%{url_effective}\n" -L -s -I -S "$dl" -o /dev/null)"

echo "$urltype" | grep -qE 'http://www.*.rai..*/dl/RaiTV/programmi/media/.*|http://www.*.rai..*/dl/RaiTV/tematiche/*|http://www.*.rai..*/dl/.*PublishingBlock-.*|http://www.*.rai..*/dl/replaytv/replaytv.html.*|http://.*.rai.it/.*|http://www.rainews.it/dl/rainews/.*|http://mediapolisvod.rai.it/.*|http://*.akamaihd.net/*|http://www.video.mediaset.it/video/.*|http://www.video.mediaset.it/player/playerIFrame.*|http://.*wittytv.it/.*|http://la7.it/.*|http://.*.la7.it/.*|http://la7.tv/.*|http://.*.la7.tv/.*' || common=y



echo "$urltype" | grep -qE 'http://www.*.rai..*/dl/RaiTV/programmi/media/.*|http://www.*.rai..*/dl/RaiTV/tematiche/*|http://www.*.rai..*/dl/.*PublishingBlock-.*|http://www.*.rai..*/dl/replaytv/replaytv.html.*|http://.*.rai.it/.*|http://www.rainews.it/dl/rainews/.*|http://mediapolisvod.rai.it/.*|http://*.akamaihd.net/*' && rai=y


echo "$urltype" | grep -qE 'http://www.video.mediaset.it/video/.*|http://www.video.mediaset.it/player/playerIFrame.*' && mediaset=y

echo "$urltype" | grep -q 'http://.*wittytv.it/.*' && mediaset=y && witty=y

echo "$urltype" | grep -qE 'http://la7.it/.*|http://.*.la7.it/.*|http://la7.tv/.*|http://.*.la7.tv/.*' && lasette=y

# OK, here we have all the functions.

function error() {
echo "$URLS" | awk 'END {print $NF}'
}

function var() {
eval $*
}

size() {
echo `echo $1 | awk -F. '$0=$NF'`, $(
tmpsize=$(echo $(wget -S --spider $1 2>&1 | grep -E '^Length|^Lunghezza' | sed 's/.*(//' | sed 's/).*//')B)

if [ "$tmpsize" != "" ]; then echo ""$tmpsize", "; fi)$(mplayer -vo null -ao null -identify -frames 0 $1 2>/dev/null | grep kbps | awk '{print $3}')
}

getsize() {
info=$(echo "$unformatted" | grep "$a" | sed 's/http.*//')

[[ -z $title ]] && todl=$(echo $a | sed 's/.*\///') || todl="$title.$(echo $a | awk -F. '$0=$NF')"

}


function checkurl() {
tbase="$(echo $base | sort | awk '!x[$0]++' | awk '{ while(++i<=NF) printf (!a[$i]++) ? $i FS : ""; i=split("",a); print "" }')"

base=
for u in $tbase;do wget -S --tries=3 --spider $u 2>&1 | grep -q 'HTTP/1.1 200 OK' && base="$base
$u"; done
}

formatoutput() {
urlsfromunformatted="$(echo "$unformatted" | awk 'NF>1{print $NF}')"


if [ "$rai" = "y" ]; then 
 four="$(echo "$urlsfromunformatted" | grep .*_400.mp4)"
 six="$(echo "$urlsfromunformatted" | grep .*_600.mp4)"
 eight="$(echo "$urlsfromunformatted" | grep .*_800.mp4)"
 twelve="$(echo "$urlsfromunformatted" | grep .*_1200.mp4)"
 fifteen="$(echo "$urlsfromunformatted" | grep .*_1500.mp4)"
 eighteen="$(echo "$urlsfromunformatted" | grep .*_1800.mp4)"
 normal="$(echo "$urlsfromunformatted" | grep -v .*_400.mp4 | grep -v .*_600.mp4 | grep -v .*_800.mp4 | grep -v .*_1200.mp4 | grep -v .*_1500.mp4 | grep -v .*_1800.mp4)"
fi

if [ "$mediaset" = "y" ];then mp4="$(echo "$urlsfromunformatted" | grep ".mp4")"
 smooth="$(echo "$urlsfromunformatted" | grep -v "pl)" | grep "est")"
 apple="$(echo "$urlsfromunformatted" | grep "pl)")"
 wmv="$(echo "$urlsfromunformatted" | grep ".wmv")"
 flv="$(echo "$urlsfromunformatted" | grep ".flv")"
 f4v="$(echo "$urlsfromunformatted" | grep ".f4v")"
fi

if [ "$lasette" = "y" ];then lamp4="$(echo "$urlsfromunformatted" | grep -v master | grep -v manifest | grep ".mp4")"
fi

if [ "$common" = "y" ]; then common="$urlsfromunformatted";fi


formats="$([ "$common" != "" ] && for a in $common; do getsize
 info="$(echo "$info" | sed 's/[(]//;s/[)]//')"

 echo "$info $a";done

[ "$lamp4" != "" ] && for a in $lamp4; do getsize

 echo "$info $a";done

[ "$normal" != "" ] && for a in $normal; do getsize

 echo "Normal quality $info $a";done

[ "$eighteen" != "" ] && for a in $eighteen; do getsize

 echo "Maximum quality $info $a";done


[ "$fifteen" != "" ] && for a in $fifteen; do getsize

 echo "Medium-high quality $info $a";done



[ "$twelve" != "" ] && for a in $twelve; do getsize

 echo "Medium quality $info $a";done

[ "$eight" != "" ] && for a in $eight; do getsize

 echo "Medium-low quality $info $a";done


[ "$six" != "" ] && for a in $six; do getsize
 
 echo "Low quality $info $a";done



[ "$four" != "" ] && for a in $four; do getsize
 echo "Minimum quality $info $a";done



[ "$smooth" != "" ] && for a in $smooth; do echo "High quality (smooth streaming) $a";done


[ "$mp4" != "" ] && for a in $mp4; do getsize
 echo "Medium-high quality $info $a";done



[ "$apple" != "" ] && for a in $apple; do echo "Medium-low quality  (apple streaming, pseudo-m3u8) $a";done


[ "$wmv" != "" ] && for a in $wmv; do getsize

 echo "Low quality $info $a";done


[ "$flv" != "" ] && for a in $flv; do getsize

 echo "Low quality $info $a";done


[ "$f4v" != "" ] && for a in $f4v; do getsize

 echo "Low quality $info $a";done



)"

formats="$(echo "$formats" | awk '!x[$0]++')"
}



# Relinker function



function relinker_rai() {
# Get a working url
for f in `echo $* | awk '{ while(++i<=NF) printf (!a[$i]++) ? $i FS : ""; i=split("",a); print "" }'`; do
 
 dl=$(echo $f | grep -q http: && echo $1 || echo http:$1)


 url="$(wget "$dl&output=43" -q -O -)"
 [ "$url" != "" ] && base=$(echo "$url" | sed 's/<\/url>/\
&/g' | sed 's/.*<url>//' | grep '.*.mp4$\|.*.wmv$\|.*.mov$') && checkurl
 
 if [ "$base" = "" ]; then
  url="$(wget "$dl&output=4" -q -O -)"
  [ "$url" != "" ] && base=$(echo "$url" | grep -q creativemedia && echo "$url" || curl -w "%{url_effective}\n" -L -s -I -S $dl -A "" -o /dev/null) && checkurl
 fi
 
 

 TMPURLS="$TMPURLS
$base"

done

base="$(echo $TMPURLS | sort | awk '!x[$0]++')"

ext=$(echo $base | awk -F. '$0=$NF')
tbase=

for t in _400.$ext _600.$ext _800.$ext _1200.$ext _1500.$ext _1800.$ext; do for i in _400.$ext _600.$ext _800.$ext _1200.$ext _1500.$ext _1800.$ext; do tbase="$tbase
$(echo "$base" | sed "s/$t/$i/")"; done ;done

base="$(echo "$tbase" | sort | tr -s " " "\n" | awk '!x[$0]++' | awk '{ while(++i<=NF) printf (!a[$i]++) ? $i FS : ""; i=split("",a); print "" }')"

checkurl


# Quality checks

unformatted="$([ "$base" != "" ] && for a in $base; do echo "(`size $a`) $a";done)"

echo "$userinput
$title $videoTitolo
$unformatted
endofdbentry" >> /var/www/video-db.txt

formatoutput

}


function rai() {
# Store the page in a variable
file=$(wget $1 -q -O -)

echo $1 | grep -q http://www.*.rai..*/dl/replaytv/replaytv.html.*
# Get the relinkers

if [ "$?" = "0" ]; then 
 # Rai replay
 v=$(echo $1 | sed 's/.*v=//' | sed 's/\&.*//')

 day=$(echo $1 | sed 's/.*?day=//' | sed 's/\&.*//' | tr -s "-" "_")

 tmpch=$(echo $1 | sed 's/.*ch=//' | sed 's/\&.*//')

 let "vprev = $v - 1"

 ch=$([ "$tmpch" = "1" ] && echo RaiUno; [ "$tmpch" = "2" ] && echo RaiDue; [ "$tmpch" = "3" ] && echo RaiTre; [ "$tmpch" = "31" ] && echo RaiCinque; [ "$tmpch" = "32" ] && echo RaiPremium; [ "$tmpch" = "23" ] && echo RaiGulp; [ "$tmpch" = "38" ] && echo RaiYoyo)

 json=$(wget http://www.rai.it/dl/portale/html/palinsesti/replaytv/static/"$ch"_$day.html -q -O -)

 echo "$json" | grep -q $vprev

 tmpjson="$(if [ "$?" = 0 ]; then echo "$json" |
sed -n "1,/$v/p" |
awk "/$vprev/{i++}i" |
awk '/{/{i++}i' |
tr -s "," "\n" |
tr -s '"' "\n" |
sed 's/\\//g'; else echo "$json" |
sed -n "1,/$v/p" |
awk '/{/{i++}i' |
tr -s "," "\n" |
tr -s '"' "\n" |
sed 's/\\//g';fi)"

 replay=$(echo "$tmpjson" | sed 's/.*://' | grep mediapolis | sort | awk '!x[$0]++')

 # Get the title
 videoTitolo=$(echo "$tmpjson" | grep -A 2 '^t$' | awk 'END{print}')
 title="${videoTitolo//[^a-zA-Z0-9 ]/}"
 title=`echo $title | tr -s " "`
 title=${title// /_}
 relinker_rai $replay

else

 echo "$file" | grep -q videoURL

 if [ "$?" != "0" ]; then
  eval $(echo "$file" | grep 'content="ContentItem' | cut -d" " -f2) &&
  file="$(wget http://www.rai.it/dl/RaiTV/programmi/media/"$content".html -q -O -)"
 fi

 # Get the video URLs

 eval "$(echo "$file" | grep videoURL | sed "s/var//g" | tr -d '[[:space:]]')"

 # Get the title
 $(echo "$file" | grep videoTitolo)
 title="${videoTitolo//[^a-zA-Z0-9 ]/}"
 title=`echo $title | tr -s " "`
 title=${title// /_}

 # Get the destination URL.
 relinker_rai $videoURL_M3U8 $videoURL_MP4 $videoURL_H264 $videoURL_WMV $videoURL
fi
}

lasette() {
page="$(wget $1 -q -O -)"

URLS="$(wget -q -O - $(echo "$page" | grep starter | sed 's/.*src\=\"//;s/\".*//') | grep -E 'src:.*|src_.*' | sed 's/.*\: \"//;s/\".*//')"

videoTitolo="$(echo $page | sed 's/.*<title>//;s/<\/title>.*//' | sed 's/^ //')"

title="${videoTitolo//[^a-zA-Z0-9 ]/}"
title=`echo $title | tr -s " "`
title=${title// /_}

unformatted="$([ "$URLS" != "" ] && for a in $URLS; do echo "(`size $a`) $a";done)"

echo "$userinput
$title $videoTitolo
$unformatted
endofdbentry" >> /var/www/video-db.txt

formatoutput
}

mediaset() {
page=$(wget $1 -q -O -)

if [ "$witty" = "y" ]; then id=$(echo "$page" | grep '\<iframe id=\"playeriframe\" src=\"http\:\/\/www.video.mediaset.it\/player\/playerIFrame.shtml?id\=' | sed 's/.*\<iframe id=\"playeriframe\" src=\"http\:\/\/www.video.mediaset.it\/player\/playerIFrame.shtml?id\=//;s/\&.*//')

 videoTitolo=$(echo "$page" | grep -o "<meta content=\".*\" property=\".*title\"/>" | sed 's/.*\<meta content\=\"//;s/\".*//g')

else
 eval $(echo "$page" | grep "var videoMetadataId" | sed 's/var //' | tr -d '[[:space:]]')
 id="$videoMetadataId"
 videoTitolo=$(echo "$page" | grep -o "<meta content=\".*\" name=\"title\"/>" | sed 's/.*\<meta content\=\"//;s/\".*//g')
 
fi

title="${videoTitolo//[^a-zA-Z0-9 ]/}"
title=`echo $title | tr -s " "`
title=${title// /_}
URLS="$(wget "http://cdnselector.xuniplay.fdnames.com/GetCDN.aspx?streamid=$id" -O - -q -U="" | sed 's/</\
&/g' | grep http:// | sed 's/.*src=\"//;s/\".*//' |  sed '/^\s*$/d')"

# Quality checks

unformatted="$([ "$URLS" != "" ] && for a in $URLS; do echo "(`size $a`) $a";done)"

echo "$userinput
$title $videoTitolo
$unformatted
endofdbentry" >> /var/www/video-db.txt

formatoutput

}

common() {
page="$(wget -q -O - $1)"

URLS="$(echo "$page" | egrep '\.mp4|\.mkv|\.flv|\.f4v|\.wmv|\.mov|\.3gp|\.avi|\.m4v|\.mpg|\.mpe|\.mpeg' | sed 's/.*http:\/\//http:\/\//;s/\".*//' | sed "s/'.*//" | sed 's/.mp4.*/.mp4/g;s/.mkv.*/.mkv/g;s/.flv.*/.flv/g;s/.f4v.*/.f4v/g;s/.wmv.*/.wmv/g;s/.mov.*/.mov/g;s/.3gp.*/.3gp/g;s/.avi.*/.avi/g;s/.m4v.*/.m4v/g;s/.mpg.*/.mpg/g;s/.mpe.*/.mpe/g;s/.mpeg.*/.mpeg/g' | awk '!x[$0]++')"


[ "$URLS" = "" ] && exit

videoTitolo="$(echo $page | sed 's/.*<title>//;s/<\/title>.*//' | sed 's/^ //')"


title="${videoTitolo//[^a-zA-Z0-9 ]/}"
title=`echo $title | tr -s " "`
title=${title// /_}

unformatted="$(for a in $URLS; do echo "(`size $a`) $a";done)"

echo "$userinput
$title $videoTitolo
$unformatted
endofdbentry" >> /var/www/video-db.txt

formatoutput

}


video_db() {
db="$(sed -n '/'"$saneuserinput"'/,$p' /var/www/video-db.txt | sed -n '/endofdbentry/q;p' | sed '1d')"

titles="$(echo "$db" | sed -n 1p)"

unformatted="$(echo "$db" | sed '1d')"

title="$(echo "$titles" | cut -d \  -f 1)"

videoTitolo="$(echo "$titles" | cut -d' ' -f2- | sed 's/è/e/' | sed 's/é/e/' | sed 's/ì/i/' | sed 's/í/i/' | sed 's/ù/u;/' | sed 's/ú/u/' )"


formatoutput
}


# And here we have the final URL check and the working part.

second=$2
third=$3

userinput="$dl"
saneuserinput="$(echo "$dl" | sed 's/\//\\\//g' | sed 's/\&/\\\&/g' )"


grep -q "$saneuserinput" /var/www/video-db.txt

if [ "$?" = 0 ]; then
 video_db
 [ "$formats" = "" ] && exit || echo "$title $videoTitolo
$formats"

else
 [ "$rai" = "y" ] && rai $dl $2 $3
 
 [ "$mediaset" = "y" ] && mediaset $dl $2 $3

 [ "$lasette" = "y" ] && lasette $dl $2 $3

 [ "$common" = "y" ] && common $dl $2 $3

 videoTitolo=$(echo $videoTitolo | sed 's/è/\&egrave;/' | sed 's/é/\&eacute;/' | sed 's/ì/\&igrave;/' | sed 's/í/\&iacute;/' | sed 's/ù/\&ugrave;/' | sed 's/ú/\&uacute;/' )

 [ "$formats" = "" ] && exit || echo "$title $videoTitolo
$formats"

fi

# A bit messed up, I know. But at least it works (right?).


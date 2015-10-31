#!/bin/bash
# Rai.TV download script
# Created by Daniil Gentili (http://daniil.it)
# This program is licensed under the GPLv3 license.


####################################################
############# Beginning of the script ##############
####################################################

[ "$*" = "" ] && exit 1
[ "$1" = "" ] && exit 1
[ "$1" = "dontmindme" ] && exit 1



api() {
####################################################
####### Beginning of URL recognition section #######
####################################################

dl="$(echo "$1" | grep -q '^//' && echo "http:$1" || echo "$1")"

urltype="$(curl -w "%{url_effective}\n" -L -s -I -S "$dl" -o /dev/null | sed 's/^HTTP:\/\//http:\/\//g')"

echo "$urltype" | grep -qE 'http://www.*.rai..*/dl/RaiTV/programmi/media/.*|http://www.*.rai..*/dl/RaiTV/tematiche/*|http://www.*.rai..*/dl/.*PublishingBlock-.*|http://www.*.rai..*/dl/replaytv/replaytv.html.*|http://.*.rai.it/.*|http://www.rainews.it/dl/rainews/.*|http://mediapolisvod.rai.it/.*|http://*.akamaihd.net/*|http://www.video.mediaset.it/video/.*|http://www.video.mediaset.it/player/playerIFrame.*|http://.*wittytv.it/.*|http://la7.it/.*|http://.*.la7.it/.*|http://la7.tv/.*|http://.*.la7.tv/.*' || ptype=common

echo "$urltype" | grep -qE 'http://www.*.rai..*/dl/RaiTV/programmi/media/.*|http://www.*.rai..*/dl/RaiTV/tematiche/*|http://www.*.rai..*/dl/.*PublishingBlock-.*|http://www.*.rai..*/dl/replaytv/replaytv.html.*|http://.*.rai.it/.*|http://www.rainews.it/dl/rainews/.*' && ptype=rai


echo "$urltype" | grep -qE 'http://www.video.mediaset.it/video/.*|http://www.video.mediaset.it/player/playerIFrame.*' && ptype=mediaset

echo "$urltype" | grep -q 'http://.*wittytv.it/.*' && ptype=mediaset && witty=y

echo "$urltype" | grep -qE 'http://la7.it/.*|http://.*.la7.it/.*|http://la7.tv/.*|http://.*.la7.tv/.*' && ptype=lasette

dl="$urltype"


##############################################################################
####### End of URL recognition section, beginning of Functions section #######
##############################################################################

# Declare javascript variable

var() {
eval $(echo "$*" | sed 's/var//g;s/\s=\s/=/g')
}
# Get video information

getsize() {
minfo="$(timeout -skill 15s mediainfo "$a")"
info="($(echo "$(echo "$a" | sed "s/.*\.//;s/[^a-z|0-9].*//"), $(echo "$minfo" | sed '/File size/!d;s/.*:\s//g'), $(echo "$minfo" | sed '/Width\|Height/!d;s/.*:\s//g;s/\spixels//g;s/\s//g;/^\s*$/d' | tr -s "\n" x | sed 's/x$//g')" |
sed 's/\
//g;s/^, //g;s/, B,/, Unkown size,/g;s/, ,/,/g;s/^B,//g;s/, $//;s/ $//g'))"
minfo=
}


# Check if URL exists and remove copies of the same URL

function checkurl() {
tbase="$(echo "$base" | sed 's/ /%20/g;s/%20http:\/\//\
http:\/\//g;s/%20$//g;s/ /\
/g' | awk '!x[$0]++')"

base=
for u in $tbase;do echo "$u" | grep -q 'rmtp://\|mms://' && {
base="$base
$u"
} || {
wget -S --tries=3 --spider "$u" 2>&1 | grep -q '200 OK\|206 Partial' && base="$base
$u"
}; done
}


# Nicely format input

formatoutput() {

case $ptype in
  rai)
    {
two="$(echo "$unformatted" | grep '.*_250.mp4')"
four="$(echo "$unformatted" | grep '.*_400.mp4')"
six="$(echo "$unformatted" | grep '.*_600.mp4')"
seven="$(echo "$unformatted" | grep '.*_700.mp4')"
eight="$(echo "$unformatted" | grep '.*_800.mp4')"
twelve="$(echo "$unformatted" | grep '.*_1200.mp4')"
fifteen="$(echo "$unformatted" | grep '.*_1500.mp4')"
eighteen="$(echo "$unformatted" | grep '.*_1800.mp4')"
twentyfour="$(echo "$unformatted" | grep '.*_2400.mp4')"
thirtytwo="$(echo "$unformatted" | grep '.*_3200.mp4')"
fourthousand="$(echo "$unformatted" | grep '.*_4000.mp4')"
normal="$(echo "$unformatted" | sed '/.*_250\.mp4/d;/.*_400\.mp4/d;/.*_600\.mp4/d;/.*_700\.mp4/d;/.*_800\.mp4/d;/.*_1200\.mp4/d;/.*_1500\.mp4/d;/.*_1800\.mp4/d;/.*_2400\.mp4/d;/.*_3200\.mp4/d;/.*_4000\.mp4/d')"
    }
    ;;
  mediaset)
    {
mp4="$(echo "$unformatted" | grep ".mp4")"
smooth="$(echo "$unformatted" | sed '/pl[)]/d;/est/!d')"
apple="$(echo "$unformatted" | grep "pl)")"
wmv="$(echo "$unformatted" | grep ".wmv")"
flv="$(echo "$unformatted" | grep ".flv")"
f4v="$(echo "$unformatted" | grep ".f4v")"
    }
    ;;
  lasette)
    lamp4="$(echo "$unformatted" | sed '/master/d;/manifest/d;/\.mp4/!d')"
    ;;
  common)
    common="$unformatted"
    ;;
esac


formats="$(
[ "$common" != "" ] && for a in $common; do getsize
 info="$(echo "$info" | sed 's/[(]//;s/[)]//')"

 echo "$info $a";done

[ "$lamp4" != "" ] && for a in $lamp4; do getsize

 echo "$info $a";done

[ "$normal" != "" ] && for a in $normal; do getsize

 echo "Normal quality $info $a";done

[ "$fourthousand" != "" ] && for a in $fourthousand; do getsize

 echo "Full HD quality $info $a";done

[ "$thirtytwo" != "" ] && for a in $thirtytwo; do getsize

 echo "HD quality $info $a";done

[ "$twentyfour" != "" ] && for a in $twentyfour; do getsize

 echo "Super-high quality $info $a";done

[ "$eighteen" != "" ] && for a in $eighteen; do getsize

 echo "High quality $info $a";done


[ "$fifteen" != "" ] && for a in $fifteen; do getsize

 echo "Medium-high quality $info $a";done



[ "$twelve" != "" ] && for a in $twelve; do getsize

 echo "Medium quality $info $a";done

[ "$seven" != "" ] && for a in $seven; do getsize

 echo "Medium-medium quality $info $a";done


[ "$eight" != "" ] && for a in $eight; do getsize

 echo "Medium-low quality $info $a";done
 
[ "$six" != "" ] && for a in $six; do getsize
 
 echo "Low quality $info $a";done



[ "$four" != "" ] && for a in $four; do getsize
 echo "Minimum quality $info $a";done
 
[ "$two" != "" ] && for a in $two; do getsize
 echo "Lowest Minimum quality $info $a";done



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

formats="$(echo "$formats" | awk '!x[$0]++' | awk '{print $(NF-1), $0}' | sort -gr | cut -d' ' -f2- | sed '/^\s*$/d')"
videoTitolo=$(echo "$videoTitolo" | tr -d '\015')
title="${videoTitolo//[^a-zA-Z0-9 ]/}"
title=$(echo $title | sed 's/^\s*//g;s/\s*$//g')
title=${title// /_}

[ "$formats" = "" ] && exit

}



# Rai website 

rai_normal() {

# iframe check
echo "$file" | grep -q videoURL || {
urls="http://www.rai.it/dl/RaiTV/programmi/media/"$(echo "$file" | sed '/content="ContentItem/!d;s/.*content="//g;s/".*//g')".html http://www.rai.tv$(echo "$file" | grep -A1 '<div id="idFramePlayer">' | sed '/\<iframe/!d;s/.*src="//g;s/?.*//g') $(echo "$file" | sed '/drawMediaRaiTV/!d;s/.*http/http/g;s/'"'"'.*//g')"

file="$(wget -qO- $urls)"; 

}

# read and declare videoURL and videoTitolo variables from javascript in page

$(echo "$file" | grep 'videoTitolo\|videoURL')

}


# Rai replay function

replay() {
# Get the video id
v=$(echo "$1" | sed 's/.*v=//;s/\&.*//')

# Get the day
day=$(echo "$1" | sed 's/.*day=//;s/\&.*//;s/-/_/g')

# Get the channel
case $(echo "$1" | sed 's/.*ch=//;s/\&.*//') in
  1)
    ch=RaiUno
    ;;
  2)
    ch=RaiDue
    ;;
  3)
    ch=RaiTre
    ;;
  31)
    ch=RaiCinque
    ;;
  32)
    ch=RaiPremium
    ;;
  23)
    ch=RaiGulp
    ;;
  38)
    ch=RaiYoyo
    ;;
esac

# Get the json
tmpjson="$(wget http://www.rai.it/dl/portale/html/palinsesti/replaytv/static/"$ch"_$day.html -qO-)"

# Keep only section with correct video id and make it grepable
json="$(echo $tmpjson | sed 's/'$v'.*//g;s/.*[{]//g;s/\,/\
/g')"

# Get the relinkers
replay=$(echo "$json" | sed '/mediapolis/!d;s/.*\"://g;s/\"//g;s/^ *//g')

# Get the title
videoTitolo=$(echo "$json" | sed '/\"t\":/!d;s/.*\"://;s/\"//g;s/^ *//g')


}


# Relinker function



function relinker_rai() {
# Resolve relinker


for f in $(echo $* | awk '{ while(++i<=NF) printf (!a[$i]++) ? $i FS : ""; i=split("",a); print "" }'); do
 
 dl=$(echo "$f" | grep -q '^//' && echo "http:$f" || echo "$f")

 # 1st method

 url="$(timeout -skill 5s wget -qO- "$dl&output=25")
$(timeout -skill 5s wget "$dl&output=43" -U="" -q -O -)"
 
 [ "$url" != "" ] && base="$(echo "$url" | sed 's/[>]/\
/g;s/[<]/\
/g' | sed '/\.mp4\|\.wmv\|\.mov/!d;/http/!d;s/\.mp4.*/\.mp4/;s/\.wmv.*/\.wmv/;s/\.mov.*/\.mov/')" && checkurl


 # 2nd method

 [ "$base" = "" ] && {
base="$(eval echo "$(for f in $(echo "$tempbase" | grep ","); do number="$(echo "$f" | sed 's/http\:\/\///g;s/\/.*//;s/[^0-9]//g')"; echo "$f" | sed 's/.*Italy/Italy/;s/^/http\:\/\/creativemedia'$number'\.rai\.it\//;s/,/{/;s/,\./}\./;s/\.mp4.*/\.mp4/'; done)")" && checkurl
 }
 

 # 3rd and 4th method
 [ "$base" = "" ] && {
url="$(wget "$dl&output=4" -q -O -)"
[ "$url" != "" ] && echo "$url" | grep -q 'creativemedia\|wms' && base="$url" || base=$(curl -w "%{url_effective}\n" -L -s -I -S "$dl" -A "" -o /dev/null); checkurl
 }


 #[ "$base" = "" ] && base="$(curl -w "%{url_effective}\n" -L -s -I -S "$dl" -o /dev/null -A='')" && checkurl 


 TMPURLS="$TMPURLS
$base"

done

# Remove copies of the same url
base="$(echo "$TMPURLS" | sort | awk '!x[$0]++')"

# Find all qualities in every video
tbase=
qualities="250 400 600 700 800 1200 1500 1800 2400 3200 4000"
for lol in $qualities; do loop="$loop"_"$lol ";done

for t in $loop \ ; do [ "$t" = " " ] && t=; for i in $loop; do tbase="$tbase
${base//$t\.mp4/$i\.mp4}"; tbase="$(echo "$tbase" | grep -Ev "_([0-9]{3,4})_([0-9]{3,4})\.mp4" | awk '!seen[$0]++')"; done;done


base="$tbase"

checkurl

unformatted="$base"
formatoutput


}

###########################################################################################
################## End of Rai relinker section, beginning of Rai section ##################
###########################################################################################


function rai() {
saferai="$1"
# Store the page in a variable
file=$(wget "$saferai" -q -O -)

# Rai replay or normal rai website choice
echo "$1" | grep -q 'http://www.*.rai..*/dl/replaytv/replaytv.html.*' && replay "$saferai" || rai_normal "$saferai"

videoTitolo="$(echo -en "$videoTitolo")"

# Resolve relinkers
relinker_rai $videoURL_M3U8 $videoURL_MP4 $videoURL_H264 $videoURL_WMV $videoURL $replay
}


###########################################################################################
##################### End of Rai section, beginning of Lasette section ####################
###########################################################################################


lasette() {
# Store the page in a variable
page="$(wget "$1" -q -O -)"

# Get the javascript with the URLs
URLS="$(wget -q -O - $(echo "$page" | sed '/starter/!d;s/.*src\=\"//;s/\".*//') | sed '/src:.*\|src_.*/!d;s/.*\: \"//;s/\".*//')"

# Get the title
videoTitolo="$(echo $page | sed 's/.*<title>//;s/<\/title>.*//;s/^ //')"

unformatted="$URLS"
formatoutput


}



###########################################################################################
################## End of Lasette section, beginning of Mediaset section ##################
###########################################################################################



mediaset() {
# Store the page in a variable
page=$(wget "$1" -q -O -)

# Witty tv recongition
[ "$witty" = "y" ] && {
# Get the video id
id=$(echo "$page" | sed '/[<]iframe id=\"playeriframe\" src=\"http\:\/\/www.video.mediaset.it\/player\/playerIFrame.shtml?id\=/!d;s/.*\<iframe id=\"playeriframe\" src=\"http\:\/\/www.video.mediaset.it\/player\/playerIFrame.shtml?id\=//;s/\&.*//')

# Get the title
videoTitolo=$(echo "$page" | sed '/[<]meta content=\".*\" property=\".*title\"\/[>]/!d;s/.*\<meta content\=\"//;s/\".*//g')

} || {
$(echo "$page" | grep "var videoMetadataId")
id="$videoMetadataId"
videoTitolo=$(echo "$page" | sed '/[<]meta content=\".*\" name=\"title\"\/[>]/!d;s/.*\<meta content\=\"//;s/\".*//g')

}

# Get the video URLs using the video id
URLS="$(wget "http://cdnselector.xuniplay.fdnames.com/GetCDN.aspx?streamid=$id" -O - -q -U="" | sed 's/</\
&/g;/http:\/\//!d;s/.*src=\"//;s/\".*//;/^\s*$/d')"


unformatted="$URLS"
formatoutput

}


###########################################################################################
##################### End of Mediaset section, beginning of common section ################
###########################################################################################


common() {
# Store the page in a variable
#page="$(wget -q -O - "$1")"
# Get the video URLs
#base="$(echo "$page" | egrep '\.mp4|\.mkv|\.flv|\.f4v|\.wmv|\.mov|\.3gp|\.avi|\.m4v|\.mpg|\.mpe|\.mpeg' | sed 's/.*http:\/\//http:\/\//;s/\".*//' | sed "s/'.*//" | sed 's/.mp4.*/.mp4/g;s/.mkv.*/.mkv/g;s/.flv.*/.flv/g;s/.f4v.*/.f4v/g;s/.wmv.*/.wmv/g;s/.mov.*/.mov/g;s/.3gp.*/.3gp/g;s/.avi.*/.avi/g;s/.m4v.*/.m4v/g;s/.mpg.*/.mpg/g;s/.mpe.*/.mpe/g;s/.mpeg.*/.mpeg/g' | awk '!x[$0]++')"
#checkurl
#[ "$base" = "" ] && {

tmpjson="$(youtube-dl -J "$1")"
videoTitolo=$(echo "$tmpjson" | sed 's/.*\"title\": \"//g;s/\".*//g')
json="$(echo "$tmpjson" | sed 's/.*requested_formats//g;s/, [{]/\
/g')"
while read -r line; do
    l=$(echo "$line" | sed 's/,/\
/g')
    for f in format url ext; do
     temp="$(echo "$l" | sed '/"'$f'":/!d;s/"'$f'"\: "//g;s/"$//g;s/^ //g;s/^.* - //g')"
     eval $f=\""$temp"\"
    done
    url=$(echo "$url" | tr -s "\n" " " | sed 's/\s.*//')
    format=$(echo "$format" | awk '!x[$0]++' | tr -s "\n" " ")
    ext=$(echo "$ext" | tr -s "\n" " " | sed 's/\s.*//')
    [ "$url" != "" ] && {
size=
timeout -skill 3s wget -S --spider "$url" &>/dev/null && size=", $(wget -S --spider "$url" 2>&1 | sed '/^Length\|^Lunghezza/!d;s/.*(//;s/).*//')B" || size=", Unkown size"
format=$(echo "$format" | sed 's/[(]//g;s/[)]//g')
echo "$url" | grep -q "://" && formats="$format ($ext$size) $url
$formats"
    }
done <<< "$json"

# Get the title
title="${videoTitolo//[^a-zA-Z0-9 ]/}"
title=${title// /_}

}


###########################################################################################
##################### End of Common section, beginning of database section ################
###########################################################################################

video_db() {
# Read formats from database
formats="$(sed -n '/'"$saneuserinput"'/,$p' /var/www/video-db.txt | sed -n '/endofdbentry/q;p' | sed '1d')"

}



###########################################################################################
##################### End of Database section, beginning of working section ###############
###########################################################################################
error() {
videoTitolo=$(basename "$dl")
a="$dl"
getsize
formats="$info $dl"
[ "$formats" = "" ] && exit || echo "$videoTitolo
video $formats"
exit
}

size="$(wget -S --spider "$dl" 2>&1 | sed '/^Length\|^Lunghezza/!d;s/.*[(]//g;s/[)].*//g')"
echo "$size" | grep -q G && error




# May need this in future...
second=$2
third=$3
[ "$ptype" = "common" -a "$second" = "json" ] && youtube-dl -J "$dl" && exit
# Find input URLs in database
$ptype "$dl" "$2" "$3"
[ "$formats" = "" ] && exit || echo "$title $videoTitolo
$formats"

###########################################################################################
################################### End of the script #####################################
################################### That's it folks! ######################################
###########################################################################################


}
api "$@"

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

dl="$(echo $1 | grep -q '^//' && echo http:$1 || echo $1)"

dl="$(echo "$dl" | sed 's/#.*//;s/https:\/\//http:\/\//g')"

urltype="$(curl -w "%{url_effective}\n" -L -s -I -S "$dl" -o /dev/null)"

echo "$urltype" | grep -qE 'http://www.*.rai..*/dl/RaiTV/programmi/media/.*|http://www.*.rai..*/dl/RaiTV/tematiche/*|http://www.*.rai..*/dl/.*PublishingBlock-.*|http://www.*.rai..*/dl/replaytv/replaytv.html.*|http://.*.rai.it/.*|http://www.rainews.it/dl/rainews/.*|http://mediapolisvod.rai.it/.*|http://*.akamaihd.net/*|http://www.video.mediaset.it/video/.*|http://www.video.mediaset.it/player/playerIFrame.*|http://.*wittytv.it/.*|http://la7.it/.*|http://.*.la7.it/.*|http://la7.tv/.*|http://.*.la7.tv/.*' || ptype=common

echo "$urltype" | grep -qE 'http://www.*.rai..*/dl/RaiTV/programmi/media/.*|http://www.*.rai..*/dl/RaiTV/tematiche/*|http://www.*.rai..*/dl/.*PublishingBlock-.*|http://www.*.rai..*/dl/replaytv/replaytv.html.*|http://.*.rai.it/.*|http://www.rainews.it/dl/rainews/.*' && ptype=rai


echo "$urltype" | grep -qE 'http://www.video.mediaset.it/video/.*|http://www.video.mediaset.it/player/playerIFrame.*' && ptype=mediaset

echo "$urltype" | grep -q 'http://.*wittytv.it/.*' && ptype=mediaset && witty=y

echo "$urltype" | grep -qE 'http://la7.it/.*|http://.*.la7.it/.*|http://la7.tv/.*|http://.*.la7.tv/.*' && ptype=lasette

#echo "$urltype" | grep -q 'http.*://.*vk.com/.*' && ptype=vk

#echo "$urltype" | grep -q 'http.*://.*mail.ru/.*' && ptype=mail


##############################################################################
####### End of URL recognition section, beginning of Functions section #######
##############################################################################

# Declare javascript variable

var() {
eval $*
}
# Get video information

getsize() {

info="($(echo "$(echo $a | sed "s/.*\.//;s/[^a-z|0-9].*//"), $(wget -S --spider $a 2>&1 | grep -E '^Length|^Lunghezza' | sed 's/.*(//;s/).*//')B, $(mplayer -vo null -ao null -identify -frames 0 $a 2>/dev/null | grep kbps | awk '{print $3}')" |
sed 's/\
//g;s/^, //g;s/, B,//g;s/, ,/,/g;s/^B,//g;s/, $//;s/ $//g'))"

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
wget -S --tries=3 --spider "$u" 2>&1 | grep -q '200 OK' && base="$base
$u"
}; done
}


# Nicely format input

formatoutput() {

case $ptype in
  rai)
    {
four="$(echo "$unformatted" | grep .*_400.mp4)"
six="$(echo "$unformatted" | grep .*_600.mp4)"
eight="$(echo "$unformatted" | grep .*_800.mp4)"
twelve="$(echo "$unformatted" | grep .*_1200.mp4)"
fifteen="$(echo "$unformatted" | grep .*_1500.mp4)"
eighteen="$(echo "$unformatted" | grep .*_1800.mp4)"
normal="$(echo "$unformatted" | grep -v .*_400.mp4 | grep -v .*_600.mp4 | grep -v .*_800.mp4 | grep -v .*_1200.mp4 | grep -v .*_1500.mp4 | grep -v .*_1800.mp4)"
    }
    ;;
  mediaset)
    {
mp4="$(echo "$unformatted" | grep ".mp4")"
smooth="$(echo "$unformatted" | grep -v "pl)" | grep "est")"
apple="$(echo "$unformatted" | grep "pl)")"
wmv="$(echo "$unformatted" | grep ".wmv")"
flv="$(echo "$unformatted" | grep ".flv")"
f4v="$(echo "$unformatted" | grep ".f4v")"
    }
    ;;
  lasette)
    lamp4="$(echo "$unformatted" | grep -v master | grep -v manifest | grep ".mp4")"
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

formats="$(echo "$formats" | awk '!x[$0]++' | awk '{print $(NF-1), $0}' | sort -g | cut -d' ' -f2-)"
[ "$formats" = "" ] && exit
echo "$userinput
$title $videoTitolo
$formats
endofdbentry" >> /var/www/video-db.txt


}



# Rai website 

rai_normal() {

# iframe check
echo "$file" | grep -q videoURL || { eval $(echo "$file" | grep 'content="ContentItem' | cut -d" " -f2) && file="$(wget http://www.rai.it/dl/RaiTV/programmi/media/"$content".html -qO-)"; }

# read and declare videoURL variables from javascript in page

eval "$(echo "$file" | grep videoURL | sed "s/var//g" | tr -d '[[:space:]]')"

# read and declare title variable from javascript in page
$(echo "$file" | grep videoTitolo)
}

# Rai replay function

replay() {
# Get the video id
v=$(echo "$1" | sed 's/.*v=//;s/\&.*//')

# Get the day
day=$(echo "$1" | sed 's/.*?day=//;s/\&.*//;s/-/_/g')

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
json="$(

echo "$tmpjson" | sed '/'$v'/,//d;s/\,/\
/g;s/\"/\
/g;s/\\//g' | tac | awk "flag != 1; /\}/ { flag = 1 }; " | tac


)"

# Get the relinkers
replay=$(echo "$json" | grep mediapolis | sort | awk '!x[$0]++')

# Get the title
videoTitolo=$(echo "$json" | grep -A 2 '^t$' | awk 'END{print}')


}


# Relinker function



function relinker_rai() {
# Resolve relinker


for f in $(echo $* | awk '{ while(++i<=NF) printf (!a[$i]++) ? $i FS : ""; i=split("",a); print "" }'); do
 
 dl=$(echo $f | grep -q http: && echo $f || echo http:$f)

 # 1st method

 url="$(wget -qO- "$dl&output=25")
$(wget "$dl&output=43" -U="" -q -O -)"
 
 [ "$url" != "" ] && tempbase=$(echo "$url" | sed 's/[>]/\
/g;s/[<]/\
/g' | grep '.*\.mp4\|.*\.wmv\|.*\.mov')
 
 base="$(echo "$tempbase"  | sed 's/\.mp4.*/\.mp4/;s/\.wmv.*/\.wmv/;s/\.mov.*/\.mov/')" && checkurl


 # 2nd method

 [ "$base" = "" ] && {
base="$(eval echo "$(for f in $(echo "$tempbase" | grep ","); do number="$(echo "$f" | sed 's/http\:\/\///g;s/\/.*//;s/[^0-9]//g')"; echo "$f" | sed 's/.*Italy/Italy/;s/^/http\:\/\/creativemedia'$number'\.rai\.it\//;s/,/{/;s/,\./}\./;s/\.mp4.*/\.mp4/'; done)")" && checkurl
 }
 

 # 3rd and 4th method
 [ "$base" = "" ] && {
url="$(wget "$dl&output=4" -q -O -)"
[ "$url" != "" ] && echo "$url" | grep -q creativemedia && base="$url" || base=$(curl -w "%{url_effective}\n" -L -s -I -S $dl -A "" -o /dev/null); checkurl
 }


 #[ "$base" = "" ] && base="$(curl -w "%{url_effective}\n" -L -s -I -S "$dl" -o /dev/null -A='')" && checkurl 


 TMPURLS="$TMPURLS
$base"

done

# Remove copies of the same url
base="$(echo "$TMPURLS" | sort | awk '!x[$0]++')"

# Find all qualities in every video
tbase=
for t in _400.mp4 _600.mp4 _800.mp4 _1200.mp4 _1500.mp4 _1800.mp4 .mp4; do for i in _400.mp4 _600.mp4 _800.mp4 _1200.mp4 _1500.mp4 _1800.mp4; do tbase="$tbase
$(echo "$base" | sed "s/$t/$i/")"; tbase="$(echo "$tbase" | awk '!x[$0]++')"; done;done


base="$tbase"

checkurl

unformatted="$base"
formatoutput


}

###########################################################################################
################## End of Rai relinker section, beginning of Rai section ##################
###########################################################################################


function rai() {

# Store the page in a variable
file=$(wget $1 -q -O -)

# Rai replay or normal rai website choice
echo $1 | grep -q http://www.*.rai..*/dl/replaytv/replaytv.html.* && replay $1 || rai_normal $1

title="${videoTitolo//[^a-zA-Z0-9 ]/}"
title=`echo $title | tr -s " "`
title=${title// /_}

# Resolve relinkers
relinker_rai $videoURL_M3U8 $videoURL_MP4 $videoURL_H264 $videoURL_WMV $videoURL $replay
}


###########################################################################################
##################### End of Rai section, beginning of Lasette section ####################
###########################################################################################


lasette() {
# Store the page in a variable
page="$(wget $1 -q -O -)"

# Get the javascript with the URLs
URLS="$(wget -q -O - $(echo "$page" | grep starter | sed 's/.*src\=\"//;s/\".*//') | grep -E 'src:.*|src_.*' | sed 's/.*\: \"//;s/\".*//')"

# Get the title
videoTitolo="$(echo $page | sed 's/.*<title>//;s/<\/title>.*//' | sed 's/^ //')"

title="${videoTitolo//[^a-zA-Z0-9 ]/}"
title=`echo $title | tr -s " "`
title=${title// /_}

unformatted="$URLS"
formatoutput


}



###########################################################################################
################## End of Lasette section, beginning of Mediaset section ##################
###########################################################################################



mediaset() {
# Store the page in a variable
page=$(wget $1 -q -O -)

# Witty tv recongition
[ "$witty" = "y" ] && {
# Get the video id
id=$(echo "$page" | grep '\<iframe id=\"playeriframe\" src=\"http\:\/\/www.video.mediaset.it\/player\/playerIFrame.shtml?id\=' | sed 's/.*\<iframe id=\"playeriframe\" src=\"http\:\/\/www.video.mediaset.it\/player\/playerIFrame.shtml?id\=//;s/\&.*//')

# Get the title
videoTitolo=$(echo "$page" | grep -o "<meta content=\".*\" property=\".*title\"/>" | sed 's/.*\<meta content\=\"//;s/\".*//g')

} || {
eval $(echo "$page" | grep "var videoMetadataId" | sed 's/var //' | tr -d '[[:space:]]')
id="$videoMetadataId"
videoTitolo=$(echo "$page" | grep -o "<meta content=\".*\" name=\"title\"/>" | sed 's/.*\<meta content\=\"//;s/\".*//g')

}

title="${videoTitolo//[^a-zA-Z0-9 ]/}"
title=`echo $title | tr -s " "`
title=${title// /_}

# Get the video URLs using the video id
URLS="$(wget "http://cdnselector.xuniplay.fdnames.com/GetCDN.aspx?streamid=$id" -O - -q -U="" | sed 's/</\
&/g' | grep http:// | sed 's/.*src=\"//;s/\".*//' |  sed '/^\s*$/d')"


unformatted="$URLS"
formatoutput

}


###########################################################################################
##################### End of Mediaset section, beginning of common section ################
###########################################################################################


common() {
# Store the page in a variable
#page="$(wget -q -O - $1)"
# Get the video URLs
#base="$(echo "$page" | egrep '\.mp4|\.mkv|\.flv|\.f4v|\.wmv|\.mov|\.3gp|\.avi|\.m4v|\.mpg|\.mpe|\.mpeg' | sed 's/.*http:\/\//http:\/\//;s/\".*//' | sed "s/'.*//" | sed 's/.mp4.*/.mp4/g;s/.mkv.*/.mkv/g;s/.flv.*/.flv/g;s/.f4v.*/.f4v/g;s/.wmv.*/.wmv/g;s/.mov.*/.mov/g;s/.3gp.*/.3gp/g;s/.avi.*/.avi/g;s/.m4v.*/.m4v/g;s/.mpg.*/.mpg/g;s/.mpe.*/.mpe/g;s/.mpeg.*/.mpeg/g' | awk '!x[$0]++')"
#checkurl
#[ "$base" = "" ] && {

tmpjson="$(youtube-dl -J "$1")"
videoTitolo=$(echo "$tmpjson" | sed 's/.*\"title\": \"//g;s/\".*//g')
json="$(echo "$tmpjson" | sed 's/.*formats//g;s/, [{]/\
/g')"
while read -r line; do
    l=$(echo "$line" | sed 's/,/\
/g')
    for f in format url ext; do
     temp="$(echo "$l" | grep \"$f\": | sed 's/"'$f'"\: "//g;s/"$//g;s/^ //g;s/^.* - //g')"
     eval $f=\""$temp"\"
    done
    [ "$url" != "" ] && {
size=
timeout -skill 3s wget -S --spider "$url" &>/dev/null && size=", $(wget -S --spider "$url" 2>&1 | grep -E '^Length|^Lunghezza' | sed 's/.*(//;s/).*//')B" || size=", Unkown size"
format=$(echo "$format" | sed 's/[(]//g;s/[)]//g')
formats="$formats
$format ($ext$size) $url"
    }
done <<< "$json"

# Get the title
title="${videoTitolo//[^a-zA-Z0-9 ]/}"
title=`echo $title | tr -s " "`
title=${title// /_}

echo "$userinput
$title $videoTitolo
$formats
endofdbentry" >> /var/www/video-db.txt
}


vk() {
page="$(wget -q -O - $(echo "$1" | sed 's/http:\/\/m.vk/http:\/\/vk/'))"

URLS="$(echo "$page" | sed 's/,/\
/g' | egrep '\.mp4|\.mkv|\.flv|\.f4v|\.wmv|\.mov|\.3gp|\.avi|\.m4v|\.mpg|\.mpe|\.mpeg' | sed 's/\\//g;s/.*http:\/\//http:\/\//;s/\".*//' | sed "s/'.*//" | awk '!x[$0]++' | tr -s " " "\n")"


[ "$URLS" = "" ] && exit

videoTitolo="$(echo "$page" | grep '<title>' | sed 's/.*<title>//;s/<\/title>.*//' | sed 's/^ //' | translit -t "GOST 7.79 RUS")"


title="${videoTitolo//[^a-zA-Z0-9 ]/}"
title=`echo $title | tr -s " "`
title=${title// /_}

unformatted="$URLS"
formatoutput

}

mail() {
page="$(wget -q -O - $(echo "$1" | sed 's/http:\/\/.*.mail.ru/http:\/\/videoapi.my.mail.ru\/videos/;s/.html$/.json/') | sed 's/{/\
/g' )"


twom="320x180 $(echo "$page" | grep 240p | sed 's/,/\
/g' | egrep '\.mp4|\.mkv|\.flv|\.f4v|\.wmv|\.mov|\.3gp|\.avi|\.m4v|\.mpg|\.mpe|\.mpeg' | sed 's/\\//g;s/.*http:\/\//http:\/\//;s/\".*//' | sed "s/'.*//" | awk '!x[$0]++')"

[ "$(echo $twom | grep ' ' | sed 's/^.* //' )" != "" ] && URLS="$twom"


threem="640x360 $(echo "$page" | grep 360p | sed 's/,/\
/g' | egrep '\.mp4|\.mkv|\.flv|\.f4v|\.wmv|\.mov|\.3gp|\.avi|\.m4v|\.mpg|\.mpe|\.mpeg' | sed 's/\\//g;s/.*http:\/\//http:\/\//;s/\".*//' | sed "s/'.*//" | awk '!x[$0]++')"

[ "$(echo $threem | grep ' ' | sed 's/^.* //' )" != "" ] && URLS="$URLS
$threem"

fourm="720x480 $(echo "$page" | grep 480p | sed 's/,/\
/g' | egrep '\.mp4|\.mkv|\.flv|\.f4v|\.wmv|\.mov|\.3gp|\.avi|\.m4v|\.mpg|\.mpe|\.mpeg' | sed 's/\\//g;s/.*http:\/\//http:\/\//;s/\".*//' | sed "s/'.*//" | awk '!x[$0]++')"

[ "$(echo $fourm | grep ' ' | sed 's/^.* //')" != "" ] && URLS="$URLS
$fourm"


sevenm="1280x720 $(echo "$page" | grep 720p | sed 's/,/\
/g' | egrep '\.mp4|\.mkv|\.flv|\.f4v|\.wmv|\.mov|\.3gp|\.avi|\.m4v|\.mpg|\.mpe|\.mpeg' | sed 's/\\//g;s/.*http:\/\//http:\/\//;s/\".*//' | sed "s/'.*//" | awk '!x[$0]++')"

[ "$(echo $sevenm | grep ' ' | sed 's/^.* //')" != "" ] && URLS="$URLS
$sevenm"

tenm="1920x1080 $(echo "$page" | grep 1080p | sed 's/,/\
/g' | egrep '\.mp4|\.mkv|\.flv|\.f4v|\.wmv|\.mov|\.3gp|\.avi|\.m4v|\.mpg|\.mpe|\.mpeg' | sed 's/\\//g;s/.*http:\/\//http:\/\//;s/\".*//' | sed "s/'.*//" | awk '!x[$0]++')"

[ "$(echo $tenm | grep ' ' | sed 's/^.* //')" != "" ] && URLS="$URLS
$tenm"


[ "$URLS" = "" ] && exit

videoTitolo="$(echo "$page" | grep 'title' | sed 's/.*\"title\"\:\"//;s/\".*//' | translit -t "GOST 7.79 RUS")"


title="${videoTitolo//[^a-zA-Z0-9 ]/}"
title=`echo $title | tr -s " "`
title=${title// /_}

unformatted="$URLS"

formatoutput

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
videoTitolo=$(basename $dl)
a=$dl
getsize
formats="$(echo "$info" | sed 's/[(]//;s/[)]//') $dl"
[ "$formats" = "" ] && exit || echo "$title $videoTitolo
$formats"
exit
}

size="$(wget -S --spider $dl 2>&1 | grep -E '^Length|^Lunghezza' | sed 's/.*[(]//g;s/[)].*//g')"
echo "$size" | grep -q G && error
[ ${size%?} -gt 20 ] && error




# May need this in future...
second=$2
third=$3

# Find input URLs in database
userinput="$dl"
saneuserinput="$(echo "$dl" | sed 's/\//\\\//g' | sed 's/\&/\\\&/g' )"

grep -q ^"$saneuserinput"$ /var/www/video-db.txt && {
video_db
[ "$formats" = "" ] && exit || echo "$title $videoTitolo
$formats"
} || {
$ptype $dl $2 $3
[ "$formats" = "" ] && exit || echo "$title $videoTitolo
$formats"
}

###########################################################################################
################################### End of the script #####################################
################################### That's it folks! ######################################
###########################################################################################


}
api $*

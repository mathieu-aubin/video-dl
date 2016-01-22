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
 
 
 echo "$urltype" | grep -qE 'http://www.*.rai..*/dl/RaiTV/programmi/media/.*|http://www.*.rai..*/dl/RaiTV/tematiche/.*|http://www.*.rai..*/ dl/.*PublishingBlock-.*|http://www.*.rai..*/dl/replaytv/replaytv.html.*|http://.*.rai.it/.*|http://www.rainews.it/dl/rainews/.*|https://www.*.rai..*/dl/ RaiTV/programmi/media/.*|https://www.*.rai..*/dl/RaiTV/tematiche/.*|https://www.*.rai..*/dl/.*PublishingBlock-.*|https://www.*.rai..*/dl/ replaytv/replaytv.html.*|https://.*.rai.it/.*|https://www.rainews.it/dl/rainews/.*' && ptype=rai
 
 
 echo "$urltype" | grep -qE 'http://www.video.mediaset.it/video/.*|http://www.video.mediaset.it/player/playerIFrame.*|https:// www.video.mediaset.it/video/.*|https://www.video.mediaset.it/player/playerIFrame.*|tgcom24.mediaset.it/video/.*|http://mediaset.it/.*|https:// mediaset.it/.*' && ptype=mediaset
 
 echo "$urltype" | grep -qE 'http://.*wittytv.it/.*|https://.*wittytv.it/.*' && ptype=mediaset && witty=y
 
 echo "$urltype" | grep -qE 'http://la7.it/.*|http://.*.la7.it/.*|http://la7.tv/.*|http://.*.la7.tv/.*|https://la7.it/.*|https://.*.la7.it/.*|https://la7.tv/.*| https://.*.la7.tv/.*' && ptype=lasette
 
 echo "$urltype" | grep -qE '.*dplay.com/.*|.*dmax.it.*|.*realtimetv.it.*|.*giallotv.it.*|.*focustv.it.*|.*k2tv.it.*|.*frisbeetv.it.*' && ptype=dplay
 
 echo "$urltype" | grep -qE '.*deejay.it.*' && ptype=deejay
 
 echo "$urltype" | grep -qE '.*eurosport.com.*' && ptype=eurosport
 echo "$urltype" | grep -qE '.*wat.tv.*' && ptype=wat
 
 [ "$ptype" = "" ] && ptype="common"
 
 dl="$urltype"
 [ "$ptype" = "rai" ] && echo "$1" | grep -q '#' && dl="$1"
 
 ##############################################################################
 ####### End of URL recognition section, beginning of Functions section #######
 ##############################################################################

 # Declare javascript variable

 var() {
  eval $(echo "$*" | sed 's/var//g;s/\s=\s/=/g')
 }
 # Get video information

 getsize() {
  minfo="$(timeout -skill 5s mediainfo "$a")"
  info="($(echo "$(echo "$a" | sed "s/.*\.//;s/[^a-z|0-9].*//"), $(echo "$minfo" | sed '/File size/!d;s/.*:\s//g'), $(echo "$minfo" | sed '/Width\|Height/!d;s/.*:\s//g;s/\spixels//g;s/\s//g;/^\s*$/d' | tr -s "\n" x | sed 's/x$//g')" |
sed 's/\
//g;s/^, //g;s/, B,/, Unkown size,/g;s/, ,/,/g;s/^B,//g;s/, $//;s/ $//g'))"
  minfo=
 }


 # Check if URL exists and remove copies of the same URL

 checkurl() {
 tbase="$(echo "$base" | sed 's/ /%20/g;s/%20http:\/\//\
http:\/\//g;s/%20https:\/\//\
https:\/\//g;s/%20$//g;s/ /\
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
    ;;
   mediaset)
    mp4="$(echo "$unformatted" | grep ".mp4")"
    smooth="$(echo "$unformatted" | sed '/pl[)]/d;/est/!d')"
    apple="$(echo "$unformatted" | grep "pl)")"
    wmv="$(echo "$unformatted" | grep ".wmv")"
    flv="$(echo "$unformatted" | grep ".flv")"
    f4v="$(echo "$unformatted" | grep ".f4v")"
    ;;
   lasette)
    lamp4="$(echo "$unformatted" | sed '/master/d;/manifest/d;/\.mp4/!d')"
    ;;
   *)
    common="$unformatted"
  esac


  formats="$(
[ "$common" != "" ] && for a in $common; do getsize
# info="$(echo "$info" | sed 's/[(]//;s/[)]//')"

 echo "$info $a";done

[ "$lamp4" != "" ] && for a in $lamp4; do getsize

 echo "$info $a";done

[ "$normal" != "" ] && for a in $normal; do getsize

 echo "$info $a";done

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
  videoTitolo=$(echo "$videoTitolo" | tr -d '\015' | tr -s "\n" " ")
  title="${videoTitolo//[^a-zA-Z0-9 ]/}"
  title=$(echo $title | sed 's/^\s*//g;s/\s*$//g')
  title=${title// /_}
 }


 ########################################################################################### 
 ################## End of formatting section, beginning of Rai section ##################
 ###########################################################################################


 rai() { 
  saferai="$1"
  # Store the page in a variable
  file=$(wget "$saferai" -q -O -)

  # Rai replay or normal rai website choice
  echo "$1" | grep -q 'http://www.*.rai..*/dl/replaytv/replaytv.html.*' && replay "$saferai" || rai_normal "$saferai"
  links="$videoURL_M3U8 $videoURL_MP4 $videoURL_H264 $videoURL_WMV $videoURL $replay"
  links="$(echo "$links" | sed '/^\s*$/d')"
  videoTitolo="$(echo -en "$videoTitolo")"
  [ "$links" = "" ] && replay "$saferai"
  links="$videoURL_M3U8 $videoURL_MP4 $videoURL_H264 $videoURL_WMV $videoURL $replay"
  [ "$videoTitolo" = "" ] && videoTitolo=$(echo "$file" | tr '\n' ' ' | sed 's/.*<title>//;s/<\/title>.*//;s/^ //')
  # Resolve relinkers
  relinker_rai "$links"
 }


 # Rai website 

 rai_normal() {

  echo "$1" | grep -q "rainews.it" && {
   bsp=$(echo "$file" | sed '/parentPage.bsp /!d;'"s/.* '//;s/'.*//")
   jsons=$(echo "$file" | sed '/"url" : "http/!d;s/.* : "//;s/".*//')
   json=$(curl -s $jsons)
  } || {
   # iframe check
   echo "$file" | grep -q videoURL || { urls="http://www.rai.it/dl/RaiTV/programmi/media/"$(echo "$file" | sed '/content="ContentItem/!d;s/.*content="//g;s/".*//g')".html http://www.rai.tv$(echo "$file" | grep -A1 '<div id="idFramePlayer">' | sed '/\<iframe/!d;s/.*src="//g;s/?.*//g') $(echo "$file" | sed '/drawMediaRaiTV/!d;s/.*http/http/g;s/'"'"'.*//g')"; file="$(wget -qO- $urls)"; }
  }
  # read and declare videoURL and videoTitolo variables from javascript in page

  $(echo "$file" | grep 'videoTitolo\|videoURL')

 }


 # Rai replay function

 replay() {
  # Get the video id
  v=$(echo "$1" | sed 's/.*v=//;s/\&.*//')

  # Get the day
  day=$(echo "$1" | sed 's/.*day=//;s/\&.*//;s/-/_/g;/http/d')
  [ "$day" = "" ] && day=$(echo "$1" | sed 's/.*vd=//;s/\&.*//;s/-/_/g')

  ch=$(echo "$1" | sed 's/.*ch=//;s/\&.*//;/http/d')
  [ "$ch" = "" ] && ch=$(echo "$1" | sed 's/.*vc=//;s/\&.*//')

  # Get the channel
  case $ch in
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
tmpjson="$(wget http://www.rai.it/dl/portale/html/palinsesti/replaytv/static/"$ch"_$day.html -qO- | tr '\n' ' ')"

  # Keep only section with correct video id and make it grepable
  json="$(echo "$tmpjson" | sed 's/'$v'.*//g;s/.*[{]//g;s/\,/\
/g')"

  # Get the relinkers
  replay=$(echo "$json" | sed '/mediapolis/!d;s/.*\"://g;s/\"//g;s/^ *//g')

  # Get the title
  videoTitolo=$(echo "$json" | sed '/\"t\":/!d;s/.*\"://;s/\"//g;s/^ *//g')
 }


 # Relinker function



 relinker_rai() {
 # Resolve relinker


  for f in $(echo $* | awk '{ while(++i<=NF) printf (!a[$i]++) ? $i FS : ""; i=split("",a); print "" }'); do
   dl=$(echo "$f" | grep -q '^//' && echo "http:$f" || echo "$f")

   # 1st method

   url="$(timeout -skill 5s wget -qO- "$dl&output=25")
$(timeout -skill 5s wget "$dl&output=43" -U="" -q -O -)"

   url="$(echo "$url" | sed 's/[>]/\
/g;s/[<]/\
/g')"

   [ "$url" != "" ] && base="$(echo "$url" | sed '/\.mp4\|\.wmv\|\.mov/!d;s/mms/http/g;/http/!d;s/\.mp4.*/\.mp4/;s/\.wmv.*/\.wmv/;s/\.mov.*/\.mov/')" && checkurl


   # 2nd method

   [ "$base" = "" ] && {
    base="$(eval echo "$(for f in $(echo "$url" | grep ","); do number="$(echo "$f" | sed 's/http\:\/\///g;s/\/.*//;s/[^0-9]//g;s/^.*\(.\{1\}\)$/\1/')"; echo "$f" | sed 's/.*Italy/Italy/;s/^/http\:\/\/creativemedia'$number'\.rai\.it\//;s/,/{/;s/,\./}\./;s/\.mp4.*/\.mp4/'; done)")" && checkurl
   }
 

   # 3rd and 4th method
   [ "$base" = "" ] && {
    url="$(wget "$dl&output=4" -q -O -)"
    [ "$url" != "" ] && echo "$url" | grep -q 'creativemedia\|wms' && base="$url" || base=$(curl -w "%{url_effective}\n" -L -s -I -S "$dl" -A "" -o /dev/null)
    checkurl
   }

   TMPURLS="$TMPURLS
$base"

  done

  # Remove copies of the same url
  base="$(echo "$TMPURLS" | sort | awk '!x[$0]++')"

  # Find all qualities in every video
  tbase=
  loop="_250 _400 _600 _700 _800 _1200 _1500 _1800 _2400 _3200 _4000"
  
  for t in $loop \ ; do [ "$t" = " " ] && t=; for i in $loop; do tbase="$tbase
${base//$t\.mp4/$i\.mp4}"; tbase="$(echo "$tbase" | grep -Ev "_([0-9]{3,4})_([0-9]{3,4})\.mp4" | awk '!seen[$0]++')"; done;done


  base="$tbase"

  checkurl

  unformatted="$base"
  formatoutput
 }


 ###########################################################################################
 ##################### End of Rai section, beginning of Lasette section ####################
 ###########################################################################################


 lasette() {
  # Store the page in a variable
  page="$(wget "$1" -q -O -)"

  # Get the javascript with the URLs
  unformatted="$(wget -q -O - $(echo "$page" | sed '/starter/!d;s/.*src\=\"//;s/\".*//') | sed '/src:.*\|src_.*/!d;s/.*\: \"//;s/\".*//')"

  # Get the title
  videoTitolo="$(echo "$page" | tr '\n' ' ' | sed 's/.*<title>//;s/<\/title>.*//;s/^ //')"

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
  unformatted="$(wget "http://cdnselector.xuniplay.fdnames.com/GetCDN.aspx?streamid=$id" -O - -q -U="" | sed 's/</\
&/g;/http:\/\//!d;s/.*src=\"//;s/\".*//;/^\s*$/d')"

  formatoutput

 }

 ###########################################################################################
 ##################### End of Mediaset section, beginning of dplay section ################
 ###########################################################################################

 dplay() {
  id=$(curl -Ls "$dl" | sed '/data-video-id\=\"/!d;s/.*data-video-id\=\"//g;s/\".*//g')
  [ "$id" = "" ] && {
   orig=$(curl -Ls "$dl" | sed '/dplay.com/!d;s/.*href="http/http/g;s/".*//g') && 
   id=$(curl -Ls "$orig" | sed '/data-video-id\=\"/!d;s/.*data-video-id\=\"//g;s/\".*//g')
  }
  json="$(curl -Ls http://it.dplay.com/api/v2/ajax/videos?video_id=$id)"
  unformatted="$(echo "$json" | sed 's/\"\:\"/\
/g' | sed '/mp4/!d;s/\".*//g;s/\\//g')"
  videoTitolo=$(echo "$json" | sed 's/.*","title":"//g;s/".*//g')
  formatoutput
 }

 ###########################################################################################
 ##################### End of dplay section, beginning of deejay section ################
 ###########################################################################################
 deejay() {
  file="$(curl -sL "$1")"
  unformatted="$(echo "$file" | sed '/addParam[(]'"'"'format'"'"', /!d;s/.*'"'"'http/http/g;s/'"'"'.*//g')"
  videoTitolo=$(echo $file | sed 's/.*<title>//;s/<\/title>.*//;s/^ //')
  formatoutput
 }

 ###########################################################################################
 ##################### End of deejay section, beginning of eurosport section ################
 ###########################################################################################
 eurosport() {
  file="$(curl -sL "$1")"
  frame="$(echo $file | sed 's/.*src=\"http:\/\/www.wat.tv\/embedframe/http:\/\/www.wat.tv\/embedframe/g;s/\".*//g')"
  videoTitolo=$(echo $file | sed 's/.*<title>//;s/<\/title>.*//;s/^ //')
  wat_base "$frame"
  formatoutput
 }
 ###########################################################################################
 ##################### End of eurosport section, beginning of wat section ################
 ###########################################################################################

 wat_base() {
  file="$(curl -sL "$1")"
  unformatted="$(echo "$file" | sed 's/,/\
/g' | sed '/PlayerLite.swf?videoId=/!d;s/.*\/\/www.wat.tv\/images/\/\/wat.tv\/images/g;s/\".*//g' | awk '!x[$0]++')"

 }
 wat() {
  wat_base "$1"
  videoTitolo=$(echo $file | sed 's/.*<title>//;s/<\/title>.*//;s/^ //')
  formatoutput
 }
 ###########################################################################################
 ##################### End of wat section, beginning of common section ################
 ###########################################################################################

 common() {
  # Store the page in a variable
  page="$(wget -q -O - "$1")"

  json="$(youtube-dl -J "$1" | ./JSON.sh -s)"
  videoTitolo=$(echo "$json" | sed '/\["title"\]/!d;s/.*\t"//g;s/".*//g')
  urls="$(echo "$json" | sed '/\["formats",.*,"url"\]\|\["url"\]\|\["entries",.*,"url"\]/!d;s/.*\t"//g;s/".*//g')"
  formats="$(echo "$json" | sed '/\["formats",.*,"format"\]\|\["format"\]\|\["entries",.*,"format"\]/!d;s/.*\t"//g;s/".*//g;s/[(]\|[)]//g')"
  exts="$(echo "$json" | sed '/\["formats",.*,"ext"\]\|\["ext"\]\|\["entries",.*,"ext"\]/!d;s/.*\t"//g;s/".*//g')"
  ws="$(echo "$json" | sed '/\["formats",.*,"width"\]\|\["width"\]\|\["entries",.*,"width"\]/!d;s/.*\t//g')"
  hs="$(echo "$json" | sed '/\["formats",.*,"height"\]\|\["height"\]\|\["entries",.*,"height"\]/!d;s/.*\t//g')"
  sizes="$(echo "$json" | sed '/\["formats",.*,"filesize"\]\|\["filesize"\]\|\["entries",.*,"filesize"\]/!d;s/.*\t//g' | awk ' function human(x) { if (x<1000) {return x} else {x/=1024} s="kMGTEPYZ"; while (x>=1000 && length(s)>1) {x/=1024; s=substr(s,2)} return int(x+0.5) substr(s,1,1) } {sub(/^[0-9]+/, human($1)); print}')"
  n=1
  while read -r line; do
    a=$line
    [ "$a" != "" ] && {
     format=$(echo "$formats" | sed $n'q;d')
     ext=$(echo "$exts" | sed $n'q;d')
     width=$(echo "$hs" | sed $n'q;d')
     height=$(echo "$ws" | sed $n'q;d')
     size=$(echo "$sizes" | sed $n'q;d')
     [ "$width" = "" -a "$height" = "" ] && quality="Unkown quality" || quality=$width"x"$height
     [ "$size" = "" -o "$size" = "null" ] && size="Unkown size"
     info="("$ext", "$size", "$quality")"
     final="$final
$format $info $a"
     n=$(($n + 1))
    }
  done <<< "$urls"
  n=
  final="$(echo "$final" | awk '!x[$0]++')"
  [ "$final" = "" ] && {
   base="$(echo "$tmpjson" | sed 's/\"/\
/g' | egrep '\.mp4|\.mkv|\.flv|\.f4v|\.wmv|\.mov|\.3gp|\.avi|\.m4v|\.mpg|\.mpe|\.mpeg'  | awk '!x[$0]++')"
   checkurl
   unformatted="$base"
   formatoutput
  }

  [ "$final" = "" ] &&  {

   # Get the video URLs
   base="$(echo "$page" | egrep '\.mp4|\.mkv|\.flv|\.f4v|\.wmv|\.mov|\.3gp|\.avi|\.m4v|\.mpg|\.mpe|\.mpeg' | sed 's/.*http:\/\//http:\/\//;s/\".*//' | sed "s/'.*//" | sed 's/.mp4.*/.mp4/g;s/.mkv.*/.mkv/g;s/.flv.*/.flv/g;s/.f4v.*/.f4v/g;s/.wmv.*/.wmv/g;s/.mov.*/.mov/g;s/.3gp.*/.3gp/g;s/.avi.*/.avi/g;s/.m4v.*/.m4v/g;s/.mpg.*/.mpg/g;s/.mpe.*/.mpe/g;s/.mpeg.*/.mpeg/g' | awk '!x[$0]++')"
   checkurl
   unformatted="$base"

   formatoutput
  }

  [ "$videoTitolo" = "" ] && videoTitolo=$(echo "$page" | tr "\n" " " | sed 's/<\/title>.*//;s/.*>//g;s/^ //')
  formats="$final"
  # Get the title
  title="${videoTitolo//[^a-zA-Z0-9 ]/}"
  title=${title// /_}

}




 ###########################################################################################
 ##################### End of common section, beginning of working section ###############
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

 size="$(mediainfo "$dl" | sed '/size/!d;s/.*:\s//g')"
 echo "$size" | grep -q G && error




 # May need this in future...
 second=$2
 third=$3
 [ "$ptype" = "common" -a "$second" = "json" ] && youtube-dl -J "$dl" && exit

 [ "$second" = "check" ] && {
  wget -qO /dev/null "$1" && {
   youtube-dl "$1" &>/dev/null || youtube-dl --verbose -J "$1" 2>&1
  };
  exit
 }
 # Find input URLs in database
 $ptype "$dl" "$2" "$3"
 [ "$formats" = "" ] && common "$dl" "$2" "$3"
 [ "$formats" = "" ] && exit || echo "$title $videoTitolo
$formats"

 ###########################################################################################
 ################################### End of the script #####################################
 ################################### That's it folks! ######################################
 ###########################################################################################


}

api "$@"

#!/bin/bash
# Rai.TV download script
# Created by Daniil Gentili (http://daniil.eu.org)
# Uses Andrea Lazzarotto's (http://andrealazzarotto.com) server (http://video.lazza.dk) to decode URLs in automatic mode.
# Changelog:
# v1 (and revisions): initial version.
# v2 (and revisions): added support for Rai Replay, support for multiple qualities, advanced video info and custom API server.
#

[ "$1" = "--help" ] && echo "Rai.tv download script
Created by Daniil Gentili
Uses Andrea Lazzarotto's server to decode the URLs (when -a is specified).
Usage: $(basename $0) [ -qmf [ urls.txt ] ] URL URL2 URL3 ...

Options:

-q	Quiet mode: useful for crontab jobs, automatically enables -a.
-a	Automatic/Andrea mode: automatically download the video in the maximum quality using Andrea's server.
-f	Reads URL(s) from specified text file(s).
--help	Show this extremely helpful message.

" && exit

[ "$*" = "" ] && echo "No url specified. Aborting." && exit 1

[ "$1" = "-q" ] && WOPT="-q" && shift
[ "$1" = "-a" ] && A=y && shift
[ "$1" = "-f" ] && F=y && shift
[ "$1" = "-qa" ] && WOPT="-q" && A=y && shift

[ "$1" = "-af" ] && A=y && F=y && shift

[ "$1" = "-qf" ] && WOPT="-q" && F=y && shift

[ "$1" = "-qaf" ] && WOPT="-q" && A=y && F=y && shift

[ "$1" = "-aq" ] && WOPT="-q" && A=y && shift
[ "$1" = "-fa" ] && A=y && F=y && shift
[ "$1" = "-fq" ] && WOPT="-q" && F=y && shift
[ "$1" = "-afq" ] && WOPT="-q" && A=y && F=y && shift
[ "$1" = "-faq" ] && WOPT="-q" && A=y && F=y && shift
[ "$1" = "-aqf" ] && WOPT="-q" && A=y && F=y && shift
[ "$WOPT" = "-q" ] && A=y
[ "$F" = "y" ] && URL="$(cat "$*")" || URL="$*"

echo -n "Self-updating script..." && wget http://daniilgentili.magix.net/rai.sh -O $0 -q 2>/dev/null ; echo -en "\r\033[K" ; exec $0 $*; exit $?

function var() {
eval $*
}


if [ "$A" = "y" ]; then

 function relinker_rai() {
set +u
dl=$(wget http://video.lazza.dk/rai/?r=$(echo $videoURL_MP4 || echo $videoURL_H264 || echo $videoURL_WMV || echo $videoURL || echo $1) -q -O -)
set +u
ext=$(echo $dl | awk -F. '$0=$NF')
queue="$queue
wget $dl -O $title.$ext $WOPT
"
 }
else

 echo "Video(s) info:" &&
 function relinker_rai() {
sane="$(echo "$u" | sed 's/\&/%26/g' | sed 's/\=/%3D/g' | sed 's/\:/%3A/g' | sed 's/\//%2F/g' | sed 's/\?/%3F/g')"

api="$(wget "http://video.daniil.it/api/rai.php?url=$sane" -q -O - | sed '/^\s*$/d')"

max="$(echo "$api" | awk 'END{print}' | grep -Eo '^[^ ]+')"

echo "Title: $videoTitolo

$(echo "$api" | sed 's/http.*//')

"

until [ "$l" -le "$max" ] && [ "$l" -gt 0 ] ; do echo -n "What quality do you whish to download (number)? "; read l;done 2>/dev/null


url=$(echo "$api" | sed "$l!d" | awk 'NF>1{print $NF}')


ext=$(echo $url | awk -F. '$0=$NF')

queue="$queue
wget $url -O $title.$ext $WOPT
"
 }
fi


for u in $URL; do
 curl --version &>/dev/null && (curl -Ls -o /dev/null -w %{url_effective} $u | grep -qE 'http://www*.rai.*/dl/RaiTV/programmi/media/*|http://www*.rai.*/dl/RaiTV/tematiche/*|http://www*.rai.*/dl/*PublishingBlock-*|http://www*.rai.*/dl/replaytv/replaytv.html*|http://*.rai.it/*|http://www.rainews.it/dl/rainews/*' || continue) || echo $u  | grep -qE 'http://www*.rai.*/dl/RaiTV/programmi/media/*|http://www*.rai.*/dl/RaiTV/tematiche/*|http://www*.rai.*/dl/*PublishingBlock-*|http://www*.rai.*/dl/replaytv/replaytv.html*|http://*.rai.it/*|http://www.rainews.it/dl/rainews/*' || continue
 file=$(wget $u -q -O -)
 echo $u | grep -q http://www.*.rai..*/dl/replaytv/replaytv.html.*
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
awk '/\{/{i++}i' |
tr -s "," "\n" |
tr -s '"' "\n" |
sed 's/\\//g'; else echo "$json" |
sed -n "1,/$v/p" |
awk '/\{/{i++}i' |
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
  relinker_rai
 fi

done && echo "Downloading videos..." && eval $queue && echo "All downloads completed successfully."

#!/bin/bash
# Video download script
# Created by Daniil Gentili (http://daniil.it)
# This program is licensed under the GPLv3 license.
# Changelog:
# v1 (and revisions): initial version.
# v2 (and revisions): added support for Rai Replay, support for multiple qualities, advanced video info and custom API server.
# v3 (and revisions): added support for Mediaset, Witty TV, La7, etc..

echo "This program is licensed under the GPLv3 license."
[ "$1" = "--help" ] || [ "$*" = "" ]&& echo "Video download script
Created by Daniil Gentili
Supported websites: $(wget -q -O - http://api.daniil.it/?p=websites)
Usage: $(basename $0) [ -qmf [ urls.txt ] --player=player ] URL URL2 URL3 ...

Options:

-q		Quiet mode: useful for crontab jobs, automatically enables -a.
-a		Automatic mode: automatically download the video in the maximum quality.
-f		Reads URL(s) from specified text file(s). If specified, you cannot provide the URLs as an argument.
--player=player	Play the video instead of downloading it using specified player, mplayer if none specified.
--help		Show this extremely helpful message.

" && [ "$*" = "" ] && echo "No url specified." && exit

which smooth.sh &>/dev/null && smoothsh=y || smoothsh=n
which ffmpeg &>/dev/null && ffmpeg=y || ffmpeg=n

urlformatcheck() {
case $urlformat in
  smooth\ streaming)
    queue="$queue
`[ "$smoothsh" = "y" ] && echo "smooth.sh \\"$url\\" \\"$title.mkv\\"" || echo "echo \"Manifest URL: $url\""`
    "
    ;;
  apple\ streaming)
    queue="$queue
`[ "$ffmpeg" = "y" ] && echo "ffmpeg -i \\"$url\\" -c copy \\"$title.mkv\\"" || echo "echo \"URL: $url\""`
    "
    ;;
  *)
    ext=$(echo $url | awk -F. '$0=$NF')
    queue="$queue
dl $url $title.$ext $WOPT
    "
    ;;
esac
}

which wget &>/dev/null
if [ "$?" = 0 ];then dl() {
wget $1 -O $2 $3
 }
 Q="-q"
else dl() {
curl $1 -o $2 $3
 }
 Q="-s"
fi

echo "$*" | grep -q "\--player" && player=$(echo "$*" | grep -o "\--player.* " | sed 's/ .*//;s/.*--player//;s/=//') && play=y && allvars="$(echo "$*" | sed 's/--player.* //')" || allvars=$*


[ "$player" = "" ] && player=mplayer

[ "$play" = y ] && dlvideo() {
queue="$queue
$player $url
"
} || dlvideo() {
urlformatcheck
}


[ "$1" = "-q" ] && WOPT="$Q" && shift
[ "$1" = "-a" ] && A=y && shift
[ "$1" = "-f" ] && F=y && shift
[ "$1" = "-qa" ] && WOPT="$Q" && A=y && shift

[ "$1" = "-af" ] && A=y && F=y && shift

[ "$1" = "-qf" ] && WOPT="$Q" && F=y && shift

[ "$1" = "-qaf" ] && WOPT="$Q" && A=y && F=y && shift

[ "$1" = "-aq" ] && WOPT="$Q" && A=y && shift
[ "$1" = "-fa" ] && A=y && F=y && shift
[ "$1" = "-fq" ] && WOPT="$Q" && F=y && shift
[ "$1" = "-afq" ] && WOPT="$Q" && A=y && F=y && shift
[ "$1" = "-faq" ] && WOPT="$Q" && A=y && F=y && shift
[ "$1" = "-aqf" ] && WOPT="$Q" && A=y && F=y && shift
[ "$WOPT" = "$Q" ] && A=y
[ "$F" = "y" ] && URL="$(cat "$allvars")" || URL="$allvars"

#echo -n "Self-updating script..." && dl http://daniilgentili.magix.net/rai.sh $0 $Q 2>/dev/null;chmod 755 $0 2>/dev/null; echo -en "\r\033[K"

function var() {
eval $*
}


if [ "$A" = "y" ]; then

 function dlcmd() {
echo "$api" | grep -q \( && url="$(echo "$api" | awk 'END {print $NF}')" || url="$(echo "$api" | sort | awk 'END {print $NF}')"
ext=$(echo $url | awk -F. '$0=$NF')
dlvideo
 }
else

 echo "Video(s) info:" &&
 function dlcmd() {
videoTitolo=$(echo "$titles" | cut -d' ' -f2-)

max="$(echo "$api" | awk 'END{print}' | grep -Eo '^[^ ]+')"

echo "Title: $videoTitolo

$(echo "$api" | sed 's/http.*//')

"

until [ "$l" -le "$max" ] && [ "$l" -gt 0 ] ; do echo -n "What quality do you whish to download (number, enter q to skip this video)? "; read l; [ "$l" = "q" ] && break;done 2>/dev/null

[ "$l" = "q" ] && continue

urlformat=$(echo "$api" | sed "$l!d" | sed 's/http:\/\/.*//;s/.*[(]//;s/[)].*//')

url=$(echo "$api" | sed "$l!d" | awk 'NF>1{print $NF}')

ext=$(echo $url | awk -F. '$0=$NF')

dlvideo
 }
fi


for u in $URL; do
 sane="$(echo "$u" | sed 's/#.*//' | sed 's/\&/%26/g' | sed 's/\=/%3D/g' | sed 's/\:/%3A/g' | sed 's/\//%2F/g' | sed 's/\?/%3F/g')"

 api="$(dl "http://api.daniil.it/?url=$sane" - $Q | sed '/^\s*$/d')"


 [ "$api" = "" ] && continue
 titles=$(echo "$api" | sed -n 1p)
 api=$(echo "$api" | sed '1d' | awk '{print NR, $0}')
 title=$(echo "$titles" | cut -d \  -f 1)

 dlcmd
done


[ "$queue" != "" -a "$play" != "y" ] && echo "Downloading videos..." && eval $queue && echo "All downloads completed successfully."
[ "$play" = "y" ] && eval $queue

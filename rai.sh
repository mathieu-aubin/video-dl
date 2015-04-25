#!/bin/bash
# Rai.TV download script
# Created by Daniil Gentili (http://daniil.eu.org)
# Uses Andrea Lazzarotto's (http://andrealazzarotto.com) server (http://video.lazza.dk) to decode URLs.

[ "$1" = "--help" ] && echo "Rai.tv download script
Created by Daniil Gentili
Uses Andrea Lazzarotto's server to decode the URLs.
Usage: $(basename $0) [ -qmf [ urls.txt ] ] URL URL2 URL3 ...

Options:

-q	Quiet mode: useful for crontab jobs.
-m	Manual mode: manually select the quality to download.
-f	Reads URL(s) from specified text file(s).
--help	Show this extremely helpful message.

" && exit

wget --help &>/dev/null && (function dl() { wget $1 -O $2 $3 ; } && dopt="-q" && uopt="-U") || (function dl()  { curl -L $1 -o $2 $3; } && dopt="-s" && uopt="-A")

[ "$*" = "" ] && echo "No url specified. Aborting." && exit 1

[ "$1" = "-q" ] && WOPT="$dopt" && shift
[ "$1" = "-m" ] && M=y && shift
[ "$1" = "-f" ] && F=y && shift
[ "$1" = "-qm" ] && WOPT="$dopt" && M=y && shift

[ "$1" = "-mf" ] && M=y && F=y && shift

[ "$1" = "-qf" ] && WOPT="$dopt" && F=y && shift

[ "$1" = "-qmf" ] && WOPT="$dopt" && M=y && F=y && shift

[ "$1" = "-mq" ] && WOPT="$dopt" && M=y && shift
[ "$1" = "-fm" ] && M=y && F=y && shift
[ "$1" = "-fq" ] && WOPT="$dopt" && F=y && shift
[ "$1" = "-mfq" ] && WOPT="$dopt" && M=y && F=y && shift
[ "$1" = "-fmq" ] && WOPT="$dopt" && M=y && F=y && shift
[ "$1" = "-mqf" ] && WOPT="$dopt" && M=y && F=y && shift

function var() {
eval $*
}


if [ "$M" != "y" ]; then

 function dlcmd() {
set +u
dl=$(dl http://video.lazza.dk/rai/?r=$(echo $videoURL_MP4 || echo $videoURL_H264 || echo $videoURL_WMV | echo $videoURL) - $dopt)
set +u
ext=$(echo $dl | awk -F. '$0=$NF')
queue="$queue
dl $dl $title.$ext $WOPT
"
 }
else

 echo "Video(s) info:" &&
 function dlcmd() {
user="Mozilla/5.0 (iPad; CPU OS 7_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53"
vars=$(compgen -A variable | grep videoURL)
formats="$(echo "$vars" | sed -e 's/\<videoURL\>/Normal quality (mp4)/g' | sed -e 's/\<videoURL_MP4\>/High quality (mp4)/g' | sed -e 's/\<videoURL_H264\>/Normal quality (h264)/g' | sed 's/\<videoURL_M3U8\>/Normal quality (m3u8)/g' |  sed 's/\<videoURL_wmv\>/Normal quality (wmv)/g' | awk '{print NR, $0}')"
echo -n "

=====================================

Title: $videoTitolo

Available formats:
$formats

Select the format you want to download: " && read l &&
dl=$(eval echo "$`echo "$vars" | sed "$l!d"`") &&
dl=$(echo $dl | grep -q http && echo $dl || echo http:$dl)
queue="$queue
dl $dl $title.tmp $WOPT $uopt 'Mozilla/5.0 (iPad; CPU OS 7_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53'; grep -q EXT- $title.tmp && (avconv -i $dl -codec copy -qscale 0 $title.mp4; rm $title.tmp)|| mv $title.tmp $title.mp4
"
 }
fi


[ "$F" = "y" ] && URL="$(cat "$*")" || URL="$*"

for u in $URL; do
 curl --version &>/dev/null && (curl -Ls -o /dev/null -w %{url_effective} $u |  grep -qE 'http://www*.rai.*/dl/RaiTV/programmi/media/*|http://www*.rai.*/dl/RaiTV/tematiche/*|http://www*.rai.*/dl/*PublishingBlock-*|http://www*.rai.*/dl/replaytv/replaytv.html*|http://*.rai.it/*|http://www.rainews.it/dl/rainews/*' || continue)
 file=$(dl $u - $dopt)
 $(echo "$file" | grep videoTitolo)
 eval $(echo "$file" | grep videoURL | sed "s/var//g" | tr -d '[[:space:]]')
 title="${videoTitolo//[^a-zA-Z0-9 ]/}" && title=`echo $title | tr -s " "` && title=${title// /_}
 dlcmd
done && echo "Downloading videos..." && eval $queue && echo "All downloads completed successfully."

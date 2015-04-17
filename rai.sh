#!/bin/bash
# Rai.TV download script
# By Daniil Gentili

[ "$1" = "--help" ] && echo "Rai.tv download script
Created by Daniil Gentili

Usage: rai.sh [ -af ] URL URL2 URL3 ...

Options:

-a	Automatic mode: quietly downloads every video in maximum mp4 quality.
-f	Reads URLs from specified text file(s).
--help	Shows this extremely helpful message.

" && exit

[ "$*" = "" ] && echo "No url specified. Aborting." && exit 1

[ "$1" = "-a" ] && A=y && shift
[ "$1" = "-f" ] && F=y && shift
[ "$1" = "-fa" ] && A=y && F=y && shift
[ "$1" = "-af" ] && A=y && F=y && shift

[ "$2" = "-a" ] && A=y && set -- "${@:1}" "" "${@:3}"

[ "$2" = "-f" ] && F=y && set -- "${@:1}" "" "${@:3}"

[ "$3" = "-a" ] && A=y && set -- "${@:2}" "" "${@:4}"




function var() {
eval $*
}

if [ "$A" = "y" ]; then

 function dlcmd() {
dl=$(echo $videoURL_MP4 || echo $videoURL)
ext=mp4
wget $(wget http://video.lazza.dk/rai/?r=$dl -q -O -) -O "$title.$ext"
 }

else

 echo "Video(s) info:" &&
 function dlcmd() {
echo -n "

=====================================================

Title: $videoTitolo

Available formats:
$formats

Select the format you want to download: " && read l &&
 selection=$(echo "$vars" | sed "$l!d")
 dl=$(wget http://video.lazza.dk/rai/?r=$(eval echo "$`echo "$vars" | sed "$l!d"`") -q -O -) &&
 ext=$(echo $dl | awk -F. '$0=$NF') &&
 echo "Download queued." &&
 queue="$queue
wget $dl -O $title.$ext
 "
 }
fi


[ "$F" = "y" ] && URL="$(cat "$*")" || URL="$*"



for u in $URL; do
 file=$(wget $u -q -O -)
 $(echo "$file" | grep videoTitolo)
 eval "$(echo "$file" | grep videoURL | sed "s/var//g" | tr -d '[[:space:]]')"
 vars=$(compgen -A variable | grep videoURL)
 formats="$(echo "$vars" | sed -e 's/\<videoURL\>/Normal quality (mp4)/g' | sed -e 's/\<videoURL_MP4\>/High quality (mp4)/g' | sed -e 's/\<videoURL_H264\>/Normal quality (h264)/g' | sed 's/\<videoURL_M3U8\>/Normal quality (m3u8)/g' |  sed 's/\<videoURL_wmv\>/Normal quality (wmv)/g' | awk '{print NR, $0}')"
 title="${videoTitolo//[^a-zA-Z0-9 ]/}" && title=`echo $title | tr -s " "` && title=${title// /_}
 dlcmd
done

echo "Downloading videos..." && $queue && echo "All downloads completed successfully."

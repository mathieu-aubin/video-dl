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



function var() {
eval $*
}

if [ "$A" = "y" ]; then
 function dlcmd() {
dltmp=$(echo $videoURL_MP4 || echo $videoURL)
dl=$(echo $dltmp | grep -q "http://" && echo $dltmp || echo "http:$dltmp")
ext=mp4
 }
else
 echo "Video(s) info:" &&
 WOPT=""
 function dlcmd() {
echo -n "

=====================================================

Title: $videoTitolo

Available formats:
$formats

Select the format you want to download: " && read l &&
 selection=$(echo "$vars" | sed "$l!d")
 ext=$(case $selection in
 videoURL)
  echo mp4
  ;;
 videoURL_MP4)
  echo mp4
  ;;
 videoURL_H264)
  echo mp4
  ;;
 videoURL_M3U8)
  echo m3u8
  ;;
 videoURL_WMV)
  echo wmv
  ;;
 *)
  echo mp4
  ;;
 esac) &&
 dltmp=$(eval echo "$`echo "$vars" | sed "$l!d"`") &&
 dl=$(echo $dltmp | grep -q "http://" && echo $dltmp || echo "http:$dltmp")
 }
fi


[ "$F" = "y" ] && URL="$(cat "$*")" || URL="$*"


for u in "$URL"; do
 file=$(wget $u -q -O -)
 $(echo "$file" | grep videoTitolo)
 eval "$(echo "$file" | grep videoURL | sed "s/var//g" | tr -d '[[:space:]]')"
 vars=$(compgen -A variable | grep videoURL)
 formats="$(echo "$vars" | sed -e 's/\<videoURL\>/Normal quality (mp4)/g' | sed -e 's/\<videoURL_MP4\>/High quality (mp4)/g' | sed -e 's/\<videoURL_H264\>/Normal quality (h264)/g' | sed 's/\<videoURL_M3U8\>/Normal quality (m3u8)/g' |  sed 's/\<videoURL_wmv\>/Normal quality (wmv)/g' | awk '{print NR, $0}')"
 export title="${videoTitolo//[^a-zA-Z0-9 ]/}"
 dlcmd
 wget $dl -O "$title.$ext" $WOPT
done

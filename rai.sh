#!/bin/bash
# Rai.TV download script
# By Daniil Gentili
[ "$*" = "" ] && echo "No url specified. Aborting." && exit 1 || echo "Video(s) info:"


function var() {
eval $*
}

for u in $*; do
 file=$(wget $u -q -O -)
 $(echo "$file" | grep videoTitolo)
 eval "$(echo "$file" | grep videoURL | sed "s/var//g" | tr -d '[[:space:]]')"
 vars=$(compgen -A variable | grep videoURL)
 formats="$(echo "$vars" | sed -e 's/\<videoURL\>/Normal quality (mp4)/g' | sed -e 's/\<videoURL_MP4\>/High quality (mp4)/g' | sed -e 's/\<videoURL_H264\>/Normal quality (h264)/g' | sed 's/\<videoURL_M3U8\>/Normal quality (m3u8)/g' |  sed 's/\<videoURL_wmv\>/Normal quality (wmv)/g' | awk '{print NR, $0}')"
 export title="${videoTitolo//[^a-zA-Z0-9 ]/}"
 echo -n "

=====================================================

Title: $videoTitolo

Available formats:
$formats

Select the format you want to download: "
 read l
 dltmp=$(eval echo "$`echo "$vars" | sed "$l!d"`")
 dl=$(echo $dltmp | grep -q "http://" && echo $dltmp || echo "http:$dltmp")
 wget $dl -O "$title"
done

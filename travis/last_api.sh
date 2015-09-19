common() {
# Store the page in a variable
page="$(wget -q -O - $1)"
# Get the video URLs
base="$(echo "$page" | egrep '\.mp4|\.mkv|\.flv|\.f4v|\.wmv|\.mov|\.3gp|\.avi|\.m4v|\.mpg|\.mpe|\.mpeg' | sed 's/.*http:\/\//http:\/\//;s/\".*//' | sed "s/'.*//" | sed 's/.mp4.*/.mp4/g;s/.mkv.*/.mkv/g;s/.flv.*/.flv/g;s/.f4v.*/.f4v/g;s/.wmv.*/.wmv/g;s/.mov.*/.mov/g;s/.3gp.*/.3gp/g;s/.avi.*/.avi/g;s/.m4v.*/.m4v/g;s/.mpg.*/.mpg/g;s/.mpe.*/.mpe/g;s/.mpeg.*/.mpeg/g' | awk '!x[$0]++')"

checkurl
[ "$base" = "" ] && continue 

videoTitolo="$(echo $page | sed 's/.*<title>//;s/<\/title>.*//' | sed 's/^ //')"

title="${videoTitolo//[^a-zA-Z0-9 ]/}"

title=`echo $title | tr -s " "`

title=${title// /_}

unformatted="$base"
formatoutput

}

# OK, here's the problem: The following function uses youtube-dl to get the download info, but offering the functionality of youtube-dl using an http api is one thing, while using the above mentioned program when the user can already use it is another thing. Comment the auto update line and change common_yt_dl to common if you still want to use youtube-dl trough this script.

common_yt_dl() {
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

}

###########################################################################################
##################### End of Common section, beginning of database section ################
$ptype $dl $2 $3
[ "$formats" = "" ] && continue || echo "$title $videoTitolo
$formats"
}

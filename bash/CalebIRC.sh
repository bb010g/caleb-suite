#!/bin/bash
# Usage: ./CalebIRC "$username" "$network" "$channel"

iidir='ii'

pgrep -f $"ii \-s "$2" -p 6667 \-n $1 \-f CalebBot" && echo 'already running' || ii -s "$2" -p 6667 -i "$iidir" -n "$1" -f CalebBot &

echo "/j #$3" > "$iidir/$2/in"

removedate() {
    sed -n 's/^[0-9]\+-[0-9]\+-[0-9]\+ [0-9]\+:[0-9]\+ \(.*\)$/\1/p' <<< "$1"
}

messagepart() {
    service=""
    i=$(perl -pe 's/<[^<>]+> (.*)$/\1/' <<< "$1")
    if [[ '12(O)' == "${i::7}" ]] ; then
        service="OmnomIRC web"
        i=${i:7}
        i=$(messagepart "$i")
    fi
    if [ '(#)' = "${i::3}" ] ; then
        service="linker"
        i=${i:3}
        i=$(messagepart "$i")
    fi
    echo "$i"
}

tail -n 0 -f "$iidir/$2/#$3/out" | while read LINE; do
    dateless=$(removedate "$LINE")
    msg=$(messagepart "$dateless")
    ./CalebBot.sh "$msg" "$service" > "$iidir/$2/#$3/in"
done

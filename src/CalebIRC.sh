#!/bin/bash
# Usage: ./CalebIRC <botname> <network> <botchannel>

botname="$1"
network="$2"
botchannel="$3"

iidir='ii'

#pgrep -fx "ii -s $(printf '%q' "$network") -p 6667 -i $iidir -n $(printf '%q' "$botname") -f CalebBot" && echo 'already running' || \
#ii -s $(printf '%q' "$network") -p 6667 -i $iidir -n $(printf '%q' "$botname") -f CalebBot &
#disown

echo "/j $botchannel" > "$iidir/$network/in"

removedate() {
    sed -n 's/^[0-9]\+-[0-9]\+-[0-9]\+ [0-9]\+:[0-9]\+ \(.*\)$/\1/p' <<< "$1"
}

messagepart() {
    service=""
    IFS='> ' read -r username message <<< "${1:1}"
    if [[ "x$username" == "x$botname" ]]; then return 130; fi
    echo "$username>$message"
}

tail -n 0 -f "$iidir/$network/$botchannel/out" | while read LINE; do
    dateless="$(removedate "$LINE")"
    IFS='>' read -r username msg <<< "$(messagepart "$dateless")"
    if [[ "x$msg" != "x" ]] ; then
        ./CalebBot.sh "$botchannel" "$username" "$msg" 'IRC' > "$iidir/$network/$botchannel/in"
    fi
done

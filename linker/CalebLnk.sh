#!/bin/bash
# To use two-way, run both of these:
# CalebLink.sh network1 channel1 network2 channel2
# CalebLink.sh network2 channel3 network1 channel2

iidir='ii'
username='CalebLnk'

pgrep -f "ii -s $1 -p 6667 -i $iidir -n $username -f $username" && echo "$1 $2 already running" || ii -s "$1" -p 6667 -i "$iidir" -n "$username" -f "$username" &
pgrep -f "ii -s $3 -p 6667 -i $iidir -n $username -f $username" && echo "$3 $4 already running" || ii -s "$3" -p 6667 -i "$iidir" -n "$username" -f "$username" &

echo "/j #$2" > "$iidir/$1/in"
echo "/j #$4" > "$iidir/$3/in"

datechar=17

tail -n 0 -f "$iidir/$1/#$2/out" | while read -r LINE; do
    if [[ "${LINE:$datechar:${#username}+2}" != "<$username>" ]]; then
        echo "(#)${LINE:$datechar}" > "$iidir/$3/#$4/in"
    fi
done

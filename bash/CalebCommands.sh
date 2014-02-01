#!/bin/bash

. CalebCore.sh

mode() {
    echo "/mode #$channel $1 $2"
}

helpmessage() {
    if [ "$1" == "" ] ; then
        echo "I am CalebBot, Caleb Hansberry's bot! For a list of commands, type $(nametocommand commands)."
    else
        echo "No help for $1."
    fi
}

commands() {
    awk '{printf "%s (",$1; $1=$2=""; printf "%s), ",substr($0,3)}' commandnames.txt | sed -z 's/\(.*\), /Commands: \1\n/'
}

rename() {
    if [[ "$1" == "$(nametocommand helpmessage)" || "$1" == "" ]] ; then
        echo 'Funny, but no.'
    else
        if [[ "$(cut -d ' ' -f 1 commandnames.txt | grep -xF "$2")" == "" ]] ; then
            while IFS=' ' read -r name rest; do
            if [[ "$1" == "$name" ]]
            then echo "$2 $rest"
            else echo "$name $rest"; fi
            done < commandnames.txt > commandnames_.txt
            mv commandnames{_,}.txt
            echo "Renamed $1 to $2."
        fi
    fi
}

ping() {
    echo ping
}

pong() {
    echo pong
}

nikkybot-ping() {
    echo 'nikkybot ping more like'
}

nikkybot-pong() {
    echo 'nikkybot pong more like'
}

testsucceed() {
    echo 'Test succeeded'
}

op() {
    pass="$(while read LINE; do
        if [[ "$3" == "$(cut -d ' ' -f 1 <<< "$LINE")" ]]
        then cut -d ' ' -f 2
        fi
    done < passwords.txt)"
    [[ "$2  -" == "$(echo -n "pass $1" | shasum)" ]] && echo "/mode #$3 +o $1" && echo "Opped $1 on $3." || echo 'Wrong username/pass/channel combination.'
}

bye() {
    echo 'Bye!'
}

thegame() {
    echo 'You have lost THE GAME'
}

blubclub() {
    echo 'Blub club! >(<'"'"')'
}

lolcode() {
    lci <(echo "HAI 1.2, $@, KTHXBYE") <<< '42' 2>&1
}

tibasic() {
    ~/code/tibasic/tibasic <(echo "$@") <<< '42'
}

mathematica() {
    math -noprompt <<< "$1" | sed '/.\{256\}.\+/{s/\(.\{0,253\}\).*/\1\.\.\./g}'
}

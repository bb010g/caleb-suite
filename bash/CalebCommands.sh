#!/bin/bash

. CalebCore.sh

hashpass() { # hashpass <file> <key> <salt> <comparison>
    pass="$(while read LINE; do
        if [[ "$2" == "$(cut -d ' ' -f 1 <<< "$LINE")" ]]
        then cut -d ' ' -f 2
        fi
    done < $1)"
    [[ "$4 -" == "$(echo -n "$pass $3" | shasum )" ]]
}

helpmessage() {
    if [[ -z "$1" ]]; then
        echo "I am CalebBot, Caleb Hansberry's bot! For a list of commands, type $(nametocommand commands)."
    else
        $(commandtoname "$1")-help || echo "No help found for $1."
    fi
}
helpmessage-help() { echo 'Who helps the Helpmen?'; }
helpmessage-usage() { echo '[command]'; }

usagemessage-name() { echo "Usage: $(nametocommand "$1") $($1-usage)"; }
usagemessage-command() { echo "Usage: $1 $($(commandtoname "$1")-usage)"; }
usagemessage() {
    if [[ "x$1" == "x" ]]; then
        usagemessage-name 'usagemessage'; return
    fi
    usagemessage-command "$1" || echo "No usage found for $1."
}
usagemessage-help() { echo 'Gives the usage of the given command.'; }
usagemessage-usage() { echo '<command>'; }

commands() {
    awk '{printf "%s (",$1; $1=$2=""; printf "%s), ",substr($0,3)}' commandnames.txt | sed -z 's/\(.*\), /Commands: \1\n/'
}
commands-help() { echo 'Lists the commands.'; }
commands-usage() { echo; }

rename() {
    if [[ "$1" == "$(nametocommand helpmessage)" ]]; then
        echo 'Funny, but no.'
    elif [[ "x$1" == "x" ]]; then
        usagemessage-name 'rename'
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
rename-help() { echo "Renames any given command (except $(nametocommand 'helpmessage'))."; }
rename-usage() { echo '<old name> <new name>'; }

ping() {
    echo ping
}
ping-help() { echo 'Plays the first half of ping-pong.'; }
ping-usage() { echo; }

pong() {
    echo pong
}
pong-help() { echo 'Plays the second half of ping-pong.'; }
pong-usage() { echo; }

nikkybot-ping() {
    echo 'nikkybot ping more like'
}
nikkybot-ping-help() { echo 'Plays the first half of ping-pong though nikkybot.'; }
nikkybot-ping-usage() { echo; }

nikkybot-pong() {
    echo 'nikkybot pong more like'
}
nikkybot-pong-help() { echo 'Plays the second half of ping-pong though nikkybot.'; }
nikkybot-pong-usage() { echo; }

testsucceed() {
    echo 'Test succeeded'
}
testsucceed-help() { echo 'Tests and reports the result.'; }
testsucceed-usage() { echo; }

op() {
    hashpass 'passwords.txt' "$3" "$1" "$2" && echo "/mode $3 +o $1" && echo "Opped $1 on $3." || echo 'Wrong username/pass/channel combination.'
}
op-help() { echo 'Ops a user on a channel that I have op on given the right hash.'; }
op-usage() { echo '<user> <hash> <channel>'; }

bye() {
    echo 'Bye!'
}
bye-help() { echo 'Says bye.'; }
bye-usage() { echo; }

thegame() {
    echo 'You have lost THE GAME'
}
thegame-help() { echo 'Reports your success at a certain competition.'; }
thegame-usage() { echo; }

blubclub() {
    echo 'Blub club! >(<'"'"')'
}
blubclub-help() { echo 'Cemetech'"'"'s mascot.'; }
blubclub-usage() { echo; }

lolcode() {
    if [[ "x$1" == "x" ]]; then usagemessage-name 'lolcode'; return; fi
    lci <(echo "HAI 1.2, $@, KTHXBYE") <<< '42' 2>&1
}
lolcode-help() { echo 'An interface to the lci LOLCODE interpreter. http://lolcode.org/1.2_spec.html'; }
lolcode-usage() { echo '<YR CODE>'; }

tibasic() {
    if [[ "$1" == "" ]]; then usagemessage-name 'tibasic'; return; fi
    ~/code/tibasic/tibasic <(echo "$@") <<< '42'
}
tibasic-help() { echo 'An interface to Juju'"'"'s TI-BASIC interpreter. https://github.com/juju2143/tibasic'; }
tibasic-usage() { echo '<YourCode>'; }

mathematica() {
    if [[ "x$1" == "x" ]]; then usagemessage-name 'mathematica'; return; fi
    math -noprompt <<< "$1" | sed '/.\{256\}.\+/{s/\(.\{0,253\}\).*/\1\.\.\./g}'
}
mathematica-help() { echo 'Runs calculations through Wolfram Mathematica.'; }
mathematica-usage() { echo '<Calculation>'; }

multiline() {
    if [[ "x$1" == "x" ]]; then usagemessage-name 'multiline'; return; fi
    if [[ "x$1" == "xlist" ]]; then
        contents="$(ls multiline | sed 's/\.txt$//g')"
        if [[ "x$contents" == "x" ]]; then echo 'No buffers.'; else echo "$contents"; fi
        return
    fi
    buffer="$1"
    shift 1
    case "$1" in
        run)
            $(commandtoname "$2") "$(cat "multiline/$buffer.txt")"
            ;;

        view)
            if [[ "x$(cat multiline/$buffer.txt)" == "x" ]]; then echo 'Empty buffer.'
            else cat -n multiline/$buffer.txt | cut -c 6-
            fi
            ;;

        append)
            shift 1
            echo "$@" >> multiline/$buffer.txt
            echo 'Appended.'
            ;;

        prepend)
            shift 1
            mv multiline/$buffer.txt multiline.tmp
            cat <(echo "$@") multiline.tmp > multiline/$buffer.txt
            echo 'Prepended.'
            ;;

        replace)
            line="$2"
            shift 2
            mv multiline/$buffer.txt multiline.tmp
            cat <(head -n $(($line-1)) multiline.tmp) <(echo "$@") <(tail -n +$(($line+1)) multiline.tmp) > multiline/$buffer.txt
            echo 'Replaced.'
            ;;

        move)
            if [[ ! -e "multiline/$2.txt" ]]; then mv multiline/$buffer.txt multiline/$2.txt; echo 'Moved.'; else echo 'Cannot overwrite an existing buffer.'; fi
            ;;

        remove)
            rm multiline/$buffer.txt
            echo 'Removed.'
            ;;
        *)
            echo 'Invalid command.'
            ;;
    esac
}
multiline-help() { echo 'Allows for parameters to span multiple lines.'; }
multiline-usage() {
    echo '<command below>'
    echo 'list'
    echo '<buffer> run <command>'
    echo '<buffer> view'
    echo '<buffer> append <line>'
    echo '<buffer> prepend <line>'
    echo '<buffer> replace <line num> <line>'
    echo '<buffer> move <new buffer>'
    echo '<buffer> remove'
}

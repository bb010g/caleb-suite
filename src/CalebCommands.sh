#!/usr/bin/env bash

main() {
    cmd="$1"
    metadata_file="$2"
    arg="$3"
    "$cmd" "$metadata_file" "$arg"
}

. CalebCore.sh

helpmessage() {
    if [[ "x$2" == "x" ]]; then
        ../jq -r '[.channel, .username, .service] | @tsv' $1 | read channel username service
        echo "Hi, $username. I am CalebBot, bb010g's bot! This is $channel on $service. For a list of commands, type $(nametocommand commands). Thanks to Caleb Hansberry for the inspiration."
    else
        $(commandtoname "$2")-help || echo "No help found for $2."
    fi
}
helpmessage-help() { echo 'Who helps the Helpmen?'; }
helpmessage-usage() { echo '[command]'; }

usagemessage-name() { echo "Usage: $(nametocommand "$1") $(${1}-usage)"; }
usagemessage-command() {
    command="$1"
    name="$(commandtoname "$command")"
    if [[ "x$name" == "x" ]]; then return 1; fi
    echo "Usage: $commmand $(${name}-usage)"
}
usagemessage() {
    if [[ "x$2" == "x" ]]; then
        usagemessage-name 'usagemessage'; return
    fi
    usagemessage-command "$2" || echo "No usage found for $2."
}
usagemessage-help() { echo 'Gives the usage of the given command.'; }
usagemessage-usage() { echo '<command>'; }

commands() {
    awk '{printf "%s (",$1; $1=$2=""; printf "%s), ",substr($0,3)}' data/commandnames.txt | sed -z 's/\(.*\), /Commands: \1\n/'
}
commands-help() { echo 'Lists the commands.'; }
commands-usage() { echo; }

rename() {
    IFS=' ' read -r old new <<< $2
    if [[ "$old" == "$(nametocommand helpmessage)" ]]; then
        echo 'Funny, but no.'
    elif [[ "$old" == "$(nametocommand op)" ]]; then
        echo 'I don'"'"'t want pissed off mods. Do you?'
    elif [[ "x$new" == "x" ]]; then
        usagemessage-name 'rename'
    else
        if [[ "$(cut -d ' ' -f 1 data/commandnames.txt | grep -xF "$new")" == "" ]] ; then
            while IFS=' ' read -r name rest; do
            if [[ "$old" == "$name" ]]
            then echo "$new $rest"
            else echo "$name $rest"; fi
            done < data/commandnames.txt | sponge data/commandnames.txt
            echo "Renamed $old to $new."
        fi
    fi
}
rename-help() { echo "Renames any given command (except $(nametocommand 'helpmessage'))."; }
rename-usage() { echo '<old name> <new name>'; }

. commands/quips.sh

. commands/perms.sh

lolcode() {
    if [[ "x$2" == "x" ]]; then usagemessage-name 'lolcode'; return; fi
    lci <(echo "HAI 1.2, $@, KTHXBYE") <<< '42' 2>&1
}
lolcode-help() { echo 'An interface to the lci LOLCODE interpreter. http://lolcode.org/1.2_spec.html'; }
lolcode-usage() { echo '<YR CODE>'; }

. commands/karma.sh

. commands/quotes.sh

multiline() {
    IFS=' ' command buffer rest <<< $2
    if [[ "x$command" == "x" ]]; then usagemessage-name 'multiline'; return; fi
    if [[ "x$command" == "xlist" ]]; then
        contents="$(ls multiline | sed 's/\.txt$//g')"
        if [[ "x$contents" == "x" ]]; then echo 'No buffers.'; else echo "$contents"; fi
        return
    fi
    case "$buffer" in
        run)
            IFS=' ' read -r command rest <<< $rest
            $(commandtoname "$command") "$rest $(< "multiline/$buffer.txt")"
            ;;

        view)
            if [[ -e multiline/$buffer.txt ]]; then echo 'Empty buffer.'
            else cat -n multiline/$buffer.txt | cut -c 6-
            fi
            ;;

        append)
            echo "$rest" >> multiline/$buffer.txt
            echo 'Appended.'
            ;;

        prepend)
            mv multiline/$buffer.txt multiline.tmp
            cat <(echo "$rest") multiline.tmp > multiline/$buffer.txt
            echo 'Prepended.'
            ;;

        replace)
            IFS=' ' read -r line rest <<< $rest
            mv multiline/$buffer.txt multiline.tmp
            cat <(head -n $(($line-1)) multiline.tmp) <(echo "$@") <(tail -n +$(($line+1)) multiline.tmp) > multiline/$buffer.txt
            echo 'Replaced.'
            ;;

        move)
            IFS=' ' read -r new rest <<< $rest
            if [[ ! -e "multiline/$new.txt" ]]; then mv multiline/$buffer.txt multiline/$new.txt; echo 'Moved.'; else echo 'Cannot overwrite an existing buffer.'; fi
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

main "$@"


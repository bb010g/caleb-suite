#!/bin/bash
# Usage: ./CalebBot "$msg" "$service"

commandfile='CalebCommands.sh'

. CalebCore.sh

cmd=$(commandtoname $(commandpart "$1"))
if [[ "$cmd" ]] ; then
    arg=$(argumentpart "$1")
    echo "${2}running $cmd $arg at $(date)" >&2
    arg=$(sed 's/\\/\\\\/g;s/"/\\"/g;s/ /\" $\"/g' <<< "$arg")
    timeout 10 bash -c $". $\"$commandfile\"; $\"$cmd\" $\"$arg\"" || echo 'Your command probably ran too long. Sorry.'
fi

#!/bin/bash
# Usage: ./CalebBot <channel> <username> <msg> <service>

channel="$1"
username="$2"
msg="$3"
service="$4"

commandfile='./CalebCommands.sh'

. CalebCore.sh

cmd="$(commandtoname $(commandpart "$msg"))"
if [[ "$cmd" ]] ; then
    arg="$(argumentpart "$msg")"
    echo "$username running $cmd $arg at $(date)" >&2
    metadata="$(mktemp -p metadata metadataXXXXXXXXXX.json)"
    ../jq -c --arg channel "$channel" --arg username "$username" --arg service "$service" '.channel = $channel | .username = $username | .service = $service' <<< '{}' > $metadata
    timeout 10 $commandfile "$cmd" "$metadata" "$arg" || echo 'Your command probably ran too long. Sorry.'
    rm $metadata
fi

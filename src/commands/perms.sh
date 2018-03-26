#!/usr/bin/env bash

# hashpass <file> <key> <salt> <hash>
hashpass() {
    file=$1; key=$2; salt=$3; hash=$4
    echo "file: $file; key: $key; salt: $salt; hash: $hash" >&2

    pass="$(while read LINE; do
        if [[ "$key" == "$(cut -d ' ' -f 1 <<< $LINE)" ]]; then
            cut -d ' ' -f 2 <<< $LINE
        fi
    done < $file)"
    echo "pass: $pass" >&2
    realhash=$(echo -n "$pass $salt" | shasum -a 512)
    echo "realhash: $realhash" >&2
    if [[ "$hash  -" == "$realhash" ]]; then
        echo "success" >&2
        return 0
    else
        return 1
    fi
}

op() {
    IFS=' ' read -r channel user hash <<< "$2"
    echo "channel: $channel; user: $user; hash: $hash" >&2
    hashpass data/passwords.txt "$channel" "$channel $user" "$hash" && echo "/mode $channel +o $user" && echo "Opped $user on $channel." \
        || echo 'You are either not authorized to use this command or giving a bad hash. Message an admin for assistance.'
}
op-help() { echo 'Ops a user on a channel that I have op on given the right hash.'; }
op-usage() { echo '<channel> <user> <hash>'; }


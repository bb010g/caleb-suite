#!/bin/bash

commandtoname() {
    while read LINE; do
        if [[ "$1" == "$(cut -d ' ' -f 1 <<< $LINE)" ]]
        then cut -d ' ' -f 2 <<< $LINE
    fi
    done < commandnames.txt
}

nametocommand() {
    while read LINE; do
        if [[ "$1" == "$(cut -d ' ' -f 2 <<< $LINE)" ]]
        then cut -d ' ' -f 1 <<< $LINE
    fi
    done < commandnames.txt
}

commandpart() {
    cut -d ' ' -f 1 <<< "$1"
}

argumentpart() {
    cut -s -d ' ' -f 2- <<< "$1"
}

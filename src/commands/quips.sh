#!/usr/bin/env bash

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

dong() {
    echo dong
}
dong-help() { echo "The upstanding doorbell's response to a call."; }
dong-usage() { echo; }

testsucceed() {
    echo 'Test succeeded'
}
testsucceed-help() { echo 'Tests and reports the result.'; }
testsucceed-usage() { echo; }

hello() {
    echo 'Hello!'
}
hello-help() { echo 'Says hello'; }
hello-usage() { echo; }

bye() {
    echo 'Bye!'
}
bye-help() { echo 'Says bye.'; }
bye-usage() { echo; }

goodnight() {
    echo 'Goodnight!'
}
goodnight-help() { echo 'Says goodnight.'; }
goodnight-usage() { echo; }

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


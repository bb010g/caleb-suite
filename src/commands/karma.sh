#!/usr/bin/env bash

karma_file=data/karma.json
karma_get() {
    IFS=' ' read -r nick <<< $2
    karma=$(jq --arg nick "${nick,,}" '.[$nick].karma // 0' < $karma_file)
    echo "$nick has $karma taps"
}
karma_get-help() { echo "Check on a nick\'s current IRC taps."; }
karma_get-usage() { echo '<nick>'; }
karma_inc() {
    IFS=' ' read -r nick <<< $2
    jq --arg nick "${nick,,}" '.[$nick].karma |= .+1' < $karma_file | sponge $karma_file
}
karma_inc-help() { echo 'Tap a nick.'; }
karma_inc-usage() { echo '<nick>'; }
karma_dec() {
    IFS=' ' read -r nick <<< $2
    jq --arg nick "${nick,,}" '.[$nick].karma |= if . then .-1 else -1 end' < $karma_file | sponge $karma_file
}
karma_dec-help() { echo 'Slap a nick.'; }
karma_dec-usage() { echo '<nick>'; }

quote_file=data/quotes.json
quote_add() {
    IFS=' ' read -r nick quote <<< $2
    jq --arg nick "${nick,,}" --arg quote "$quote" '.[$nick] += ["<\($nick)> \($quote)"] | .[$nick] |= unique' < $quote_file | sponge $quote_file
}


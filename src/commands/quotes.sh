#!/usr/bin/env bash

quote_add() {
    IFS=' ' read -r nick quote <<< "$2"
    ../jq --arg nick "$nick" --arg quote "$quote" '.[$nick | ascii_downcase] += ["<\($nick)> \($quote)"] | .[$nick | ascii_downcase] |= unique' < $quote_file | sponge $quote_file
}
quote_add-help() { echo 'Add a quote to the database.'; }
quote_add-usage() { echo '<nick> <quote>'; }
quote_del() {
    IFS=' ' read -r nick quote <<< "$2"
    temp="$(mktemp)"
    ../jq --arg nick "$nick" --arg quote "$quote" '.[$nick | ascii_downcase] |= . // [] - ["<\($nick)> \($quote)"]' < $quote_file | sponge $quote_file
}
quote_del-help() { echo 'Remove a quote from the database.'; }
quote_del-usage() { echo '<nick> <quote>'; }
quote_get() {
    IFS=' ' read -r nick <<< "$2"
    if [[ "x$nick" == "x" ]]; then
        ../jq -r ".[][]" < $quote_file | shuf -n 1
    else
        ../jq --arg nick "$nick" -r '.[$nick | ascii_downcase][]' < $quote_file | shuf -n 1
    fi
}
quote_get-help() { echo 'Get a random quote from the database.'; }
quote_get-usage() { echo '[nick]'; }


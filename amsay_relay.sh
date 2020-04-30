#!/usr/bin/env bash

# This script reads in lines produced by the /amsay command from the server log
# The player's name and the message content are parsed out and then sent to
# Discord via a webhook.

discord_config=${1:-"./amsay_relay.cfg"}

if [ ! -f $discord_config ] ; then
    echo "Discord config not found at path: $discord_config"
    exit 1
fi

# Read in our config params
. $discord_config

if [ -z $discord_webhook_url ]; then
    echo "Discord webhook URL unspecified"
    exit 1
fi

if [ -z $log_file ] ; then
    echo "Log file unspecified"
    exit 1
fi

if [ ! -f $log_file ] ; then
    echo "Log file not found at path: $log_file"
    exit 1
fi

# Send the contents of the amsay message to a Discord webhook
send_to_discord() {
    curl --location --request POST "$1" \
        --header 'Content-Type: application/json' \
        --data-raw "{
            \"username\": \"$2\",
            \"content\": \"$3\"
        }"
}

# Redirect tail output of server log to a read-while loop, sending the input
# to Discord
watch_amsay() {
    while read -r line; do
        # Grab the raw player name, including color codes
        raw_player_name=$(
            echo "$line" \
            | awk -F" say_admin: " '{print $2}' \
            | awk -F": " '{print $1}'
        )

        # We want to remove color codes from player name for better readability
        clean_player_name=$(echo "$raw_player_name" | sed 's/[!^][0-9]//g') 

        # Escape any special characters in the raw player name for proper splitting
        escaped_player_name=$(sed 's/[^^]/[&]/g; s/\^/\\^/g' <<< "$raw_player_name")

        message=$(
            echo "$line" \
            | awk -F"${escaped_player_name}: " '{print $NF}' \
            | sed 's/\\/\\\\/g' # escape slashes
		)

        send_to_discord $1 "$clean_player_name" "$message"
    done < <(tail -fn 0 $2 | grep --line-buffered "say_admin") # /amsay only 
}

watch_amsay "$discord_webhook_url" "$log_file"

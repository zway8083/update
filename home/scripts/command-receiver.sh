#!/bin/bash

declare -r DEFAULT_SHORT_TIME='5s'
declare -r DEFAULT_LONG_TIME='3h'

if [ -z "$SERVER_ADDRESS" ]; then
    echo "Required environment variable SERVER_ADDRESS: not set or empty"
    exit 1
fi
if [ -z "$RASPBERRY_ID" ]; then
    echo "Required environment variable RASPBERRY_ID: not set or empty"
    exit 1
fi
if [ -z "$SHORT_TIME" ]; then
    echo "Environment variable SHORT_TIME is not set or empty, default is 5s"
    SHORT_TIME="$DEFAULT_SHORT_TIME"
fi
if [ -z "$LONG_TIME" ]; then
    echo "Environment variable LONG_TIME is not set or empty, default is 3h"
    LONG_TIME="$DEFAULT_LONG_TIME"
fi

URL="$SERVER_ADDRESS"'/api/raspberry'
echo "URL=$URL"
WAITING_TIME="$LONG_TIME"

while true; do
    RESPONSE=$(curl -i -s -H "Id: $RASPBERRY_ID" "$URL/input")
    RESPONSE="${RESPONSE//$''/''}"
    echo "RESPONSE=\"$RESPONSE\"" | cat -A
    HTTP_CODE=$(echo "$RESPONSE" | head -1 | awk '{print $2}')

    echo "HTTP_CODE=$HTTP_CODE" | cat -A

    if [ "$HTTP_CODE" -eq 200 ]; then
        HEADER_CONNECTED=$(echo "$RESPONSE" | grep Connected | head -1)
        CONNECTED="${HEADER_CONNECTED##*[ :]}"
        echo "CONNECTED=$CONNECTED"
        if [ "$CONNECTED" = "True" ]; then
            WAITING_TIME="$SHORT_TIME"
        elif [ "$CONNECTED" = "False" ]; then
            WAITING_TIME="$LONG_TIME"
        else
            echo "Connected=???"
        fi

        HEADER_TOKEN=$(echo "$RESPONSE" | grep Token | head -1)
        BODY=$(echo "$RESPONSE" | tr -d '\r' | sed '1,/^$/d')

        if [ "$BODY" -a "$HEADER_TOKEN" ]; then
            echo "HEADER_TOKEN=$HEADER_TOKEN"
            echo "BODY=$BODY"

            echo "$BODY" > script.sh
            chmod u+x script.sh
            STDOUT=$(./script.sh 2>&1)

            echo "OUTPUT='$STDOUT'"
            echo "Sending..."

            curl \
                -H "Content-Type: text/plain" \
                -H "Id: $RASPBERRY_ID" \
                -H "$HEADER_TOKEN" \
                -X POST --data "$STDOUT" "$URL/output"
        fi
    fi
    echo "Waiting $WAITING_TIME"...
    sleep "$WAITING_TIME"
done

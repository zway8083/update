#!/bin/bash

LOG='[ZWAY]'

ZWAY='/opt/z-way-server/automation/'
RESTART=0
cd files

shopt -s dotglob
for FILE in *
do
    diff -q "$ZWAY$FILE" "$FILE" &>/dev/null
    DIFF=$(( $? > 0 ))
    RESTART=$(( RESTART | DIFF ))
    if [ "$DIFF" -gt 0 ]; then
        cp -f "$FILE" "$ZWAY$FILE"
        echo "$LOG" Updated "$FILE"
    else
        echo "$LOG" Already up-to-date "$FILE"
    fi
done

if [ "$RESTART" -eq 1 ]; then
    sudo systemctl restart z-way-server.service
    echo "$LOG" Restarted zway service
fi
exit "$RESTART"

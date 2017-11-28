#!/bin/bash

LOG='[ENVIRONEMENT VARIABLES]'

REF_FILE='afg_ericsson.sh'
USR_FILE='/etc/profile.d/'"$REF_FILE"

diff -q "$USR_FILE" "$REF_FILE" &>/dev/null

if [ "$?" -gt 0 ]; then
    sudo cp -f "$REF_FILE" "$USR_FILE"
    echo "$LOG" Updated "$USR_FILE"
    exit 1
fi
echo "$LOG" Already up-to-date "$USR_FILE"
exit 0

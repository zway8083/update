#!/bin/bash

LOG='[Environement Variables]'

REF_FILE='.bash_afg_ericsson'
USR_FILE="$HOME"'/'"$REF_FILE"
BASHRC="$HOME"'/.bashrc'

COUNT=$(cat "$BASHRC" | grep -cFx ". ~/.bash_afg_ericsson")
if [ "$COUNT" -eq 0 ]; then
    echo '. ~/.bash_afg_ericsson' >> "$BASHRC"
    echo "$LOG" 'Updated ~/.bashrc'
fi

diff -q "$USR_FILE" "$REF_FILE" &>/dev/null

if [ "$?" -gt 0 ]; then
    cp -f "$REF_FILE" "$USR_FILE"
    echo "$LOG" 'Updated' "$USR_FILE"
    exit 1
fi
exit 0


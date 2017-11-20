#!/bin/bash

LOG='[CRONTAB & SCRIPTS]'

cp -f scripts/*.sh "$HOME"
echo "$LOG" 'Replaced scripts'

crontab -u "$USER" -r
crontab -u "$USER" 'crontabs/usercrontab'
echo "$LOG" 'Updated user crontab'

#!/bin/bash

LOG='[CRONTAB & SCRIPTS]'

cp -f scripts/*.sh "$HOME"
echo "$LOG" 'Replaced scripts'

crontab -u "$USER" -r
crontab -u "$USER" 'crontabs/usercrontab'
echo "$LOG" 'Updated user crontab'

sudo crontab -u "root" -r
sudo crontab -u "root" 'crontabs/rootcrontab'
echo "$LOG" 'Updated root crontab'

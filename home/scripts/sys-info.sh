#!/bin/bash

NOW=$(date +%s)
MEMTOT=$(/usr/bin/free -tmo | grep -i Mem: | awk '{print $2}')
MEMFREE=$(/usr/bin/free -tmo | grep -i Mem: | awk '{print $4+$6+$7}')
HDDSIZE=$(df -lBMB | grep /dev/root | awk '{ print $2}')
HDDSIZE=${HDDSIZE%MB}
HDDUSED=$(df -lBMB | grep /dev/root | awk '{ print $3}')
HDDUSED=${HDDUSED%MB}
LASTBOOTDATE=$(uptime -s)
LASTBOOT=$(date --date="$LASTBOOTDATE" +"%s")
UPTIME=$(uptime -p)
RUNNING=$(systemctl status z-way-server.service | grep running | wc -l)

POST_DATA=$(cat <<EOF
{
  "date": $NOW,
  "memTotal": $MEMTOT,
  "memFree": $MEMFREE,
  "hddSize": $HDDSIZE,
  "hddUsed": $HDDUSED,
  "lastBoot": $LASTBOOT,
  "uptime": "$UPTIME",
  "running": $RUNNING
}
EOF)

curl \
    -s
    -H "Content-Type: application/json" \
    -H "Id: $RASPBERRY_ID" \
    -X POST --data "$POST_DATA" "http://35.187.36.227/api/monitor" \
    >> afg-ericsson.log

exit "$?"

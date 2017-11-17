#!/bin/bash

LOG='[UPDATER]'

BASEDIR=$(pwd)
echo "$LOG" Base folder: "$BASEDIR"
for DIR in */
do
    cd -- "$DIR"
    CURDIR=$(pwd)
    echo "$LOG" Moving to "$CURDIR"

    for SCRIPT in install*.sh
    do
        echo "$LOG" Executing "$SCRIPT"
        ./"$SCRIPT"
    done

    cd -- "$BASEDIR"
done

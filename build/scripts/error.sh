#!/bin/bash

PARENT_LINENO="$1"
MESSAGE="$2"
CODE="${3:-1}"
LOG_FILE=$4

if [ ! -z "$MESSAGE" ]; then
    echo "[ERROR] On or near line $PARENT_LINENO with message \"$MESSAGE\" exiting with status \"$CODE\""
else
    echo "[ERROR] On or near line $PARENT_LINENO; exiting with status \"$CODE\""
fi

if [ ! -z "$LOG_FILE" ]; then
    echo "[BEGIN][PROBLEM SOURCE]"
    cat $LOG_FILE
    echo "[END][PROBLEM SOURCE]"
fi

exit "$CODE"

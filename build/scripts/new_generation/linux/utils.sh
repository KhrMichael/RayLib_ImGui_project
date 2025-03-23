#!/bin/bash

function error() {
    local parent_lineno="$1"
    local message="$2"
    local code="${3:-1}"
    local log_file=$4

    local error_format="\e[0;38;2;220;20;60m"
    local reset_format="\e[0m"

    if [ ! -z "$message" ]; then
        echo -e -e "$error_format[ERROR] On or near line $parent_lineno with message \"$message\" exiting with status \"$code\""
    else
        echo -e "$error_format[ERROR] On or near line $parent_lineno; exiting with status \"$code\""
    fi

    if [ ! -z "$log_file" ]; then
        log_file=$(cat $log_file)
        echo -e "$error_format[BEGIN] LOG"
        echo -e "$reset_format$log_file"
        echo -e "$error_format[END] LOG"
    fi

    exit "$code"
}

# checks if the first argument isn't an empty string or a whitespace only string
function is_empty() {
    if [[ -z "${1// /}" ]]; then
        return 0
    else
        return -1
    fi
}

# first argument : a command the needs to be asserted
# second argument: a message that will be printed if the assertion failed
# third argument: a log file path that will be printed if the assertion failed
function assert() {
    if is_empty "$1"; then
        error $LINENO "Expected a command as the first argument of the assert function" 12
        exit $?
    fi

    local temp_file="$3"
    if is_empty "$temp_file"; then
        temp_file=$(mktemp -p $TEMP_DIR)
        tempfiles+=($temp_file)
    fi

    if ! eval "$1" >"$temp_file" 2>"$temp_file"; then
        error $LINENO "$2" 11 "$temp_file"
        exit $?
    fi
}

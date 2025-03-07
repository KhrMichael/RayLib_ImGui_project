#!/bin/bash

DIST_DIR=$(pwd)/dist

if [ ! -d "$DIST_DIR" ]; then
    mkdir -p "$DIST_DIR"
fi

cd "$DIST_DIR"

cmake -G Ninja ../..

ninja

COMPILE_COMMANDS_FILE_NAME=compile_commands.json
rm $COMPILE_COMMANDS_FILE_NAME || true
ln -s "$DIST_DIR/$COMPILE_COMMANDS_FILE_NAME" ../$COMPILE_COMMANDS_FILE_NAME

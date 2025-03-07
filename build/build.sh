#!/bin/bash

DIST_DIR=$(pwd)/dist
BUILD_DIR=$(pwd)

if [ ! -d "$DIST_DIR" ]; then
    mkdir -p "$DIST_DIR"
fi

cd "$DIST_DIR"

cmake -G Ninja ../..

ninja

cd ../..

COMPILE_COMMANDS_FILE_NAME=compile_commands.json
rm $COMPILE_COMMANDS_FILE_NAME
ln -s "$BUILD_DIR/$COMPILE_COMMANDS_FILE_NAME" ../$COMPILE_COMMANDS_FILE_NAME

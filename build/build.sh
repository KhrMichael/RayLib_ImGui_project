#!/bin/bash

DIST_DIR=$(pwd)/dist
BUILD_DIR=$(pwd)

if [ -d "$DIST_DIR" ]; then
    rm -rf "$DIST_DIR"
fi
mkdir -p "$DIST_DIR"

cd "$DIST_DIR"

cmake -G Ninja ../..

ninja

if [ -d "resources" ]; then
    rm -r resources
fi
if [ -d "../../resources" ]; then
    cp -r ../../resources resources
fi

COMPILE_COMMANDS_FILE_NAME=compile_commands.json
rm $BUILD_DIR/../$COMPILE_COMMANDS_FILE_NAME || true
ln -s "$DIST_DIR/$COMPILE_COMMANDS_FILE_NAME" $BUILD_DIR/../$COMPILE_COMMANDS_FILE_NAME

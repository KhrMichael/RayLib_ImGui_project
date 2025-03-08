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

rm -r resources
cp -r ../../resources resources

COMPILE_COMMANDS_FILE_NAME=compile_commands.json
rm $BUILD_DIR/../$COMPILE_COMMANDS_FILE_NAME || true
ln -s "$DIST_DIR/$COMPILE_COMMANDS_FILE_NAME" $BUILD_DIR/../$COMPILE_COMMANDS_FILE_NAME

#!/bin/bash

BUILD_DIR=build

if [ ! -d "$BUILD_DIR" ]; then
    mkdir -p "$BUILD_DIR"
fi

cd "$BUILD_DIR"

cmake -G Ninja ..

ninja

cd ..

COMPILE_COMMANDS_FILE_NAME=compile_commands.json
rm $COMPILE_COMMANDS_FILE_NAME
ln -s "$BUILD_DIR/$COMPILE_COMMANDS_FILE_NAME" $COMPILE_COMMANDS_FILE_NAME

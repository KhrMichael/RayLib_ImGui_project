#!/bin/bash

BUILD_SCRIPT_PATH=$(realpath $0)
SCRIPTS_DIR=$(dirname $BUILD_SCRIPT_PATH)
BUILD_DIR=$(dirname $SCRIPTS_DIR)
DIST_DIR=$BUILD_DIR/dist
PROJECT_DIR=$(dirname $BUILD_DIR)

if ! command -v ninja 2>&1 >/dev/null; then
    echo "'ninja' does not exist"
    exit 10
fi

if ! command -v cmake 2>&1 >/dev/null; then
    echo "'cmake' does not exist"
    exit 10
fi

if [ -d "$DIST_DIR" ]; then
    echo "Removing dist ..."
    rm -rf $DIST_DIR
fi
mkdir -p $DIST_DIR

cd $DIST_DIR

echo "Making project ..."
cmake -G Ninja $PROJECT_DIR

echo "Building project ..."
ninja

if [ -d "resources" ]; then
    echo "Removing resources from dist ..."
    rm -r resources
fi
if [ -d "$PROJECT_DIR/resources" ]; then
    echo "Copying resources into dist ..."
    cp -r $PROJECT_DIR/resources resources
fi

echo "Generating new compile_commands.json ..."
COMPILE_COMMANDS_FILE_NAME=compile_commands.json
rm $PROJECT_DIR/$COMPILE_COMMANDS_FILE_NAME >/dev/null 2>/dev/null
ln -s "$DIST_DIR/$COMPILE_COMMANDS_FILE_NAME" $PROJECT_DIR/$COMPILE_COMMANDS_FILE_NAME

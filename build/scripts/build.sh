#!/bin/bash

BUILD_SCRIPT_PATH=$(realpath $0)
SCRIPTS_DIR=$(dirname $BUILD_SCRIPT_PATH)
BUILD_DIR=$(dirname $SCRIPTS_DIR)
DIST_DIR=$BUILD_DIR/dist
PROJECT_DIR=$(dirname $BUILD_DIR)

TEMP_DIR=$BUILD_DIR/build_temp
mkdir -p $TEMP_DIR

tempfiles=()
cleanup() {
    rm -f "${tempfiles[@]}"
    rm -rf $TEMP_DIR
}
trap cleanup 0

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
    rm -rf $DIST_DIR >/dev/null
fi
mkdir -p $DIST_DIR >/dev/null

cd $DIST_DIR >/dev/null

echo "Making project ..."
CMAKE_TEMP=$(mktemp -p $TEMP_DIR)
tempfiles=($CMAKE_TEMP)
if ! cmake -G Ninja $PROJECT_DIR >$CMAKE_TEMP 2>$CMAKE_TEMP; then
    sh "$SCRIPTS_DIR/error.sh" $(($LINENO - 1)) "Failed to create ninja files using cmake" 30 $CMAKE_TEMP
    exit $?
fi

echo "Building project ..."
NINJA_TEMP=$(mktemp -p $TEMP_DIR)
tempfiles=($NINJA_TEMP)
if ! ninja >$NINJA_TEMP 2>$NINJA_TEMP; then
    sh "$SCRIPTS_DIR/error.sh" $(($LINENO - 1)) "Failed to build with ninja" 31 $NINJA_TEMP
    exit $?
fi

if [ -d "resources" ]; then
    echo "Removing resources from dist ..."
    rm -r resources >/dev/null
fi
if [ -d "$PROJECT_DIR/resources" ]; then
    echo "Copying resources into dist ..."
    cp -r $PROJECT_DIR/resources resources >/dev/null
fi

echo "Generating new compile_commands.json ..."
COMPILE_COMMANDS_FILE_NAME=compile_commands.json
if [ -e "$PROJECT_DIR/$COMPILE_COMMANDS_FILE_NAME" ]; then
    rm $PROJECT_DIR/$COMPILE_COMMANDS_FILE_NAME >/dev/null
fi
ln -s "$DIST_DIR/$COMPILE_COMMANDS_FILE_NAME" $PROJECT_DIR/$COMPILE_COMMANDS_FILE_NAME >/dev/null

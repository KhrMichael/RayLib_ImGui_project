#!/bin/bash

SETUP_SCRIPT_PATH=$(realpath $0)
SCRIPTS_DIR=$(dirname $SETUP_SCRIPT_PATH)
BUILD_DIR=$(dirname $SCRIPTS_DIR)
DEPS_DIR=$(dirname $BUILD_DIR)/deps
DEPS_LIST_PATH=$(dirname $BUILD_DIR)/deps/list.txt

mkdir -p $DEPS_DIR
touch $DEPS_LIST_PATH

cd $DEPS_DIR

if ! command -v git >/dev/null 2>/dev/null; then
    echo "'git' does not exist"
    exit 10
fi

if ! command -v make >/dev/null 2>/dev/null; then
    echo "'make' does not exist"
    exit 10
fi

# START raylib

if ! grep -Fxq "raylib" $DEPS_LIST_PATH; then
    echo Downloading raylib sources ...
    git clone --depth 1 https://github.com/raysan5/raylib.git raylib
    RAYLIB_PATH=$DEPS_DIR/raylib

    cd $RAYLIB_PATH/src/

    echo Making raylib ...
    make PLATFORM=PLATFORM_DESKTOP &>/dev/null

    echo Installing raylib ...
    make DESTDIR=$DEPS_DIR install &>/dev/null

    echo Removing raylib sources ...
    rm -rf $RAYLIB_PATH

    echo "raylib" >>$DEPS_LIST_PATH
    echo [INSTALLED] raylib
fi

# END raylib

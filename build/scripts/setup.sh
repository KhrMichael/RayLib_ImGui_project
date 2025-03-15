#!/bin/bash

SETUP_SCRIPT_PATH=$(realpath $0)
SCRIPTS_DIR=$(dirname $SETUP_SCRIPT_PATH)
BUILD_DIR=$(dirname $SCRIPTS_DIR)
DEPS_DIR=$(dirname $BUILD_DIR)/deps
DEPS_LIST_PATH=$(dirname $BUILD_DIR)/deps/list.txt

TEMP_DIR=$BUILD_DIR/setup_temp
mkdir -p $TEMP_DIR

tempfiles=()
cleanup() {
    rm -f "${tempfiles[@]}"
    rm -rf $TEMP_DIR
}
trap cleanup 0

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
    GIT_CLONE_TEMP=$(mktemp -p $TEMP_DIR)
    tempfiles+=($GIT_CLONE_TEMP)
    if ! git clone --depth 1 https://github.com/raysan5/raylib.git raylib >$GIT_CLONE_TEMP 2>$GIT_CLONE_TEMP; then
        sh "$SCRIPTS_DIR/error.sh" $(($LINENO - 1)) "Failed to clone raylib github repository" 21 $GIT_CLONE_TEMP
        exit $?
    fi
    RAYLIB_PATH=$DEPS_DIR/raylib

    cd $RAYLIB_PATH/src/

    echo Making raylib ...
    MAKE_TEMP=$(mktemp -p $TEMP_DIR)
    tempfiles+=($MAKE_TEMP)
    if ! make PLATFORM=PLATFORM_DESKTOP >$MAKE_TEMP 2>$MAKE_TEMP; then
        sh "$SCRIPTS_DIR/error.sh" $(($LINENO - 1)) "Failed to make" 21 $MAKE_TEMP
        exit $?
    fi

    echo Installing raylib ...
    MAKE_INSTALL_TEMP=$(mktemp -p $TEMP_DIR)
    tempfiles+=($MAKE_INSTALL_TEMP)
    if ! sudo make DESTDIR=$DEPS_DIR install >$MAKE_INSTALL_TEMP 2>$MAKE_INSTALL_TEMP; then
        sh "$SCRIPTS_DIR/error.sh" $(($LINENO - 1)) "Failed to run make install" 22 $MAKE_INSTALL_TEMP
        exit $?
    fi
    echo Removing raylib sources ...
    rm -rf $RAYLIB_PATH >/dev/null 2>/dev/null

    echo "raylib" >>$DEPS_LIST_PATH >/dev/null 2>/dev/null
    echo [INSTALLED] raylib
fi

# END raylib

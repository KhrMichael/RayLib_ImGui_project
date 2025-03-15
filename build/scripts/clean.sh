#!/bin/bash

CLEAN_SCRIPT_PATH=$(realpath $0)
SCRIPTS_DIR=$(dirname $CLEAN_SCRIPT_PATH)
BUILD_DIR=$(dirname $SCRIPTS_DIR)
PROJECT_DIR=$(dirname $BUILD_DIR)

cd $BUILD_DIR
echo "Removing dist ..."
rm -rf dist >/dev/null 2>/dev/null

cd $PROJECT_DIR
echo "Removing compile_commands.json ..."
rm compile_commands.json >/dev/null 2>/dev/null

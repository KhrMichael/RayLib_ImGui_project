#!/bin/bash

RUN_SCRIPT_PATH=$(realpath $0)
SCRIPTS_DIR=$(dirname $RUN_SCRIPT_PATH)
BUILD_DIR=$(dirname $SCRIPTS_DIR)
DIST_DIR=$BUILD_DIR/dist

cd $DIST_DIR
./HolyLight

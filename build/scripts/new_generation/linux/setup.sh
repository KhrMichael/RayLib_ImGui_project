#!/bin/bash

CURRENT_DIR="$(dirname $(realpath $0))/.."
SCRIPTS_DIR="$(dirname $(realpath $0))"

source "$SCRIPTS_DIR/utils.sh"

INFO_FORMAT="\e[0;38;2;30;144;255m"

if ! command -v git >/dev/null 2>/dev/null; then
    error $(($LINENO - 1)) "\"git\" does not exist" 10
    exit $?
fi

if ! command -v make >/dev/null 2>/dev/null; then
    error $(($LINENO - 1)) "\"make\" does not exist" 10
    exit $?
fi

if ! command -v tar >/dev/null 2>/dev/null; then
    error $(($LINENO - 1)) "\"tar\" does not exist" 10
    exit $?
fi

TEMP_DIR=$(mktemp -d)
tempfiles=()
cleanup() {
    rm -f "${tempfiles[@]}"
    rm -rf "$TEMP_DIR"
}
trap cleanup 0

LUA_DIR="$CURRENT_DIR/lua"
mkdir -p "$LUA_DIR"

LUA_JIT_DIR="$LUA_DIR/lua_jit"

LUA_JIT_TEMP_FILE_PATH=$(mktemp -p $TEMP_DIR)
tempfiles+=($LUA_JIT_TEMP_FILE_PATH)

if ! test -d "$LUA_JIT_DIR"; then
    echo -e -e "$INFO_FORMAT[Installing] luajit ..."
    cd "$TEMP_DIR"
    assert "git clone https://luajit.org/git/luajit.git" "Failed to clone luajit" $LUA_JIT_TEMP_FILE_PATH
    cd luajit
    assert "make" "Failed to make luajit" $LUA_JIT_TEMP_FILE_PATH
    assert "mkdir -p \"$LUA_JIT_DIR\"" "Failed to create directory for luajit" $LUA_JIT_TEMP_FILE_PATH
    assert "make install PREFIX=\"$LUA_JIT_DIR\"" "Failed to install luajit" $LUA_JIT_TEMP_FILE_PATH
    cd "$LUA_JIT_DIR"
    echo -e "$INFO_FORMAT[Installed] luajit"
fi

LUA_JIT_BIN_DIR="$LUA_JIT_DIR/bin"
LUA_JIT_VERSION="5.1"

LUA_ROCKS_VERSION="3.11.1"
LUA_ROCKS_UNPACKED_NAME="luarocks-$LUA_ROCKS_VERSION"
LUA_ROCKS_ARCHIVE="$LUA_ROCKS_UNPACKED_NAME.tar.gz"
LUA_ROCKS_ARCHIVE_URL="https://luarocks.org/releases/$LUA_ROCKS_ARCHIVE"
LUA_ROCKS_DIR="$LUA_DIR/luarocks"

LUA_ROCKS_TEMP_FILE_PATH=$(mktemp -p $TEMP_DIR)
tempfiles+=($LUA_ROCKS_TEMP_FILE_PATH)

if ! test -d "$LUA_ROCKS_DIR"; then
    echo -e "$INFO_FORMAT[Installing] LuaRocks ..."
    cd "$TEMP_DIR"
    assert "wget \"$LUA_ROCKS_ARCHIVE_URL\"" "Failed to download luarocks" $LUA_ROCKS_TEMP_FILE_PATH
    assert "tar zxpf \"$LUA_ROCKS_ARCHIVE\"" "Failed to unpack luarocks" $LUA_ROCKS_TEMP_FILE_PATH
    cd "$LUA_ROCKS_UNPACKED_NAME"
    assert "./configure --prefix=\"$LUA_ROCKS_DIR\" --lua-version=\"$LUA_JIT_VERSION\" --with-lua-bin=\"$LUA_JIT_BIN_DIR\"" "Failed to configure luarock's make" $LUA_ROCKS_TEMP_FILE_PATH
    assert "make" "Failed to make luarocks" $LUA_ROCKS_TEMP_FILE_PATH
    assert "make install" "Failed to install luarocks" $LUA_ROCKS_TEMP_FILE_PATH
    echo -e "$INFO_FORMAT[Installed] LuaRocks"
fi

LUAFILESYSTEM_ROCK_TEMP_FILE_PATH=$(mktemp -p $TEMP_DIR)
tempfiles+=($LUAFILESYSTEM_ROCK_TEMP_FILE_PATH)

assert "eval \"$LUA_ROCKS_DIR/bin/luarocks install luafilesystem\"" "Failed to install luafilesystem rock" $LUAFILESYSTEM_ROCK_TEMP_FILE_PATH

echo -e "$INFO_FORMAT[SETUP IS DONE]"

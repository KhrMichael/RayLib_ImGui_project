DEPS_PATH=$(pwd)/deps

mkdir -p $DEPS_PATH

cd $DEPS_PATH

# START raylib

git clone --depth 1 https://github.com/raysan5/raylib.git raylib
RAYLIB_PATH=$DEPS_PATH/raylib

cd $RAYLIB_PATH/src/

echo "CURRENT DIR: $DEPS_PATH"
make PLATFORM=PLATFORM_DESKTOP

sudo make DESTDIR=$DEPS_PATH install

rm -rf $RAYLIB_PATH

# END raylib

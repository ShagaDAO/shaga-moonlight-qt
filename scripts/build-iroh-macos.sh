# This script requires cargo and rust to be already installed
BUILD_CONFIG=$1

BUILD_FOLDER=./moonlight-common-c/moonlight-common-c/iroh-net-ffi
OUT_FOLDER=./libs_shaga
OUT_LIB_FILE_NAME=$OUT_FOLDER/mac/lib/libiroh_net_ffi.dylib
OUT_HEADER_FILE_NAME=$OUT_FOLDER/mac/include/irohnet.h
BUILD_OPTIONS=""
BUILD_DIR_NAME="debug"

if [ "$BUILD_CONFIG" == "Release" ]; then
  BUILD_OPTIONS="--release"
  BUILD_DIR_NAME="release"
fi

echo Clean existing iroh-net-ffi shared library
rm $OUT_LIB_FILE_NAME
rm $OUT_HEADER_FILE_NAME

echo Building iroh-net-ffi library
pushd $BUILD_FOLDER
cargo build $BUILD_OPTIONS
cc -o main{,.c} -L target/$BUILD_DIR_NAME -l iroh_net_ffi -lc -lm
popd

echo Copying iroh-neg-ffi shared library
mkdir -p $OUT_FOLDER/mac/lib
mkdir -p $OUT_FOLDER/mac/include
cp $BUILD_FOLDER/target/$BUILD_DIR_NAME/libiroh_net_ffi.dylib $OUT_LIB_FILE_NAME
cp $BUILD_FOLDER/irohnet.h $OUT_HEADER_FILE_NAME

echo Build iroh-net-ffi was successful

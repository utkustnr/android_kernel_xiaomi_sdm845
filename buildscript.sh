#!/usr/bin/env bash
set -e
SRC_DIR="$(pwd)"
OUT_DIR="$SRC_DIR/out"
TC_DIR="$HOME/toolchains"
USR_NAME="$(whoami)"

export ARCH=arm64
export SUBARCH=arm64
export CLANGVER="clang-r530567"
# https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/main/clang-r530567.tar.gz
export CLANG_TRIPLE=aarch64-linux-gnu-
export CLANG_PREBUILT_BIN="$TC_DIR/$CLANGVER/bin"
# https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/+archive/2241b5c67a912c653fce95ad21fe71ef8dc970b2.tar.gz
export CROSS_COMPILE_ARM32="arm-linux-androideabi-"
export GCC32_DIR="$TC_DIR/gcc/arm-linux-androideabi-4.9/bin"
# https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+archive/95280bf546fc70c4574c0261a9bedd45275047b5.tar.gz
export CROSS_COMPILE="aarch64-linux-android-"
export GCC64_DIR="$TC_DIR/gcc/aarch64-linux-android-4.9/bin"
export JOBS=$(nproc)
export KBUILD_BUILD_HOST="archbtw"
export KBUILD_BUILD_USER="$USR_NAME"
export LLVM=1

export PATH="$TC_DIR:$CLANG_PREBUILT_BIN:$GCC64_DIR:$GCC32_DIR:$PATH"
mkdir -p "$OUT_DIR"
make -j$JOBS -C $SRC_DIR O=$OUT_DIR \
     KCFLAGS="-gdwarf-2 -Wno-error" \
     vendor/xiaomi/mi845_defconfig vendor/xiaomi/dipper.config

make -j$JOBS -C $SRC_DIR O=$OUT_DIR \
     KCFLAGS="-gdwarf-2 -Wno-error" \
     Image.gz-dtb

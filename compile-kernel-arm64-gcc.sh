#!/bin/env bash

set -e

sudo apt update && sudo apt install python3 python libelf-dev tree -y
mkdir android-kernel && cd android-kernel
git clone --depth=1 https://android.googlesource.com/kernel/common -b deprecated/android-4.14-q
export CROSS_COMPILE=arm-linux-androideabi-
export REAL_CROSS_COMPILE=arm-linux-androideabi-
export ARCH=arm
git clone --depth=1 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 -b android-10.0.0_r47
export PATH=$PATH:$(pwd)/arm-linux-androideabi-4.9/bin
cd goldfish && make defconfig && make -j12
tree -f . | grep Image

echo Done.

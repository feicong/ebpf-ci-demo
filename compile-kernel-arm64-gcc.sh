#!/bin/env bash

set -e

sudo apt-get update && sudo apt-get install dialog file python3 python libelf-dev gpg gpg-agent tree flex bison libssl-dev zip unzip curl wget tree build-essential bc software-properties-common libstdc++6 libpulse0 libglu1-mesa locales lcov libsqlite3-0 --no-install-recommends -y

mkdir android-kernel && cd android-kernel
git clone --depth=1 https://android.googlesource.com/kernel/common -b deprecated/android-4.14-q
export CROSS_COMPILE=arm-linux-androideabi-
export REAL_CROSS_COMPILE=arm-linux-androideabi-
export ARCH=arm
git clone --depth=1 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 -b android-10.0.0_r47
export PATH=$PATH:$(pwd)/arm-linux-androideabi-4.9/bin
cd common && make defconfig && make -j12
tree -f . | grep Image

echo Done.

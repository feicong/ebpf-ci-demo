#!/bin/env bash

set -e

sudo apt update && sudo apt install python3 python libelf-dev tree -y
mkdir android-kernel && cd android-kernel
git clone --depth=1 https://android.googlesource.com/kernel/common -b deprecated/android-4.14-q
wget https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/master-kernel-build-2021/clang-r416183c.tar.gz
rm -rf clang-r416183c && mkdir clang-r416183c && tar xf clang-r416183c.tar.gz -C clang-r416183c
git clone --depth=1 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 -b master-kernel-build-2021
git clone --depth=1 https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 -b master-kernel-build-2021
export PATH=$(pwd)/clang-r416183c/bin:$(pwd)/aarch64-linux-android-4.9/bin:$(pwd)/arm-linux-androideabi-4.9/bin:$PATH
cd common && make ARCH=arm64 defconfig && make -j12 ARCH=arm64 CC=clang \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi-
tree -f . | grep Image

echo Done.

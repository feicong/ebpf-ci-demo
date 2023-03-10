#!/bin/env bash
# https://github.com/nathanchance/android-kernel-clang
# https://source.android.google.cn/setup/build/building-kernels
# https://android.googlesource.com/kernel/manifest/+/refs/heads/q-common-android-4.14/default.xml
set -e

mkdir -p ~/.bin
PATH="${HOME}/.bin:${PATH}"
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
chmod a+rx ~/.bin/repo
sudo apt-get update && sudo apt-get install dialog file python3 python libelf-dev gpg gpg-agent tree flex bison libssl-dev zip unzip curl wget tree build-essential bc software-properties-common libstdc++6 libpulse0 libglu1-mesa locales lcov libsqlite3-0 --no-install-recommends -y
mkdir android-kernel && cd android-kernel
repo init -u https://android.googlesource.com/kernel/manifest -b q-common-android-4.14
sed -i 's/android-4.14-q/deprecated\/android-4.14-q/g' .repo/manifests/default.xml
repo sync -qcj12
ls -al
tree -f -L 3 prebuilts
# tree -f prebuilts | grep aarch64-linux-android-4.9
ls -al prebuilts-master/clang/host/linux-x86/
df -h
# clang-r383902c
tree -f -L 5 prebuilts-master
export PATH=$(pwd)/prebuilts-master/clang/host/linux-x86/clang-r383902c/bin:$(pwd)/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin:$PATH
ARCH=arm64 BUILD_CONFIG=common/build.config.aarch64 SKIP_MRPROPER=1 SKIP_DEFCONFIG=0 DEFCONFIG=defconfig CC=clang CLANG_TRIPLE=aarch64-linux-gnu- CROSS_COMPILE=aarch64-linux-android- build/build.sh -j12
tree -f . | grep Image

echo Done.

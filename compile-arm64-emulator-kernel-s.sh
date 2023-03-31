#!/bin/env bash
# https://github.com/nathanchance/android-kernel-clang
# https://source.android.google.cn/setup/build/building-kernels
# https://android.googlesource.com/kernel/manifest/+/refs/heads/common-android12-5.10/default.xml
# https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+/refs/heads/master-kernel-build-2022
# https://android.googlesource.com/kernel/common/+/refs/heads/android12-5.10
# https://android.googlesource.com/kernel/common-modules/virtual-device/+/refs/heads/android12-5.10
set -e

sudo apt-get update && sudo apt-get install dwarves dialog file python3 python libelf-dev gpg gpg-agent tree flex bison libssl-dev zip unzip curl wget tree build-essential bc software-properties-common libstdc++6 libpulse0 libglu1-mesa locales lcov libsqlite3-0 --no-install-recommends -y

 # for emulators
sudo apt-get install -y libxtst6 libnss3-dev libnspr4 libxss1 libasound2 libatk-bridge2.0-0 libgtk-3-0 libgdk-pixbuf2.0-0 -y

sudo locale-gen en_US.UTF-8
export LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US:en

mkdir -p ~/.bin
PATH="${HOME}/.bin:${PATH}"
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
chmod a+rx ~/.bin/repo

mkdir -p android-kernel && pushd android-kernel
repo init -u https://android.googlesource.com/kernel/manifest -b common-android12-5.10
echo Syncing code.
repo sync -cj8

tree -f -L 5 prebuilts-master
rm -rf  prebuilts-master/clang/host/linux-x86/clang-st*
rm -rf  prebuilts-master/clang/host/linux-x86/clang-32*
rm -rf  prebuilts-master/clang/host/linux-x86/clang-r45*

echo Building code.
sed -i '/soong_zip/d' build/build.sh
BUILD_CONFIG=common-modules/virtual-device/build.config.virtual_device.aarch64 SKIP_MRPROPER=1 CC=clang build/build.sh -j12

popd
tree -f android-kernel | grep Image

IMG=$(find android-kernel -name "Image" | grep "arch/arm64/boot")
echo ${IMG}

echo compile done.

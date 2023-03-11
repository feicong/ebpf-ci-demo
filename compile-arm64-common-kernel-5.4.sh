#!/usr/bin/env bash
# https://github.com/nathanchance/android-kernel-clang
# https://source.android.google.cn/setup/build/building-kernels
# https://android.googlesource.com/kernel/manifest/+/refs/heads/common-android11-5.4/default.xml
# https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+/refs/heads/master-kernel-build-2021
# https://android.googlesource.com/kernel/goldfish/+/refs/heads/android-goldfish-5.4-dev
# https://android.googlesource.com/kernel/common/+/refs/heads/android11-5.4
# https://android.googlesource.com/kernel/common-modules/virtual-device/+/refs/heads/android11-5.4
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
repo init -u https://android.googlesource.com/kernel/manifest -b common-android11-5.4
echo Syncing code.
repo sync -cj8

tree -f -L 5 prebuilts-master
rm -rf  prebuilts-master/clang/host/linux-x86/clang-st*
rm -rf  prebuilts-master/clang/host/linux-x86/clang-32*
rm -rf  prebuilts-master/clang/host/linux-x86/clang-r35*
rm -rf  prebuilts-master/clang/host/linux-x86/clang-r37*

echo patching code.
cd common

git checkout android11-5.4
git rev-parse HEAD
git status || true

echo enable kprobe
cp -f ../../ebpf-ci-demo/patches/5.4/* ../common/
ls ../common/

cd ..
echo patch code done.

echo Building code.
sed -i '/soong_zip/d' build/build.sh
BUILD_CONFIG=common-modules/virtual-device/build.config.goldfish.kprobes.aarch64 SKIP_MRPROPER=1 CC=clang build/build.sh -j12

popd
tree -f android-kernel | grep Image

IMG=$(find android-kernel -name "Image" | grep "arch/arm64/boot")
echo ${IMG}
IMGGZ=$(find android-kernel -name "Image.gz" | grep "arch/arm64/boot")
echo ${IMGGZ}

echo compile done.

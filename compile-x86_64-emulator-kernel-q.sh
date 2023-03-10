#!/usr/bin/env bash
# https://github.com/nathanchance/android-kernel-clang
# https://source.android.google.cn/setup/build/building-kernels
# https://android.googlesource.com/kernel/manifest/+/refs/heads/q-goldfish-android-goldfish-4.14-dev/default.xml
# https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+/refs/heads/master-kernel-build-2021
# https://android.googlesource.com/kernel/goldfish/+/refs/heads/android-goldfish-4.14-dev
set -e

sudo apt-get update && sudo apt-get install dialog file python3 python libelf-dev gpg gpg-agent tree flex bison libssl-dev zip unzip curl wget tree build-essential  bc software-properties-common libstdc++6 libpulse0 libglu1-mesa locales lcov libsqlite3-0 --no-install-recommends -y

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
repo init -u https://android.googlesource.com/kernel/manifest -b q-goldfish-android-goldfish-4.14-dev
echo Syncing code.
repo sync -cj8

ls -al
echo ls goldfish
ls -al goldfish

#  build.config.base: LANG_PREBUILT_BIN=prebuilts-master/clang/host/linux-x86/clang-r365631c/bin
# rebuilts-master/clang/host/linux-x86/llvm-binutils-stable linked to clang-r383902 now
tree -f -L 5 prebuilts-master
rm -rf  prebuilts-master/clang/host/linux-x86/clang-st*
rm -rf  prebuilts-master/clang/host/linux-x86/clang-32*
rm -rf  prebuilts-master/clang/host/linux-x86/clang-r35*
rm -rf  prebuilts-master/clang/host/linux-x86/clang-r37*

echo patching code.
cd goldfish
git checkout android-goldfish-4.14-dev
git rev-parse HEAD
git apply ../../android-kernel-patch/patches/4.14/*.patch
git status || true

echo enable kprobe
cp -f ../../android-kernel-patch/patches/android-goldfish-4.14-dev/* ../goldfish/
ls ../goldfish/

cd ..
echo patch code done.

echo Building code.
BUILD_CONFIG=goldfish/build.config.goldfish.kprobes.x86_64 SKIP_MRPROPER=1 CC=clang build/build.sh -j12

popd
tree -f android-kernel | grep Image

IMG=$(find android-kernel -name "bzImage" | grep "arch/x86_64/boot")
echo ${IMG}

echo Done.

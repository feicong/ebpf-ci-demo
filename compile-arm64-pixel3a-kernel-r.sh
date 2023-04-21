#!/bin/env bash
# https://source.android.google.cn/setup/build/building-kernels
# https://android.googlesource.com/kernel/manifest/+/refs/heads/android-msm-bonito-4.9-android11/default.xml
# https://android.googlesource.com/kernel/build/+/refs/heads/android-msm-bonito-4.9-android12L/build.sh
# https://www.jianshu.com/p/b37b624b4bf5#

set -e

BRANCH=android-msm-bonito-4.9-android11
mkdir -p ~/.bin
PATH="${HOME}/.bin:${PATH}"
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
chmod a+rx ~/.bin/repo

sudo apt-get update && sudo apt-get install dialog file python3 python libelf-dev gpg gpg-agent tree flex bison libssl-dev zip unzip curl wget tree build-essential bc software-properties-common libstdc++6 libpulse0 libglu1-mesa locales lcov libsqlite3-0 --no-install-recommends -y

mkdir android-kernel && cd android-kernel
repo init -u https://android.googlesource.com/kernel/manifest -b ${BRANCH}
repo sync -qcj12

ls -al
tree -f -L 3 prebuilts
ls -al prebuilts-master/clang/host/linux-x86/
df -h
# clang-r383902c
tree -f -L 5 prebuilts-master

echo patching code.
pushd private/msm-google
git checkout ${BRANCH}
git rev-parse HEAD
git apply ../../../ebpf-ci-demo/patches/4.9/android-11/*.patch
git status || true
popd

mv build build.bak
git clone https://mirrors.tuna.tsinghua.edu.cn/git/AOSP/kernel/build -b android-msm-bonito-4.9-android12-qpr1
ls -al build

# export PATH=$(pwd)/prebuilts-master/clang/host/linux-x86/clang-r383902c/bin:$(pwd)/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin:$PATH
build/build.sh -j12
tree -f . | grep Image

echo Done.

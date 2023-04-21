#!/bin/env bash
# https://source.android.google.cn/setup/build/building-kernels
# https://android.googlesource.com/kernel/manifest/+/refs/heads/android-msm-bonito-4.9-android11/default.xml
set -e

mkdir -p ~/.bin
PATH="${HOME}/.bin:${PATH}"
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
chmod a+rx ~/.bin/repo
sudo apt-get update && sudo apt-get install dialog file python3 python libelf-dev gpg gpg-agent tree flex bison libssl-dev zip unzip curl wget tree build-essential bc software-properties-common libstdc++6 libpulse0 libglu1-mesa locales lcov libsqlite3-0 --no-install-recommends -y
mkdir android-kernel && cd android-kernel
repo init -u https://android.googlesource.com/kernel/manifest -b android-msm-bonito-4.9-android11
# sed -i 's/android-4.14-q/deprecated\/android-4.14-q/g' .repo/manifests/default.xml
repo sync -qcj12
ls -al
tree -f -L 3 prebuilts
ls -al prebuilts-master/clang/host/linux-x86/
df -h
# clang-r383902c
tree -f -L 5 prebuilts-master
build/build.sh -j12
tree -f . | grep Image

echo Done.

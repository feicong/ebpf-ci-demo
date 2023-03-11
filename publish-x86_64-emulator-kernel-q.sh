#!/usr/bin/env bash
set -e

echo publishing.

PUBLISH_REPO=feicong/ebpf-course
if [[ ! -z ${CIRRUS_REPO_FULL_NAME} ]]; then
    PUBLISH_REPO=${CIRRUS_REPO_FULL_NAME}
fi
if [[ ! -z ${GITHUB_REPOSITORY} ]]; then
    PUBLISH_REPO=${GITHUB_REPOSITORY}
fi

FILE_TAIL="$(date +'%s')"
if [[ ! -z ${GITHUB_SHA} ]]; then
    FILE_TAIL=${GITHUB_SHA}
fi
if [[ ! -z ${CIRRUS_TASK_ID} ]]; then
    FILE_TAIL=${CIRRUS_TASK_ID}
fi

IMG=$(find android-kernel -name "bzImage" | grep "arch/x86_64/boot")
echo ${IMG}
if [[ -z ${IMG} ]]; then
    echo "bzImage not found."
    exit 1
fi

ZIP_FILE=android-x86_64-emulator-q-4.14-kernel-${FILE_TAIL}.zip
zip -P qq121212 ${ZIP_FILE} ${IMG}

echo Publishing ${ZIP_FILE}
curl --request PUT --progress-bar --dump-header - --upload-file ${ZIP_FILE} https://transfer.sh/${ZIP_FILE}
gh release upload latest ${ZIP_FILE} --repo ${PUBLISH_REPO} --clobber

IMG=$(find android-kernel -name "kernel-headers.tar.gz" | grep "dist/kernel-headers.tar.gz")
echo ${IMG}
if [[ -z ${IMG} ]]; then
    echo "kernel-headers.tar.gz not found."
    exit 1
fi
ZIP_FILE=android-x86_64-emulator-q-4.14-kernel-headers-${FILE_TAIL}.tar.gz
mv ${IMG} ${ZIP_FILE}
gh release upload latest ${ZIP_FILE} --repo ${PUBLISH_REPO} --clobber

IMG=$(find android-kernel -name "kernel-uapi-headers.tar.gz" | grep "dist/kernel-uapi-headers.tar.gz")
echo ${IMG}
if [[ -z ${IMG} ]]; then
    echo "kernel-uapi-headers.tar.gz not found."
    exit 1
fi
ZIP_FILE=android-x86_64-emulator-q-4.14-kernel-uapi-headers-${FILE_TAIL}.tar.gz
mv ${IMG} ${ZIP_FILE}
gh release upload latest ${ZIP_FILE} --repo ${PUBLISH_REPO} --clobber

if [[ -f android-kernel/out/x86_64/dist/vmlinux ]]; then
    ZIP_FILE=android-x86_64-emulator-q-4.14-vmlinux-${FILE_TAIL}.zip
    zip -P qq121212 ${ZIP_FILE} android-kernel/out/x86_64/dist/vmlinux
    gh release upload latest ${ZIP_FILE} --repo ${PUBLISH_REPO} --clobber
fi

if [[ -f android-kernel/out/x86_64/dist/vmlinux.btf ]]; then
    ZIP_FILE=android-x86_64-emulator-q-4.14-vmlinux-btf-${FILE_TAIL}.zip
    zip -P qq121212 ${ZIP_FILE} android-kernel/out/x86_64/dist/vmlinux.btf
    gh release upload latest ${ZIP_FILE} --repo ${PUBLISH_REPO} --clobber
fi

set +e
echo publish done.

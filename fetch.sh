#!/bin/bash

set -e

SHASUM_x86_64=33054ee647ee8a4fb54fc05110e07e0b53e04591fe53d0a4cb4c7ed7a05e91f1
SHASUM_AARCH64=ba06837ac2899547bbb799989f11464fecd6782226871c3b7a48619481042679

TARGET="$1"
MAJOR_VERSION="$2"
VERSION="$3"

function fetch () {
    FILENAME="julia-${VERSION}-linux"

    if test "x86_64" = "${1}"; then
        curl --create-dirs -O "https://julialang-s3.julialang.org/bin/linux/x64/${MAJOR_VERSION}/${FILENAME}-x86_64.tar.gz"
    elif test "aarch64" = "${1}"; then
        curl --create-dirs -O "https://julialang-s3.julialang.org/bin/linux/aarch64/${MAJOR_VERSION}/${FILENAME}-aarch64.tar.gz"
    else
        return 1
    fi
}

function validate() {
    FILENAME="julia-${VERSION}-linux"

    # Validate that the toolchain we downloaded matches the expected SHA256 checksum.
    if test "x86_64" = "${1}"; then
        test "${SHASUM_x86_64}" = "$(sha256sum ${FILENAME}-x86_64.tar.gz | cut -d' ' -f1)"
    elif test "aarch64" = "${1}"; then
        test "${SHASUM_AARCH64}" = "$(sha256sum ${FILENAME}-aarch64.tar.gz | cut -d' ' -f1)"
    else
        return 1
    fi
}

rm -rf ${TARGET}
mkdir -p ${TARGET}
cd ${TARGET}

function fetch_target() {
    validate ${1} || (fetch ${1} && validate ${1})
}

fetch_target x86_64
fetch_target aarch64

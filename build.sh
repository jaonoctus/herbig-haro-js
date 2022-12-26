#!/bin/bash

build() {
    local output="hh"
    local output_folder="./bin"
    local targets="node18-linux-x64,node18-linux-arm64"

    printf "# START: building binaries...\n"
    [ -d bin ] && rm -rf ./bin
    npx pkg -C GZip \
        -o "${output_folder}/${output}" \
        -t "${targets}" \
        --no-bytecode \
        --public-packages "*" \
        --public \
        src/index.js
    printf "# DONE: binaries built.\n"

    (
        cd "${output_folder}"

        printf "# START: generating checksums...\n"
        sha256sum * > SHA256SUMS
        printf "# DONE: SHA256SUMS generated.\n"

        printf "# START: creating a signature...\n"
        gpg --detach-sign --armor SHA256SUMS
        printf "# DONE: checksum file signed.\n"
    )
}

build

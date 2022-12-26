#!/bin/bash

build() {
    local output="hh"
    local targets="node18-linux-x64,node18-linux-arm64"

    pkg -C GZip \
        -o "bin/${output}" \
        -t "${targets}" \
        --no-bytecode \
        --public-packages "*" \
        --public \
        src/index.js
}

build

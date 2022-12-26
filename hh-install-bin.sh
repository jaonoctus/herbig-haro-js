#!/bin/bash
#
# This script will install herbig-haro (hh)
# hh is a BTRFS interactive CLI
# by jaonoctus <jaonoctus@protonmail.com>

set -euo pipefail

readonly BIN_PATH="/usr/bin/hh"

check_is_root() {
    local user_id=$(id -u)

    if [ "${user_id}" != "0" ]; then
        printf "ERROR: you MUST run it as root.\n$ sudo bash ./hh-install-bin.sh\n" 1>&2
        exit 1
    fi
}

get_latest_herbig_haro_version() {
    echo $(curl --silent https://api.github.com/repos/jaonoctus/herbig-haro-js/releases/latest | sed -n 's/.*"tag_name": "\([^"]*\).*/\1/p')
}

get_bin_name() {
    local arch=$(uname -m)
    local bin_name

    case "${arch}" in
        x86_64) bin_name="hh-x64" ;;
        aarch64) bin_name="hh-arm64" ;;
        *)
            printf "ERROR: arch ${arch} not supported.\n" 1>&2
            exit 1
            ;;
    esac

    echo "${bin_name}"
}

confirm_installation() {
    printf "# This will install herbig-haro (hh) $1\n"
    read -r -p "> Do you want to proceed? [y/N]: " confirm

    case "${confirm}" in
        y|Y|s|S|yes|SIM)
            # do nothing, proceed
            ;;
        *)
            printf "ERROR: you MUST have to confirm. Installation aborted.\n" 1>&2
            exit 1
            ;;
    esac
}

download_assets() {
    local version="$1"
    local temp_folder="$2"
    local bin_name="$3"
    local url="https://github.com/jaonoctus/herbig-haro-js/releases/download/${version}"

    printf "Downloading assets (${temp_folder})...\n"

    (
        cd "${temp_folder}"
        curl -L -O "${url}/SHA256SUMS"
        curl -L -O "${url}/SHA256SUMS.asc"
        curl -L -O "${url}/${bin_name}"
    )
}

verify_assets() {
    local temp_folder="$1"

    printf "Verifying assets...\n"

    (
        cd "${temp_folder}"
        # import key
        curl -L -O https://jaonoct.us/jaonoctus_0x6B457D060ACE363C9D67D8E6782C165A293D6E18.asc
        gpg --import jaonoctus_0x6B457D060ACE363C9D67D8E6782C165A293D6E18.asc
        # verify signature
        gpg --verify "SHA256SUMS.asc"
        # verify binary
        sha256sum --ignore-missing --check SHA256SUMS
    )
}

install() {
    check_is_root

    local version=$(get_latest_herbig_haro_version)

    confirm_installation "${version}"

    local temp_folder=$(mktemp -d)
    local bin_name=$(get_bin_name)

    download_assets "${version}" "${temp_folder}" "${bin_name}"
    verify_assets "${temp_folder}"

    cp "${temp_folder}/${bin_name}" "${BIN_PATH}"
    sudo chmod +x "${BIN_PATH}"

    printf "\n\nDONE. herbig-haro (hh) is installed under \"${BIN_PATH}\". You can start using it:\n"
    printf "$ hh --help\n"
}

install

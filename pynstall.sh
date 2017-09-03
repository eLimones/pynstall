#!/usr/bin/env bash

function download_page {
    curl -s https://www.python.org/downloads/source/
}

function extract_links {
    grep  "https://www.python.org/ftp/python/.\+\.tgz" -o | sort
}

function extract_versions {
    grep -oP  "Python-(.+)(?=\.tgz)"
}

function extract_filename {
    grep -oP  "(Python-.+)(?=\.tgz)"
}

function something_ls-remote () {
    download_page | extract_links | extract_versions
}

function something_install(){
    BUILD_TEMP_DIR=./downloads
    mkdir -p $BUILD_TEMP_DIR 
    SOURCE_CODE_URL=$(download_page | extract_links | grep "$1\.tgz")
    SOURCE_FILE_NAME=$(echo $SOURCE_CODE_URL | extract_filename)
    wget -P $BUILD_TEMP_DIR $SOURCE_CODE_URL
    tar zxfv $BUILD_TEMP_DIR/$SOURCE_FILE_NAME.tgz -C $BUILD_TEMP_DIR
}

function something_help () {
    echo "this is help"
}

ProgName=$(basename $0)
subcommand=$1
shift
something_${subcommand} $@
if [ $? = 127 ]; then
    echo "Error '$subcommand' is not a known subcommand." >&2
    echo "  Run '$ProgName help' for a list of known subcommands." >&2
    exit 1
fi

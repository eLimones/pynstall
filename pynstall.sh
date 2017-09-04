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

function download_source_code {
    wget -P $BUILD_TEMP_DIR $SOURCE_CODE_URL
}

function decompress_source_code {
    tar zxfv $BUILD_TEMP_DIR/$SOURCE_FILE_NAME.tgz -C $BUILD_TEMP_DIR
}

function compile_and_install_python {
    cd $BUILD_TEMP_DIR/$SOURCE_FILE_NAME
    ./configure --prefix=$DESTINATION_DIR_ABSOLUTE
    make -j8 && make install
}

function something_install(){
    BUILD_TEMP_DIR=./downloads
    DESTINATION_DIR=./python
    mkdir -p $BUILD_TEMP_DIR 
    SOURCE_CODE_URL=$(download_page | extract_links | grep "$1\.tgz")
    SOURCE_FILE_NAME=$(echo $SOURCE_CODE_URL | extract_filename)
    download_source_code
    decompress_source_code
    mkdir -p $DESTINATION_DIR/$SOURCE_FILE_NAME
    find $BUILD_TEMP_DIR -type d | xargs chmod 0755
    DESTINATION_DIR_ABSOLUTE=$( cd $DESTINATION_DIR/$SOURCE_FILE_NAME; pwd )
    ( compile_and_install_python )
    echo "Install Success"
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

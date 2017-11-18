#!/usr/bin/env bash

set -e

DOWNLOAD_DIR=~/bin/local_python/downloads
SOURCECODE_DIR=~/bin/local_python/source
INSTALL_DIR=~/bin/local_python

function download_page {
    curl -s https://www.python.org/downloads/source/
}

function extract_links {
    grep  "https://www.python.org/ftp/python/.\+\.tgz" -o | sort
}

function extract_versions {
    grep -oP  "Python-(.+)(?=\.tgz)"
}

function get_full_version_name {
    grep -oP  "(Python-.+)(?=\.tgz)"
}

function download_source_code {
    mkdir -p $DOWNLOAD_DIR
    wget -P $DOWNLOAD_DIR $SOURCE_CODE_URL
}

function decompress_source_code {
    mkdir -p $SOURCECODE_DIR
    tar zxfv $DOWNLOAD_DIR/$COMPLETE_VERSION_NAME.tgz -C $SOURCECODE_DIR
}

function compile_and_install_python {
    mkdir -p $INSTALL_DIR/$COMPLETE_VERSION_NAME
    find $SOURCECODE_DIR -type d | xargs chmod 0755
    INSTALL_DIR_ABSOLUTE=$( cd $INSTALL_DIR/$COMPLETE_VERSION_NAME; pwd )
    cd $SOURCECODE_DIR/$COMPLETE_VERSION_NAME
    ./configure --prefix=$INSTALL_DIR_ABSOLUTE
    make -j8 && make install
}

function remove_source_code {
    echo "Removing Source files"
    rm -rf $SOURCECODE_DIR/$COMPLETE_VERSION_NAME
}

function remove_tarball {
    echo "Removing tarball"
    rm -rf $DOWNLOAD_DIR/$COMPLETE_VERSION_NAME.tgz
}

function is_virtual_env {
    lsvirtualenv | grep --silent "$COMPLETE_VERSION_NAME$"
}

function delete_local_python_version {
    rm -rfv $PYTHON_VERSION_PATH
}

function is_installed {
    test -d $PYTHON_VERSION_PATH/bin
}

function python_binary_location {
    find $PYTHON_VERSION_PATH/bin -name "python[[:digit:]]"
}

function load_virtual_env_wrapper {
    source ~/.local/bin/virtualenvwrapper.sh
}

function delete_vitual_env {
    rmvirtualenv $COMPLETE_VERSION_NAME
}

function create_virtual_env {
    mkvirtualenv -p $(python_binary_location) $COMPLETE_VERSION_NAME
}

function load_names {
    SOURCE_CODE_URL=$(download_page | extract_links | grep "$1\.tgz")
    COMPLETE_VERSION_NAME=$(echo $SOURCE_CODE_URL | get_full_version_name)
    PYTHON_VERSION_PATH=$( realpath -m $INSTALL_DIR/$COMPLETE_VERSION_NAME)
}

function install_local_python {
    download_source_code
    decompress_source_code
    ( compile_and_install_python ) && { remove_source_code; remove_tarball; echo "Install success"; } || echo "Install failed";
    remove_source_code; remove_tarball ; echo "Install Success" } || echo  "Install failed!"
}

function pynstall_ls-remote {
    download_page | extract_links | extract_versions
}

function pynstall_ls {
    ls -d $INSTALL_DIR/Python* || echo ""
}

function pynstall_install {
    load_names $@
    install_local_python
}

function pynstall_uninstall {
    load_names $@
    delete_local_python_version
    echo "Uninstalled"
}

function  pynstall_install-ve {
    load_virtual_env_wrapper
    load_names $@
    is_installed && echo "already installed" || install_local_python
    is_virtual_env && echo "virtualenv already exists" || create_virtual_env
}

function pynstall_uninstall_ve {
    load_virtual_env_wrapper
    load_names $@
    is_virtual_env && delete_vitual_env || echo "virtualenv $COMPLETE_VERSION_NAME does not exist, skipping step"
    is_installed && delete_local_python_version || echo "$COMPLETE_VERSION_NAME does not exist, skipping step"
    echo "Uninstalled"
}

function pynstall_help {
    echo "this is help"
}

ProgName=$(basename $0)
subcommand=$1
shift
pynstall_${subcommand} $@
if [ $? = 127 ]; then
    echo "Error '$subcommand' is not a known subcommand." >&2
    echo "  Run '$ProgName help' for a list of known subcommands." >&2
    exit 1
fi


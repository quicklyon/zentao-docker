#!/bin/bash
#
# Zentao persistence library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/easysoft/scripts/libfs.sh

# Functions

########################
# make link source directory to dest directory
# Arguments:
#   $1 - sourcepath
#   $2 - destpath
#   $3 - owner
# Returns:
#   None
#########################
move_then_link() {
    local source="${1:?path is missing}"
    local dest="${2:?path is missing}"
    local owner=${3:-}
    local group=${4:-}

    ensure_dir_exists "$dest" "$owner" "$group" "777"

    # 持久化目录没有文件，将代码中需要持久化的文件复制到持久化目录
    if [ ! -e "$source" ];then
        mv "$dest" "$(dirname "$source")"
    fi

    # 代码中有需要持久化的目录，将代码中的目录改名
    if [ -e "$dest" ] && [ ! -L "$dest" ];then
        mv "$dest" "$dest.$$"
    fi

    [ ! -L "$dest" ] && ln -s "$source" "$dest"

    if [[ -n $group ]]; then
        chown -h "$owner":"$group" "$dest"
    else
        chown -h "$owner":"$owner" "$dest"
    fi
}
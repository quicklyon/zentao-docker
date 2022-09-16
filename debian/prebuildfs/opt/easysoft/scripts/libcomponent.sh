#!/bin/bash
#
# Library for managing Easysoft components

[ -n "${DEBUG:+1}" ] && set -x

set -e

# Constants
DOWNLOAD_URL="https://pkg-hk.qucheng.com/files/stacksmith"
ZENTAO_URL="https://dl.cnezsoft.com/zentao"
ZDOO_URL="https://www.zdoo.com/dl/zdoo"


# Functions

########################
# Download and unpack a Easysoft software
# Globals:
#   OS_NAME
#   OS_ARCH
# Arguments:
#   $1 - software's name
#   $2 - software's version
# Returns:
#   None
#########################
z_download() {
    timestamp="$(date +%s)"
    local name="${1:?software name is required}"
    local version="${2:?version is required}"
    local zentao_base_name="ZenTaoPMS.${version}.php7.2_7.4.zip?$timestamp"
    local zdoo_base_name="zdoo.${version}.php7.2.zip"
    local directory="/apps/"

    echo "Downloading $name:$version package"
    case $name in 
    "zentao")
        # 下载旗舰版 k8s定制版(amd64)
        #if [[ "$version" =~ "max-k8s" ]];then
        #    component_unpack "zentao" "$version" -c 4b140d9c9cb962345e8aefc84676e428bf842347798b2732e974d5b1172545b1
        #else
            wget --no-check-certificate --quiet --output-document=/tmp/"${1}" "${ZENTAO_URL}/${version/.k8s}/${zentao_base_name}"
            unzip -qq -d ${directory} /tmp/"${1}" && mv /apps/zentaopms /apps/zentao && rm -rf /apps/zentao/www/data
            rm /tmp/"${1}"
        #fi
        ;;
    "zdoo")
        wget --no-check-certificate --quiet --output-document=/tmp/"${1}" "${ZDOO_URL}/${version}/${zdoo_base_name}"
        unzip -qq -d ${directory} /tmp/"${1}" && rm -rf /apps/zdoo/www/data
        rm /tmp/"${1}"
        ;;
    *)
        echo "$1 does not support download yet."
        exit 1
        ;;
    esac
}

########################
# Download and unpack a Easysoft package
# Globals:
#   OS_NAME
#   OS_ARCH
# Arguments:
#   $1 - component's name
#   $2 - component's version
# Returns:
#   None
#########################
component_unpack() {
    local name="${1:?name is required}"
    local version="${2:?version is required}"
    local base_name="${name}-${version}-${OS_NAME}-${OS_ARCH}"
    local package_sha256=""
    local directory="/"

    # Validate arguments
    shift 2
    while [ "$#" -gt 0 ]; do
        case "$1" in
            -c|--checksum)
                shift
                package_sha256="${1:?missing package checksum}"
                ;;
            *)
                echo "Invalid command line flag $1" >&2
                return 1
                ;;
        esac
        shift
    done

    echo "Downloading $base_name package"

	curl -k --remote-name --silent --show-error --fail "${DOWNLOAD_URL}/${base_name}.tar.gz"

    if [ -n "$package_sha256" ]; then
        echo "Verifying package integrity"
        echo "$package_sha256  ${base_name}.tar.gz" | sha256sum -c - || exit "$?"
    fi
    tar xzf "${base_name}.tar.gz" --directory "${directory}"
    rm "${base_name}.tar.gz"
}
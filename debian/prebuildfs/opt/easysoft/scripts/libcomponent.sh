#!/bin/bash
#
# Library for managing Easysoft components
# shellcheck disable=SC1091

set -xe

. /opt/easysoft/scripts/envs

if [ "$BUILD_ENV" == "internal" ];then
    DOWNLOAD_URL="https://nexus.qc.oop.cc/repository/easycorp-library/runtime"
else
    DOWNLOAD_URL="https://pkg.qucheng.com/files/runtime"
fi

ZENTAO_URL=${ZENTAO_URL:-https://dl.cnezsoft.com/zentao}
PKG_URL_FORMATTER=${PKG_URL_FORMATTER:-}
ZDOO_URL="https://www.zdoo.com/dl/zdoo"


# Functions
######################################
# Generate the zentaopms download url
# Globals:
#   PKG_URL_FORMATTER
#   PHP_CLASSIFIER
# Arguments:
#   $1 - software's name
#   $2 - software's version
# Returns:
#   string
######################################
gen_zentao_download_url() {
    timestamp="$(date +%s)"
    local name="${1:?software name is required}"
    local version="${2:?version is required}"
    local zentao_base_name="ZenTaoPMS-${version}-${PHP_CLASSIFIER}.zip?$timestamp"

    if [[ $version =~ \.k8s ]];then
        zentao_base_name="ZenTaoPMS-${version/.k8s}-k8s.${PHP_CLASSIFIER}.zip?$timestamp"
    fi

    local download_url=""
    if [ -n "$PKG_URL_FORMATTER" ];then
        # 内网下载地址
        
        # 根据版本号，得到下载子目录名称
        local subdir
        case $version in
        biz*)
            subdir=bizPack
        ;;
        max*)
            subdir=maxPack
        ;;
        ipd*)
            subdir=ipdPack
            ;;
        *)
            subdir=pmsPack
        ;;
        esac

        download_url=$(printf "$PKG_URL_FORMATTER" $subdir "ZenTaoPMS" "${version/.k8s}" "$zentao_base_name")
    else
        # 外网下载地址
        # 兼容18.6之前的文件名
        testPkg=$(curl -s -I -w %{http_code} -o /dev/null "${ZENTAO_URL}"/"${version/.k8s}"/"${zentao_base_name}")
        if [ "$testPkg" == "404" ];then
            zentao_base_name=${zentao_base_name//-/.}
        fi

        download_url=${ZENTAO_URL}/${version/.k8s}/${zentao_base_name}
    fi
    
    echo "$download_url"
}


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
    local name="${1:?software name is required}"
    local version="${2:?version is required}"
    local zdoo_base_name="zdoo.${version}.php7.2.zip"
    local directory="/apps/"

    zentao_download_url=$(gen_zentao_download_url "$name" "$version")

    echo "Downloading $name:$version package"
    case $name in 
    "zentao")
            wget --no-check-certificate --quiet --output-document=/tmp/"${1}" "$zentao_download_url"
            unzip -qq -d ${directory} /tmp/"${1}" \
            && mv /apps/zentaopms /apps/zentao \
            && rm -rf /apps/zentao/www/data \
            && chown nobody.nogroup /apps/zentao -R
            rm /tmp/"${1}"
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

# uppack 
unpack() {
    local name="${1:?name is required}"
    local version="${2:?version is required}"
    local base_name="${name}-${version}-${OS_NAME}-${OS_ARCH}"
    local package_sha256=""
    local directory=${3:-"/"}

    if [ "$BUILD_ENV" == "internal" ];then
        URL_PATH="${name}/${version}"
    else
        URL_PATH=""
    fi

    echo "Downloading $base_name package"

    curl -skL "${DOWNLOAD_URL}/${URL_PATH}/${base_name}.tar.gz" -o "$base_name".tar.gz

    echo "Verifying package integrity"
    curl -skL "${DOWNLOAD_URL}/${URL_PATH}/${base_name}.tar.gz.sha1" -o "$base_name".tar.gz.sha1
    echo "$(awk '{print $1}' "$base_name".tar.gz.sha1)  ${base_name}.tar.gz" | sha1sum -c - || exit "$?"

    tar xzf "${base_name}.tar.gz" -C "$directory"
    rm "${base_name}.tar.gz" "${base_name}.tar.gz.sha1" -f
}
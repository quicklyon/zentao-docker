#!/bin/bash

# Build the project
# This script is used to build the project

appName=${1:? "appName is required"}
appVer=${2:? "appVer is required"}
phpVer=${3:? "phpVer is required"}
mysqlVer=${4:? "mysqlVer is required"}
arch=${5:? "arch is required"}
dockerfile=${6:? "dockerfile is required"}
buildDate=$(date +%Y%m%d)

if [ "$arch" == "all" ];then
    arch="linux/amd64,linux/arm64"
fi

docker buildx build \
	    --no-cache \
            --build-arg ZENTAO_VER="$appVer" \
            --build-arg PHP_VER="$phpVer" \
            --build-arg MYSQL_VER="$mysqlVer" \
            --build-arg MIRROR="true" \
            --build-arg OS_ARCH="$arch" \
            --platform=linux/"$arch" \
            -t "$appName":"$appVer"-"$buildDate" \
            -t "$appName":"$appVer" \
            -f "$dockerfile" . --push

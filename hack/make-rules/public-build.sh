#!/bin/bash
set -e

appName=${1:? "appName is required"}
appVer=${2:? "appVer is required"}
phpVer=${3:? "phpVer is required"}
mysqlVer=${4:? "mysqlVer is required"}
arch=${5:-"linux/amd64,linux/arm64"} # like linux/amd64,linux/arm64
dockerfile=${6:-Dockerfile}
buildEnv=${7:-internal}
buildDate=$(date +%Y%m%d)


publicRepository="hub.zentao.net/app/$appName"
baseImage="hub.zentao.net/ci/zentao-runtime:php${phpVer%.*}-mysql${mysqlVer%.*}"

if [[ $appVer =~ ^[0-9]+.[0-9]+ ]];then
    docker buildx build \
                --build-arg BASE_IMAGE="$baseImage" \
                --build-arg ZENTAO_VER="$appVer" \
                --build-arg ZENTAO_URL="$ZENTAO_URL" \
                --build-arg PHP_VER="$phpVer" \
                --build-arg MYSQL_VER="$mysqlVer" \
                --build-arg BUILD_ENV="$buildEnv" \
                --platform="$arch" \
                -t $publicRepository:$appVer-$buildDate \
                -t $publicRepository:$appVer \
                -t $publicRepository \
                -f "$dockerfile" . --pull --push
else

    docker buildx build \
                --build-arg BASE_IMAGE="$baseImage" \
                --build-arg ZENTAO_VER="$appVer" \
                --build-arg ZENTAO_URL="$ZENTAO_URL" \
                --build-arg PHP_VER="$phpVer" \
                --build-arg MYSQL_VER="$mysqlVer" \
                --build-arg BUILD_ENV="$buildEnv" \
                --platform="$arch" \
                -t $publicRepository:$appVer-$buildDate \
                -t $publicRepository:$appVer \
                -f "$dockerfile" . --pull --push
fi
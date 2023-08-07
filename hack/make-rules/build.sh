#!/bin/bash

appName=${1:? "appName is required"}
appVer=${2:? "appVer is required"}
phpVer=${3:? "phpVer is required"}
mysqlVer=${4:? "mysqlVer is required"}
arch=${5:? "arch is required"} # like linux/amd64,linux/arm64
dockerfile=${6:? "dockerfile is required"}
buildEnv=${7:? "buildEnv is required"}
buildDate=$(date +%Y%m%d)

internalRepository="${INTERNAL_IMAGE_REPO}/$appName"
publicRepository="${PUBLIC_IMAGE_REPO}/$appName"

local extraTagFlags=""
if [ "$BUILD_PUBLIC_IMAGE" = "true" ];then
  #extraTagFlags="-t ${publicRepository}/$appVer-$buildDate -t ${publicRepository}/$appVer"
  extraTagFlags="-t ${publicRepository}/$appVer-$buildDate"
fi

docker buildx build \
            --build-arg ZENTAO_VER="$appVer" \
            --build-arg ZENTAO_URL="$ZENTAO_URL" \
            --build-arg PHP_VER="$phpVer" \
            --build-arg MYSQL_VER="$mysqlVer" \
            --build-arg BUILD_ENV="$buildEnv" \
            --platform="$arch" \
            -t $internalRepository:$appVer-$buildDate \
            -t $internalRepository:$appVer \
            $extraTagFlags \
            -f "$dockerfile" . --push

. hack/make-rules/gen_report.sh
addInternalImage $internalRepository:$appVer-$buildDate
addInternalImage $internalRepository:$appVer

if [ "$BUILD_PUBLIC_IMAGE" = "true" ];then
  addPublicImage ${publicRepository}/$appVer-$buildDate
  #addPublicImage ${publicRepository}/$appVer
fi

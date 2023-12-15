#!/bin/bash
set -e

appName=${1:? "appName is required"}
appVer=${2:? "appVer is required"}
phpVer=${3:? "phpVer is required"}
mysqlVer=${4:? "mysqlVer is required"}
arch=${5:? "arch is required"} # like linux/amd64,linux/arm64
dockerfile=${6:? "dockerfile is required"}
buildEnv=${7:-public}
manifestOutput=${8:-registry} # or local

buildDate=$(date +%Y%m%d)
buildCommitId=${GIT_COMMIT:-unknown}

baseImage="${PUBLIC_IMAGE_REPO}/ci/zentao-runtime:php${phpVer%.*}-mysql${mysqlVer%.*}"
internalRepoList=()
publicRepoList=()

genImageList() {
  internalRepository="${INTERNAL_IMAGE_REPO}/${INTERNAL_IMAGE_NAMESPACE}/$appName"
  publicRepository="${PUBLIC_IMAGE_REPO}/${PUBLIC_IMAGE_NAMESPACE}/$appName"

  internalRepoList+=("$internalRepository:$appVer-$buildDate")
  internalRepoList+=("$internalRepository:$appVer")

  if [ "$BUILD_PUBLIC_IMAGE" = "true" ];then
    publicRepoList+=("${publicRepository}:$appVer-$buildDate")
    publicRepoList+=("${publicRepository}:$appVer")
    
    if [[ "$appVer" =~ ^[0-9]+ ]];then
      publicRepoList+=("${publicRepository}:latest")
    fi
  fi
}

addTagsToReport() {
  . hack/make-rules/gen_report.sh

  for i in "${internalRepoList[@]}"
  do
    addInternalImage "$i"
  done

  for i in "${publicRepoList[@]}"
  do
    addPublicImage "$i"
  done

}

genBuildTagOpt() {
  buildTagFlags=""
  for i in "${internalRepoList[@]}" "${publicRepoList[@]}"
  do
    buildTagFlags="$buildTagFlags -t $i"
  done
  echo "$buildTagFlags"
}

doBuildx() {
  set -x
  docker buildx build \
              --build-arg BASE_IMAGE="$baseImage" \
              --build-arg ZENTAO_VER="$appVer" \
              --build-arg PKG_URL_FORMATTER="$PKG_URL_FORMATTER" \
              --build-arg PHP_VER="$phpVer" \
              --build-arg MYSQL_VER="$mysqlVer" \
              --build-arg BUILD_ENV="$buildEnv" \
              --build-arg BUILD_COMMIT_ID="$buildCommitId" \
              -f "$dockerfile" . --pull "$@"
  set +x
}

buildAndPush() {
  doBuildx --platform="$arch" --push --no-cache $(genBuildTagOpt)
}

buildLocal() {
  localImage=${1:?local image is required}
  doBuildx --platform="linux/amd64" --load --no-cache  -t "$localImage"
}

case $manifestOutput in
  "registry")
    genImageList
    buildAndPush
    addTagsToReport
  ;;
  "local")
    buildLocal "local/$appName:$appVer"
  ;;
  *)
    echo "unsupport storage"
  ;;
esac
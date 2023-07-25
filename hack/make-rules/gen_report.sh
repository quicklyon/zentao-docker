#!/bin/bash

#
# Library for markdown functions
# used in jenkins pipeline

genUniqueFile() {
  if [ "$CI" = "true" ];then
    echo "/tmp/zentao-image-${BUILD_NUMBER}.json"
  else
    echo "/tmp/zentao-image.json"
  fi
}

# json body
# {
#   "images": {
#     "internal": {
#       "pms": [],
#       "biz": [],
#       "max": []
#     },
#     "public": {
#       "pms": [],
#       "biz": [],
#       "max": []
#     }
#   }
# }
initSource() {
  echo '{"images": {"internal": {}, "public": {}}}' > $1
}

detectRelease() {
  case ${1:0:3} in
    biz)
      echo biz
    ;;
    max)
      echo max
    ;;
    *)
      echo pms
    ;;
  esac
}

addImageToJson() {
  listKey=".images.$1"
  image=$2

  filePath=`genUniqueFile`
  test -f $filePath || initSource $filePath

  jq "$listKey += [\"$image\"]" $filePath > ${filePath}.tmp
  mv ${filePath}.tmp $filePath
}

addImage() {
  zone=$1
  image=$2
  release=$(detectRelease ${image##*:})
  addImageToJson "${zone}.${release}" $image
}

addInternalImage() {
  addImage "internal" $1
}

addPublicImage() {
  addImage "public" $1
}

outputGroupedImages() {
  title=$1
  listKey=$2
  jsonSourceFile=$3
  count=$(jq -r "${listKey} | length " < $jsonSourceFile)
  if [ "$count" -gt 0 ];then
    echo "##### $title"
    for i in `jq -r "${listKey}[]" < $jsonSourceFile`
    do
      echo "* $i"
    done
  fi
}

outputMakdown() {
  jsonSourceFile=`genUniqueFile`

  if [ -n "$TAG_NAME" ];then
    echo "Build by Tag: ${TAG_NAME}"
    echo
  fi

  echo "### 生成镜像明细"
  echo "#### 内网镜像"
  echo

  outputGroupedImages "开源版" ".images.internal.pms" $jsonSourceFile
  outputGroupedImages "企业版" ".images.internal.biz" $jsonSourceFile
  outputGroupedImages "旗舰版" ".images.internal.max" $jsonSourceFile

  publicCount=$(jq -r ".images.public | length " < $jsonSourceFile)
  if [ "$publicCount" -gt 0 ];then
    echo "#### 公网镜像"
    echo
    outputGroupedImages "开源版" ".images.public.pms" $jsonSourceFile
    outputGroupedImages "企业版" ".images.public.biz" $jsonSourceFile
    outputGroupedImages "旗舰版" ".images.public.max" $jsonSourceFile
  fi
}

if [ $# -gt 0 ];then
  case $1 in
    init)
      initSource `genUniqueFile`
    ;;
    add)
      shift
      addImage $@
    ;;
    render)
      outputMakdown
    ;;
  esac
fi


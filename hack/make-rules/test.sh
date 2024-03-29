#!/bin/bash
set -e

appName=${1:? "appName is required"}
appVer=${2:? "appVer is required"}
rebuild=${3:-true}

targetImg="local/$appName:${appVer}"

setupEnv() {
    export GOSS_FILES_PATH=./test
    export GOSS_SLEEP=0
    export GOSS_WAIT_OPTS="-r 30s -s 1s > /dev/null"
    export GOSS_VARS=vars.yaml
    export GOSS_OTHER_YAML=public.yaml
}

buildTestImage() {
    "$(dirname "$0")/build.sh" "$appName" "$appVer" "$PHP_VER" "$MYSQL_VER" "linux/amd64" "Dockerfile" "internal" "local" 
}

cleanContainer() {
    ctnName=${1:?container name is required}
    cid=$(docker ps -a -q -f name="$ctnName")
    if [ -z "$cid" ];then
        return 0
    fi

    running=$(docker inspect "$ctnName" -f '{{.State.Running}}')
    if [ "$running" = "true" ];then
        docker kill "$ctnName" 2>/dev/null && echo "killed container $ctnName"
    fi

    docker rm "$ctnName" 2>/dev/null && echo "removed container $ctnName"
}

setupDependService() {
    cleanContainer redis && docker run -d --name redis redis
    cleanContainer mysql && docker run -d --name mysql -e MYSQL_ROOT_PASSWORD=pass4you mysql
}

testInternalMysql() {
    setupDependService
    dgoss run --link redis \
          -e MYSQL_INTERNAL=true \
          -e APP_WEB_ROOT=/pms \
          -e PHP_MAX_EXECUTION_TIME=60 \
          -e PHP_MAX_INPUT_VARS=2000 \
          -e PHP_MEMORY_LIMIT=256M \
          -e PHP_ERROR_LOG=/tmp/php.log \
          -e PHP_POST_MAX_SIZE=50M \
          -e PHP_UPLOAD_MAX_FILESIZE=50M \
          -e PHP_SESSION_TYPE=redis \
          -e PHP_SESSION_PATH=tcp://redis:6379 \
          -e PHP_EXT_MONGODB=true \
          -e PHP_EXT_XHPROF=true \
          -e PHP_EXT_XLSWRITER=true \
          -e PHP_EXT_YAML=true \
          "$targetImg"
}

testExternalMysql() {
    setupDependService
    dgoss run --link redis --link mysql \
          -e APP_WEB_ROOT=/pms \
          -e ZT_MYSQL_HOST=mysql \
          -e ZT_MYSQL_PORT=3306 \
          -e ZT_MYSQL_USER=root \
          -e ZT_MYSQL_PASSWORD=pass4you \
          -e ZT_MYSQL_DB=oss \
          -e PHP_MAX_EXECUTION_TIME=60 \
          -e PHP_MAX_INPUT_VARS=2000 \
          -e PHP_MEMORY_LIMIT=256M \
          -e PHP_ERROR_LOG=/tmp/php.log \
          -e PHP_POST_MAX_SIZE=50M \
          -e PHP_UPLOAD_MAX_FILESIZE=50M \
          -e PHP_SESSION_TYPE=redis \
          -e PHP_SESSION_PATH=tcp://redis:6379 \
          -e PHP_EXT_MONGODB=true \
          -e PHP_EXT_XHPROF=true \
          -e PHP_EXT_XLSWRITER=true \
          -e PHP_EXT_YAML=true \
          "$targetImg"
}

[ "$rebuild" = "true" ] && buildTestImage

setupEnv

echo "Check with internal mysql"
testInternalMysql

echo "Check with external mysql"
testExternalMysql

#!/bin/bash
# Copyright ZenTao, Inc.
# SPDX-License-Identifier: APACHE-2.0
# Info : 如果用户输入了PHP_EXT_开头的环境变量，判断是否正常启用了扩展

set -o errexit
set -o nounset
set -o pipefail

# 支持的扩展名列表
ext_lists="redis,xdebug,xhprof,yaml,mongodb"

env_vars=$(env | awk '/^PHP_EXT_/ {print}')

# 循环处理环境变量
# Ex: PHP_EXT_REDIS=true
# extensions: redis
for var in $env_vars; do
    # 获取环境变量名
    var_name=$(echo "$var" | cut -d'=' -f1)

    # 截取PHP_EXT_之后的部分作为扩展名，并转化为小写
    ext_name=${var_name#PHP_EXT_}
    ext_name=${ext_name,,}

    # 获取环境变量的值
    value=$(echo "$var" | cut -d'=' -f2)

    # 判断扩展名是否在支持的扩展名列表中
    if [[ "$ext_lists"  =~ $ext_name ]];then
        # 如果值为true，则进行特定处理
        if [ "${value,,}" == "true" ]; then
            php -m | grep "$ext_name" || exit 1
        fi
    fi
done

# 判断PHP SESSION类型是否为redis，需要判断是否启用了redis扩展
if [ "${PHP_SESSION_TYPE:-}" = "redis" ];then
    php -m | grep redis || exit 1
fi
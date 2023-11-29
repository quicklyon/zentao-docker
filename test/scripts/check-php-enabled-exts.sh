#!/bin/bash
# Copyright ZenTao, Inc.
# SPDX-License-Identifier: APACHE-2.0

set -o errexit
set -o nounset
set -o pipefail

env_vars=$(env | awk '/^PHP_EXT_/ {print}')

# 循环处理环境变量
for var in $env_vars; do
    # 获取环境变量名
    var_name=$(echo "$var" | cut -d'=' -f1)

    # 截取PHP_EXT_之后的部分作为扩展名，并转化为小写
    ext_name=${var_name#PHP_EXT_}
    ext_name=${ext_name,,}

    # 获取环境变量的值
    value=$(echo "$var" | cut -d'=' -f2)

    # 如果值为true，则进行特定处理
    if [ "${value,,}" == "true" ]; then
        php -m | grep "$ext_name" || exit 1
    fi
done

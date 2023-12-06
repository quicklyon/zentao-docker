#!/bin/bash
# Copyright ZenTao, Inc.
# SPDX-License-Identifier: APACHE-2.0
# Info : 根据环境变量，检查php.ini是否被修改

set -o errexit
set -o nounset
set -o pipefail

php_env_list="PHP_MAX_EXECUTION_TIME \
PHP_MAX_INPUT_VARS \
PHP_MEMORY_LIMIT \
PHP_ERROR_LOG \
PHP_POST_MAX_SIZE \
PHP_UPLOAD_MAX_FILESIZE \
PHP_SESSION_TYPE \
PHP_SESSION_PATH"

php_envs=$(env | awk '/^PHP_/ {print}'|grep -v PHP_EXT)

# 循环处理环境变量
# Ex: PHP_MAX_EXECUTION_TIME=30
# variable:max_execution_time
# value:30
for var in $php_envs; do
    # 获取环境变量名
    var_name=$(echo "$var" | cut -d'=' -f1)

    # 截取PHP_EXT_之后的部分作为扩展名，并转化为小写
    var_name=${var_name#PHP_}
    var_name=${var_name,,}

    # 获取环境变量的值
    value=$(echo "$var" | cut -d'=' -f2)

    # 判断扩展名是否在支持的扩展名列表中
    if [[ "${php_env_list,,}"  =~ $var_name ]];then

        case "$var_name" in
        "session_type")
            php_setting=$(php -r "echo ini_get(\"session.save_handler\");")
            ;;
        "session_path")
            php_setting=$(php -r "echo ini_get(\"session.save_path\");")
            ;;
        *)
            php_setting=$(php -r "echo ini_get(\"$var_name\");")
            ;;
        esac

        # 环境变量的值，与php的配置进行比较，如果不一致，则返回1
        if [ "$php_setting" != "$value" ];then
            exit 1
        fi
    fi
done

# 判断PHP SESSION类型是否为redis，需要判断是否启用了redis扩展
if [ "$PHP_SESSION_TYPE" = "redis" ];then
    php -m | grep redis || exit 1
fi
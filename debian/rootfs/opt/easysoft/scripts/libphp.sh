#!/bin/bash

function control_php_ext(){
    # 获取所有以PHP_EXT开头的环境变量
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
            # 启用扩展
            info "Enable php $ext_name extension."
            phpenmod "$ext_name"
        else
            # 禁用扩展
            info "Disable php $ext_name extension."
            phpdismod "$ext_name"
        fi
    done
}
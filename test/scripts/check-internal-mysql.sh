#!/bin/bash
# Copyright ZenTao, Inc.
# SPDX-License-Identifier: APACHE-2.0

set -o errexit
set -o nounset
set -o pipefail

# 启用内部数据库，并且没有指定外部数据库地址
if [ "$MYSQL_INTERNAL" == "true" ] && [ "$ZT_MYSQL_HOST" == "127.0.0.1" ];then

    # 检查是否设置了mysql启动脚本
    [ -L /etc/s6/s6-enable/00-mysql ] || exit 1
    
fi
#!/bin/bash
# Copyright ZenTao, Inc.
# SPDX-License-Identifier: APACHE-2.0

set -o errexit
set -o nounset
set -o pipefail

if [ "${APP_WEB_ROOT:-}" != "" ];then
    [[ $(grep -c "$APP_WEB_ROOT" /opt/zbox/etc/apache/httpd.conf ) -eq 2 ]] || exit 1
fi
#!/bin/bash
#
# Library for managing Easysoft components

# shellcheck disable=SC1090,SC1091,SC2155

# Load generic libraries
. /opt/easysoft/scripts/libquery.sh

[ -n "${DEBUG:+1}" ] && set -x

export LDAP_SQL="/apps/zentao/config/ldap.sql"

# Founction: Config LDAP
function Config_LDAP()
{
    # 无论是否开启LDAP，都要先清理ldap配置
    # 有可能上次开启，本次关闭
    info "Check LDAP config ..."
    Del_LDAP_Config

    # 如果开启LDAP，导入LDAP配置
    if [ "$LDAP_ENABLED" == "1" ] && [ "$(Check_Version)" == "ok" ] ;then

        info "Enable LDAP ..."
        /usr/bin/render-template ${LDAP_SQL}.tpl > $LDAP_SQL
        mysql_import_to_db "$MYSQL_DB" "$LDAP_SQL" | tee $CHECK_LOG
    fi
}



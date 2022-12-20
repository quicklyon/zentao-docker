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
    # 如果开启LDAP，导入LDAP配置
    if [ "$LDAP_ENABLED" == "1" ];then
        # 清理禅道ldap配置
        info "Check LDAP config ..."
        Del_LDAP_Config

        info "Enable LDAP ..."
        /usr/bin/render-template ${LDAP_SQL}.tpl > $LDAP_SQL
        mysql_import_to_db "$MYSQL_DB" "$LDAP_SQL" | tee $CHECK_LOG
    fi
}



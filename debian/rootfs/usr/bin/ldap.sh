#!/bin/bash

# shellcheck disable=SC1091

set -o nounset
set -o pipefail

[ -n "${DEBUG:+1}" ] && set -x

# Load libraries
. /opt/easysoft/scripts/liblog.sh
. /opt/easysoft/scripts/libmysql.sh

MYSQL_BIN="/usr/bin/mysql --host=$MYSQL_HOST --port=$MYSQL_PORT --user=$MYSQL_USER --password=$MYSQL_PASSWORD"

# Get table prefix 
TABLE_PREFIX=$(grep prefix /data/zentao/config/my.php  | cut -d '=' -f 2 | sed -E "s/( |'|;)//g")
export TABLE_PREFIX=${TABLE_PREFIX:-zt_}

# Render ldap sql file
LDAP_SQL="/apps/zentao/config/ldap.sql"
/usr/bin/render-template ${LDAP_SQL}.tpl > $LDAP_SQL

# Check LDAP setting.
CUR_LDAP_STATE=$( $MYSQL_BIN -e "select \`value\` from ${MYSQL_DB}.${TABLE_PREFIX}config where module='ldap' and \`key\`='turnon';" | sed 1d )

# 开启LDAP
if [ "$CUR_LDAP_STATE" == "" ] && [ "$LDAP_ENABLED" == "1" ];then
    info "Enable LDAP ..."
    mysql_import_to_db "$MYSQL_DB" "$LDAP_SQL"
fi

# 关闭LDAP
if [ "$LDAP_ENABLED" == "0" ];then
    $MYSQL_BIN -e "DELETE from ${MYSQL_DB}.${TABLE_PREFIX}config where owner='system' and module='ldap';"
fi

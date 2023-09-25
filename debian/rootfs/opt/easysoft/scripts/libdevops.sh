#!/bin/bash
#
# Library for managing Easysoft components

# shellcheck disable=SC1090,SC1091,SC2155

# Load generic libraries
. /opt/easysoft/scripts/libquery.sh

[ -n "${DEBUG:+1}" ] && set -x

export InitDB_SQL="/apps/zentao/db/zentao.sql"

########################
# Init_Quickon : 初始化DevOps平台数据库
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#########################
function Init_Quickon_DevOps(){
  info "Init Quickon DevOps config ..."
  if [ ! -f "/data/zentao/.devops" ]; then
    mysql_import_to_db "$ZT_MYSQL_DB" "$InitDB_SQL" | tee $CHECK_LOG && touch /data/zentao/.devops
  fi
}

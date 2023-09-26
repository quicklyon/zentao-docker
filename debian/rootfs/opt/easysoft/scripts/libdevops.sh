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
  if [ ! -f "/data/zentao/.devops" ]; then
    info "Init Quickon DevOps config ..."
    # TODO 没有admin或者super权限
    valid_mysql_user_admin_role
    /opt/zbox/bin/php /usr/bin/initdevops.php && (
      touch /data/zentao/.devops
      info "Init Quickon DevOps Done"
    ) || error "Init Quickon DevOps Failed"
  fi
}

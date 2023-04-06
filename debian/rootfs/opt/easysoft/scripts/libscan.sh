#!/bin/bash
#
# Library for managing Easysoft components

# shellcheck disable=SC1090,SC1091,SC2155

# Load generic libraries
. /opt/easysoft/scripts/libquery.sh

[ -n "${DEBUG:+1}" ] && set -x

# Functions
########################
# Link SCAN service
# Globals:
#   None
# Arguments:
#   $1: Table prefix (default: zt_)
# Returns:
#   None
#########################
Config_SCAN(){

    # 版本较低，不支持配置
    [ "$(Check_Version)" == "error" ] && return 0

    # 检查禅道是否已经有配置
    if [ "$(Get_SCAN_Config)" == "1" ];then
        log "Zentao SCAN service is configured."
    else
        # 等待SCAN服务就绪
        Wait_For_SCAN
        warn "Zentao SCAN config not found,rebuild the configuration."
        # 清理残余配置
        Clean_SCAN_Config
        # 导入配置
        Import_SCAN_Config
    fi
}

########################
# Import_SCAN_Config : 导入扫描工具配置
# Globals:
#   MYSQL_DB
#   SCAN_SQL_FILE
# Arguments:
#   dbsql file
# Returns:
#   None
#########################
Import_SCAN_Config(){

    export SCAN_PASSWORD_ENCODE=$(echo $SCAN_PASSWORD | base64)
    export SCAN_TOKEN_ENCODE=$(echo $SCAN_USERNAME:$SCAN_PASSWORD | base64)
    # 生成sql语句
    /usr/bin/render-template ${SCAN_SQL_FILE}.tpl > ${SCAN_SQL_FILE}

    # 导入SQL
    info "Link and configure scan Service ..."
    mysql_import_to_db "$MYSQL_DB" "$SCAN_SQL_FILE" | tee $CHECK_LOG
}


########################
# Wait_For_SCAN : 等待SCAN服务就绪
# Globals:
#   WAIT_SCAN_TIME
#   SCAN_PROTOCOL
#   SCAN_URL
# Arguments:
#   dbsql file
# Returns:
#   None
#########################
Wait_For_SCAN(){
    local retries=${WAIT_SCAN_TIME:-600}

    info "Check whether the scan service is available."

    for ((i = 1; i <= retries; i += 1)); do
        if curl -skL "$SCAN_URL" > /dev/null 2>&1;
        then
            info "ci is ready."
            break
        fi

        warn "Waiting scan $i seconds"
        sleep 1

        if [ "$i" == "$retries" ]; then
            error "Unable to connect to scan: $SCAN_URL"
            return 1
        fi
    done
    return 0
}

Clean_SCAN_Config(){

    # 版本较低，不支持配置
    [ "$(Check_Version)" == "error" ] && return 0

    # 删除禅道数据库中的SCAN信息
    Del_SCAN_Config
}

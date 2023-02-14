#!/bin/bash
#
# Library for managing Easysoft components

# shellcheck disable=SC1090,SC1091,SC2155

# Load generic libraries
. /opt/easysoft/scripts/libquery.sh

[ -n "${DEBUG:+1}" ] && set -x

# Functions
########################
# Link CI service
# Globals:
#   CI_USERNAME
#   CI_PASSWORD
#   CI_PROTOCOL
#   CI_URL
#   CI_SQL_FILE
# Arguments:
#   $1: Table prefix (default: zt_)
# Returns:
#   None
#########################
Config_CI(){

    # 版本较低，不支持配置
    [ "$(Check_Version)" == "error" ] && return 0

    # 检查禅道是否已经有配置
    if [ "$(Get_CI_Config)" == "1" ];then
        log "Zentao CI service is configured."
    else
        # 等待CI服务就绪
        Wait_For_CI
        warn "Zentao CI config not found,rebuild the configuration."
        # 清理残余配置
        Clean_CI_Config
        # 创建Token
        Create_CI_Token
        # 导入配置
        Import_CI_Config
    fi
}


########################
# Create_CI_Token : 创建CI服务Token
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#########################
Create_CI_Token(){
    # TODO 支持其它CI
    CI_TOKEN=$(/usr/bin/jt | grep token| awk '{print $NF}')

    # 创建Token失败
    if [ "$CI_TOKEN" == "" ] ;then
        error "Create jenkins token error."
        exit 1
    fi

    export CI_TOKEN
    echo "$CI_TOKEN" > /data/zentao/.jenkins_token
}


########################
# Import_CI_Config : 导入CI配置
# Globals:
#   MYSQL_DB
#   CI_SQL_FILE
# Arguments:
#   dbsql file
# Returns:
#   None
#########################
Import_CI_Config(){

    # 生成sql语句
    /usr/bin/render-template ${CI_SQL_FILE}.tpl > ${CI_SQL_FILE}

    # 导入SQL
    info "Link and configure ci Service ..."
    mysql_import_to_db "$MYSQL_DB" "$CI_SQL_FILE" | tee $CHECK_LOG
}


########################
# Wait_For_CI : 等待CI服务就绪
# Globals:
#   WAIT_CI_TIME
#   CI_USERNAME
#   CI_PASSWORD
#   CI_PROTOCOL
#   CI_URL
#   CI_SQL_FILE
# Arguments:
#   dbsql file
# Returns:
#   None
#########################
Wait_For_CI(){
    local retries=${WAIT_CI_TIME:-600}

    info "Check whether the ci service is available."

    for ((i = 1; i <= retries; i += 1)); do
        if curl -skL "${CI_PROTOCOL:-http}://$CI_URL" > /dev/null 2>&1;
        then
            info "ci is ready."
            break
        fi

        warn "Waiting ci $i seconds"
        sleep 1

        if [ "$i" == "$retries" ]; then
            error "Unable to connect to ci: $CI_PROTOCOL://$CI_URL"
            return 1
        fi
    done
    return 0
}

Clean_CI_Config(){

    # 版本较低，不支持配置
    [ "$(Check_Version)" == "error" ] && return 0

    # 删除禅道数据库中的CI信息
    Del_CI_Config

}

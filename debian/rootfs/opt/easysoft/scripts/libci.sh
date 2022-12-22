#!/bin/bash
#
# Library for managing Easysoft components

# shellcheck disable=SC1090,SC1091,SC2155

# Load generic libraries
. /opt/easysoft/scripts/libquery.sh

[ -n "${DEBUG:+1}" ] && set -x

# Functions
########################
# Link Jenkins service
# Globals:
#   JENKINS_USERNAME
#   JENKINS_PASSWORD
#   JENKINS_PROTOCOL
#   JENKINS_URL
#   JENKINS_SQL_FILE
# Arguments:
#   $1: Table prefix (default: zt_)
# Returns:
#   None
#########################
Config_Jenkins(){

    # 版本较低，不支持配置
    [ "$(Check_Version)" == "error" ] && return 0

    # 检查禅道是否已经有配置
    if [ "$(Get_Jenkins_Config)" == "1" ];then
        log "Zentao Jenkins service is configured."
    else
        # 等待Jenkins服务就绪
        Wait_For_Jenkins
        warn "Zentao Jenkins config not found,rebuild the configuration."
        # 清理残余配置
        Clean_Jenkins_Config
        # 创建Token
        Create_Jenkins_Token
        # 导入配置
        Import_Jenkins_Config
    fi
}


########################
# Create_Jenkins_Token : 创建Jenkins服务Token
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#########################
Create_Jenkins_Token(){

    JENKINS_TOKEN=$(/usr/bin/jt | grep token| awk '{print $NF}')

    # 创建Token失败
    if [ "$JENKINS_TOKEN" == "" ] ;then
        error "Create jenkins token error."
        exit 1
    fi

    export JENKINS_TOKEN
    echo "$JENKINS_TOKEN" > /data/zentao/.jenkins_token
}


########################
# Import_Jenkins_Config : 导入Jenkins配置
# Globals:
#   MYSQL_DB
#   JENKINS_SQL_FILE
# Arguments:
#   dbsql file
# Returns:
#   None
#########################
Import_Jenkins_Config(){

    # 生成sql语句
    /usr/bin/render-template ${JENKINS_SQL_FILE}.tpl > ${JENKINS_SQL_FILE}

    # 导入SQL
    info "Link and configure jenkins Service ..."
    mysql_import_to_db "$MYSQL_DB" "$JENKINS_SQL_FILE" | tee $CHECK_LOG
}


########################
# Wait_For_Jenkins : 等待Jenkins服务就绪
# Globals:
#   WAIT_JENKINS_TIME
#   JENKINS_USERNAME
#   JENKINS_PASSWORD
#   JENKINS_PROTOCOL
#   JENKINS_URL
#   JENKINS_SQL_FILE
# Arguments:
#   dbsql file
# Returns:
#   None
#########################
Wait_For_Jenkins(){
    local retries=${WAIT_JENKINS_TIME:-600}

    info "Check whether the jenkins service is available."

    for ((i = 1; i <= retries; i += 1)); do
        if curl -skL "${JENKINS_PROTOCOL:-http}://$JENKINS_URL" > /dev/null 2>&1;
        then
            info "jenkins is ready."
            break
        fi

        warn "Waiting jenkins $i seconds"
        sleep 1

        if [ "$i" == "$retries" ]; then
            error "Unable to connect to jenkins: $JENKINS_PROTOCOL://$JENKINS_URL"
            return 1
        fi
    done
    return 0
}

Clean_Jenkins_Config(){

    # 版本较低，不支持配置
    [ "$(Check_Version)" == "error" ] && return 0

    # 删除禅道数据库中的Jenkins信息
    Del_Jenkins_Config

}

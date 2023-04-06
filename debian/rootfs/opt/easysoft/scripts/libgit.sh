#!/bin/bash
#
# Library for managing Easysoft components

# shellcheck disable=SC1090,SC1091,SC2155

# Load generic libraries
. /opt/easysoft/scripts/libquery.sh

[ -n "${DEBUG:+1}" ] && set -x

# Functions
########################
# Link Git service
# Globals:
#   GIT_TYPE
#   GIT_INSTANCE_NAME
#   GIT_USERNAME
#   GIT_PASSWORD
#   GIT_PROTOCOL
#   GIT_DOMAIN
#   GIT_SQL_FILE
# Arguments:
#   $1: Table prefix (default: zt_)
# Returns:
#   None
#########################
Config_Git(){

    # 版本较低，不支持配置
    [ "$(Check_Version)" == "error" ] && return 0

    # 等待Git服务就绪
    Wait_For_Git

    # 检查Git是否已经配置
    if [ "$(Get_Git_Config)" == "1" ];then
        log "Zentao Git service is configured."
    else
        if [ -f /data/zentao/.git_token ];then
            # 读取之前生成的Token
            GIT_TOKEN=$(cat /data/zentao/.git_token)
            export GIT_TOKEN
        else
            # 创建Git服务Token
            Create_Git_Token
        fi
        # 导入Git配置
        Import_Git_Config
    fi
    # 没有创建过Token
#     if [ "$(/usr/bin/git_token list)" == "" ];then

#         # 创建Token
#         Create_Git_Token

#         # 导入Git配置
#         Import_Git_Config

#     else
#         # 禅道没有成功导入Token
#         if [ -f /data/zentao/.git_token ];then

#             # 读取之前生成的Token
#             GIT_TOKEN=$(cat /data/zentao/.git_token)
#             export GIT_TOKEN

#             # 导入Git配置
#             Import_Git_Config

#         else
#             # 检查禅道是否已经有配置
#             if [ "$(Get_Git_Config)" == "1" ];then
#                 log "Zentao Git service is configured."
#             else
#                 warn "Zentao Git config was deleted,rebuild the configuration."

#                 # 清理残余配置
#                 Clean_Git_Config

#                 # 创建Token
#                 Create_Git_Token

#                 # 导入Git配置
#                 Import_Git_Config
#             fi
#         fi
#     fi
}


########################
# Create_Git_Token : 创建Git服务Token
# Globals:
#   GIT_TYPE
# Arguments:
#   None
# Returns:
#   None
#########################
Create_Git_Token(){
    if [ "$GIT_TOKEN" == "" ] ;then
        GIT_TOKEN=$(/usr/bin/git_token create)
        # 创建Token失败
        if [ "$GIT_TOKEN" == "null" ] ;then
            error "Create ${GIT_TYPE} token error."
            exit 1
        fi
    fi
    export GIT_TOKEN
    echo "$GIT_TOKEN" > /data/zentao/.git_token
}


########################
# Import_Git_Config : 导入Git配置
# Globals:
#   MYSQL_DB
#   GIT_TYPE
#   GIT_SQL_FILE
# Arguments:
#   dbsql file
# Returns:
#   None
#########################
Import_Git_Config(){

    # 生成sql语句
    /usr/bin/render-template ${GIT_SQL_FILE}.tpl > ${GIT_SQL_FILE}

    # 导入SQL
    info "Link and configure Git Service ..."
    mysql_import_to_db "$MYSQL_DB" "$GIT_SQL_FILE" | tee $CHECK_LOG && rm -rf /data/zentao/.git_token
}


########################
# Wait_For_Git : 等待Git服务就绪
# Globals:
#   WAIT_GIT_TIME
#   GIT_TYPE
#   GIT_USERNAME
#   GIT_PASSWORD
#   GIT_PROTOCOL
#   GIT_DOMAIN
# Arguments:
#   dbsql file
# Returns:
#   None
#########################
Wait_For_Git(){
    local retries=${WAIT_GIT_TIME:-300}

    info "Check whether the $GIT_TYPE service is available."

    for ((i = 1; i <= retries; i += 1)); do
        if curl -skL "$GIT_DOMAIN" > /dev/null 2>&1;
        then
            info "$GIT_TYPE is ready."
            break
        fi

        warn "Waiting $GIT_TYPE $i seconds"
        sleep 1

        if [ "$i" == "$retries" ]; then
            error "Unable to connect to $GIT_TYPE: $GIT_DOMAIN"
            return 1
        fi
    done
    return 0
}

Clean_Git_Config(){

    # 版本较低，不支持配置
    [ "$(Check_Version)" == "error" ] && return 0

    # 删除Git token
    /usr/bin/git_token delete

    # 删除禅道数据库中的Git信息
    Del_Git_Config

}

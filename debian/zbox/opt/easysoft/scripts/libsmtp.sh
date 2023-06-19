#!/bin/bash
#
# Library for managing Easysoft components

# shellcheck disable=SC1090,SC1091,SC2155

# Load generic libraries
. /opt/easysoft/scripts/libquery.sh

[ -n "${DEBUG:+1}" ] && set -x

export SMTP_SQL="/apps/zentao/config/smtp.sql"


# Founction: Config SMTP
function Config_SMTP()
{
    # 如果开启 SMTP，导入SMTP配置
    if [ "$SMTP_ENABLED" == "1" ] && [ "$(Check_Version)" == "ok" ] ;then
        /usr/bin/render-template ${SMTP_SQL}.tpl > $SMTP_SQL

        # 判断并设置发件人
        SENDER=$(Get_SMTP_Sender)

        if [ "$SENDER" == "" ];then
            Set_SMTP_Sender
        fi

        # 清理禅道 SMTP 配置
        info "Check SMTP config ..."
        Del_SMTP_Config

        info "Enable SMTP ..."
        mysql_import_to_db "$MYSQL_DB" "$SMTP_SQL" | tee $CHECK_LOG
    fi

}
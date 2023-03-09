#!/bin/bash
#
# Library for managing Easysoft components

# shellcheck disable=SC1090,SC1091,SC2155

# Load generic libraries
. /opt/easysoft/scripts/libmysql.sh

[ -n "${DEBUG:+1}" ] && set -x

MYSQL_BIN="/usr/bin/mysql --host=$MYSQL_HOST --port=$MYSQL_PORT --user=$MYSQL_USER --password=$MYSQL_PASSWORD -D$MYSQL_DB"
export MYSQL_BIN

# 获取当前运行的版本
Get_Running_Ver(){
    $MYSQL_BIN -e "select value from \`${TABLE_PREFIX}config\` where  \`section\`='global' and \`key\`='version';" 2>/dev/null | sed 1d
}

# 获取禅道Git配置
Get_Git_Config(){
    $MYSQL_BIN -e "select count(1) from ${TABLE_PREFIX}pipeline \
    where \`type\`=\"${GIT_TYPE}\" \
    and \`name\`=\"${GIT_INSTANCE_NAME}\" \
    and \`deleted\`=0;" | sed 1d
}

# 获取禅道CI配置
Get_CI_Config(){
    $MYSQL_BIN -e "select count(1) from ${TABLE_PREFIX}pipeline \
    where \`type\`=\"${CI_TYPE}\" \
    and \`name\`=\"quickon-${CI_TYPE}\" \
    and \`deleted\`=0;" | sed 1d
}

# 删除禅道数据库中的Git信息
Del_Git_Config(){
    $MYSQL_BIN -e "delete from ${TABLE_PREFIX}pipeline where \`id\`=999;"
}

# 删除禅道数据库中的CI信息
Del_CI_Config(){
    $MYSQL_BIN -e "delete from ${TABLE_PREFIX}pipeline where \`name\`=\"quickon-${CI_TYPE}\";"
}

# 删除禅道数据库中的SCAN信息
Del_SCAN_Config(){
    $MYSQL_BIN -e "delete from ${TABLE_PREFIX}pipeline where \`name\`=\"quickon-${SCAN_TYPE}\";"
}

# 获取SMTP发件人信息
Get_SMTP_Sender(){
    $MYSQL_BIN -e "select * from ${TABLE_PREFIX}config where \`key\`='fromName';"
}

# 设置SMTP发件人信息
Set_SMTP_Sender(){
    $MYSQL_BIN --default-character-set=utf8 \
                -e "REPLACE INTO ${TABLE_PREFIX}config \
                   (\`vision\`,\`owner\`,\`module\`,\`section\`,\`key\`,\`value\`) \
                   VALUES ('','system','mail','','fromName',\"${SMTP_FROMNAME}\");"
}

# 删除SMTP配置信息
Del_SMTP_Config(){
    $MYSQL_BIN -e "DELETE from ${TABLE_PREFIX}config where owner='system' and module='mail' and \`key\`<>'fromName';"
}

# 删除LDAP配置
Del_LDAP_Config(){
    $MYSQL_BIN -e "DELETE from ${TABLE_PREFIX}config where owner='system' and module='ldap';"
}

Check_Version(){

    if [ "$CURRENT_VER" == "biz4.1.3" ] || [ "$CURRENT_VER" == "12.5.3" ];then
        echo "error"
    else
        echo "ok"
    fi
}

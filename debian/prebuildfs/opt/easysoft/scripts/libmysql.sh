#!/bin/bash
#
# Easysoft mysql server handler library

# shellcheck disable=SC1090,SC1091

# Load generic libraries
. /opt/easysoft/scripts/liblog.sh
. /opt/easysoft/scripts/libos.sh

[ -n "${DEBUG:+1}" ] && set -x

########################
# Check and waiting MySQL to be ready. 
# Globals:
#   MAXWAIT
#   ZT_MYSQL_HOST
#   ZT_MYSQL_PORT
# Arguments:
#   $1 - mysql service host
#   $2 - mysql service port
# Returns:
#   0 if the mysql server is can be connected, 1 otherwise
#########################
wait_for_mysql() {
    local retries=${MAXWAIT:-30}
    local mysql_host="${1:-$ZT_MYSQL_HOST}"
    local mysql_port="${2:-$ZT_MYSQL_PORT}"
    info "Check whether the MySQL is available."

    for ((i = 1; i <= retries; i += 1)); do
        sleep 1
        if nc -z "${mysql_host}" "${mysql_port}";
        then
            info "MySQL is ready."
            break
        fi

        warn "Waiting MySQL $i seconds"

        if [ "$i" == "$retries" ]; then
            error "Unable to connect to MySQL: $mysql_host:$mysql_port"
            return 1
        fi
    done
    return 0
}

########################
# Initialize app database.
# Globals:
#   ZT_MYSQL_HOST
#   ZT_MYSQL_PORT
#   ZT_MYSQL_USER
#   ZT_MYSQL_PASSWORD
#   ZT_MYSQL_DB
# Arguments:
#   $1 - mysql service host
#   $2 - mysql service port
#   $3 - app database name
# Returns:
#   0 if the database create succeed,1 otherwise
#########################
mysql_init_db() {
    local init_db=${1:-ZT_MYSQL_DB}
    local -a args=("--host=$ZT_MYSQL_HOST" "--port=$ZT_MYSQL_PORT" "--user=$ZT_MYSQL_USER" "--password=$ZT_MYSQL_PASSWORD")
    local command="/usr/bin/mysql"

    args+=("--execute=CREATE DATABASE IF NOT EXISTS $init_db;")

    info "Check $EASYSOFT_APP_NAME database."
    debug_execute "$command" "${args[@]}" || return 1
}

mysql_reset_password(){
    local -a args=("--host=$ZT_MYSQL_HOST" "--port=$ZT_MYSQL_PORT" "-p123456" "--user=root" "-S /data/mysql/tmp/mysql.sock")
    local command="/usr/bin/mysql"

    args+=("--execute=CREATE USER '$ZT_MYSQL_USER'@'%' IDENTIFIED BY '$ZT_MYSQL_PASSWORD';GRANT ALL ON *.* TO '$ZT_MYSQL_USER'@'%';flush privileges;")

    if [ $(mysql_check_user) == "0" ];then
        info "Check $EASYSOFT_APP_NAME database."
        debug_execute "$command" "${args[@]}" || return 1 
    fi
}

mysql_check_user(){
    local -a args=("--host=$ZT_MYSQL_HOST" "--port=$ZT_MYSQL_PORT" "-p123456" "--user=root" "-S /data/mysql/tmp/mysql.sock" "-sN")
    local command="/usr/bin/mysql"

    args+=("--execute=select count(1) from mysql.user where User='$ZT_MYSQL_USER' and Host='%';")

    info "Check zentao mysql $ZT_MYSQL_HOST user."
    "$command" "${args[@]}"
}

########################
# Import to mysql from mysql dump file
# Globals:
#   ZT_MYSQL_HOST
#   ZT_MYSQL_PORT
#   ZT_MYSQL_USER
#   ZT_MYSQL_PASSWORD
#   ZT_MYSQL_DB
# Arguments:
#   $1 - app database name
#   $2 - mysql dump file(*.sql)
# Returns:
#   0 if import succeed,1 otherwise
#########################
mysql_import_to_db() {
    local db_name=${1:?missing db name}
    local sql_file=${2:?missing db init file}
    local -a args=("--host=$ZT_MYSQL_HOST" "--port=$ZT_MYSQL_PORT" "--user=$ZT_MYSQL_USER" "--password=$ZT_MYSQL_PASSWORD" "$db_name")
    local command="/usr/bin/mysql"

    if [ -f "$sql_file" ] ;then
        info "Import $sql_file to ${db_name}."
        debug_execute "$command" "${args[@]}" < "$sql_file" || return 1
    else
        error "The specified import file: $sql_file does not exist"
        return 1
    fi
}

#########################
# 校验用户权限是否为super/admin
# Globals:
#########################
valid_mysql_user_admin_role() {
    local retries=${MAXWAIT:-30}
    local -a args=("--host=$ZT_MYSQL_HOST" "--port=$ZT_MYSQL_PORT" "-p$ZT_MYSQL_PASSWORD" "--user=$ZT_MYSQL_USER")
    local command="/usr/bin/mysql"

    args+=("--execute=SHOW GRANTS FOR CURRENT_USER;")

    info "Valid MySQL User admin role"

    for ((i = 1; i <= retries; i += 1)); do
        sleep 1
        "$command" "${args[@]}" | grep -E "(SUPER|SYSTEM_VARIABLES_ADMIN)"
        if [ $? -eq 0 ];
        then
            info "MySQL User Admin Role is ready."
            break
        fi

        warn "Waiting valid MySQL $i seconds"

        if [ "$i" == "$retries" ]; then
            error "Failed to valid MySQL user admin role: $ZT_MYSQL_USER"
            return 1
        fi
    done
    return 0
}



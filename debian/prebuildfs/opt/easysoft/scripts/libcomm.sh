#!/bin/bash

########################
# Check and waiting service to be ready. 
# Globals:
#   MAXWAIT
# Arguments:
#   $1 - Service name
#   $2 - Service host
#   $3 - Service port
#   S4 - Prefix information
# Returns:
#   0 if the service is can be connected, 1 otherwise
#########################
wait_for_service() {
    local retries=${MAXWAIT:-5}
    local service_name="${1^}"
    local svc_host="${2:-localhost}"
    local svc_port="${3:-80}"
    local prefix_info=${4^}

    info "Check whether the $service_name is available."

    for ((i = 0; i <= retries; i += 1)); do
        # 重试5次，每次间隔2的i次方秒
        secs=$((2 ** i))
        sleep $secs
        if nc -z "${svc_host}" "${svc_port}";
        then
            info "$prefix_info: $service_name is ready."
            break
        fi

        warn "$prefix_info: Waiting $service_name $secs seconds"

        if [ "$i" == "$retries" ]; then
            error "$prefix_info Maximum number of retries reached!"
            error "$prefix_info Unable to connect to $service_name: $svc_host:$svc_port"
            return 1
        fi
    done
    return 0
}
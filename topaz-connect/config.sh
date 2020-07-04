#!/bin/bash

MSG_SERVER_IP=$(hostname -i)

## modify configuration
function modConfig() {
    local db_files=(login.conf map.conf search_server.conf)

    for f in ${db_files[@]}
    do
        if [[ -f conf/$f ]]; then
            sed -i "s/^\(msg_server_ip:\s*\).*\$/\1$MSG_SERVER_IP/" conf/$f
        fi
    done
}

modConfig
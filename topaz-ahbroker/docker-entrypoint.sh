#!/bin/bash

set -ex

MYSQL_HOST=${MYSQL_HOST:-localhost}
MYSQL_PORT=${MYSQL_PORT:-3306}
MYSQL_LOGIN=${MYSQL_LOGIN:-root}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-root}
MYSQL_DATABASE=${MYSQL_DATABASE:-tpzdb}
AH_BOTNAME=${AH_BOTNAME:-Zissou}
AH_SINGLE=${AH_SINGLE:-5}
AH_STACK=${AH_STACK:-5}


## modify configuration
function modConfig() {
    local db_files=(config.yaml)

    for f in ${db_files[@]}
    do
        if [[ -f /topaz/bin/$f ]]; then
            sed -i "s/^\(hostname:\s*\).*\$/\1$MYSQL_HOST/" /topaz/bin/$f
            sed -i "s/^\(username:\s*\).*\$/\1$MYSQL_LOGIN/" /topaz/bin/$f
            sed -i "s/^\(password:\s*\).*\$/\1$MYSQL_PASSWORD/" /topaz/bin/$f
            sed -i "s/^\(database:\s*\).*\$/\1$MYSQL_DATABASE/" /topaz/bin/$f
            sed -i "s/^\(name:\s*\).*\$/\1$AH_BOTNAME/" /topaz/bin/$f
            sed -i "s/^\(stock01:\s*\).*\$/\1$AH_SINGLE/" /topaz/bin/$f
            sed -i "s/^\(stock12:\s*\).*\$/\1$AH_STACK/" /topaz/bin/$f
        fi
    done
}

modConfig

exec /usr/local/bin/supervisord
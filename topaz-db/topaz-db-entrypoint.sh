#!/bin/bash

ZONE_IP=${ZONE_IP:-127.0.0.1}
MYSQL_USER=${MYSQL_USER:-topaz}
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-topaz}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-topaz}
MYSQL_DATABASE=${MYSQL_DATABASE:-tpzdb}

if [[ -d /docker-entrypoint-initdb.d/.seed ]]; then
    cd /docker-entrypoint-initdb.d/.seed
    for f in *.sql
    do
        echo "USE ${MYSQL_DATABASE};" | cat - $f >> /docker-entrypoint-initdb.d/10-$f    
    done
fi

if [[ -f /docker-entrypoint-initdb.d/zoneip.sql.tpl ]]; then
  sed -i "s/{{ZONE_IP}}/$ZONE_IP/" /docker-entrypoint-initdb.d/zoneip.sql.tpl && \
    mv /docker-entrypoint-initdb.d/zoneip.sql.tpl /docker-entrypoint-initdb.d/999-zoneip.sql
fi

docker-entrypoint.sh "$@"

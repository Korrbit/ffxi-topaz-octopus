#!/bin/bash

MYSQL_USER=${MYSQL_USER:-darkstar}
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-darkstar}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-darkstar}
MYSQL_DATABASE=${MYSQL_DATABASE:-dspdb}
MYSQL_HOST=${MYSQL_HOST:-darkstar-db}
zoneport=${zoneport}
zoneid=${zoneid}
zoneids=${zoneids}

array=($(echo $zoneids | tr ',' "\n"))

for zoneid in ${array[@]}
do
    echo "updating zone settings with ${zoneid} : ${zoneport}"
    mysql -h${MYSQL_HOST} -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} -sse "update zone_settings SET zoneport = '${zoneport}' where zoneid = '${zoneid}';"
done
mysqlcheck -h${MYSQL_HOST} -u${MYSQL_USER} -p${MYSQL_PASSWORD} --repair ${MYSQL_DATABASE}
#ubuntu:focal - 20.04
FROM ubuntu:focal

ARG MYSQL_DATABASE
ENV MYSQL_DATABASE ${MYSQL_DATABASE:-topaz-db}

ARG DEPS="\
                mysql-client\
                libmysqlclient21\
                libzmq5"

RUN apt-get update && \
    apt-get install -y $DEPS && \
    rm -rf /var/lib/apt/lists/*

COPY config.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/config.sh

WORKDIR /usr/build

EXPOSE 54001
EXPOSE 54230
EXPOSE 54231

CMD ./wait-for-it.sh ${MYSQL_DATABASE}:3306 --timeout=0 && /usr/local/bin/config.sh && ./topaz_connect
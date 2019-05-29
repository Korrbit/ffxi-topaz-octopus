FROM ubuntu:bionic

ARG MYSQL_DATABASE
ENV MYSQL_DATABASE ${MYSQL_DATABASE:-darkstar-db}

ARG DEPS="\
                libluajit-5.1\
                libmariadbclient18\
                libzmq5"

RUN apt-get update && \
    apt-get install -y $DEPS && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/build

EXPOSE 54230

CMD ./wait-for-it.sh ${MYSQL_DATABASE}:3306 --timeout=0 && ./dsgame
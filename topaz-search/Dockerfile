#ubuntu:focal - 20.04
FROM ubuntu:focal

ARG MYSQL_DATABASE
ENV MYSQL_DATABASE ${MYSQL_DATABASE:-topaz-db}

ARG DEPS="\
                libmariadbclient18\
                libzmq5"

RUN apt-get update && \
    apt-get install -y $DEPS && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/build

EXPOSE 54002

CMD ./wait-for-it.sh ${MYSQL_DATABASE}:3306 --timeout=0 && ./search
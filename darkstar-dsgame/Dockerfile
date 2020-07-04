FROM ubuntu:bionic

ARG MYSQL_HOST
ENV MYSQL_HOST ${MYSQL_HOST:-darkstar-db}
ARG zoneport
ENV zoneport ${zoneport:-54230}

ARG DEPS="\
                libluajit-5.1\
                libmariadbclient18\
                libzmq5\
                mysql-client\
                python3\
                python3-pip\
                python-mysqldb"

RUN apt-get update && \
    apt-get install -y $DEPS && pip3 install mysql-connector-python && \
    rm -rf /var/lib/apt/lists/*

COPY . /opt
RUN chmod a+x /opt/update_db.sh && \
    chmod a+x /opt/run_dsgame.sh

WORKDIR /usr/build

#EXPOSE ${zoneport}

CMD ./wait-for-it.sh ${MYSQL_HOST}:3306 --timeout=0 && /opt/update_db.sh && /opt/run_dsgame.sh
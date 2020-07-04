#ubuntu:focal - 20.04
FROM ubuntu:focal

ARG FFXI_REPO 
ENV FFXI_REPO ${FFXI_REPO:-https://github.com/project-topaz/topaz.git}
ARG FFXI_BRANCH
ENV FFXI_BRANCH ${FFXI_BRANCH:-release}
ARG VER_LOCK
ENV VER_LOCK ${VER_LOCK:-1}

ENV DEBIAN_FRONTEND=noninteractive

#                libmariadbclient-dev\

ARG DEPS="\
                git\
                autoconf\
                automake\
                pkg-config\
                g++-7\
                libmysqlclient-dev\
                libluajit-5.1-dev\
                libzmq3-dev\
                mysql-client\
                libmysqlclient21\
                python3\
                python3-pip\
                python3-mysqldb"

RUN apt-get update && \
    apt-get install -y $DEPS && pip3 install mysql-connector-python && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/build
RUN rm -rf *
RUN git clone -b ${FFXI_BRANCH} ${FFXI_REPO} .
RUN ./autogen.sh
RUN ./configure
RUN make -j6
COPY . .
RUN sed -i "s/^\(VER_LOCK:\s*\).*\$/\1${VER_LOCK}/" conf/default/version.conf && \
    chmod a+x config.sh && \
    chmod a+x wait-for-it.sh && \
    chmod a+x update_db.sh

CMD ./config.sh && ./wait-for-it.sh ${MYSQL_HOST}:3306 --timeout=0 && ./update_db.sh
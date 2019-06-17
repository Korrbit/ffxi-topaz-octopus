FROM ubuntu:bionic

ARG FFXI_REPO 
ENV FFIX_REPO ${FFXI_REPO:-https://github.com/DarkstarProject/darkstar.git}
ARG FFXI_BRANCH
ENV FFXI_BRANCH ${FFXI_BRANCH:-master}
ARG VER_LOCK
ENV VER_LOCK ${VER_LOCK:-1}

ARG DEPS="\
                git\
                autoconf\
                automake\
                pkg-config\
                g++-7\
                libmariadbclient-dev\
                libluajit-5.1-dev\
                libzmq3-dev"

RUN apt-get update && \
    apt-get install -y $DEPS && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/build
RUN git clone -b ${FFXI_BRANCH} ${FFXI_REPO} .
RUN ./autogen.sh
RUN ./configure
RUN make -j4
COPY . .
RUN sed -i "s/^\(VER_LOCK:\s*\).*\$/\1${VER_LOCK}/" version.info && \
    chmod a+x config.sh && \
    chmod a+x wait-for-it.sh

CMD ./config.sh
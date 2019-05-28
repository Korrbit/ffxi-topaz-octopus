FROM ubuntu:bionic

ENV DS_BRANCH=master

ARG FFXI_REPO 
ENV FFIX_REPO ${FFXI_REPO:-https://github.com/DarkstarProject/darkstar.git}
ARG MYSQL_DATABASE
ENV MYSQL_DATABASE ${MYSQL_DATABASE}:-darkstar-db}


RUN apt-get update && \
  apt-get install -y build-essential git libmysqlclient-dev libluajit-5.1-dev \
  libzmq3-dev autoconf pkg-config software-properties-common python-pip python-setuptools && \
  apt-add-repository -y ppa:ubuntu-toolchain-r/test && \
  apt-get update && \
  apt-get install -y g++-7 && \
  pip install supervisor && \
  pip install supervisor-stdout && \
  git clone -b ${DS_BRANCH} $FFXI_REPO /darkstar && \
  cd /darkstar && \
  sh autogen.sh && \
  ./configure --enable-debug=gdb && \
  make -j6 && \
  apt-get autoremove -y build-essential git autoconf pkg-config software-properties-common && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /darkstar/src && \
  rm -rf /darkstar/sql

COPY etc/ etc/
COPY docker-entrypoint.sh /usr/local/bin/
COPY wait-for-it.sh /usr/local/bin/

# add darkstar user and fix permissions
RUN groupadd -r darkstar && \
  useradd -g darkstar -ms /bin/bash darkstar && \
  chown -R darkstar:darkstar /darkstar && \
  chmod a+x /usr/local/bin/docker-entrypoint.sh && \
  chmod a+x /usr/local/bin/wait-for-it.sh

USER darkstar
EXPOSE 54230 54230/udp 54231 54001 54002
WORKDIR /darkstar

CMD ["wait-for-it.sh", "$MYSQL_DATABASE:3306", "--", "docker-entrypoint.sh"]

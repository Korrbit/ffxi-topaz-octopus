FROM ubuntu:bionic

ENV DS_BRANCH=master

RUN apt-get update && \
  apt-get install -y build-essential git libmysqlclient-dev libluajit-5.1-dev \
  libzmq3-dev autoconf pkg-config software-properties-common python-pip python-setuptools && \
  apt-add-repository -y ppa:ubuntu-toolchain-r/test && \
  apt-get update && \
  apt-get install -y g++-7 && \
  pip install supervisor && \
  pip install supervisor-stdout && \
  git clone -b ${DS_BRANCH} http://github.com/DarkstarProject/darkstar.git/ /darkstar && \
  cd /darkstar && \
  sh autogen.sh && \
  ./configure --enable-debug=gdb && \
  make -j4 && \
  apt-get autoremove -y build-essential git autoconf pkg-config software-properties-common && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /darkstar/src && \
  rm -rf /darkstar/sql

COPY etc/ etc/
COPY docker-entrypoint.sh /usr/local/bin/

# add darkstar user and fix permissions
RUN groupadd -r darkstar && \
  useradd -g darkstar -ms /bin/bash darkstar && \
  chown -R darkstar:darkstar /darkstar && \
  chmod a+x /usr/local/bin/docker-entrypoint.sh

USER darkstar
EXPOSE 54230 54230/udp 54231 54001 54002
WORKDIR /darkstar

CMD ["docker-entrypoint.sh"]

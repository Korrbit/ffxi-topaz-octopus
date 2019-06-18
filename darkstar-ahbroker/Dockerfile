FROM ubuntu:bionic

ARG MYSQL_DATABASE
ENV MYSQL_DATABASE ${MYSQL_DATABASE}:-darkstar-db}

RUN apt-get update && \
  apt-get install -y  git python3 python3-pip python python-pip && \
  pip3 install sqlalchemy && \
  pip3 install pymysql && \
  pip3 install beautifulsoup4 && \
  pip3 install pyyaml && \
  pip3 install six && \
  pip install supervisor && \
  pip install supervisor-stdout && \
  git clone https://github.com/Korrbit/pydarkstar.git /darkstar && \
  cd /darkstar && \
  rm -rf /var/lib/apt/lists/*

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
WORKDIR /darkstar

CMD /usr/local/bin/wait-for-it.sh ${MYSQL_DATABASE}:3306 --timeout=0 && ./docker-entrypoint.sh
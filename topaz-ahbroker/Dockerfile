FROM ubuntu:focal

ARG MYSQL_HOST
ENV MYSQL_HOST ${MYSQL_HOST:-topaz-db}
ARG GITHUB_REPO
ENV GITHUB_REPO ${GITHUB_REPO:-https://github.com/Korrbit/pydarkstar.git}
ARG GITHUB_BRANCH
ENV GITHUB_BRANCH ${GITHUB_BRANCH:-master}  

# pip3 install supervisor supervisor-stdout && \

RUN apt-get update && \
  apt-get install -y  git python3 python3-pip supervisor  && \
  pip3 install sqlalchemy pymysql beautifulsoup4 pyyaml six && \
  git clone -b ${GITHUB_BRANCH} ${GITHUB_REPO} /topaz && \
  cd /topaz && \
  rm -rf /var/lib/apt/lists/*

COPY etc/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker-entrypoint.sh /usr/local/bin/
COPY wait-for-it.sh /usr/local/bin/

# add topaz user and fix permissions
#RUN groupadd -r topaz && \
#  useradd -g topaz -ms /bin/bash topaz && \
#  chown -R topaz:topaz /topaz && \
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh && \
  chmod a+x /usr/local/bin/wait-for-it.sh 
#  chown -R topaz:topaz /var/log/supervisor

# USER topaz
WORKDIR /topaz

CMD /usr/local/bin/wait-for-it.sh ${MYSQL_HOST}:3306 --timeout=0 && /usr/local/bin/docker-entrypoint.sh
FROM mariadb:10.4.5-bionic

ARG FFXI_REPO 
ENV FFIX_REPO ${FFXI_REPO:-https://github.com/DarkstarProject/darkstar.git}
ARG FFXI_BRANCH
ENV FFXI_BRANCH ${FFXI_BRANCH:-master}

COPY docker-entrypoint-initdb.d/ docker-entrypoint-initdb.d

RUN apt-get update && apt-get install -y git && \
  rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 -b ${FFXI_BRANCH} ${FFXI_REPO} /darkstar && \
  mkdir -p /docker-entrypoint-initdb.d/.seed && \
  cp /darkstar/sql/* /docker-entrypoint-initdb.d/.seed/ && \
  rm -rf /darkstar

COPY darkstar-db-entrypoint.sh /usr/local/bin

RUN chmod a+x /usr/local/bin/*.sh

ENTRYPOINT ["darkstar-db-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld", "--max-connections=1024"]

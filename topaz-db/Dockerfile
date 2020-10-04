#mariadb:focal - 20.04
FROM mariadb:focal

ARG FFXI_REPO 
ENV FFIX_REPO ${FFXI_REPO:-https://github.com/project-topaz/topaz.git}
ARG FFXI_BRANCH
ENV FFXI_BRANCH ${FFXI_BRANCH:-release}

COPY docker-entrypoint-initdb.d/ docker-entrypoint-initdb.d

RUN apt-get update && apt-get install -y git && \
  rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 -b ${FFXI_BRANCH} ${FFXI_REPO} /topaz && \
  mkdir -p /docker-entrypoint-initdb.d/.seed && \
  cp -r /topaz/sql/* /docker-entrypoint-initdb.d/.seed/ && \
  rm -rf /topaz

COPY topaz-db-entrypoint.sh /usr/local/bin

RUN chmod a+x /usr/local/bin/*.sh

ENTRYPOINT ["topaz-db-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld", "--max-connections=1024"]

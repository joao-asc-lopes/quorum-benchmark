ARG QUORUM_VERSION
FROM quorumengineering/quorum:${QUORUM_VERSION}

ARG NODES_NUMBER
ARG GOQUORUM_CONS_ALGO

RUN apk add --no-cache curl

COPY common/config/goquorum/data data
COPY ${NODES_NUMBER}-nodes/${GOQUORUM_CONS_ALGO}/goQuorum/ data
COPY common/config/goquorum/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
ARG QUORUM_VERSION=latest
ARG NODES_NUMBER
ARG GOQUORUM_CONS_ALGO

FROM quorumengineering/quorum:${QUORUM_VERSION}

RUN apk add --no-cache curl

COPY docker-entrypoint.sh /usr/local/bin/
COPY /../../${NODES_NUMBER}-nodes/${GOQUORUM_CONS_ALGO}/goQuorum/ data

ENTRYPOINT ["docker-entrypoint.sh"]
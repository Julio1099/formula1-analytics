#!/usr/bin/env bash
set -e

echo "Aguardando DB em ${POSTGRES_HOST}:${POSTGRES_PORT}..."
for i in {1..30}; do
  if /usr/bin/env bash -lc "pg_isready -h ${POSTGRES_HOST} -p ${POSTGRES_PORT} -U ${POSTGRES_USER}" ; then
    echo "DB pronto!"
    exit 0
  fi
  sleep 2
done

echo "DB não respondeu a tempo."
exit 1

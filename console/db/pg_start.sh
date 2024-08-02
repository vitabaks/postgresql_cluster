#!/bin/bash

# Ensure the directory exists and has the correct permissions
mkdir -p ${PGDATA} ${PG_UNIX_SOCKET_DIR} /etc/postgresql/${POSTGRES_VERSION}/main
chown -R postgres:postgres ${PGDATA} ${PG_UNIX_SOCKET_DIR} /etc/postgresql/${POSTGRES_VERSION}/main

# Create if not exists
if [[ ! -d "${PGDATA}/base" ]]; then
  su - postgres -c "pg_createcluster --locale en_US.UTF-8 ${POSTGRES_VERSION} main -d ${PGDATA} -- --data-checksums"
  mv /etc/postgresql/${POSTGRES_VERSION}/main/postgresql.conf /etc/postgresql/${POSTGRES_VERSION}/main/postgresql.base.conf
  cp /var/tmp/postgresql.conf /etc/postgresql/${POSTGRES_VERSION}/main/postgresql.conf
  cp /var/tmp/pg_hba.conf /etc/postgresql/${POSTGRES_VERSION}/main/pg_hba.conf
fi

# Start postgres
su - postgres -c "/usr/lib/postgresql/${POSTGRES_VERSION}/bin/postgres -D ${PGDATA} -k ${PG_UNIX_SOCKET_DIR} -p ${POSTGRES_PORT} -c config_file=/etc/postgresql/${POSTGRES_VERSION}/main/postgresql.conf" &

for i in {1..300}; do
  pg_isready -h ${PG_UNIX_SOCKET_DIR} -p ${POSTGRES_PORT} && break || echo 'Postgres is not ready yet'; sleep 2
done

# Reset postgres password
psql -h ${PG_UNIX_SOCKET_DIR} -p ${POSTGRES_PORT} -U postgres -d postgres -c "ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}';"

# Create timescaledb extension
psql -h ${PG_UNIX_SOCKET_DIR} -p ${POSTGRES_PORT} -U postgres -d postgres -c "CREATE EXTENSION IF NOT EXISTS timescaledb;"

# Infinite sleep to allow restarting Postgres
/bin/bash -c "trap : TERM INT; sleep infinity & wait"

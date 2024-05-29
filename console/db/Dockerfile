FROM debian:12-slim

ARG POSTGRES_VERSION
ENV POSTGRES_VERSION=${POSTGRES_VERSION:-16}

ARG POSTGRES_PORT
ENV POSTGRES_PORT=${POSTGRES_PORT:-5432}

ARG POSTGRES_PASSWORD
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-"postgres-pass"}

ARG PGDATA
ENV PGDATA=${PGDATA:-"/var/lib/postgresql/${POSTGRES_VERSION}/main"}

ARG PG_UNIX_SOCKET_DIR
ENV PG_UNIX_SOCKET_DIR=${PG_UNIX_SOCKET_DIR:-"/var/run/postgresql"}

# Set SHELL to /bin/bash
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get clean && rm -rf /var/lib/apt/lists/partial \
   && apt-get update -o Acquire::CompressionTypes::Order::=gz \
   && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
      gnupg postgresql-common apt-transport-https lsb-release openssh-client ca-certificates wget curl vim-tiny sudo \
   # Locale
   && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen \
   # PostgreSQL
   && install -d /usr/share/postgresql-common/pgdg \
   && curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc \
   && echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
   && apt-get update -o Acquire::CompressionTypes::Order::=gz \
   && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y postgresql-${POSTGRES_VERSION} \
   # TimescaleDB
   && wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | gpg --dearmor -o /etc/apt/trusted.gpg.d/timescaledb.gpg \
   && echo "deb https://packagecloud.io/timescale/timescaledb/debian/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/timescaledb.list \
   && apt-get update -o Acquire::CompressionTypes::Order::=gz \
   && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y timescaledb-2-postgresql-${POSTGRES_VERSION}

# Copy configuration files
COPY console/db/postgresql.conf /var/tmp/postgresql.conf
COPY console/db/pg_hba.conf /var/tmp/pg_hba.conf

# Clean up
RUN apt-get autoremove -y --purge gnupg wget \
   && apt-get clean -y autoclean \
   && rm -rf /var/lib/apt/lists/*

VOLUME ${PGDATA}

EXPOSE ${POSTGRES_PORT}

# Prepare Postgres start script
RUN echo "#!/bin/bash" > /pg_start.sh && chmod a+x /pg_start.sh \
    && echo "chown -R postgres:postgres \${PGDATA} \${PG_UNIX_SOCKET_DIR} /etc/postgresql/\${POSTGRES_VERSION}/main" >> /pg_start.sh \
    && echo "if [[ ! -d \"\${PGDATA}/base\" ]]; then" >> /pg_start.sh \
    && echo "  pg_createcluster --locale en_US.UTF-8 \${POSTGRES_VERSION} main -d \${PGDATA} -- --data-checksums" >> /pg_start.sh \
    && echo "  mv /etc/postgresql/\${POSTGRES_VERSION}/main/postgresql.conf /etc/postgresql/\${POSTGRES_VERSION}/main/postgresql.base.conf" >> /pg_start.sh \
    && echo "  cp /var/tmp/postgresql.conf /etc/postgresql/\${POSTGRES_VERSION}/main/postgresql.conf" >> /pg_start.sh \
    && echo "  cp /var/tmp/pg_hba.conf /etc/postgresql/\${POSTGRES_VERSION}/main/pg_hba.conf" >> /pg_start.sh \
    && echo "fi" >> /pg_start.sh \
    && echo "sudo -Eu postgres /usr/lib/postgresql/\${POSTGRES_VERSION}/bin/postgres -D \${PGDATA} -k \${PG_UNIX_SOCKET_DIR} -p \${POSTGRES_PORT} -c config_file=/etc/postgresql/\${POSTGRES_VERSION}/main/postgresql.conf &" >> /pg_start.sh \
    && echo "for i in {1..300}; do pg_isready -h ${PG_UNIX_SOCKET_DIR} -p \${POSTGRES_PORT} && break || echo 'Postgres is not ready yet'; sleep 1; done" >> /pg_start.sh \
    # Reset postgres password
    && echo "psql -h ${PG_UNIX_SOCKET_DIR} -p \${POSTGRES_PORT} -U postgres -d postgres -c \"ALTER USER postgres WITH PASSWORD '\${POSTGRES_PASSWORD}';\"" >> /pg_start.sh \
    # Create timescaledb extension
    && echo "psql -h ${PG_UNIX_SOCKET_DIR} -p \${POSTGRES_PORT} -U postgres -d postgres -c \"CREATE EXTENSION IF NOT EXISTS timescaledb;\"" >> /pg_start.sh \
    # Infinite sleep to allow restarting Postgres
    && echo "/bin/bash -c \"trap : TERM INT; sleep infinity & wait\"" >> /pg_start.sh

CMD ["/pg_start.sh"]

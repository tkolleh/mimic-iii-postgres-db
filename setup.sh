#!/bin/bash
set -e

echo "Initializing MIMIC III database..."

echo "Creating MIMIC user..."
pg_ctl stop

pg_ctl -D "$PGDATA" \
	-o "-c listen_addresses='' -c checkpoint_timeout=600" \
	-w start

psql <<- EOSQL
    CREATE USER MIMIC WITH PASSWORD '$MIMIC_PASSWORD';
    CREATE DATABASE MIMIC OWNER MIMIC;
    \c mimic;
    CREATE SCHEMA MIMIC;
	ALTER SCHEMA MIMIC OWNER TO MIMIC;
EOSQL

export PGOPTIONS="--search_path=MIMIC --client_min_messages=warning"

if [ "$CONTAINER_HOSTNAME" = "" ]
then
  echo "Running postgres_create_tables.sql"
  psql --username "$POSTGRES_USER" --dbname mimic < /docker-entrypoint-initdb.d/psql/postgres_create_tables.sql

  echo "Running postgres_add_comments.sql"
  psql --username "$POSTGRES_USER" --dbname mimic < /docker-entrypoint-initdb.d/psql/postgres_add_comments.sql

  echo "Running postgres_add_indexes.sql"
  psql --username "$POSTGRES_USER" --dbname mimic < /docker-entrypoint-initdb.d/psql/postgres_add_indexes.sql

  echo "Running postgres_add_constraints.sql"
  psql --username "$POSTGRES_USER" --dbname mimic < /docker-entrypoint-initdb.d/psql/postgres_add_constraints.sql

  echo "Granting all privileges on MIMIC database tables to MIMIC user"
  psql --username "$POSTGRES_USER" --dbname mimic -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA MIMIC TO MIMIC;"
else
  echo "Running postgres_create_tables.sql"
  psql --host "$CONTAINER_HOSTNAME" --username "$POSTGRES_USER" --dbname mimic < /docker-entrypoint-initdb.d/psql/postgres_create_tables.sql

  echo "Running postgres_add_comments.sql"
  psql --host "$CONTAINER_HOSTNAME" --username "$POSTGRES_USER" --dbname mimic < /docker-entrypoint-initdb.d/psql/postgres_add_comments.sql

  echo "Running postgres_add_indexes.sql"
  psql --host "$CONTAINER_HOSTNAME" --username "$POSTGRES_USER" --dbname mimic < /docker-entrypoint-initdb.d/psql/postgres_add_indexes.sql

  echo "Running postgres_add_constraints.sql"
  psql --host "$CONTAINER_HOSTNAME" --username "$POSTGRES_USER" --dbname mimic < /docker-entrypoint-initdb.d/psql/postgres_add_constraints.sql

  echo "Granting all privileges on MIMIC database tables to MIMIC user"
  psql --host "$CONTAINER_HOSTNAME" --username "$POSTGRES_USER" --dbname mimic -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA MIMIC TO MIMIC;"

  echo "Initialization complete."
fi

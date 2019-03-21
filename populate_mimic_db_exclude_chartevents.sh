#!/bin/bash
set -e

echo "Populating mimic-iii database"

export PGOPTIONS="--search_path=MIMIC --client_min_messages=warning"

echo "Loading data into the postgres database from *.csv.gz files at /var/lib/postgresql/mdata"
cd /var/lib/postgresql/mdata
psql --username "$POSTGRES_USER" --dbname mimic -f postgres_load_data_gz_exclude_chartevents.sql -v mimic_data_dir="/var/lib/postgresql/mdata"

echo "Running postgres_add_indexes.sql"
psql --username "$POSTGRES_USER" --dbname mimic < /docker-entrypoint-initdb.d/psql/postgres_add_indexes.sql

echo "Running postgres_add_constraints.sql"
psql --username "$POSTGRES_USER" --dbname mimic < /docker-entrypoint-initdb.d/psql/postgres_add_constraints.sql

echo "Data load complete"

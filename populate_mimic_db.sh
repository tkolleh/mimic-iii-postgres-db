#!/bin/bash
set -e

echo "Populating mimic-iii database"

export PGOPTIONS="--search_path=MIMIC --client_min_messages=warning"

echo "Loading data into the postgres database from *.csv.gz files at $MIMIC_DATA_DIR"
cd $MIMIC_DATA_DIR
psql -f postgres_load_data_gz.sql -v mimic_data_dir="$MIMIC_DATA_DIR"

echo "Running postgres_add_indexes.sql"
psql --username "$POSTGRES_USER" --dbname mimic < /docker-entrypoint-initdb.d/psql/postgres_add_indexes.sql

echo "Running postgres_add_constraints.sql"
psql --username "$POSTGRES_USER" --dbname mimic < /docker-entrypoint-initdb.d/psql/postgres_add_constraints.sql

echo "Data load complete"

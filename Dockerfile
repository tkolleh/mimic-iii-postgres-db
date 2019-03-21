FROM postgres:10.7-alpine

LABEL maintainer="tkolleh@me.com"
#
# Gather setup scripts from MIT repo
# Reference: https://github.com/MIT-LCP/mimic-code
#
COPY postgres_create_tables.sql /docker-entrypoint-initdb.d/psql/
COPY postgres_add_comments.sql /docker-entrypoint-initdb.d/psql/
COPY postgres_add_indexes.sql /docker-entrypoint-initdb.d/psql/
COPY postgres_add_constraints.sql /docker-entrypoint-initdb.d/psql/
COPY populate_mimic_db.sh /docker-entrypoint-initdb.d/psql/
COPY populate_mimic_db_exclude_chartevents.sh /docker-entrypoint-initdb.d/psql/

RUN chmod -R a+r /docker-entrypoint-initdb.d/psql/

ADD setup.sh /docker-entrypoint-initdb.d/

EXPOSE 5432/tcp

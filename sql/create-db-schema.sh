#!/usr/bin/env sh
set -e

db_schema=$1

export PGPASSWORD=$DATABASE_PASSWORD;

psql postgresql://"$DATABASE_ENDPOINT":"$DATABASE_PORT"/"$DATABASE_NAME" -U "$DATABASE_USERNAME" -c "CREATE SCHEMA IF NOT EXISTS ${db_schema};"
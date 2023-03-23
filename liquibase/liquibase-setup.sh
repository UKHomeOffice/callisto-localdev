#!/bin/bash
set -e

db_schema=$1

if [ -z "${db_schema}" ] ; then
  echo 'Database schema name must be specified as a command argument in Docker compose file'
  echo 'e.g. command: ["timecard"]'
  exit 1
fi

liquibase \
--url=jdbc:postgresql://postgres:5432/${DATABASE_NAME} \
--username=${DATABASE_USERNAME} \
--password=${DATABASE_PASSWORD} \
--changeLogFile=changelog/db.changelog-main.yml \
--liquibaseSchemaName=${db_schema} \
update
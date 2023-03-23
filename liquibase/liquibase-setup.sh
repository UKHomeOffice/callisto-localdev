#!/bin/bash
set -e

db_schema=$1

liquibase \
--url=jdbc:postgresql://postgres:5432/${DATABASE_NAME} \
--username=${DATABASE_USERNAME} \
--password=${DATABASE_PASSWORD} \
--changeLogFile=changelog/db.changelog-main.yml \
--liquibaseSchemaName=${db_schema} \
update
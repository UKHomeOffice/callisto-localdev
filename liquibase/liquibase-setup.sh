#!/bin/bash
echo "Initializing Liquibase conf from liquibase/liquibase-setup.sh"
liquibase \
--url=jdbc:postgresql://postgres:5432/${DATABASE_NAME} \
--username=${DATABASE_USERNAME} \
--password=${DATABASE_PASSWORD} \
--changeLogFile=changelog/db.changelog-main.yml \
--liquibaseSchemaName=${databaseSchemaName} \
update \

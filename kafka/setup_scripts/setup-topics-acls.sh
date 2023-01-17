#!/usr/bin/env bash
set -e

root_path=${BASH_SOURCE[0]%/*}
. $root_path/kafka.sh

kafka_host=kafka:9093
properties_file=$1

create_topics
apply_permissions
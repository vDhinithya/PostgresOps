#!/bin/bash

set -e

echo "========================================="
echo "PostgresOps Replica Bootstrap"
echo "========================================="

echo "Waiting for primary database..."

until pg_isready -h "$PRIMARY_HOST" \
                 -p "$PRIMARY_PORT" \
                 -U "$REPLICATION_USER"
do
    sleep 2
done

echo "Primary is ready."

echo "Cleaning old data directory..."

rm -rf /var/lib/postgresql/data/*

echo "Creating base backup..."

export PGPASSWORD="$REPLICATION_PASSWORD"

pg_basebackup \
    -h "$PRIMARY_HOST" \
    -p "$PRIMARY_PORT" \
    -U "$REPLICATION_USER" \
    -D /var/lib/postgresql/data \
    -Fp \
    -Xs \
    -P \
    -R

echo "Replica initialized."

echo "Starting PostgreSQL..."

exec docker-entrypoint.sh postgres
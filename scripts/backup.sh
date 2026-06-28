#!/bin/bash

# ==========================================================
# PostgresOps
# Logical Backup Script
# ==========================================================

set -e

echo "====================================="
echo "PostgresOps Logical Backup"
echo "====================================="

# ----------------------------------------------------------
# Configuration
# ----------------------------------------------------------

CONTAINER_NAME="postgresops-primary"
DATABASE_NAME="postgresops"
DATABASE_USER="postgres"

BACKUP_DIR="backups/logical"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

BACKUP_FILE="${BACKUP_DIR}/postgresops_${TIMESTAMP}.sql"

RETENTION_COUNT=7

# ----------------------------------------------------------
# Create Backup Directory
# ----------------------------------------------------------

mkdir -p "$BACKUP_DIR"

# ----------------------------------------------------------
# Create Logical Backup
# ----------------------------------------------------------

echo
echo "Creating logical backup..."

docker exec "$CONTAINER_NAME" \
pg_dump \
-U "$DATABASE_USER" \
-d "$DATABASE_NAME" \
> "$BACKUP_FILE"

echo "Backup created:"
echo "$BACKUP_FILE"

# ----------------------------------------------------------
# Retention Policy
# Keep only the latest 7 backups
# ----------------------------------------------------------

echo
echo "Applying retention policy..."

BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/postgresops_*.sql 2>/dev/null | wc -l)

if [ "$BACKUP_COUNT" -gt "$RETENTION_COUNT" ]; then

    REMOVE_COUNT=$((BACKUP_COUNT - RETENTION_COUNT))

    ls -1t "$BACKUP_DIR"/postgresops_*.sql \
    | tail -n "$REMOVE_COUNT" \
    | while read file
    do
        echo "Removing old backup: $file"
        rm "$file"
    done

else
    echo "No old backups to remove."
fi

echo
echo "====================================="
echo "Backup completed successfully."
echo "====================================="
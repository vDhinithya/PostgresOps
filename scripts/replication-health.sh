#!/bin/bash

echo "=============================="
echo "PostgresOps Replication Health"
echo "=============================="

PRIMARY_CONTAINER="postgresops-primary"

docker exec -it $PRIMARY_CONTAINER psql -U postgres -d postgresops -c "
SELECT
    client_addr,
    state,
    sync_state,
    pg_wal_lsn_diff(sent_lsn, replay_lsn) AS replication_lag_bytes
FROM pg_stat_replication;
"
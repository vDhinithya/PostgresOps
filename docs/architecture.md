# Architecture

> This document describes the overall architecture of **PostgresOps**, a Dockerized PostgreSQL DBA Platform designed to simulate production-grade database administration, high availability, observability, disaster recovery, and automation.

---

# Design Principles

PostgresOps is designed around four core principles:

- High Availability
- Disaster Recovery
- Observability
- DBA Automation

The platform is built incrementally, with each phase adding production-grade capabilities while keeping the infrastructure modular and easy to understand.

---

# Current Architecture (Phase 1)

Phase 1 establishes the core PostgreSQL cluster.

- One Primary PostgreSQL node
- Two Streaming Replicas
- Docker Bridge Network
- Persistent Docker Volumes
- Custom PostgreSQL Configuration
- Replication Health Monitoring

## Architecture Diagram

```mermaid
flowchart TB

    Client["DBA / Developer"]

    subgraph DockerNetwork["Docker Network : postgresops-network"]

        Primary["Primary PostgreSQL
        Read / Write
        WAL Sender"]

        Replica1["Replica 1
        Read Only
        WAL Receiver"]

        Replica2["Replica 2
        Read Only
        WAL Receiver"]

    end

    Client --> Primary

    Primary -- Streaming Replication --> Replica1
    Primary -- Streaming Replication --> Replica2
```

---

# Current Data Flow

```mermaid
sequenceDiagram

participant Client
participant Primary
participant Replica1
participant Replica2

Client->>Primary: INSERT / UPDATE / DELETE

Primary->>Primary: Generate WAL

Primary-->>Replica1: Stream WAL

Primary-->>Replica2: Stream WAL

Replica1->>Replica1: Replay WAL

Replica2->>Replica2: Replay WAL
```

---

# Replication Architecture

The replication model follows PostgreSQL Streaming Replication.

```
                 Write Requests
                       │
                       ▼

              PostgreSQL Primary
                     │
              WAL Generation
                     │
         ┌───────────┴───────────┐
         │                       │
         ▼                       ▼

     Replica 1              Replica 2
  Read Only Node         Read Only Node

      WAL Replay           WAL Replay
```

Current replication mode:

- Streaming Replication
- Asynchronous Replication
- WAL-based synchronization
- Continuous recovery mode on replicas

---

# Current Infrastructure

```
PostgresOps
│
├── Primary Database
│      ├── Read / Write
│      ├── WAL Generation
│      └── Client Connections
│
├── Replica 1
│      ├── Read Only
│      └── WAL Replay
│
├── Replica 2
│      ├── Read Only
│      └── WAL Replay
│
└── Docker Bridge Network
```

---

# Repository Architecture

```text
postgresops/

├── docker/
│   ├── compose/
│   ├── postgres/
│   │      ├── primary/
│   │      ├── replica1/
│   │      └── replica2/
│   ├── pgadmin/
│   ├── pgbouncer/
│   ├── monitoring/
│   └── patroni/
│
├── configs/
│
├── scripts/
│
├── backups/
│
├── control-plane/
│
├── monitoring/
│
└── docs/
```

---

# Current Operational Flow

```mermaid
flowchart LR

Start["docker compose up"]

Start --> Primary["Primary Starts"]

Primary --> Health["Health Check"]

Health --> Replica1["Replica 1 Bootstrap"]

Health --> Replica2["Replica 2 Bootstrap"]

Replica1 --> BaseBackup1["pg_basebackup"]

Replica2 --> BaseBackup2["pg_basebackup"]

BaseBackup1 --> Streaming1["Streaming Replication"]

BaseBackup2 --> Streaming2["Streaming Replication"]

Streaming1 --> ClusterReady["Cluster Ready"]

Streaming2 --> ClusterReady
```

---

# Technology Stack

| Layer | Technology |
|--------|------------|
| Database | PostgreSQL 16 |
| Containerization | Docker |
| Networking | Docker Bridge Network |
| Replication | Streaming Replication |
| Authentication | PostgreSQL Roles |
| Monitoring | Shell Scripts (Phase 1) |

---

# Future Architecture

The current cluster serves as the foundation for the complete PostgresOps platform.

Future phases will progressively introduce additional production components.

```mermaid
flowchart TB

User["Client / Applications"]

subgraph Access

PgBouncer["pgBouncer"]

end

subgraph Database

Primary["Primary"]

Replica1["Replica 1"]

Replica2["Replica 2"]

Patroni["Patroni"]

etcd["etcd Cluster"]

end

subgraph Monitoring

Exporter["postgres_exporter"]

Prometheus["Prometheus"]

Grafana["Grafana"]

end

subgraph Logging

Filebeat["Filebeat"]

Elastic["Elasticsearch"]

Kibana["Kibana"]

end

subgraph Automation

Spring["Spring Boot Control Plane"]

Flyway["Flyway"]

GitHub["GitHub Actions"]

end

User --> PgBouncer

PgBouncer --> Primary

Primary --> Replica1

Primary --> Replica2

Patroni --> Primary

Patroni --> Replica1

Patroni --> Replica2

etcd --> Patroni

Exporter --> Prometheus

Prometheus --> Grafana

Primary --> Filebeat

Replica1 --> Filebeat

Replica2 --> Filebeat

Filebeat --> Elastic

Elastic --> Kibana

Spring --> Primary

Spring --> Replica1

Spring --> Replica2

GitHub --> Flyway

Flyway --> Primary
```

---

# Planned Evolution

| Phase | Feature |
|--------|---------|
| ✅ Phase 1 | PostgreSQL Cluster & Streaming Replication |
| ⏳ Phase 2 | Backup Automation & Point-in-Time Recovery (PITR) |
| ⏳ Phase 3 | Monitoring & Observability (Prometheus, Grafana, ELK) |
| ⏳ Phase 4 | Spring Boot DBA Automation Platform |
| ⏳ Phase 5 | Patroni, pgBouncer, CI/CD, Security & Production Hardening |

---

# Architectural Goals

By the completion of PostgresOps, the platform will demonstrate:

- Production-inspired PostgreSQL High Availability
- Automated Disaster Recovery
- Database Observability
- Performance Monitoring
- DBA Automation
- Infrastructure as Code
- CI/CD for Database Operations
- Production-ready Docker Deployment
- Enterprise Documentation
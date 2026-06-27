# Engineering Journal

This journal documents the development journey of **PostgresOps**.

Unlike the formal documentation in this repository, this file captures the day-to-day engineering progress, architectural decisions, implementation notes, challenges, and lessons learned throughout the project.

---

# Entry Format

Each entry contains:

- Date
- Phase
- Objective
- Work Completed
- Challenges
- Lessons Learned
- Next Steps

---

# Journal Entries

---

# Entry #1

**Date:** 2026-06-27

**Phase:** Phase 0 — Repository Foundation

## Objective

Lay a strong engineering foundation before writing any infrastructure or application code.

## Work Completed

- Planned the complete project roadmap.
- Finalized the technology stack.
- Designed the repository structure.
- Created the documentation framework.
- Wrote the initial README.
- Created:
    - `architecture.md`
    - `roadmap.md`
    - `journal.md`
- Published the initial GitHub release (`v0.0.1`).
- Adopted Conventional Commits for version control.

## Challenges

No technical challenges.

The primary focus was designing a repository that can scale as additional infrastructure components are introduced.

## Lessons Learned

A well-organized repository significantly improves maintainability and future development.

Investing time in documentation before implementation creates a clear roadmap and reduces future rework.

## Next Steps

Design the Docker infrastructure and deploy the first PostgreSQL instance.

---

# Entry #2

**Date:** 2026-06-27

**Phase:** Phase 1.1 — Docker Infrastructure Foundation

## Objective

Deploy the first PostgreSQL instance using Docker Compose while establishing the project's infrastructure conventions.

## Work Completed

### Infrastructure Design

- Designed the Docker-based architecture.
- Chose PostgreSQL 16 as the database version.
- Adopted a modular Docker Compose strategy.
- Planned a dedicated Docker bridge network for inter-service communication.
- Defined the persistent volume strategy for database storage.
- Created a scalable directory structure for:
    - PostgreSQL
    - pgAdmin
    - Patroni
    - Monitoring
    - Future services

### Docker Environment

- Relocated Docker Desktop's storage location to the **D:** drive to avoid consuming system drive space.
- Created a dedicated Docker environment for the project.

### Docker Compose

Created the first infrastructure definition:

- PostgreSQL Primary
- Named Volume
- Bridge Network
- Environment file support
- Automatic restart policy

### PostgreSQL Deployment

Successfully deployed the first PostgreSQL container.

Verified:

- PostgreSQL initialization
- Persistent volume creation
- Docker network creation
- Database accessibility
- Interactive `psql` connection
- Environment variable initialization

Executed verification commands including:

```sql
SELECT version();

SELECT current_database();

SELECT current_user();
```

Successfully connected to the PostgreSQL server and confirmed the initial database configuration.

## Challenges

### Docker Compose Resource Naming

Observed that Docker Compose automatically prefixes resource names with the project name.

Example:

```text
compose_postgresops-network
compose_postgres-primary-data
```

Learned how Docker Compose determines project names and discussed strategies for assigning explicit names in future iterations.

### PostgreSQL Initialization Process

Initially appeared as if PostgreSQL was restarting unexpectedly.

Learned that the official PostgreSQL Docker image intentionally:

1. Initializes the database cluster.
2. Creates the configured database.
3. Executes initialization scripts.
4. Gracefully shuts down.
5. Restarts PostgreSQL in normal operation mode.

This behavior is expected during the first startup.

### Local Socket Connections

Discovered that connecting via `docker exec` uses Unix domain sockets rather than TCP/IP, which explains why:

```sql
SELECT inet_server_addr(), inet_server_port();
```

returned `NULL` values.

## Lessons Learned

This phase introduced several important infrastructure concepts:

- Docker Compose project lifecycle.
- Docker bridge networking.
- Named Docker volumes.
- PostgreSQL container initialization.
- Environment-based configuration.
- Container inspection using:
    - `docker ps`
    - `docker logs`
    - `docker network inspect`
    - `docker volume inspect`
- Interactive database administration using `psql`.

More importantly, it reinforced the principle that infrastructure should be **understood**, not merely copied.

Every Docker directive was examined and justified before implementation.

## Next Steps

Prepare the PostgreSQL primary node for streaming replication by introducing custom PostgreSQL configuration.

Upcoming work includes:

- Custom `postgresql.conf`
- Custom `pg_hba.conf`
- WAL configuration
- Replication user
- Replication-ready primary node

---

# Upcoming Entries

The following milestones will be documented as they are completed:

- PostgreSQL Replication
- Backup & Recovery
- Point-in-Time Recovery (PITR)
- Monitoring Stack
- Logging Stack
- Spring Boot Control Plane
- High Availability
- CI/CD Pipeline
- Production Hardening

---

# Engineering Notes

## Engineering Workflow

The project follows the workflow:

```text
Design
    ↓
Implement
    ↓
Verify
    ↓
Document
    ↓
Commit
    ↓
Push
```

This workflow ensures that every change is intentional, validated, and documented.

---

# PostgreSQL Commands Learned

```sql
SELECT version();

SELECT current_database();

SELECT current_user();

SELECT inet_server_addr(), inet_server_port();
```

---

# Docker Commands Learned

```bash
docker compose up -d

docker ps

docker logs <container>

docker network ls

docker network inspect <network>

docker volume ls

docker volume inspect <volume>

docker exec -it <container> psql -U postgres -d postgresops
```

---

# Performance Benchmarks

## Primary Node Startup

- PostgreSQL initialization completed successfully.
- Container startup completed without errors.
- Persistent volume successfully mounted.
- Database ready to accept connections.

*(More benchmarks will be added as monitoring is introduced.)*

---

# Problems Encountered

## Docker Compose Automatic Resource Prefixing

Docker Compose automatically prefixes networks and volumes with the project name unless explicit names are configured.

This behavior should be considered when writing automation scripts.

---

# Future Improvements

- Add Docker health checks.
- Use explicit network and volume names.
- Introduce Docker Compose profiles.
- Split infrastructure into multiple Compose files as the project grows.
- Replace environment variables with Docker Secrets during the security phase.
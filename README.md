# Internal Package Management System

An end-to-end DevOps lab that simulates an air-gapped enterprise Linux environment.

Clients cannot install from the internet. Every package comes from a controlled internal YUM repository, then gets rolled out consistently using Ansible automation.

## Why This Project Matters
- Demonstrates real-world package governance patterns used in restricted enterprise networks.
- Shows the progression from manual administration to repeatable infrastructure automation.
- Combines Linux package management, container orchestration, and configuration management in one workflow.

## Tech Stack
- Rocky Linux 8 (container base)
- Docker Compose (multi-service environment)
- nginx + createrepo (internal YUM hosting)
- Bash scripting (repo maintenance and sync)
- Ansible (fleet-wide client configuration and installs)
- Makefile + .env (operational consistency)

## Project Status
| Phase | Focus | Status |
|-------|-------|--------|
| Phase 1 | Internal YUM repository + multi-container foundation | Completed |
| Phase 2 | Bash + Ansible automation | Completed |
| Phase 3 | GPG signing + multi-server patch rollout | Planned |
| Phase 4 | CI/CD integration | Planned |

## Architecture Snapshot
| Service | Responsibility |
|--------|----------------|
| `repo-server` | Hosts RPMs, updates metadata, serves repo via nginx |
| `web-server` | Client host managed by Ansible |
| `db-server` | Client host managed by Ansible |
| `backup-server` | Client host managed by Ansible |
| `ansible-controller` | Executes playbooks across all clients over SSH |

Network: all services communicate on the `pkgnet` Docker bridge network.

Repository endpoints:
- Internal: `http://repo-server/repos/yum_local/`
- Host machine: `http://localhost:8081/repos/yum_local/`

## Demo Flow

### 1) Start the environment
```bash
docker-compose up --build
```

### 2) Configure all clients with one command
```bash
make ansible-configure
```

### 3) Install a package everywhere
```bash
make ansible-install PKG=wget
```

### 4) Add a new RPM to the internal repository
```bash
make add-pkg PKG=./packages/downloaded_rpms/curl.rpm
```

### 5) Run manual sync and validation
```bash
make sync
make test
docker-compose ps
```

## Automation Highlights
- Health-gated startup: clients wait for `repo-server` to be healthy.
- Centralized config: environment values managed via `.env`.
- Repeatable ops: standardized commands through `Makefile` targets.
- Fleet management: Ansible playbooks configure repo settings and install packages across all clients.
- Scheduled maintenance model: cron-style sync script keeps metadata and packages fresh.

## Key Commands
```bash
make up
make down
make rebuild
make ansible-configure
make ansible-install PKG=wget
make add-pkg PKG=./packages/downloaded_rpms/curl.rpm
make sync
make test
```

## What I Learned
- How internal package repositories are structured and maintained (`createrepo --update`).
- How to model production-like server groups with Docker networking.
- How to convert repetitive shell work into declarative Ansible playbooks.
- How to make operations safer through health checks, environment-driven config, and consistent command interfaces.
- How DevOps maturity grows from manual execution toward deterministic, auditable automation.

## Next Improvements
- GPG sign repository metadata and enforce signature checks on clients.
- Add staged rollout strategy for package updates.
- Integrate CI/CD to run automated validation on every infrastructure change.

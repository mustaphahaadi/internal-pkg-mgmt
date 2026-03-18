# Architecture — Phase 2

## Overview
This project simulates an air-gapped Linux environment where client
servers install packages only from an internal YUM repository served
by nginx. In Phase 2, Ansible automates repository configuration and
package installation across all client containers.

## Components

| Container           | Role                                                    | Internet? |
|---------------------|---------------------------------------------------------|-----------|
| repo-server         | Hosts RPMs, builds repo metadata, serves via nginx      | Build only|
| web-server          | Client host managed by Ansible                          | ❌ No     |
| db-server           | Client host managed by Ansible                          | ❌ No     |
| backup-server       | Client host managed by Ansible                          | ❌ No     |
| ansible-controller  | Runs playbooks against all clients over internal SSH    | ❌ No     |

## Network
All containers share a Docker bridge network called `pkgnet`.
Service-to-service communication uses container hostnames.
The internal repository is reached by clients at:
`http://repo-server/repos/yum_local/`

The repository is exposed to the host machine on port `8081`:
`http://localhost:8081/repos/yum_local/`

## Automation Flow (Phase 2)
1. `make up` (or `make rebuild`) starts all services.
2. `repo-server` healthcheck must pass before clients/ansible dependents continue.
3. Clients start SSH service and become reachable by `ansible-controller`.
4. `make ansible-configure` runs `configure-repo.yml` and ensures:
	- `dnf-plugins-core` is installed
	- all default repos are disabled
	- `yum_local.repo` points to the internal repo
5. `make ansible-install PKG=<name>` installs a package from `yum_local` on all clients.

## Package Flow
1. RPMs are stored under `packages/downloaded_rpms/`.
2. `repo-server/setup-repo.sh` updates metadata with `createrepo --update`.
3. nginx serves the repository to clients.
4. Clients install packages only from `yum_local`.

## Key Paths
- `docker-compose.yml` — service orchestration and dependencies
- `ansible/inventory.ini` — Ansible target hosts and SSH settings
- `ansible/playbooks/configure-repo.yml` — repo bootstrap on all clients
- `ansible/playbooks/install-package.yml` — package rollout on all clients
- `scripts/cron-sync.sh` — scheduled package sync/update logic

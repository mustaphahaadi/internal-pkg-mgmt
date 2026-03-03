# Architecture — Phase 1

## Overview
Simulates an air-gapped company environment where production
servers have NO internet access. All packages are installed
from an internal YUM repository.

## Components

| Container     | Role                        | Internet? |
|---------------|-----------------------------|-----------|
| repo-server   | Hosts RPMs, serves via nginx| Build only|
| web-server    | Client — simulates web app  | ❌ No     |
| db-server     | Client — simulates database | ❌ No     |
| backup-server | Client — simulates backup   | ❌ No     |

## Network
All containers share a Docker bridge network called `pkgnet`.
Clients resolve `repo-server` by hostname automatically.

## Package Flow
1. RPMs placed in ./packages/downloaded_rpms/ on host
2. repo-server copies them and runs createrepo on startup
3. nginx serves the repo at http://repo-server/repos/yum_local/
4. Clients install packages via: dnf install --repo=yum_local <pkg>

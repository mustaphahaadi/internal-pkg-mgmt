# 🗄️ Internal Package Management System

> Simulating an air-gapped enterprise Linux environment where servers
> have no internet access — all packages come from a controlled
> internal YUM repository.

## 📖 My Learning Journey
I'm building this project incrementally to learn:
- Linux package management (YUM/DNF/RPM)
- Docker and container networking
- nginx as a file server
- Ansible automation (Phase 2)
- CI/CD pipeline integration (Phase 4)

## 🗺️ Project Phases
| Phase | Description | Status |
|-------|-------------|--------|
| Phase 1 | Local YUM repo + Docker multi-container setup | 🔧 In Progress |
| Phase 2 | Bash + Ansible automation | 📋 Planned |
| Phase 3 | GPG signing + multi-server patch rollout | 📋 Planned |
| Phase 4 | CI/CD pipeline integration | 📋 Planned |

## 🚀 Quick Start (Phase 1)

### Prerequisites
- Docker + Docker Compose installed

### Run it
```bash
docker-compose up --build
```

### Install a package on a client
```bash
# Exec into any client container
docker exec -it web-server bash

# Install a package from the local repo
dnf install --disablerepo="*" --enablerepo="yum_local" -y wget
```

### Add a new package to the repo
```bash
./scripts/add-package.sh /path/to/your.rpm
```

### Browse the repo
Open http://localhost:8080/repos/yum_local/ in your browser.

## 📚 What I Learned
*(Updating as I go)*
- ...

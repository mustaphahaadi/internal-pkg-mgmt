# Troubleshooting Guide

> Document errors as you hit them. This is a living document — 
> update it every time you solve a problem.

---

## Phase 1 Issues

### ❌ `repomd.xml` not found
**Error:**
```
Error: Failed to download metadata for repo 'yum_local'
```
**Cause:** `createrepo` hasn't been run yet or the repo directory is empty.
**Fix:**
```bash
docker exec repo-server createrepo /usr/share/nginx/html/repos/yum_local/
```

---

### ❌ Client starts before repo-server is ready
**Error:**
```
curl: (7) Failed to connect to repo-server
```
**Cause:** `depends_on` only waits for container start, not nginx readiness.
**Fix:** Make sure your `docker-compose.yml` uses:
```yaml
depends_on:
  repo-server:
    condition: service_healthy
```
And repo-server has a proper `healthcheck` block.

---

### ❌ `autoindex` not working in nginx
**Error:** Browser shows 403 Forbidden when browsing the repo URL.
**Cause:** `autoindex on` is missing or nginx config wasn't reloaded.
**Fix:**
```bash
docker exec repo-server nginx -t          # test config
docker exec repo-server nginx -s reload   # reload nginx
```

---

### ❌ Package not found in repo
**Error:**
```
No match for argument: wget
```
**Cause:** The RPM isn't in the repo directory OR metadata is stale.
**Fix:**
```bash
# Check what's in the repo
docker exec repo-server ls /usr/share/nginx/html/repos/yum_local/

# Refresh metadata
docker exec repo-server createrepo --update /usr/share/nginx/html/repos/yum_local/
```

---

## Phase 2 Issues

### ❌ Ansible can't connect to containers
**Error:**
```
UNREACHABLE! => connection timeout
```
**Cause:** `ansible_connection=docker` requires containers to be running.
**Fix:**
```bash
# Check all containers are up
docker ps

# If a container is down, restart it
docker-compose up -d <container-name>
```

---

### ❌ Ansible `become: yes` fails
**Error:**
```
sudo: command not found
```
**Cause:** Client container doesn't have sudo installed.
**Fix:** Either install sudo in the client Dockerfile:
```dockerfile
RUN dnf install -y sudo
```
Or run as root directly by setting in `ansible.cfg`:
```ini
become = False
```
Since containers already run as root by default.

---

### ❌ `cron-sync.sh` not downloading packages
**Error:** Script runs but no packages appear.
**Cause:** `packages.txt` not found or `dnf download` not available.
**Fix:**
```bash
# Verify packages.txt is mounted correctly
docker exec repo-server cat /packages/downloaded_rpms/packages.txt

# Install dnf-utils if dnf download is missing
docker exec repo-server dnf install -y dnf-utils
```

---

### ❌ Makefile `add-pkg` fails with "file not found"
**Error:**
```
❌ Error: File not found
```
**Cause:** Wrong path passed to `make add-pkg`.
**Fix:**
```bash
# Use path relative to project root
make add-pkg PKG=./packages/downloaded_rpms/wget.rpm
```

---

## General Docker Tips

| Problem | Command |
|---------|---------|
| See all running containers | `docker ps` |
| See container logs | `docker logs <container>` |
| Rebuild one container | `docker-compose up --build <service>` |
| Wipe everything and restart | `make rebuild` |
| Get a shell in any container | `make shell C=<container-name>` |
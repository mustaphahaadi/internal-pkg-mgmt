# -------------------------------------------------------
# Makefile — shortcuts for common project commands
# Usage: make <target>
# -------------------------------------------------------

include .env
export

# Start all containers
up:
	docker-compose up --build -d

# Stop all containers
down:
	docker-compose down

# View logs
logs:
	docker-compose logs -f

# Rebuild everything from scratch
rebuild:
	docker-compose down -v && docker-compose up --build -d

# Run Phase 1 tests
test:
	bash scripts/test-phase1.sh

# Add a package to the repo
# Usage: make add-pkg PKG=./path/to/package.rpm
add-pkg:
	bash scripts/add-package.sh $(PKG)

# Run the Ansible playbook to configure all clients
ansible-configure:
	docker exec ansible-controller ansible-playbook /ansible/playbooks/configure-repo.yml

# Install a package on all clients via Ansible
# Usage: make ansible-install PKG=wget
ansible-install:
	docker exec ansible-controller ansible-playbook /ansible/playbooks/install-package.yml -e "pkg_name=$(PKG)"

# Run cron sync manually
sync:
	docker exec repo-server bash /scripts/cron-sync.sh

# Exec into a container
# Usage: make shell C=web-server
shell:
	docker exec -it $(C) bash

.PHONY: up down logs rebuild test add-pkg ansible-configure ansible-install sync shell

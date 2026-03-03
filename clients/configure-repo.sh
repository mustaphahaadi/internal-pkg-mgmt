#!/bin/bash
# -------------------------------------------------------
# configure-repo.sh
# Configures this client to use the internal yum repo.
# Disables all default repos — only yum_local is used.
# -------------------------------------------------------

REPO_URL=${REPO_URL:-"http://repo-server/repos/yum_local/"}

echo "==> Disabling all default repos"
dnf config-manager --disable "*" 2>/dev/null || true

echo "==> Configuring yum_local repo pointing to $REPO_URL"
cat > /etc/yum.repos.d/yum_local.repo << EOF
[yum_local]
name=yum_local
baseurl=$REPO_URL
enabled=1
gpgcheck=0
EOF

echo "==> Verifying repo is recognized"
dnf repolist

echo "==> Client is ready. Use: dnf install --repo=yum_local <package>"

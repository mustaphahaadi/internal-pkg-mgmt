#!/bin/bash
# -------------------------------------------------------
# setup-repo.sh
# Copies RPMs from mounted volume into the nginx-served
# directory, then generates YUM repo metadata.
# -------------------------------------------------------

REPO_DIR="/usr/share/nginx/html/repos/yum_local"
PACKAGE_SOURCE="/packages/downloaded_rpms"

echo "==> Copying RPMs from $PACKAGE_SOURCE to $REPO_DIR"
cp -r $PACKAGE_SOURCE/*.rpm $REPO_DIR/ 2>/dev/null || echo "No RPMs found yet — repo will be empty"

echo "==> Generating repo metadata with createrepo"
createrepo $REPO_DIR

echo "==> Repo is ready at http://repo-server/repos/yum_local/"


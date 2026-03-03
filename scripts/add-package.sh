#!/bin/bash
# -------------------------------------------------------
# add-package.sh
# Usage: ./scripts/add-package.sh path/to/package.rpm
#
# Adds a new RPM to the repo and updates the metadata.
# Run this on your HOST machine whenever you add packages.
# -------------------------------------------------------

PACKAGE=$1
REPO_DIR="./packages/downloaded_rpms"

if [ -z "$PACKAGE" ]; then
  echo "Usage: $0 <path-to-rpm>"
  exit 1
fi

echo "==> Copying $PACKAGE to $REPO_DIR"
cp "$PACKAGE" "$REPO_DIR/"

echo "==> Updating repo metadata inside repo-server container"
docker exec repo-server createrepo --update /usr/share/nginx/html/repos/yum_local/

echo "==> Done! Package is now available in the repo."

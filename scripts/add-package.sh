#!/bin/bash
# -------------------------------------------------------
# add-package.sh
# Usage: ./scripts/add-package.sh path/to/package.rpm
#        OR: make add-pkg PKG=./path/to/package.rpm
#
# Adds a new RPM to the repo and refreshes metadata.
# -------------------------------------------------------

set -e    # exit immediately on any error

PACKAGE=$1
REPO_DIR="/usr/share/nginx/html/repos/yum_local"
PACKAGE_SOURCE="./packages/downloaded_rpms"

# Validate input
if [ -z "$PACKAGE" ]; then
  echo "❌ Error: No package specified"
  echo "   Usage: $0 <path-to-rpm>"
  exit 1
fi

if [ ! -f "$PACKAGE" ]; then
  echo "❌ Error: File not found: $PACKAGE"
  exit 1
fi

echo "==> Copying $(basename $PACKAGE) to $PACKAGE_SOURCE"
cp "$PACKAGE" "$PACKAGE_SOURCE/"

echo "==> Updating repo metadata inside repo-server"
docker exec repo-server createrepo --update $REPO_DIR

echo "✅ Done! $(basename $PACKAGE) is now available in the repo."
echo "   Install with: dnf install --enablerepo=yum_local $(basename $PACKAGE .rpm)"

#!/bin/bash
# -------------------------------------------------------
# cron-sync.sh
# Runs inside repo-server on a schedule (cron)
# 1. Downloads any new RPMs defined in packages.txt
# 2. Updates repo metadata with createrepo --update
#
# To run manually: make sync
# -------------------------------------------------------

REPO_DIR="/usr/share/nginx/html/repos/yum_local"
PACKAGES_LIST="/packages/downloaded_rpms/packages.txt"
LOG_FILE="/var/log/repo-sync.log"

echo "[$(date)] ==> Starting repo sync" | tee -a $LOG_FILE

# Step 1: Download packages listed in packages.txt (if file exists)
if [ -f "$PACKAGES_LIST" ]; then
  echo "[$(date)] ==> Downloading packages from packages.txt" | tee -a $LOG_FILE
  while IFS= read -r pkg || [ -n "$pkg" ]; do
    # Skip comments and empty lines
    [[ "$pkg" =~ ^#.*$ || -z "$pkg" ]] && continue
    echo "[$(date)] Downloading: $pkg" | tee -a $LOG_FILE
    dnf download "$pkg" --destdir="$REPO_DIR" 2>&1 | tee -a $LOG_FILE
  done < "$PACKAGES_LIST"
else
  echo "[$(date)] No packages.txt found — skipping download step" | tee -a $LOG_FILE
fi

# Step 2: Refresh metadata for any newly added RPMs
echo "[$(date)] ==> Running createrepo --update" | tee -a $LOG_FILE
createrepo --update $REPO_DIR 2>&1 | tee -a $LOG_FILE

echo "[$(date)] ✅ Sync complete" | tee -a $LOG_FILE

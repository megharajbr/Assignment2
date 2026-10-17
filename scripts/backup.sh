#!/bin/bash
# Purpose: Back up webapp configuration and application files
# Author: Student
# Date: 2026-10-16
# Usage: ./scripts/backup.sh

set -euo pipefail

PROJECT_DIR="$HOME/devops-assignment"
CONFIG_DIR="$PROJECT_DIR/webapp/config"
APP_DIR="$PROJECT_DIR/webapp/app"
BACKUP_DIR="$PROJECT_DIR/webapp/backups"
LOG_DIR="$PROJECT_DIR/webapp/logs"
LOG_FILE="$LOG_DIR/backup.log"

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
ARCHIVE="$BACKUP_DIR/webapp_backup_${TIMESTAMP}.tar.gz"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

if [[ ! -d "$CONFIG_DIR" || ! -d "$APP_DIR" ]]; then
    echo "ERROR: Application or configuration directory is missing"
    log_message "FAILURE: Required source directory missing"
    exit 1
fi

if tar -czf "$ARCHIVE" -C "$PROJECT_DIR" webapp/config webapp/app; then
    echo "Backup created: $ARCHIVE"
else
    echo "ERROR: Backup creation failed"
    log_message "FAILURE: Backup creation failed"
    exit 1
fi

if tar -tzf "$ARCHIVE" > /dev/null; then
    FILE_COUNT=$(tar -tzf "$ARCHIVE" | wc -l)
    echo "Archive verification: PASSED"
    echo "Files in archive: $FILE_COUNT"
    log_message "SUCCESS: $ARCHIVE created and verified; files: $FILE_COUNT"
else
    echo "ERROR: Archive verification failed"
    log_message "FAILURE: Archive verification failed: $ARCHIVE"
    exit 1
fi

mapfile -t BACKUPS < <(
    find "$BACKUP_DIR" -maxdepth 1 -type f \
        -name 'webapp_backup_*.tar.gz' -printf '%f\n' |
        sort -r
)

if (( ${#BACKUPS[@]} > 3 )); then
    for OLD_BACKUP in "${BACKUPS[@]:3}"; do
        rm -- "$BACKUP_DIR/$OLD_BACKUP"
        echo "Deleted old backup: $OLD_BACKUP"
        log_message "Deleted old backup: $OLD_BACKUP"
    done
fi

echo "Current backups:"
ls -lh "$BACKUP_DIR"

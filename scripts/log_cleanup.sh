#!/bin/bash
# Purpose: Compress log files older than 7 days
# Author: Student
# Date: 2026-10-16
# Usage: ./scripts/log_cleanup.sh [--dry-run]

set -euo pipefail

PROJECT_DIR="$HOME/devops-assignment"
CONFIG_FILE="$PROJECT_DIR/webapp/config/app.conf"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "ERROR: Configuration file not found: $CONFIG_FILE"
    exit 1
fi

source "$CONFIG_FILE"

if [[ ! -d "$LOG_DIR" ]]; then
    echo "ERROR: Log directory not found: $LOG_DIR"
    exit 1
fi

MODE="run"

if [[ $# -gt 1 ]]; then
    echo "Usage: $0 [--dry-run]"
    exit 2
fi

if [[ $# -eq 1 ]]; then
    if [[ "$1" == "--dry-run" ]]; then
        MODE="dry-run"
    else
        echo "Usage: $0 [--dry-run]"
        exit 2
    fi
fi

echo "Log directory: $LOG_DIR"

mapfile -d '' OLD_FILES < <(
    find "$LOG_DIR" -maxdepth 1 -type f -name "*.log" \
        -mtime +7 -print0
)

if [[ "$MODE" == "dry-run" ]]; then
    echo "DRY RUN: Files that would be compressed:"
    for FILE in "${OLD_FILES[@]}"; do
        echo "$FILE"
    done
    echo "Files that would be compressed: ${#OLD_FILES[@]}"
    exit 0
fi

COUNT=0

for FILE in "${OLD_FILES[@]}"; do
    gzip -- "$FILE"
    echo "Compressed: $FILE"
    COUNT=$((COUNT + 1))
done

echo "Total files compressed: $COUNT"

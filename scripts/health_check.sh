#!/bin/bash
# Purpose: Check services and log their health status
# Author: Student
# Date: 2026-10-16
# Usage: ./health_check.sh service1 service2

set -euo pipefail

if (( $# == 0 )); then
    echo "Usage: $0 service1 service2 ..."
    exit 2
fi

cd "$HOME/devops-assignment"

LOG_DIR="webapp/logs"
LOG_FILE="$LOG_DIR/health.log"

mkdir -p "$LOG_DIR"

OVERALL_STATUS=0

for SERVICE in "$@"; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    if systemctl is-active --quiet "$SERVICE"; then
        MESSAGE="[$TIMESTAMP] [OK] $SERVICE is active"
    else
        MESSAGE="[$TIMESTAMP] [FAIL] $SERVICE is not active"
        OVERALL_STATUS=1
    fi

    echo "$MESSAGE"
    echo "$MESSAGE" >> "$LOG_FILE"
done

exit "$OVERALL_STATUS"

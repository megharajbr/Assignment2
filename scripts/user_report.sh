#!/bin/bash
# Purpose: Display users with UID 1000 or above
# Author: Student
# Date: 2026-10-16
# Usage: ./scripts/user_report.sh

set -euo pipefail

print_header() {
    printf "%-25s %-10s %-30s %-25s\n" \
        "USERNAME" "UID" "HOME DIRECTORY" "SHELL"
    printf '%s\n' "------------------------------------------------------------------------------------------"
}

print_header

while IFS=: read -r username password uid gid gecos home shell; do
    if [[ "$uid" =~ ^[0-9]+$ ]] && (( uid >= 1000 )); then
        printf "%-25s %-10s %-30s %-25s\n" \
            "$username" "$uid" "$home" "$shell"
    fi
done < /etc/passwd

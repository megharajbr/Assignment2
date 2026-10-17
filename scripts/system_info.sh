#!/bin/bash
# Purpose: Display system information report
# Author: Student
# Date: 2026-10-16
# Usage: ./system_info.sh

set -euo pipefail

HOSTNAME=$(hostname)
CURRENT_USER=$(whoami)
CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')
OS_NAME=$(. /etc/os-release && echo "$PRETTY_NAME")
KERNEL=$(uname -r)
UPTIME=$(uptime -p)
CPU_CORES=$(nproc)
TOTAL_MEMORY=$(free -h | awk '/^Mem:/ {print $2}')
AVAILABLE_MEMORY=$(free -h | awk '/^Mem:/ {print $7}')
DISK_USAGE=$(df -P / | awk 'NR==2 {print $5}' | tr -d '%')
LOGGED_USERS=$(who | wc -l)

echo "===== SYSTEM INFORMATION REPORT ====="
echo "Hostname: $HOSTNAME"
echo "Current User: $CURRENT_USER"
echo "Date and Time: $CURRENT_DATE"
echo "Operating System: $OS_NAME"
echo "Kernel Version: $KERNEL"
echo "Uptime: $UPTIME"
echo "CPU Cores: $CPU_CORES"
echo "Total Memory: $TOTAL_MEMORY"
echo "Available Memory: $AVAILABLE_MEMORY"
echo "Root Disk Usage: ${DISK_USAGE}%"
echo "Logged-in Users: $LOGGED_USERS"

if (( DISK_USAGE > 80 )); then
    echo "WARNING: Root disk usage is above 80%!"
fi

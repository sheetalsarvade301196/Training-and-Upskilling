#!/bin/bash
LOG_DIR="/var/log"
find "$LOG_DIR" -type f -name "*.log" -mtime +7 -exec rm -f {} \;
echo "🗑️ Old log files deleted from $LOG_DIR"

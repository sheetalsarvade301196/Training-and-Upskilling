#!/bin/bash
echo "Check Disk Usage:"
df -h | grep -E '^Filesystem|/dev/sd'
echo "Check Memory Usage:"
free -h
echo "Check CPU Usage:"
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6

#!/bin/bash
echo "Running Services:"
dfd
systemctl list-units --type=service --state=running

#!/bin/bash
echo "Running Services:"
systemctl list-units --type=service --state=running

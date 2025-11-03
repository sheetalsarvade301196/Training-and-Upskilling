#!/bin/
PROCESS="nginx"
if ! pgrep $PROCESS > /dev/null; then
echo "$PROCESS is not running. Restarting..."
sudo systemctl restart $PROCESS
fi
sleep 2
sudo systemctl status $PROCESS

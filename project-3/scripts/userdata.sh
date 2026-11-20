#!/bin/bash

# Generate CPU load for 15 minutes

nohup bash -c '
  timeout 900 bash -c "while true; do :; done" &
  timeout 900 bash -c "while true; do :; done" &
  wait
' >/var/log/cpu-load.log 2>&1 &

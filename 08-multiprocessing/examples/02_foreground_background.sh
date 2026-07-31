#!/bin/bash
# ============================================================
# 02_foreground_background.sh
# Topic: foreground vs background processes, jobs, pgrep (Lab 8).
# ============================================================

echo "Running sleep in the FOREGROUND (terminal will be busy for 5s)..."
sleep 5
echo "Foreground sleep finished, terminal is free again."

echo "Running sleep in the BACKGROUND..."
sleep 60 &
echo "Background job started. Terminal is immediately free."

# List background jobs started from this shell.
jobs

# Find the PID(s) of any process named "sleep".
pgrep sleep

# Get detailed info about one specific PID.
first_sleep_pid=$(pgrep sleep | head -n 1)
ps -o pid,ppid,stat,cmd -p "$first_sleep_pid"

#!/bin/bash
# ============================================================
# Q1 (Modules 8 + 9): Secure environment + process management
#
# SCENARIO:
#   Configure a secure environment with process management
#   capabilities. Create shared_secure with 777 permissions,
#   apply SGID for group inheritance, and Sticky Bit for
#   deletion protection. Inside, create run.sh with SUID
#   enabled. Then generate two background sleep processes,
#   capture their PIDs, verify parent/child relationships with
#   ps, pause/resume the first, terminate the second, and
#   confirm completion via process state checks.
# ============================================================

# --- Directory setup: permissions + special bits ---
mkdir shared_secure
chmod 777 shared_secure
chmod g+s shared_secure      # SGID: new files inherit the directory's group
chmod +t shared_secure         # Sticky Bit: users can only delete their own files

# --- Script with SUID inside the directory ---
touch shared_secure/run.sh
chmod +x shared_secure/run.sh
chmod +s shared_secure/run.sh   # sets BOTH SUID and SGID on the file

# --- Process management ---
sleep 20 &
PID1=$!

sleep 30 &
PID2=$!

# Show PID, PPID, state, and command for both -- proves they are
# children of this script's own process.
ps -o pid,ppid,stat,cmd -p $PID1 $PID2

# Pause the first process and confirm it stopped.
kill -STOP $PID1
ps -o pid,stat,cmd -p $PID1

# Resume it and confirm it's active again.
kill -CONT $PID1
ps -o pid,stat,cmd -p $PID1

# Force-terminate the second process early.
kill -9 $PID2

# Wait for the first (still-running) process to finish naturally.
wait $PID1

echo "All required process management steps completed"

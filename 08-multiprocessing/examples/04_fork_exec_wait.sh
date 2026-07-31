#!/bin/bash
# ============================================================
# 04_fork_exec_wait.sh
# Topic: wait(), and the implicit fork/exec behind every
#        command Bash runs (Lab 8).
# ============================================================

echo "Starting a background process..."
sleep 10 &

# $! captures the PID of the MOST RECENTLY started background process.
pid=$!
echo "Background PID is $pid"

# Pause THIS script here until that background process finishes.
wait "$pid"
echo "The background process has finished. Continuing the script."

# --- Inspecting a process through /proc ---
sleep 30 &
pid2=$!
cat /proc/"$pid2"/status | head -20
kill "$pid2"

# Note: bash does not expose fork() directly like C does. Every
# command you run, and every "&" background job, implicitly does
# a fork() (create a child) followed by an exec() (replace that
# child's memory with the actual program) behind the scenes.

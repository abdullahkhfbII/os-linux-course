#!/bin/bash
# ============================================================
# 03_signals_and_kill.sh
# Topic: signals, kill, killall, pkill (Lab 8).
# ============================================================

sleep 100 &
pid=$!
echo "Started sleep with PID $pid"

# Pause (suspend) the process. STAT should change to T (stopped).
kill -STOP "$pid"
ps -o pid,stat,cmd -p "$pid"

# Resume the paused process. STAT goes back to S (sleeping).
kill -CONT "$pid"
ps -o pid,stat,cmd -p "$pid"

# Politely ask it to terminate (SIGTERM, signal 15 - the default).
kill "$pid"

# Force-terminate a DIFFERENT process (SIGKILL, signal 9 - cannot be ignored).
sleep 200 &
pid2=$!
kill -9 "$pid2"

# Kill every process with the EXACT name "sleep".
killall sleep

# Kill processes matching a PATTERN (more flexible than killall).
pkill slee

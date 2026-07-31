#!/bin/bash
# ============================================================
# Lab 8 - Scenario: Process lifecycle management
#
# TASK (from the original lab):
#   - Display the PID of the parent shell.
#   - Create three background processes with different
#     durations, storing their PIDs.
#   - Print the PID of each child, then display PID, PPID,
#     state, and command for each (parent-child relationship).
#   - Pause the FIRST child, print its state to prove it's
#     stopped, then resume it and print its state again.
#   - Terminate the SECOND child before it finishes naturally,
#     and show it no longer exists.
#   - Wait for the remaining two children to finish, then print
#     a final confirmation message.
# ============================================================

# --- Show the parent shell's own PID ---
echo "Parent shell PID: $$"

# --- Create three background processes with different durations ---
sleep 15 &
PID1=$!

sleep 20 &
PID2=$!

sleep 10 &
PID3=$!

echo "Child 1 PID: $PID1"
echo "Child 2 PID: $PID2"
echo "Child 3 PID: $PID3"

# --- Show PID, PPID, state, and command for all three, proving
#     they are children of this script's process ---
ps -o pid,ppid,stat,cmd -p "$PID1","$PID2","$PID3"

# --- Pause the first child and prove it's stopped ---
kill -STOP "$PID1"
echo "After STOP:"
ps -o pid,stat,cmd -p "$PID1"

# --- Resume the first child and prove it's running/sleeping again ---
kill -CONT "$PID1"
echo "After CONT:"
ps -o pid,stat,cmd -p "$PID1"

# --- Terminate the second child early, before its 20 seconds are up ---
kill -9 "$PID2"

# A short pause to let the system actually remove the process entry.
sleep 1

# ps -p on a PID that no longer exists prints nothing / an error,
# which is exactly how we prove it no longer exists.
if ps -p "$PID2" > /dev/null 2>&1; then
    echo "Child 2 still exists (unexpected)"
else
    echo "Child 2 no longer exists (terminated successfully)"
fi

# --- Wait for the two remaining children (1 and 3) to finish naturally ---
wait "$PID1" "$PID3"

echo "All required process management steps were completed successfully."

#!/bin/bash
# ============================================================
# 01_process_basics.sh
# Topic: viewing processes with ps, pstree, and top (Lab 8).
# ============================================================

# Processes tied to the current terminal only.
ps

# EVERY process on the system, full format (owner, PID, PPID, command).
ps -ef

# The PID of the current shell itself.
echo "My shell's PID is: $$"

# Visualize the process tree (parent-child relationships), with PIDs.
pstree -p

# Live, constantly-updating view of all processes. Press 'q' to quit.
top

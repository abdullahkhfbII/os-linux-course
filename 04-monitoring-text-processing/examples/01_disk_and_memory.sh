#!/bin/bash
# ============================================================
# 01_disk_and_memory.sh
# Topic: free, df, and du commands for system monitoring (Lab 4).
# ============================================================

echo "--- Memory usage ---"
free            # default units
free -g          # gigabytes
free --mega        # megabytes
free --kilo          # kilobytes

echo "--- Disk free space ---"
df               # raw block counts
df -h             # human-readable (e.g. "4.2G")

echo "--- Directory usage ---"
du -h .            # size of current directory and everything inside, human-readable
du -sh .            # -s = summarize into just ONE total line

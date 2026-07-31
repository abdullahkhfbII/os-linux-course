#!/bin/bash
# ============================================================
# 04_monitoring_script.sh
# Topic: check_desktop_size.sh - the full monitoring example
#        from Lab 4, fully commented.
#
# GOAL: warn if the Desktop directory exceeds a size threshold
#       (5 GB in this example), regardless of whether du reports
#       the size in K, M, or G.
# ============================================================

THRESHOLD=5   # threshold in GIGABYTES

# Step 1: get the human-readable total size of Desktop, e.g. "450M" or "2.1G"
# -s = summarize (one line total)   -h = human readable
size_raw=$(du -sh ~/Desktop 2>/dev/null | awk 'NR==1 {print $1}')

# Step 2: separate the NUMBER from the UNIT LETTER using grep.
number=$(echo "$size_raw" | grep -oE "[0-9.]+")
unit=$(echo "$size_raw" | grep -oE "[A-Za-z]+")

# Step 3: convert everything to GIGABYTES so we can compare fairly.
# Bash cannot do decimal math itself, so we use "bc -l" (the "-l" flag
# loads bc's math library, needed for division).
if [ "$unit" = "G" ]; then
    size_in_gb=$number
elif [ "$unit" = "M" ]; then
    size_in_gb=$(echo "$number / 1024" | bc -l)
elif [ "$unit" = "K" ]; then
    size_in_gb=$(echo "$number / 1024 / 1024" | bc -l)
else
    size_in_gb=0
fi

# Step 4: compare against the threshold and report.
result=$(echo "$size_in_gb > $THRESHOLD" | bc -l)

if (( result == 1 )); then
    echo "WARNING: Desktop folder exceeds ${THRESHOLD}G (current: ${size_raw})"
else
    echo "OK: Desktop folder is within the ${THRESHOLD}G limit (current: ${size_raw})"
fi

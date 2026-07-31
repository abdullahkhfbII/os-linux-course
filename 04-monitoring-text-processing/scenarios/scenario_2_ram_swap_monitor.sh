#!/bin/bash
# ============================================================
# Lab 4 - Scenario 2: RAM and Swap monitoring
#
# TASK: check total/used RAM, calculate percentage usage, check
# if Swap is being used, and warn if RAM usage exceeds 80%.
# ============================================================

THRESHOLD=80

# free -m gives numbers in megabytes, one row for Mem and one for Swap.
# awk grabs the "total" (2nd column) and "used" (3rd column) of the
# "Mem:" row specifically.
total_mem=$(free -m | awk '/^Mem:/ {print $2}')
used_mem=$(free -m | awk '/^Mem:/ {print $3}')

# bc handles the percentage math since it may not be a whole number.
percent_used=$(echo "scale=2; ($used_mem / $total_mem) * 100" | bc -l)

echo "RAM used: ${used_mem}MB / ${total_mem}MB (${percent_used}%)"

# Compare the calculated percentage to the threshold.
over_limit=$(echo "$percent_used > $THRESHOLD" | bc -l)

if (( over_limit == 1 )); then
    echo "WARNING: memory usage is critically high (over ${THRESHOLD}%)."
else
    echo "OK: memory usage is within a safe limit."
fi

# --- Check if Swap is being used at all ---
swap_used=$(free -m | awk '/^Swap:/ {print $3}')

if [ "$swap_used" -gt 0 ]; then
    echo "Note: system IS using Swap space (${swap_used}MB)."
else
    echo "Note: system is NOT using Swap space."
fi

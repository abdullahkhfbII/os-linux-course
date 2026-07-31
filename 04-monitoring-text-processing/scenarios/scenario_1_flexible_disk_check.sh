#!/bin/bash
# ============================================================
# Lab 4 - Scenario 1: Flexible disk usage checker
#
# TASK: create a script that checks any filesystem the user
# chooses (e.g. /, tmpfs, /dev/sda1), extracts its usage
# percentage, and warns if it exceeds a threshold (70%).
# ============================================================

THRESHOLD=70

read -p "Enter the filesystem to check (e.g. / or tmpfs): " target_fs

# df -h prints a table; grep pulls out ONLY the line for the
# filesystem the user asked about.
line=$(df -h | grep "$target_fs")

if [ -z "$line" ]; then
    echo "Filesystem '$target_fs' not found."
    exit 1
fi

# The "Use%" column looks like "42%". awk grabs that field (5th
# column in standard df -h output), then grep -oE strips the "%".
usage_percent=$(echo "$line" | awk '{print $5}' | grep -oE "[0-9]+")

if [ "$usage_percent" -gt "$THRESHOLD" ]; then
    echo "WARNING: $target_fs usage is ${usage_percent}%, above the ${THRESHOLD}% threshold!"
else
    echo "OK: $target_fs usage is ${usage_percent}%, within safe limits."
fi

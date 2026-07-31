#!/bin/bash
# ============================================================
# Lab 4 - Scenario 3: File creation + size monitoring with arrays
#
# TASK: create test1.txt, test2.txt, report.txt (report.txt gets
# extra lines so it's bigger). Store filenames in an array, loop
# through them, check each file's size in KB against a threshold,
# and count how many exceeded it.
# ============================================================

THRESHOLD_KB=1   # threshold in kilobytes

# --- Step 1: create the sample files ---
echo "Sample data" > test1.txt
echo "Sample data" > test2.txt

# Make report.txt bigger by appending many lines.
for i in {1..50}; do
    echo "This is report line number $i with some extra text to add size." >> report.txt
done

# --- Step 2: store filenames in an array ---
files=("test1.txt" "test2.txt" "report.txt")

exceeded_count=0

# --- Step 3: loop through the array and check each file's size ---
for file in "${files[@]}"; do
    # du -k gives size in kilobytes; awk grabs just the number.
    size_kb=$(du -k "$file" | awk '{print $1}')

    echo "File: $file  Size: ${size_kb}KB"

    if [ "$size_kb" -gt "$THRESHOLD_KB" ]; then
        echo "  -> exceeds the ${THRESHOLD_KB}KB threshold"
        exceeded_count=$((exceeded_count + 1))
    else
        echo "  -> within the acceptable range"
    fi
done

echo "Total files exceeding threshold: $exceeded_count"

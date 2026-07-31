#!/bin/bash
# ============================================================
# 05_loops.sh
# Topic: for, while, and until loops (Lab 2).
# ============================================================

echo "--- for loop over a fixed list ---"
for item in "apple" "banana" "cherry"; do
    echo "Fruit: $item"
done

echo "--- for loop over a number range (brace expansion) ---"
for i in {1..5}; do
    echo "Number: $i"
done

echo "--- for loop over files (glob pattern) ---"
# NOTE: this only prints something if .txt files exist here.
for file in *.txt; do
    echo "Found file: $file"
done

echo "--- while loop (condition-controlled) ---"
count=1
while [ "$count" -le 5 ]; do
    echo "Count is $count"
    count=$((count + 1))   # arithmetic increment, equivalent to count++
done

echo "--- until loop (opposite of while) ---"
count=1
until [ "$count" -gt 5 ]; do
    echo "Count is $count"
    count=$((count + 1))
done

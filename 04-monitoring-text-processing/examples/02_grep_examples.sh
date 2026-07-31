#!/bin/bash
# ============================================================
# 02_grep_examples.sh
# Topic: filtering text with grep (Lab 4).
# ============================================================

echo -e "apple\nbanana\nApple pie\nCherry" > fruits.txt

echo "--- Show line numbers of matches ---"
grep -n "apple" fruits.txt

echo "--- Show lines that do NOT match (-v) ---"
grep -v "apple" fruits.txt

echo "--- Count matching lines (-c) ---"
grep -c "a" fruits.txt

echo "--- Case-insensitive search (-i) ---"
grep -i "apple" fruits.txt

echo "--- grep combined with a pipe from another command ---"
ps -ef | grep bash

echo "--- Extracting only the matching part with -o and -E ---"
echo "The Desktop folder is 4.5G in size" | grep -oE "[0-9.]+"
echo "The Desktop folder is 4.5G in size" | grep -oE "[0-9.]+" | bc

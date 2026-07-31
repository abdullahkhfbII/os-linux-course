#!/bin/bash
# ============================================================
# 03_awk_and_pipes.sh
# Topic: extracting specific columns with awk, and chaining
#        multiple pipes together (Lab 4).
# ============================================================

printf "row1 col2 col3 col4\nrow2 col2 col3 93\n" > sample.txt
cat sample.txt

echo "--- Print column 4 of row 2 ---"
# NR = current row number, $4 = 4th column of that row
awk 'NR==2 {print $4}' sample.txt

echo "--- Chaining multiple pipes together ---"
# du -sh gives a size like "12K   ." -- awk grabs just the size field,
# grep -oE pulls out only the numeric part.
du -sh . | awk '{print $1}' | grep -oE "[0-9.]+"

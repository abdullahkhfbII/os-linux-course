#!/bin/bash
# ============================================================
# Q4 (Module 5 only): Retail chain backup, cleanup, and disk alert
#
# SCENARIO:
#   A retail chain owner needs to automate:
#     1. Compressed backup of each store's sales reports
#        (Store1/, Store2/, Store3/), with the date in the
#        filename.
#     2. Delete inventory logs in Inventory/ older than 30 days.
#     3. Monitor disk usage daily and alert if free space drops
#        below 10% (i.e. usage goes above 90%).
# ============================================================

# --- Task 1: backup each store with a for loop ---
for store in Store1 Store2 Store3; do
    tar -czvf "${store}_backup_$(date +%F).tar.gz" "$store/"
done

# --- Task 2: delete old inventory logs ---
find Inventory/ -type f -mtime +30 -exec rm -f {} \;

# --- Task 3: disk usage monitoring with a while loop ---
# df -h prints a table; we skip the header line, then read the
# "Use%" column (5th field) from every remaining line.
df -h | grep -v "Filesystem" | awk '{print $5}' | while read -r usage; do
    # Strip the trailing "%" so we can compare it as a plain number.
    num=${usage%\%}
    if [ "$num" -gt 90 ]; then
        echo "WARNING: Disk usage exceeds 90% (free space below 10%)!"
    fi
done

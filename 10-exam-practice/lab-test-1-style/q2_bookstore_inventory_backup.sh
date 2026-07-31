#!/bin/bash
# ============================================================
# Q2 (Modules 3 + 5): Bookstore inventory automation
#
# SCENARIO:
#   A vintage bookstore needs two daily tasks automated:
#     1. Backup Sales Data: compress all sales reports stored
#        in month-named directories (e.g. sales_03, sales_04)
#        into timestamped .tar.gz archives.
#     2. Clean Old Inventory Logs: remove log files older than
#        60 days from /store_logs.
#   Create two scripts (backup_sales.sh and clean_logs.sh),
#   schedule them at 2:00 AM and 3:00 AM respectively, and use
#   loops to handle multiple directories/files.
# ============================================================

# --- Script 1: backup every sales_* directory ---
cat << 'EOF_SCRIPT' > backup_sales.sh
#!/bin/bash
# Loop over every directory matching the "sales_*" pattern
# (a glob, expanded automatically by bash before the loop runs).
for dir in /store_sales/sales_*; do
    tar -czvf "${dir}_backup_$(date +%F).tar.gz" "$dir"
done
EOF_SCRIPT

chmod +x backup_sales.sh

# --- Script 2: clean up old log files ---
cat << 'EOF_SCRIPT' > clean_logs.sh
#!/bin/bash
find /store_logs -type f -mtime +60 -exec rm -f {} \;
EOF_SCRIPT

chmod +x clean_logs.sh

# --- Schedule both scripts with cron ---
(crontab -l 2>/dev/null; echo "0 2 * * * $(pwd)/backup_sales.sh") | crontab -
(crontab -l 2>/dev/null; echo "0 3 * * * $(pwd)/clean_logs.sh") | crontab -

crontab -l

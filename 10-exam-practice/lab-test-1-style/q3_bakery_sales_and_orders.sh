#!/bin/bash
# ============================================================
# Q3 (Module 5 only): Bakery sales log backup & order cleanup
#
# SCENARIO:
#   A bakery needs two automated tasks:
#     1. Daily Backup of Sales Logs: compress
#        /home/bakery/sales_logs into
#        sales_backup_YYYY-MM-DD.tar.gz at midnight daily.
#     2. Cleanup of Old Orders: delete files in
#        /home/bakery/old_orders not modified in over 30 days.
#   Combine both operations into one script, scheduled with cron.
# ============================================================

mkdir -p /home/bakery/backups

cat << 'EOF_SCRIPT' > backup_sales.sh
#!/bin/bash
# Task 1: timestamped backup of the sales logs directory.
tar -czvf /home/bakery/backups/sales_backup_$(date +%F).tar.gz /home/bakery/sales_logs

# Task 2: delete old order files (not modified in 30+ days).
find /home/bakery/old_orders -type f -mtime +30 -exec rm -f {} \;
EOF_SCRIPT

chmod +x backup_sales.sh

# Schedule this combined script daily at midnight.
(crontab -l 2>/dev/null; echo "0 0 * * * $(pwd)/backup_sales.sh") | crontab -

crontab -l

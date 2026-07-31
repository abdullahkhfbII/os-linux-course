#!/bin/bash
# ============================================================
# Lab 5 - Scenario 3: Full automated backup + cleanup system
#
# TASK:
#   1. Back up /var/logs into a timestamped archive, scheduled
#      to run on the 5th of every month.
#   2. Find files in Documents/ not modified in over 30 days,
#      delete them via a script, scheduled every Thursday at 4pm.
# ============================================================

# --- Part 1: automated backup script ---
cat << 'EOF_SCRIPT' > backup_logs.sh
#!/bin/bash
tar -czvf /backups/logs_backup_$(date +%F_%H-%M).tar.gz /var/logs
EOF_SCRIPT

chmod +x backup_logs.sh

# Schedule: at minute 0, hour 0, on day 5 of every month.
(crontab -l 2>/dev/null; echo "0 0 5 * * $(pwd)/backup_logs.sh") | crontab -

# --- Part 2: file clean-up script ---
cat << 'EOF_SCRIPT' > clean_old_documents.sh
#!/bin/bash
find ~/Documents -type f -mtime +30 -exec rm {} \;
EOF_SCRIPT

chmod +x clean_old_documents.sh

# Schedule: at minute 0, hour 16 (4 PM), every Thursday (day-of-week = 4).
(crontab -l 2>/dev/null; echo "0 16 * * 4 $(pwd)/clean_old_documents.sh") | crontab -

crontab -l

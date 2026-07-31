#!/bin/bash
# ============================================================
# Q6 (Modules 5 + 6): Network interface monitoring + log backups
#
# SCENARIO:
#   A university IT technician must:
#     1. Create a script to display active network interfaces
#        using the ip command.
#     2. Schedule it to run daily at 2:00 AM.
#     3. Compress /var/log into a dated .tar archive.
#     4. Schedule the backup weekly on Sundays at 3:00 AM.
#     5. Verify the cron jobs are active using crontab -l.
# ============================================================

# --- Script 1: show network interfaces ---
cat << 'EOF_SCRIPT' > /home/net_monitor.sh
#!/bin/bash
echo "Active network interfaces:"
ip addr show
EOF_SCRIPT

chmod +x /home/net_monitor.sh

(crontab -l 2>/dev/null; echo "0 2 * * * /home/net_monitor.sh") | crontab -

# --- One-time backup, run immediately ---
tar -cvf /home/logs_backup_$(date +%Y%m%d).tar /var/log

# --- Schedule the SAME backup weekly, Sundays at 3:00 AM ---
# Note: the backticks/escaped % below let cron and date cooperate --
# a literal "%" inside a crontab line must be escaped as "\%",
# otherwise cron treats it as a newline character.
(crontab -l 2>/dev/null; echo "0 3 * * 0 tar -cvf /home/logs_backup_\$(date +\%Y\%m\%d).tar /var/log") | crontab -

# --- Verify ---
crontab -l

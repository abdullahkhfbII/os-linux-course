#!/bin/bash
# ============================================================
# Q10 (Modules 4 + 5 + 8): Full university server maintenance
#
# SCENARIO:
#   A comprehensive maintenance solution needs:
#     1. A script that monitors disk usage (df -h), identifies
#        directories over 80% utilization, logs results to
#        /var/monitoring/disk_report.txt, run daily at 2:00 AM.
#     2. A backup script compressing /home/students monthly on
#        the 1st.
#     3. A cleanup script deleting files older than 60 days from
#        /var/log, weekly Sundays at 3:00 PM.
#     4. A process management script spawning three children:
#        two sleep processes (50s, 100s) as long tasks, a loop
#        checking/pausing/resuming the first every 10s, and
#        terminating the second. PID/PPID/state of all processes
#        logged to /var/monitoring/process_report.txt.
#   All scripts verify success with if/grep checks.
# ============================================================

mkdir -p /var/monitoring

# --- Script 1: disk usage monitor ---
cat << 'EOF_SCRIPT' > /var/monitoring/monitor_disk.sh
#!/bin/bash
df -h >> /var/monitoring/disk_report.txt || echo "Disk check failed"
EOF_SCRIPT
chmod +x /var/monitoring/monitor_disk.sh
(crontab -l 2>/dev/null; echo "0 2 * * * /var/monitoring/monitor_disk.sh") | crontab -

# --- Script 2: monthly backup of /home/students ---
cat << 'EOF_SCRIPT' > /var/monitoring/backup_students.sh
#!/bin/bash
tar -czvf /var/backups/students_backup_$(date +%F).tar.gz /home/students || echo "Backup failed"
EOF_SCRIPT
chmod +x /var/monitoring/backup_students.sh
(crontab -l 2>/dev/null; echo "0 0 1 * * /var/monitoring/backup_students.sh") | crontab -

# --- Script 3: weekly log cleanup ---
cat << 'EOF_SCRIPT' > /var/monitoring/cleanup_logs.sh
#!/bin/bash
find /var/log -type f -mtime +60 -exec rm -f {} \; || echo "Cleanup failed"
EOF_SCRIPT
chmod +x /var/monitoring/cleanup_logs.sh
(crontab -l 2>/dev/null; echo "0 15 * * 0 /var/monitoring/cleanup_logs.sh") | crontab -

# --- Script 4: process management with logging ---
cat << 'EOF_SCRIPT' > /var/monitoring/process_control.sh
#!/bin/bash
sleep 50 &
PID1=$!

sleep 100 &
PID2=$!

ps -p $PID1,$PID2 -o pid,ppid,state,cmd >> /var/monitoring/process_report.txt

kill -STOP $PID1
sleep 10
kill -CONT $PID1

kill -9 $PID2
wait $PID1

echo "Process management complete" >> /var/monitoring/process_report.txt

# Verify the log file actually exists before finishing.
# (-f checks if a regular FILE exists, -d checks if a DIRECTORY exists)
if [ -f /var/monitoring/process_report.txt ]; then
    echo "Process log exists"
else
    echo "Error: Process log missing"
fi
EOF_SCRIPT
chmod +x /var/monitoring/process_control.sh

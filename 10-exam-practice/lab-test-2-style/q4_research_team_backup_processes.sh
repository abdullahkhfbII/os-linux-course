#!/bin/bash
# ============================================================
# Q4 (Modules 3 + 5 + 8): Research team environment
#
# SCENARIO:
#   Create a secure Linux environment for a research team with
#   automated backups and process control:
#     - User 'researcher' in group 'research', owning
#       /home/researcher/Research.
#     - Subdirectories 'Data' and 'Reports' inside it.
#     - Compress 'Data' into Research_Data_backup.tar daily at
#       midnight via cron.
#     - Script to spawn two background processes, monitor
#       states, pause one, resume, terminate the other, verify
#       final states.
#     - All directories: 775 permissions for group access.
# ============================================================

sudo groupadd research
sudo useradd -G research researcher

mkdir -p /home/researcher/Research/Data /home/researcher/Research/Reports
sudo chown -R researcher:research /home/researcher
sudo chmod -R 775 /home/researcher

# One-time backup, run immediately.
tar -czvf Research_Data_backup.tar.gz /home/researcher/Research/Data

# Schedule the same backup to run daily at midnight via cron.
(crontab -l 2>/dev/null; echo "0 0 * * * tar -czvf /home/researcher/Research_Data_backup_\$(date +\%F).tar.gz /home/researcher/Research/Data") | crontab -

# --- Process management script ---
cat << 'EOF_SCRIPT' > process_control.sh
#!/bin/bash
sleep 60 &
PID1=$!

sleep 120 &
PID2=$!

ps -p $PID1 -o pid,ppid,state,comm

kill -STOP $PID1
sleep 5
ps -p $PID1 -o pid,ppid,state,comm

kill -CONT $PID1
kill $PID2

wait $PID1
echo "Process management complete"
EOF_SCRIPT

chmod +x process_control.sh

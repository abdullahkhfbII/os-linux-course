#!/bin/bash
# ============================================================
# Q5 (Modules 3 + 5 + 8): University lab environment
#
# SCENARIO:
#   Automate system backups, manage user access, and demonstrate
#   process control in a university lab:
#     - Group lab_users, users student1 and student2 in it.
#     - /home/shared_lab, all lab_users can read/write/execute.
#     - monitor.sh: two background processes (sleep 100, sleep
#       200), print PID/PPID/state/command, pause first, verify
#       stopped, resume it, kill second, wait for the rest.
#     - Schedule monitor.sh daily at 2:00 AM.
#     - Compress /home/shared_lab into a timestamped tarball.
# ============================================================

sudo groupadd lab_users
sudo useradd -G lab_users student1
sudo useradd -G lab_users student2

sudo mkdir /home/shared_lab
sudo chown :lab_users /home/shared_lab
sudo chmod 2775 /home/shared_lab    # 2775 = SGID + rwxrwxr-x, giving the group full rwx

# --- The monitoring / process management script ---
cat << 'EOF_SCRIPT' > /home/monitor.sh
#!/bin/bash
sleep 100 &
PID1=$!

sleep 200 &
PID2=$!

ps -o pid,ppid,state,command --pid $PID1 $PID2

kill -STOP $PID1 && ps -o pid,state --pid $PID1
kill -CONT $PID1 && ps -o pid,state --pid $PID1

kill -9 $PID2

wait $PID1
EOF_SCRIPT

chmod +x /home/monitor.sh

# Schedule monitor.sh to run daily at 2:00 AM.
(crontab -l 2>/dev/null; echo "0 2 * * * /home/monitor.sh") | crontab -

# Compress /home/shared_lab with a timestamp in the filename.
tar -cvf /home/shared_lab_backup_$(date +%Y%m%d).tar /home/shared_lab

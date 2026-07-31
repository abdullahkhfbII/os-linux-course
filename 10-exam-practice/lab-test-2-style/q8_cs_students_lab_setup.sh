#!/bin/bash
# ============================================================
# Q8 (Modules 3 + 5 + 6 + 8 + 9): CS lab environment
#
# SCENARIO:
#   As system administrator for a university computing lab:
#     - Group cs_students, user alice with sudo privileges.
#     - Project directory /home/cs_students/project with SGID +
#       Sticky Bit.
#     - Script monitor_processes.sh: two background processes
#       (sleep 60, sleep 90), display PID/PPID/state, pause the
#       first, resume it, terminate the second after 20 seconds.
#     - Monthly backup of the project directory on the 1st via
#       cron.
#     - Verify network interfaces and confirm backup execution.
# ============================================================

sudo groupadd cs_students
sudo adduser alice
sudo usermod -aG sudo alice

sudo mkdir -p /home/cs_students/project
sudo chown :cs_students /home/cs_students/project
sudo chmod 2770 /home/cs_students/project   # 2 = SGID, 770 = group rwx access
sudo chmod +t /home/cs_students/project       # add Sticky Bit deletion protection

cat << 'EOF_SCRIPT' > monitor_processes.sh
#!/bin/bash
sleep 60 &
PID1=$!

sleep 90 &
PID2=$!

echo "PID1=$PID1, PID2=$PID2"
ps -o pid,ppid,state,cmd -p $PID1,$PID2

kill -STOP $PID1
sleep 5
kill -CONT $PID1

sleep 20
kill -9 $PID2

echo "Process management complete"
EOF_SCRIPT

chmod +x monitor_processes.sh

(crontab -l 2>/dev/null; echo "0 0 1 * * tar -czvf /backups/project_backup-\$(date +\%F).tar.gz /home/cs_students/project") | crontab -

ip addr show

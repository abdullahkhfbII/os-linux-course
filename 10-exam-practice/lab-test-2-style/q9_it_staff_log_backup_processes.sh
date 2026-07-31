#!/bin/bash
# ============================================================
# Q9 (Modules 3 + 5 + 8): IT staff access + monthly log backup
#
# SCENARIO:
#   A university IT department needs:
#     - Group it_staff, user admin with access to /srv/logs.
#     - Monthly cron backup of /var/log to a dated .tar.gz on
#       the 5th of each month.
#     - A script launching two background processes (sleep 120,
#       sleep 180), showing PID/PPID/state, pausing the first,
#       resuming it, terminating the second, waiting for the
#       rest.
#     - Clean up files in /home/admin older than 30 days.
# ============================================================

sudo groupadd it_staff
sudo useradd -G it_staff admin
sudo chown :it_staff /srv/logs

(crontab -l 2>/dev/null; echo "0 0 5 * * tar -czvf /backups/logs_\$(date +\%F).tar.gz /var/log") | crontab -

cat << 'EOF_SCRIPT' > backup_cleanup.sh
#!/bin/bash
sleep 120 &
PID1=$!

sleep 180 &
PID2=$!

ps -o pid,ppid,state,cmd -p $PID1,$PID2

kill -STOP $PID1
ps -o pid,state -p $PID1

kill -CONT $PID1
ps -o pid,state -p $PID1

kill $PID2

wait $PID1
echo "Process management completed"
EOF_SCRIPT

chmod +x backup_cleanup.sh
./backup_cleanup.sh

find /home/admin -type f -mtime +30 -delete

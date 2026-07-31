#!/bin/bash
# ============================================================
# Q11 (Modules 5 + 8): Student backups, log cleanup, process manager
#
# SCENARIO:
#   1. Automated Backups: monthly backup of /home/students with
#      the date in the filename, scheduled 1st of each month at
#      2 AM.
#   2. Log Cleanup: delete .log files older than 30 days in
#      /var/log, weekly on Sundays at 1 AM.
#   3. Process Management: script starting 3 background
#      "sleep 10" processes, printing PID/PPID/state/command for
#      each with a for loop, pausing/resuming the first,
#      terminating the second, waiting for the rest, and
#      displaying a confirmation.
# ============================================================

mkdir -p /scripts

# --- Task 1: monthly backup ---
(crontab -l 2>/dev/null; echo "0 2 1 * * tar -czvf /backups/students_backup-\$(date +\%Y-\%m-\%d).tar.gz /home/students") | crontab -

# --- Task 2: weekly log cleanup ---
(crontab -l 2>/dev/null; echo "0 1 * * 0 find /var/log -type f -name '*.log' -mtime +30 -exec rm -f {} \;") | crontab -

# --- Task 3: process management script ---
cat << 'EOF_SCRIPT' > /scripts/process_manager.sh
#!/bin/bash
sleep 10 &
PID1=$!

sleep 10 &
PID2=$!

sleep 10 &
PID3=$!

PIDS=($PID1 $PID2 $PID3)

echo "Parent PID: $$"

for pid in "${PIDS[@]}"; do
    ps -o pid,ppid,state,cmd -p "$pid"
done

kill -STOP "$PID1"
sleep 1
ps -o pid,ppid,state,cmd -p "$PID1"

kill -CONT "$PID1"
kill -9 "$PID2"

wait "${PIDS[@]}"
echo "All tasks completed."
EOF_SCRIPT

chmod +x /scripts/process_manager.sh

#!/bin/bash
# ============================================================
# Lab 4+5 - "Extra" combined scenario: memory monitoring
#
# TASK: check memory usage, and set up a script that logs memory
# usage every minute to a file. If memory drops below a certain
# threshold, save a warning to the log too.
# ============================================================

THRESHOLD_MB=500   # warn if AVAILABLE memory drops below this

# --- Check memory usage once, immediately ---
free -m

# --- The logging script itself ---
cat << 'EOF_SCRIPT' > log_memory.sh
#!/bin/bash
THRESHOLD_MB=500
available=$(free -m | awk '/^Mem:/ {print $7}')  # "available" column
timestamp=$(date +"%F %T")

if [ "$available" -lt "$THRESHOLD_MB" ]; then
    echo "$timestamp - WARNING: available memory low (${available}MB)" >> ~/memory_log.txt
else
    echo "$timestamp - OK: available memory is ${available}MB" >> ~/memory_log.txt
fi
EOF_SCRIPT

chmod +x log_memory.sh

# --- Schedule it to run every minute using cron ---
(crontab -l 2>/dev/null; echo "* * * * * $(pwd)/log_memory.sh") | crontab -

crontab -l

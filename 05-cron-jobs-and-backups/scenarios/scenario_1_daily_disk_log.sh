#!/bin/bash
# ============================================================
# Lab 5 - Scenario 1: Daily disk usage log
#
# TASK: run "df -h" automatically every day at 8:30 AM, saving
# the output into ~/disk_usage_log.txt so usage can be reviewed
# over time.
# ============================================================

# Add a cron job: at minute 30, hour 8, every day, run df -h and
# APPEND its output to the log file.
(crontab -l 2>/dev/null; echo "30 8 * * * df -h >> ~/disk_usage_log.txt") | crontab -

# Verify it was added.
crontab -l

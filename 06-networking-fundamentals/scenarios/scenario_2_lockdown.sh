#!/bin/bash
# ============================================================
# Lab 6 - Scenario 2: lockdown.sh
#
# TASK: every Sunday at midnight, revoke SSH access for all
# "temporary" student accounts.
#
# Steps:
#   1. Store the usernames in an array.
#   2. Loop through the array, appending a DenyUsers line for
#      each one to /etc/ssh/sshd_config.
#   3. Schedule this script itself to run every Sunday at 00:00.
# ============================================================

TEMP_USERS=("student1" "student2" "student3")

for user in "${TEMP_USERS[@]}"; do
    echo "DenyUsers $user" | sudo tee -a /etc/ssh/sshd_config
done

sudo systemctl restart sshd

# Schedule THIS script to run automatically every Sunday at midnight.
# "0 0 * * 0" = minute 0, hour 0, any day-of-month, any month, Sunday (0).
(crontab -l 2>/dev/null; echo "0 0 * * 0 $(pwd)/lockdown.sh") | crontab -

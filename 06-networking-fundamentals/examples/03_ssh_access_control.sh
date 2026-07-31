#!/bin/bash
# ============================================================
# 03_ssh_access_control.sh
# Topic: restricting SSH login access via sshd_config (Lab 6).
#
# ⚠ CAUTION: misconfiguring this file can lock you (or everyone)
# out of SSH. Always keep a second session open while testing.
# ============================================================

# Deny a single user from logging in via SSH.
# We use "sudo tee -a" instead of "sudo echo >>" because the ">>"
# redirection happens BEFORE sudo applies, so plain "sudo echo ... >> file"
# would still try to write as your normal user and fail on a root-owned file.
echo "DenyUsers john" | sudo tee -a /etc/ssh/sshd_config

# Deny multiple users on one line.
echo "DenyUsers mary sam" | sudo tee -a /etc/ssh/sshd_config

# Allow ONLY specific users (denies everyone else not listed).
echo "AllowUsers alice bob" | sudo tee -a /etc/ssh/sshd_config

# Allow/deny based on group membership instead of individual users.
echo "AllowGroups internal_staff" | sudo tee -a /etc/ssh/sshd_config
echo "DenyGroups contractors" | sudo tee -a /etc/ssh/sshd_config

# Restart the SSH daemon so the new configuration takes effect.
sudo systemctl restart sshd

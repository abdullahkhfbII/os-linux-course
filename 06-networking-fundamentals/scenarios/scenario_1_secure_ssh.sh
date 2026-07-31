#!/bin/bash
# ============================================================
# Lab 6 - Scenario 1: secure_ssh.sh
#
# TASK: a contractor "temp_dev" needs an account but must NEVER
# log in via SSH. Only the "internal_staff" group should be able
# to access the server remotely.
#
# Steps:
#   1. Add the user temp_dev.
#   2. Create a group internal_staff.
#   3. Add the current user to internal_staff (so we don't lock
#      ourselves out).
#   4. Update /etc/ssh/sshd_config to deny temp_dev and allow
#      only the internal_staff group.
# ============================================================

sudo useradd temp_dev

sudo groupadd internal_staff

# $USER holds the username of whoever is running this script.
sudo usermod -aG internal_staff "$USER"

echo "DenyUsers temp_dev" | sudo tee -a /etc/ssh/sshd_config
echo "AllowGroups internal_staff" | sudo tee -a /etc/ssh/sshd_config

sudo systemctl restart sshd

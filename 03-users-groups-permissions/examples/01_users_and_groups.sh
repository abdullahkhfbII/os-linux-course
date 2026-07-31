#!/bin/bash
# ============================================================
# 01_users_and_groups.sh
# Topic: Creating users, setting passwords, expiration rules,
#        creating groups, and adding users to groups (Lab 3).
# ============================================================

# Create a new user (also creates their home directory by default).
sudo useradd alice

# Set (or reset) that user's password. You'll be prompted to type
# it twice.
sudo passwd alice

# --- Account/password expiration rules ---
sudo chage -E 2026-12-31 alice   # account itself expires on this date
sudo chage -M 30 alice            # password must change every 30 days
sudo chage -W 5 alice              # warn 5 days before password expiry
sudo chage -l alice                 # list current expiry settings for alice

# --- Groups ---
sudo groupadd research_team          # create a new, empty group
sudo usermod -aG research_team alice  # ADD alice to the group (-a = append, don't replace)

# List every member of a group.
getent group research_team

# --- Ownership ---
touch report.txt
sudo chown alice report.txt              # change the file's owner
sudo chown :research_team report.txt      # change ONLY the group owner
sudo chown alice:research_team report.txt  # change both owner and group at once

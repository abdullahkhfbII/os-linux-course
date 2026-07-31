#!/bin/bash
# ============================================================
# Lab 3 - Scenario 1: Secure research environment
#
# TASK (from the original lab):
#   - Create a group "research_team".
#   - Create users Ali and Sara, set passwords for both.
#   - Add both users to research_team.
#   - Passwords expire after 30 days, warn 5 days before
#     expiration, accounts expire after 6 months.
#   - Create a directory "research_project".
#   - Owner: Ali, group owner: research_team.
#   - Permissions: owner=rwx, group=r-x, others=none.
#   - Verify with ls -l and calculate the binary permission number.
# ============================================================

# --- Group and users ---
sudo groupadd research_team

sudo useradd Ali
sudo passwd Ali

sudo useradd Sara
sudo passwd Sara

sudo usermod -aG research_team Ali
sudo usermod -aG research_team Sara

# --- Expiration policy for both accounts ---
sudo chage -M 30 Ali
sudo chage -W 5 Ali
sudo chage -E "$(date -d '+6 months' +%Y-%m-%d)" Ali

sudo chage -M 30 Sara
sudo chage -W 5 Sara
sudo chage -E "$(date -d '+6 months' +%Y-%m-%d)" Sara

# --- Directory and ownership ---
sudo mkdir research_project
sudo chown Ali:research_team research_project

# --- Permissions ---
# owner = rwx = 4+2+1 = 7
# group = r-x = 4+1   = 5
# others = --- = 0
# Binary permission number: 750
sudo chmod 750 research_project

# --- Verify ---
ls -l -d research_project

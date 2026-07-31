#!/bin/bash
# ============================================================
# Lab 3 - Scenario 2: Securing financial data
#
# TASK (from the original lab):
#   - Create a user "manager" and a group "finance".
#   - Add manager to the finance group.
#   - Create a file "payroll.txt".
#   - Owner: manager, group: finance.
#   - Permissions: owner=rw, group=r, others=none.
#   - Verify with ls -l and calculate the binary permission number.
# ============================================================

sudo useradd manager
sudo groupadd finance
sudo usermod -aG finance manager

touch payroll.txt
sudo chown manager:finance payroll.txt

# owner = rw- = 4+2   = 6
# group = r-- = 4     = 4
# others = --- = 0
# Binary permission number: 640
sudo chmod 640 payroll.txt

ls -l payroll.txt

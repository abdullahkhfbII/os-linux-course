#!/bin/bash
# ============================================================
# Lab 5 - Scenario 2: Timestamped Documents backup
#
# TASK: create a compressed backup of ~/Documents, stored inside
# ~/Backups, with the current date in the filename so backups
# never overwrite each other.
# ============================================================

mkdir -p ~/Backups

# %F expands to YYYY-MM-DD via the date command substitution.
tar -czvf ~/Backups/Documents_backup_$(date +%F).tar.gz ~/Documents

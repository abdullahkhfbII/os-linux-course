#!/bin/bash
# ============================================================
# 02_backup_and_find.sh
# Topic: creating timestamped backups with tar, and finding /
#        deleting old files with find (Lab 5).
# ============================================================

mkdir -p Documents
touch Documents/file1.txt Documents/file2.txt

# --- Timestamped backup ---
# %F is a date format specifier meaning YYYY-MM-DD.
# $(date +%F) runs immediately and gets replaced with today's date.
tar -czvf Documents_backup_$(date +%F).tar.gz Documents/

# --- Find files older than 30 days (modification time) ---
find Documents/ -type f -mtime +30

# --- Delete files older than 30 days, method 1: using -exec ---
find Documents/ -type f -mtime +30 -exec rm {} \;

# --- Delete files older than 30 days, method 2: using -delete ---
# (equivalent, slightly more efficient, no separate rm process needed)
find Documents/ -type f -mtime +30 -delete

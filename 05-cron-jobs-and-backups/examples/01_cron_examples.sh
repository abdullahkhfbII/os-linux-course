#!/bin/bash
# ============================================================
# 01_cron_examples.sh
# Topic: adding, listing, and removing cron jobs (Lab 5).
#
# NOTE: these commands modify YOUR crontab if actually run.
# Read through them first to understand the syntax.
# ============================================================

# --- Add a new job WITHOUT opening the interactive nano editor ---
# This lists the existing jobs, adds a new line, and feeds it all
# back into crontab.
(crontab -l 2>/dev/null; echo "*/5 * * * * echo \"Running every 5 minutes\" >> ~/cron_demo.txt") | crontab -

# Some more schedule examples (for reference, not all added above):
#   0 * * * *   -> every hour, at minute 0
#   0 18 * * *  -> every day at 6:00 PM
#   0 9 * * 1   -> every Monday at 9:00 AM
#   0 0 1 * *   -> midnight on the 1st of every month

# --- List every scheduled job for the current user ---
crontab -l

# --- Remove ONE specific job (the one matching a pattern) ---
(crontab -l | grep -v "cron_demo.txt") | crontab -

crontab -l

# --- Remove ALL cron jobs (⚠ irreversible!) ---
# crontab -r

# --- Watch a command repeat live on screen every 2 seconds ---
watch df -h

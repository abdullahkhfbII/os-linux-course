#!/bin/bash
# ============================================================
# Q4 (Modules 3 + 5): Remote software development team maintenance
#
# SCENARIO:
#   Automate user management, backups, cleanup, for a remote dev
#   team:
#     - Group 'devteam', developers alice, bob, charlie added.
#     - Shared project directory /home/projects with group write
#       permissions.
#     - Archive all code in /home/projects into a timestamped
#       tarball daily at midnight.
#     - Delete code files in /home/old_code older than 60 days,
#       weekly on Sundays.
#     - All tasks automated via cron jobs.
# ============================================================

sudo groupadd devteam
sudo usermod -aG devteam alice
sudo usermod -aG devteam bob
sudo usermod -aG devteam charlie

sudo mkdir /home/projects
sudo chown :devteam /home/projects
sudo chmod 775 /home/projects

# Daily timestamped archive of the project directory, at midnight.
(crontab -l 2>/dev/null; echo "0 0 * * * tar -czvf /backups/projects_\$(date +\%Y\%m\%d).tar.gz /home/projects") | crontab -

# Weekly cleanup of code files older than 60 days, every Sunday.
(crontab -l 2>/dev/null; echo "0 0 * * 0 find /home/old_code -type f -mtime +60 -delete") | crontab -

crontab -l

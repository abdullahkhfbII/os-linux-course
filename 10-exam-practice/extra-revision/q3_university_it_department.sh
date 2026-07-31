#!/bin/bash
# ============================================================
# Q3 (Modules 2 + 3 + 5): University IT Department system
#
# SCENARIO:
#   Deploy a robust system for managing user access, automating
#   backups, and organizing files:
#     - Group 'faculty' for professors, 'students' for learners.
#     - Each professor has a subdirectory within /shared/research.
#     - Monthly backup of /var/audit, named with the current
#       date, scheduled the 1st of every month.
#     - Script to find/delete files in /shared/research older
#       than 90 days, scheduled weekly Sundays at 2:00 AM.
#     - User directories have group write permissions; cleanup
#       script stored in /scripts/research_cleanup.sh.
# ============================================================

sudo groupadd faculty
sudo groupadd students

sudo useradd -G faculty prof1
sudo useradd -G students std1

sudo mkdir -p /shared/research/prof1
sudo chown -R prof1:faculty /shared/research/prof1
sudo chmod 775 /shared/research

mkdir -p /scripts

# --- Monthly audit backup script ---
cat << 'EOF_SCRIPT' > /scripts/audit_backup.sh
#!/bin/bash
tar -czvf /backups/audit_$(date +%F)_backup.tar.gz /var/audit
EOF_SCRIPT

# --- Cleanup script for files older than 90 days ---
cat << 'EOF_SCRIPT' > /scripts/research_cleanup.sh
#!/bin/bash
find /shared/research -type f -mtime +90 -delete
EOF_SCRIPT

sudo chmod +x /scripts/research_cleanup.sh
sudo chmod +x /scripts/audit_backup.sh

(crontab -l 2>/dev/null; echo "0 0 1 * * /scripts/audit_backup.sh") | crontab -
(crontab -l 2>/dev/null; echo "0 2 * * 0 /scripts/research_cleanup.sh") | crontab -

crontab -l

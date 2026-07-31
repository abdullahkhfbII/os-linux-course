#!/bin/bash
# ============================================================
# Q2 (Modules 2 + 3 + 5): Faculty of Computer Science automation
#
# SCENARIO:
#   Streamline system management for the Faculty of CS:
#     - User accounts for 2 professors, 4 students; professors
#       in "faculty" group, students in "students" group.
#     - Bash script to create directories for each group and
#       individual users under /home/academic, with write
#       permissions for their groups.
#     - Monthly backups of /var/logs into compressed, timestamped
#       archives.
#     - Daily cleanup of files in /home/academic older than 30
#       days, excluding subdirectories.
#     - Validate configurations via cron job listing and script
#       execution testing.
# ============================================================

sudo groupadd faculty
sudo groupadd students

sudo useradd -G faculty prof1
sudo useradd -G faculty prof2

sudo useradd -G students std1
sudo useradd -G students std2
sudo useradd -G students std3
sudo useradd -G students std4

# --- Script to create the directory structure with group write access ---
cat << 'EOF_SCRIPT' > create_directories.sh
#!/bin/bash
mkdir -p /home/academic/faculty /home/academic/students
chown -R :faculty /home/academic/faculty
chown -R :students /home/academic/students
chmod -R 775 /home/academic/faculty /home/academic/students
EOF_SCRIPT

chmod +x create_directories.sh

# Run it once, to validate it works.
bash create_directories.sh

# --- Monthly backup of /var/logs, on the 5th of each month ---
(crontab -l 2>/dev/null; echo "0 5 5 * * tar -czvf /home/backup/logs_backup-\$(date +\%F).tar.gz /var/logs") | crontab -

# --- Daily cleanup: files older than 30 days, NOT subdirectories ---
# "-maxdepth 1" restricts find to the top level only, so it does
# NOT descend into subdirectories, matching the requirement.
(crontab -l 2>/dev/null; echo "0 2 * * * find /home/academic -maxdepth 1 -type f -mtime +30 -delete") | crontab -

# --- Validate: list cron jobs to confirm everything was scheduled ---
crontab -l

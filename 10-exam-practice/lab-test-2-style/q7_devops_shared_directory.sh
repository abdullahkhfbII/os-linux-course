#!/bin/bash
# ============================================================
# Q7 (Modules 3 + 5 + 6 + 9): DevOps shared directory + monitoring
#
# SCENARIO:
#   A university IT department needs:
#     - Group devops, users alice and bob in it.
#     - Shared directory /home/devops/shared, group write access
#       + Sticky Bit protection.
#     - Script monitor_network.sh that displays network
#       interface details, scheduled daily at 10:00 AM.
#     - Compress /var/log into a timestamped .tar.gz weekly on
#       Sundays at midnight.
# ============================================================

sudo groupadd devops
sudo useradd -G devops alice
sudo useradd -G devops bob

sudo mkdir -p /home/devops/shared
sudo chown :devops /home/devops/shared
sudo chmod 1770 /home/devops/shared   # 1 = Sticky Bit, 770 = rwxrwx--- (group write access)

cat << 'EOF_SCRIPT' > monitor_network.sh
#!/bin/bash
ip addr show
EOF_SCRIPT

chmod +x monitor_network.sh

(crontab -l 2>/dev/null; echo "0 10 * * * /home/devops/monitor_network.sh") | crontab -

(crontab -l 2>/dev/null; echo "0 0 * * 0 tar -czvf /backup/logs_backup_\$(date +\%Y\%m\%d).tar.gz /var/log") | crontab -

crontab -l

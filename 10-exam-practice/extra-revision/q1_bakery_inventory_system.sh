#!/bin/bash
# ============================================================
# Q1 (Modules 3 + 5): Bakery inventory & access control
#
# SCENARIO:
#   Manage a local bakery's inventory logs and restrict access
#   to sensitive files. A "Bakers" group with staff baker1,
#   baker2, and a "Suppliers" group with supplier1, supplier2.
#     - Create these groups and user accounts.
#     - Directory structure: /bakery_logs with subdirectories
#       /daily_orders and /supplier_contracts.
#     - Automate weekly backups of /bakery_logs into a tar file
#       named bakery_backup.
# ============================================================

sudo groupadd Bakers
sudo groupadd Suppliers

sudo useradd -G Bakers baker1
sudo useradd -G Bakers baker2

sudo useradd -G Suppliers supplier1
sudo useradd -G Suppliers supplier2

sudo mkdir -p /bakery_logs/daily_orders /bakery_logs/supplier_contracts

# Schedule a weekly backup, every Sunday at midnight, with the
# date embedded in the filename so backups don't overwrite each
# other. The "%" characters must be escaped as "\%" inside a
# crontab line, since cron treats an unescaped "%" specially.
(crontab -l 2>/dev/null; echo "0 0 * * 0 tar -czvf /backups/bakery_backup_\$(date +\%Y\%m\%d).tar.gz /bakery_logs") | crontab -

crontab -l

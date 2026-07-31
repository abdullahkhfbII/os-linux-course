#!/bin/bash
# ============================================================
# Q5 (Modules 2 + 3 + 5): Bakery recipes & order archiving
#
# SCENARIO:
#   Automate backup of digital recipe cards and customer orders,
#   and archive old orders (over 90 days) while retaining daily
#   backups of active recipes:
#     - Directory structure: /bakery/recipes/ and /bakery/orders/.
#     - Generate sample .txt files for 5 recipes and 10 orders
#       using a loop.
#     - Compress recipes/ daily with a timestamped filename.
#     - Delete files in orders/ older than 90 days, on a schedule.
#     - Use cron: backups at 11 PM daily, cleanup at 3 AM weekly.
# ============================================================

sudo mkdir -p /bakery/recipes /bakery/orders /bakery/backups

# --- Generate sample files using loops ---
for i in {1..5}; do
    echo "Recipe $i details" > /bakery/recipes/recipe$i.txt
done

for j in {1..10}; do
    echo "Order $j details" > /bakery/orders/order$j.txt
done

# --- Daily backup script for recipes/ ---
cat << 'EOF_SCRIPT' > /bakery/backups/recipes_backup.sh
#!/bin/bash
tar -czvf /bakery/backups/recipes_backup_$(date +%F).tar.gz /bakery/recipes/
EOF_SCRIPT

# --- Weekly cleanup script for orders/ older than 90 days ---
cat << 'EOF_SCRIPT' > /bakery/backups/orders_cleanup.sh
#!/bin/bash
find /bakery/orders -type f -mtime +90 -exec rm -f {} \;
EOF_SCRIPT

chmod +x /bakery/backups/orders_cleanup.sh
sudo chmod +x /bakery/backups/recipes_backup.sh

# Cron: recipe backups daily at 11 PM, order cleanup weekly Sundays at 3 AM.
(crontab -l 2>/dev/null; echo "0 23 * * * /bakery/backups/recipes_backup.sh") | crontab -
(crontab -l 2>/dev/null; echo "0 3 * * 0 /bakery/backups/orders_cleanup.sh") | crontab -

crontab -l

#!/bin/bash
# ============================================================
# Lab 7 - Scenario: Firewall + scheduled port monitoring
#
# TASK:
#   1. Configure the firewall to:
#        - Allow only HTTPS traffic on port 443.
#        - Deny SSH access for the current user.
#   2. Generate a secondary script that:
#        - Retrieves a list of active ports.
#        - Saves the output to a log file.
#        - Schedules itself to run weekly at 10 AM.
# ============================================================

# --- Part 1: firewall rules ---

# Allow only HTTPS (port 443) traffic in.
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Deny SSH access for the CURRENT user specifically.
# (SSH user-level access control is actually done via sshd_config,
#  as covered in Module 6 -- shown here for the exam-style answer.)
echo "DenyUsers $USER" | sudo tee -a /etc/ssh/sshd_config
sudo systemctl restart sshd

# As a network-layer backup, also block SSH's port at the firewall.
sudo iptables -A INPUT -p tcp --dport 22 -j DROP

# Set the default policy to drop anything not explicitly allowed above.
sudo iptables -P INPUT DROP

# --- Part 2: secondary script - active ports report ---
cat << 'EOF_SCRIPT' > check_active_ports.sh
#!/bin/bash
# Retrieve a list of active ports and save it to a log file.
sudo netstat -tulnp > /var/log/active_ports_$(date +%F).log
EOF_SCRIPT

chmod +x check_active_ports.sh

# Schedule this secondary script to run weekly, every Sunday at 10 AM.
(crontab -l 2>/dev/null; echo "0 10 * * 0 $(pwd)/check_active_ports.sh") | crontab -

crontab -l

#!/bin/bash
# ============================================================
# 02_iptables_firewall.sh
# Topic: configuring the iptables firewall (Lab 7).
#
# ⚠ CAUTION: always allow your OWN access method (e.g. SSH on
# port 22) BEFORE setting a DROP default policy, or you may
# lock yourself out of a remote machine.
# ============================================================

# --- Allow specific incoming traffic ---
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT   # SSH
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT    # HTTP
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT    # HTTPS

# --- Block a specific IP address entirely ---
sudo iptables -A INPUT -s 203.0.113.5 -j DROP

# --- View current rules ---
sudo iptables -L -v -n

# --- Set the default policy for the INPUT chain ---
# (add your ACCEPT rules FIRST, as done above, before this line)
sudo iptables -P INPUT DROP

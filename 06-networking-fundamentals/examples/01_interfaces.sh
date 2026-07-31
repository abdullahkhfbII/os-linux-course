#!/bin/bash
# ============================================================
# 01_interfaces.sh
# Topic: displaying and configuring network interfaces (Lab 6).
# ============================================================

# --- Display all network interfaces (modern tool) ---
ip addr show

# --- Display all network interfaces (older tool) ---
ifconfig

# --- Assign an IP address to an interface ---
# Replace enp0s3 with your actual interface name from "ip addr show".
sudo ip addr add 192.168.1.50/24 dev enp0s3

# --- Remove that IP address again (mirror of "add") ---
sudo ip addr del 192.168.1.50/24 dev enp0s3

# --- Disable an interface ---
# ⚠ CAUTION: disabling your ACTIVE remote connection will disconnect you!
sudo ip link set enp0s3 down

# --- Re-enable it ---
sudo ip link set enp0s3 up

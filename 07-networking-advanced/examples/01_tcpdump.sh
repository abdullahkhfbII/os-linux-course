#!/bin/bash
# ============================================================
# 01_tcpdump.sh
# Topic: packet capture with tcpdump (Lab 7).
#
# NOTE: run tcpdump in one terminal and generate traffic (e.g.
# ping) in a SECOND terminal to see it capture anything.
# ============================================================

sudo apt update
sudo apt upgrade -y
sudo apt-get install -y tcpdump

# Identify your interface name first.
ifconfig

# Start capturing packets on a given interface (replace eth0 as needed).
sudo tcpdump -i eth0

# More detailed/verbose output.
sudo tcpdump -i eth0 -v

# In a SECOND terminal, generate some traffic to observe:
#   ping -c 4 8.8.8.8
# Then return to the tcpdump terminal and press Ctrl+C to stop
# and see the packet capture summary.

#!/bin/bash
# ============================================================
# 02_connectivity.sh
# Topic: testing connectivity with ping/traceroute, and
#        monitoring active connections with netstat (Lab 6).
# ============================================================

# --- ping: test if a host is reachable, and how fast ---
ping -c 4 8.8.8.8      # send exactly 4 ICMP packets then stop

# --- traceroute: see every router hop along the path ---
sudo apt-get update
sudo apt-get install -y traceroute
traceroute 8.8.8.8

# --- netstat: show active listening TCP/UDP ports with process IDs ---
sudo netstat -tulnp
# -t TCP  -u UDP  -l listening only  -n numeric  -p show PID/program

#!/bin/bash
# ============================================================
# Q3 (Modules 6 + 8 + 9): shared_secure + SSH access control
#
# SCENARIO:
#   Configure a secure shared directory for team collaboration
#   with a process management script, AND configure SSH access
#   control to allow only the 'devops' group while denying
#   'admin' users.
# ============================================================

# --- Directory with SGID + Sticky Bit ---
sudo mkdir /shared_secure
sudo chmod 2770 /shared_secure     # 2 = SGID, 770 = rwxrwx--- (owner/group full, others none)
sudo chown :devops /shared_secure
sudo chmod +t /shared_secure         # add Sticky Bit for deletion protection

# --- Users for the SSH access-control demonstration ---
sudo useradd -G devops alice
sudo useradd -G admin bob

# --- SSH access control: allow only devops, deny admin group ---
echo "AllowGroups devops" | sudo tee -a /etc/ssh/sshd_config
echo "DenyGroups admin" | sudo tee -a /etc/ssh/sshd_config
sudo systemctl restart sshd

# --- Process management script with three children ---
cat << 'EOF_SCRIPT' > process_manager.sh
#!/bin/bash
sleep 30 &
PID1=$!

sleep 45 &
PID2=$!

sleep 60 &
PID3=$!

echo "PIDs: $PID1 $PID2 $PID3"
ps -o pid,ppid,stat,cmd -p $PID1,$PID2,$PID3

kill -STOP $PID1 && ps -o pid,stat,cmd -p $PID1
kill -CONT $PID1 && ps -o pid,stat,cmd -p $PID1
kill -9 $PID2 && ps -o pid,stat,cmd -p $PID2

wait $PID1 $PID3
echo "Process management completed"
EOF_SCRIPT

chmod +x process_manager.sh
sudo chown root:devops process_manager.sh
sudo chmod u+s process_manager.sh

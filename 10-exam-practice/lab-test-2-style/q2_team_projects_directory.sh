#!/bin/bash
# ============================================================
# Q2 (Modules 3 + 8 + 9): team_projects secure directory
#
# SCENARIO:
#   Create a secure shared directory "team_projects" with
#   strict permissions:
#     1. Create the directory.
#     2. 777 access, but with SGID (group inheritance) and
#        Sticky Bit (deletion protection).
#     3. Create users "alice" and "bob" in the "developers"
#        group.
#     4. Verify directory permissions.
#     5. Create "monitor.sh" inside that starts two background
#        processes, pauses/resumes the first, terminates the
#        second, and confirms states with ps.
#     6. Set the script to run with owner privileges (SUID).
#     7. Verify script permissions and process outcomes.
# ============================================================

# --- Users and group ---
sudo groupadd developers
sudo useradd -G developers alice
sudo useradd -G developers bob

# --- Directory: permissions + special bits ---
sudo mkdir team_projects
sudo chown :developers team_projects
# 1777 = Sticky Bit(1) + rwx for everyone(777); SGID added separately below.
sudo chmod 1777 team_projects
sudo chmod g+s team_projects

# Verify.
ls -ld team_projects

# --- The monitoring script ---
cd team_projects || exit

cat << 'EOF_SCRIPT' > monitor.sh
#!/bin/bash
sleep 30 &
PID1=$!
sleep 30 &
PID2=$!

echo "PIDs: $PID1 and $PID2"

kill -STOP $PID1
ps -o pid,stat,cmd -p $PID1

kill -CONT $PID1
ps -o pid,stat,cmd -p $PID1

kill -9 $PID2
ps -o pid,stat,cmd -p $PID2

wait $PID1
echo "Process management complete"
EOF_SCRIPT

chmod +x monitor.sh
sudo chmod u+s monitor.sh

# Verify the script's permissions.
ls -l monitor.sh

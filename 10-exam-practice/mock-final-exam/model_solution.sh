#!/bin/bash
# ============================================================
# NovaLab setup script - Mock Final Exam MODEL SOLUTION
#
# This single script answers every requirement in Part A of
# exam_paper.md, in order. Read exam_paper.md side-by-side with
# this file; the section headers below match the paper exactly.
#
# Assumptions stated explicitly where the paper left something
# open-ended, as the paper itself asks you to do.
# ============================================================

# ------------------------------------------------------------
# A1. Users and groups (10 marks)
# ------------------------------------------------------------
sudo groupadd novalab_staff

sudo useradd -m dr_amir
sudo useradd -m dr_lina
sudo usermod -aG novalab_staff dr_amir
sudo usermod -aG novalab_staff dr_lina

# intern_sam is created but deliberately NOT added to novalab_staff.
sudo useradd -m intern_sam

# Account expires 90 days from today; password must change every 14
# days; user is warned 3 days before that deadline.
sudo chage -E "$(date -d '+90 days' +%Y-%m-%d)" intern_sam
sudo chage -M 14 intern_sam
sudo chage -W 3 intern_sam

# Prove group membership by NUMERIC ID, not just by name -- "id"
# reports UID, primary GID, and every supplementary group's GID.
id dr_amir

# ------------------------------------------------------------
# A2. Secure shared storage (12 marks)
# ------------------------------------------------------------
sudo mkdir -p /novalab/shared_data
sudo chown :novalab_staff /novalab/shared_data

# 2775 = SGID(2) + rwxrwxr-x(775): owner+group full access, others
# read/execute only. The paper actually asked for others to have
# NO access at all, so we use 770, not 775, for the base permission.
# 2770 = SGID(2) + rwxrwx---(770)
sudo chmod 2770 /novalab/shared_data

# Sticky Bit: even with group write access, a user can only delete
# files THEY created. Added separately from the numeric mode above
# so each special bit's purpose stays clear in this comment.
sudo chmod +t /novalab/shared_data

# Verify and explain:
ls -ld /novalab/shared_data
# Expected string: drwxrws--T (or drwxrws--t, depending on whether
# "others" execute happens to be on) --
#   d            = this is a directory
#   rwx          = owner: full access
#   rws          = group: full access, lowercase s = SGID is set AND
#                  the directory is executable for the group
#   --T (or --t) = others: no read/write, T/t = Sticky Bit is set;
#                  capital T here specifically means "others" execute
#                  is off, matching "others have no access at all"

# ------------------------------------------------------------
# A3. A privileged helper script (8 marks)
# ------------------------------------------------------------
sudo touch /novalab/shared_data/run_diagnostics.sh
sudo chmod +x /novalab/shared_data/run_diagnostics.sh

# SUID: whoever runs this script executes it AS the file's owner,
# not as themselves.
sudo chmod u+s /novalab/shared_data/run_diagnostics.sh

# Risk: if this script is ever editable by someone other than its
# owner (e.g. accidentally left group-writable), any user who can
# modify its contents could insert arbitrary commands that would
# then run with the FILE OWNER'S privileges the next time anyone
# executes it -- effectively a privilege escalation path.

# ------------------------------------------------------------
# A4. Scheduled backups and cleanup (14 marks)
# ------------------------------------------------------------
sudo mkdir -p /novalab/backups

cat << 'EOF_SCRIPT' | sudo tee /novalab/backups/backup_shared_data.sh > /dev/null
#!/bin/bash
tar -czvf /novalab/backups/shared_data_$(date +%F_%H-%M).tar.gz /novalab/shared_data
EOF_SCRIPT
sudo chmod +x /novalab/backups/backup_shared_data.sh

# Daily backup at 1:00 AM.
(crontab -l 2>/dev/null; echo "0 1 * * * /novalab/backups/backup_shared_data.sh") | crontab -

cat << 'EOF_SCRIPT' | sudo tee /novalab/backups/cleanup_old_backups.sh > /dev/null
#!/bin/bash
find /novalab/backups -type f -name "*.tar.gz" -mtime +60 -delete
EOF_SCRIPT
sudo chmod +x /novalab/backups/cleanup_old_backups.sh

# Weekly cleanup, every Sunday at 3:00 AM.
(crontab -l 2>/dev/null; echo "0 3 * * 0 /novalab/backups/cleanup_old_backups.sh") | crontab -

# Confirm both jobs registered.
crontab -l

# ------------------------------------------------------------
# A5. Resource monitoring (12 marks)
# ------------------------------------------------------------
free -m

# free doesn't print a ready-made percentage, so it's calculated:
# total (column 2) and used (column 3) of the "Mem:" row, via awk,
# then divided with bc since this isn't guaranteed to be a whole number.
mem_total=$(free -m | awk '/^Mem:/ {print $2}')
mem_used=$(free -m | awk '/^Mem:/ {print $3}')
mem_percent=$(echo "scale=2; ($mem_used / $mem_total) * 100" | bc -l)

echo "Memory usage: ${mem_percent}%"

mem_over=$(echo "$mem_percent > 85" | bc -l)
if (( mem_over == 1 )); then
    echo "WARNING: memory usage exceeds 85%!"
else
    echo "OK: memory usage is within a safe range."
fi

# Disk usage for "/" specifically. grep isolates that one line from
# the full df -h table; awk grabs the "Use%" column; grep -oE strips
# the "%" character so we're left with a plain number to compare.
disk_line=$(df -h | grep -E " /\$")
disk_percent=$(echo "$disk_line" | awk '{print $5}' | grep -oE "[0-9]+")

echo "Disk usage on /: ${disk_percent}%"

if [ "$disk_percent" -gt 80 ]; then
    echo "WARNING: disk usage on / exceeds 80%!"
else
    echo "OK: disk usage on / is within a safe range."
fi

# ------------------------------------------------------------
# A6. Network and remote access control (10 marks)
# ------------------------------------------------------------
ip addr show

# Only novalab_staff may log in; intern_sam is explicitly denied.
# DenyUsers is listed BEFORE AllowGroups on purpose: sshd_config
# evaluates Deny directives before Allow directives regardless of
# file order, so intern_sam stays locked out even if a future edit
# accidentally adds them to an allowed group.
echo "DenyUsers intern_sam" | sudo tee -a /etc/ssh/sshd_config
echo "AllowGroups novalab_staff" | sudo tee -a /etc/ssh/sshd_config
sudo systemctl restart sshd

# Firewall: allow SSH and HTTPS in, drop everything else inbound by
# default. The ACCEPT rules are added BEFORE the DROP default policy
# so this session's own SSH connection is never cut off mid-script.
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -P INPUT DROP

# Capture live packets on the primary interface for a short, fixed
# duration and save them to a file instead of printing to the screen.
# -i = interface, -w = write to file (raw capture, not text), and
# "timeout" stops tcpdump automatically after 10 seconds so the
# script doesn't hang waiting for it to be interrupted manually.
sudo timeout 10 tcpdump -i eth0 -w /novalab/backups/traffic_capture_$(date +%F).pcap

# ------------------------------------------------------------
# A7. Supervised background processing (14 marks)
# ------------------------------------------------------------
# Simulated overnight jobs -- durations are arbitrary but distinct so
# they finish at different times, mirroring realistic staggered work.
sleep 40 &
JOB1=$!

sleep 25 &
JOB2=$!

sleep 60 &
JOB3=$!

JOBS=("$JOB1" "$JOB2" "$JOB3")

echo "Started jobs with PIDs: ${JOBS[@]}"

# Prove parent-child relationship for all three, using a LOOP over
# the array rather than three separate hardcoded ps commands.
for job_pid in "${JOBS[@]}"; do
    ps -o pid,ppid,stat,cmd -p "$job_pid"
done

# Pause and resume the FIRST job.
kill -STOP "$JOB1"
echo "Job 1 after STOP:"
ps -o pid,stat,cmd -p "$JOB1"

kill -CONT "$JOB1"
echo "Job 1 after CONT:"
ps -o pid,stat,cmd -p "$JOB1"

# Force-terminate the SECOND job immediately (SIGKILL cannot be
# caught, ignored, or delayed by the process).
kill -9 "$JOB2"
sleep 1   # brief pause so the OS has time to actually remove the entry

if ps -p "$JOB2" > /dev/null 2>&1; then
    echo "Job 2 still exists (unexpected!)"
else
    echo "Job 2 no longer exists (terminated successfully)"
fi

# Do not exit until jobs 1 and 3 finish naturally.
wait "$JOB1" "$JOB3"

echo "NovaLab setup and supervision completed successfully."

#!/bin/bash
# ============================================================
# 02_suid_sgid_sticky.sh
# Topic: SUID, SGID, and the Sticky Bit (Lab 9).
# ============================================================

touch run.sh
chmod +x run.sh

# --- SUID: process runs with the FILE OWNER'S privileges ---
chmod 4755 run.sh      # numeric: 4 = SUID, plus rwxr-xr-x
ls -l run.sh             # look for lowercase "s" in the owner slot: rws...
chmod u+s run.sh          # symbolic equivalent

# --- SGID on a file: process runs with the FILE'S GROUP privileges ---
chmod 2775 run.sh
ls -l run.sh              # look for lowercase "s" in the group slot: r-s...

# --- SGID on a directory: new files inherit the DIRECTORY'S group ---
mkdir shared_team_folder
chmod 2775 shared_team_folder
ls -ld shared_team_folder

# --- Sticky Bit: only the OWNER of a file can delete it, even in a
#     directory that's writable by everyone ---
mkdir shared_drop_box
chmod 1777 shared_drop_box     # numeric: 1 = Sticky Bit, plus full rwx for all
ls -ld shared_drop_box           # look for lowercase "t" at the very end: rwt

# --- Combining all three special bits at once ---
mkdir fully_special_dir
chmod 7777 fully_special_dir     # SUID(4) + SGID(2) + Sticky(1) + rwx for all
ls -ld fully_special_dir

# --- Auditing: find every SUID binary on the system ---
sudo find / -perm -4000 -type f 2>/dev/null

# --- Disarming a SUID bit you don't want ---
chmod u-s run.sh
ls -l run.sh

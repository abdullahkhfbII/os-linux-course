#!/bin/bash
# ============================================================
# Lab 9 - Scenario 1: shared_secure directory
#
# TASK (from the original lab):
#   1. Create a directory called shared_secure.
#   2. Give all users full read/write/execute (777) permissions.
#   3. Ensure new files created inside inherit the parent
#      directory's group (SGID).
#   4. Prevent users from deleting files created by other users
#      (Sticky Bit).
#   5. Verify directory permissions and print the output.
#   6. Inside the directory, create a file named run.sh.
#   7. Make run.sh executable.
#   8. Make run.sh run with the owner's privileges when executed
#      (SUID).
#   9. Verify file permissions and print the output.
# ============================================================

# --- Step 1: create the directory ---
mkdir shared_secure

# --- Step 2: full access for everyone ---
chmod 777 shared_secure

# --- Step 3: SGID so new files inherit the directory's group ---
chmod g+s shared_secure

# --- Step 4: Sticky Bit so users can only delete their OWN files ---
chmod +t shared_secure

# --- Step 5: verify and print ---
ls -ld shared_secure

# --- Step 6: create the script inside the directory ---
touch shared_secure/run.sh

# --- Step 7: make it executable ---
chmod +x shared_secure/run.sh

# --- Step 8: enable SUID so it runs with the OWNER'S privileges ---
chmod u+s shared_secure/run.sh

# --- Step 9: verify and print ---
ls -l shared_secure/run.sh

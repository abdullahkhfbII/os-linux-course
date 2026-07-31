#!/bin/bash
# ============================================================
# Q12 - BONUS (Module 9 only): Shared secure dir + SUID script
#
# SCENARIO:
#   A team of developers needs a secure shared directory and an
#   executable script with elevated privileges:
#     - Create shared_secure with 777 permissions, group
#       inheritance (SGID), deletion protection (Sticky Bit),
#       and verify its configuration.
#     - Inside, create run.sh, grant execution rights, enable
#       SUID to run with owner privileges, and validate all
#       modifications.
# ============================================================

mkdir shared_secure

# 3777 = SGID(2) + Sticky(1) + rwx for everyone(777) in one number.
chmod 3777 shared_secure

touch shared_secure/run.sh
chmod +x shared_secure/run.sh
chmod u+s shared_secure/run.sh

# Verify everything at once.
ls -l shared_secure

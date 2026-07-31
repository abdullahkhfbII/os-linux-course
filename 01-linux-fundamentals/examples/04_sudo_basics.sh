#!/bin/bash
# ============================================================
# 04_sudo_basics.sh
# Topic: Running commands with administrator privileges (Lab 1).
#
# ⚠ CAUTION: sudo commands can modify core system files.
# Only run what you understand.
# ============================================================

# Show which user you currently are.
whoami

# Run a single command with root (administrator) privileges.
sudo apt update

# Open an entire new shell running AS root, so you don't have
# to type "sudo" before every command. Similar to
# "Run as Administrator" on Windows.
sudo -i

# Inside that root shell, whoami would now print "root".
# whoami

# Leave the root shell and return to your normal user.
exit

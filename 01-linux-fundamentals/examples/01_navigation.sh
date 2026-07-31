#!/bin/bash
# ============================================================
# 01_navigation.sh
# Topic: Finding out where you are and moving around the
#        filesystem tree (Lab 1).
#
# Beginner note: run this script line by line in your head as
# you read it, then try each command yourself in a real
# terminal. Comments starting with # are ignored by bash.
# ============================================================

# Print the full path of the directory we are currently in.
pwd

# List the files/folders in the current directory.
ls

# Long-format listing: shows permissions, owner, size, date.
# (Permissions are explained fully in Module 3.)
ls -l

# Show hidden files too (anything starting with a dot).
ls -a

# Move into a sub-directory called Documents (relative path).
# NOTE: this line will only work if Documents exists — that's
# expected in a real walkthrough, just showing the syntax here.
cd Documents

# Go back up one level, to the parent directory.
cd ..

# Jump straight to the home directory, from anywhere.
cd ~

# Jump to an absolute path — always works no matter where you are.
cd /tmp

# Jump back to whatever directory you were in immediately before this one.
cd -

# Ask the system for the manual page of a command.
# Press 'q' to exit the manual viewer.
man ls

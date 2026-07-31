#!/bin/bash
# ============================================================
# Lab 2 - Scenario 2: password_checker.sh
#
# TASK (from the original lab):
#   Ask the user to enter a password.
#   Use a while loop to keep asking until the correct password
#   is entered (the correct password is admin123).
#   Count how many attempts were made.
#   When correct, print: "Access Granted after X attempts."
# ============================================================

correct_password="admin123"
attempts=0
entered=""

# Keep looping WHILE the entered password is NOT equal to the
# correct one. "!=" is the "not equal" string comparison operator.
while [ "$entered" != "$correct_password" ]; do
    read -p "Enter password: " entered
    attempts=$((attempts + 1))
done

echo "Access Granted after $attempts attempts."

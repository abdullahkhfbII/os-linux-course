#!/bin/bash
# ============================================================
# Lab 1 - Scenario 2: Work summary tracking
#
# TASK (from the original lab):
#   1. Find out which directory you are currently in.
#   2. Create a file named work_summary.txt in your current
#      directory.
#   3. Add the text "Learning Linux is fun!" to the file.
#   4. Display the content of the file on the terminal.
#   5. Append "Practicing commands makes perfect." to the file.
#   6. Copy the file to a new file named backup_summary.txt.
#   7. Delete work_summary.txt.
#   8. Display the updated content of work_summary.txt to
#      confirm the append (NOTE: this step in the original lab
#      text is written after the delete step, but logically you
#      can only "confirm the append" before deleting the file —
#      we display it right after appending below, which is the
#      correct working order).
# ============================================================

# Step 1: show current directory.
pwd

# Step 2 + 3: create the file and write the first line into it.
# echo with a single ">" creates the file if missing and writes
# this exact text, overwriting any previous content.
echo "Learning Linux is fun!" > work_summary.txt

# Step 4: show the file's content.
cat work_summary.txt

# Step 5: append a second line without erasing the first ("<<" would
# be wrong here — we use ">>" specifically because it APPENDS).
echo "Practicing commands makes perfect." >> work_summary.txt

# Confirm the appended content before we delete the original file.
cat work_summary.txt

# Step 6: copy the file to a new name.
cp work_summary.txt backup_summary.txt

# Step 7: delete the original file.
rm work_summary.txt

# Step 8: the backup copy still has the same content, since cp
# happened before the delete.
cat backup_summary.txt

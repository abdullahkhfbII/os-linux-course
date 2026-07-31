#!/bin/bash
# ============================================================
# Lab 1 - Scenario 1: Document organization and backup
#
# TASK (from the original lab):
#   1. Navigate to your home directory.
#   2. Create a new directory named Documents.
#   3. Inside Documents, create two subdirectories: Assignments
#      and Projects.
#   4. Create three text files named assignment1.txt,
#      assignment2.txt, and project1.txt in the Documents
#      directory.
#   5. Move all files starting with "assignment" to the
#      Assignments directory, and project1.txt to Projects.
#   6. Compress the entire Documents directory into a single
#      file named Documents_backup.tar.
#   7. List the contents of both subdirectories to confirm the
#      files were moved correctly.
# ============================================================

# Step 1: go to the home directory (~ is a shortcut for it).
cd ~

# Step 2: create the top-level Documents folder.
mkdir Documents

# Step 3: create the two subfolders inside Documents.
mkdir Documents/Assignments
mkdir Documents/Projects

# Step 4: create the three empty files inside Documents.
touch Documents/assignment1.txt
touch Documents/assignment2.txt
touch Documents/project1.txt

# Step 5: move files starting with "assignment" using a wildcard (*)
# The * means "anything", so assignment* matches assignment1.txt
# and assignment2.txt in one command.
mv Documents/assignment*.txt Documents/Assignments/

# Move project1.txt into the Projects folder.
mv Documents/project1.txt Documents/Projects/

# Step 6: archive the WHOLE Documents directory into one .tar file.
# (No -z here because the task asked for .tar, not .tar.gz.)
tar -cvf Documents_backup.tar Documents/

# Step 7: confirm the files landed in the right place.
ls Documents/Assignments/
ls Documents/Projects/

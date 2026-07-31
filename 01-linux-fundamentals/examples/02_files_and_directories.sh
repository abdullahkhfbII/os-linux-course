#!/bin/bash
# ============================================================
# 02_files_and_directories.sh
# Topic: Creating, writing, viewing, copying, moving and
#        deleting files and directories (Lab 1).
# ============================================================

# Create a single new directory.
mkdir Projects

# Create nested directories in one shot.
# -p = also create any missing parent directories.
mkdir -p Projects/2026/OS_Course

# Create an empty file.
touch notes.txt

# Write text into a file, OVERWRITING whatever was there before.
echo "This is my first line" > notes.txt

# Add MORE text to the end of the file, without erasing it.
echo "This is a second line" >> notes.txt

# Print the file's contents to the screen.
cat notes.txt

# Open the file in the nano text editor.
# (Interactive — save with Ctrl+X, then Y, then Enter.)
# nano notes.txt

# Copy a file, keeping the original.
cp notes.txt notes_backup.txt

# Rename a file (mv is used both to rename AND to move).
mv notes_backup.txt notes_old.txt

# Move a file into a folder.
mv notes_old.txt Projects/

# Delete a single file permanently. No confirmation prompt!
rm notes.txt

# Delete an EMPTY directory only.
mkdir empty_folder
rmdir empty_folder

# ⚠ CAUTION: delete a directory AND everything inside it.
# Double, triple check the path before running this for real.
rm -r Projects

#!/bin/bash
# ============================================================
# Q1 (Module 1 only): Photographer's portfolio archive
#
# SCENARIO:
#   A freelance photographer needs to archive their latest
#   photos for a client. Create a structured directory system,
#   move specific files into the right subdirectories, compress
#   the final collection into a single file, and verify the
#   contents. The raw files "portrait1.jpg", "portrait2.jpg",
#   "landscape1.jpg", and "landscape2.jpg" are directly in the
#   home directory. The final archive must be named
#   "client_portfolio.tar" and include all files, organized.
# ============================================================

# Create the main portfolio folder and its two subfolders.
mkdir ~/Portfolio
mkdir ~/Portfolio/Portraits
mkdir ~/Portfolio/Landscapes

# Move the matching files into their correct subfolders.
mv ~/portrait1.jpg ~/portrait2.jpg ~/Portfolio/Portraits
mv ~/landscape1.jpg ~/landscape2.jpg ~/Portfolio/Landscapes

# Archive AND compress the whole Portfolio folder.
# (Note: the task says the final file must be named
# "client_portfolio.tar" -- here we use .tar.gz since we are
# compressing with -z; if a plain, uncompressed .tar is
# strictly required, drop the -z flag and the .gz extension.)
tar -czvf client_portfolio.tar.gz ~/Portfolio

# Verify: -R lists directory contents RECURSIVELY, so you can
# see every file inside every subfolder in one command.
ls -R ~/Portfolio

#!/bin/bash
# ============================================================
# 03_archiving_compressing.sh
# Topic: tar archiving and compression (Lab 1).
#
# Archiving = bundling many files into ONE file (no size change).
# Compressing = shrinking data size (usually done at the same time).
# ============================================================

mkdir -p Documents/Assignments Documents/Projects
touch Documents/assignment1.txt Documents/assignment2.txt Documents/project1.txt

# Archive a single file into a .tar (no compression).
tar -cvf assignment1_backup.tar Documents/assignment1.txt

# Archive an entire directory into a .tar (no compression).
tar -cvf documents_backup.tar Documents/

# Extract (de-archive) a plain .tar file back into files/folders.
tar -xvf documents_backup.tar

# Archive AND compress a file in one step (produces .tar.gz).
tar -czvf assignment1_backup.tar.gz Documents/assignment1.txt

# Archive AND compress an entire directory.
tar -czvf documents_backup.tar.gz Documents/

# Extract a compressed .tar.gz archive.
tar -xzvf documents_backup.tar.gz

# -c = create   -x = extract   -v = verbose (show file names as it works)
# -f = filename follows   -z = also use gzip compression

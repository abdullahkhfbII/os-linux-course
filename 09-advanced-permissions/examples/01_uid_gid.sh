#!/bin/bash
# ============================================================
# 01_uid_gid.sh
# Topic: UID/GID, the id command, and numeric ownership (Lab 9).
# ============================================================

# Show all identity info: UID, primary GID, and every group you belong to.
id

id -u        # only your UID
id -g         # only your primary GID
id -G          # ALL group IDs you belong to

# Identity info for a specific user.
id "$USER"

touch example.txt

# View numeric UID/GID ownership instead of names.
ls -l -n example.txt

mkdir example_dir
ls -ldn example_dir

# Change ownership using raw numeric UID:GID (more stable for the kernel
# than names, since names can be renamed/reused but numbers cannot).
sudo chown 1001:1002 example.txt

# Change ONLY the group ownership of a file.
sudo chgrp research_team example.txt

#!/bin/bash
# ============================================================
# 02_permissions_chmod.sh
# Topic: Reading and changing permissions with chmod (Lab 3).
# ============================================================

touch script.sh

# View current permissions in the 10-character format, e.g. -rwxr-x---
ls -l script.sh

# --- Numeric (absolute) chmod ---
# 7 = rwx (4+2+1), 5 = r-x (4+1), 0 = nothing
# owner=7 group=5 others=0
chmod 750 script.sh
ls -l script.sh

# Full permissions for everyone (⚠ use with caution - security risk!)
chmod 777 script.sh
ls -l script.sh

# --- Symbolic chmod (relative changes) ---
chmod u+x script.sh    # add execute for the owner
chmod g-w script.sh    # remove write for the group
chmod o=r script.sh    # set others to read-only, exactly
chmod a+r script.sh    # add read for everyone (owner+group+others)
ls -l script.sh

# --- Generating a child script using a heredoc ---
cat << 'EOF_INNER' > child_script.sh
#!/bin/bash
echo "I was generated automatically by another script!"
EOF_INNER

chmod +x child_script.sh
./child_script.sh

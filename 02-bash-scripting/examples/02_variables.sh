#!/bin/bash
# ============================================================
# 02_variables.sh
# Topic: Assigning and using variables (Lab 2).
# ============================================================

# CORRECT: no spaces around the equals sign.
name="Yahia"
age=21

# Double quotes expand variables AND preserve spacing.
echo "$name is $age years old"

# Single quotes do NOT expand variables - shown for comparison.
echo 'This is $name literally, not expanded'

# This next line would cause an ERROR if uncommented, because of
# the spaces around "=":
#   name = "Yahia"

# --- Variable scope demo ---
# If you run this script with ./02_variables.sh, "name" only
# exists INSIDE this script's own process. Try this yourself:
#   ./02_variables.sh
#   echo $name        <-- will print nothing, empty output
#
# But if you instead run:
#   source 02_variables.sh
#   echo $name        <-- will print "Yahia"
# because "source" runs the script inside your CURRENT shell,
# instead of spawning a brand new one.

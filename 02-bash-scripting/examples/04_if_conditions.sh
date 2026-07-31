#!/bin/bash
# ============================================================
# 04_if_conditions.sh
# Topic: if / elif / else, string comparison, numeric
#        comparison, and floating-point comparison (Lab 2).
# ============================================================

read -p "Enter a number: " number

# --- Numeric comparison (integers only) ---
if [ "$number" -gt 10 ]; then
    echo "Greater than 10"
elif [ "$number" -eq 10 ]; then
    echo "Exactly 10"
else
    echo "Less than 10"
fi

# --- String comparison ---
read -p "Enter a password: " pass
if [ "$pass" = "admin123" ]; then
    echo "Password correct"
else
    echo "Password incorrect"
fi

if [ -z "$pass" ]; then
    echo "You entered an empty password"
fi

# --- Floating point comparison (bash cannot do this natively) ---
read -p "Enter your grade (can be decimal, e.g. 85.5): " grade

# Build the comparison as text, then let "bc" (a calculator program)
# evaluate it. bc prints 1 for true, 0 for false.
result=$(echo "$grade >= 85" | bc -l)

if (( result == 1 )); then
    echo "Excellent"
else
    echo "Not excellent (below 85)"
fi

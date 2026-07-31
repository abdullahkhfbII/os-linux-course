#!/bin/bash
# ============================================================
# 03_user_input.sh
# Topic: Reading input from the user with "read" (Lab 2).
# ============================================================

echo "What is your name?"
read name
echo "Hello, $name!"

# You can also prompt and read in a single line using -p:
read -p "Enter your favorite number: " fav_number
echo "You picked: $fav_number"

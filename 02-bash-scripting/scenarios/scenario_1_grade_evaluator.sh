#!/bin/bash
# ============================================================
# Lab 2 - Scenario 1: grade_evaluator.sh
#
# TASK (from the original lab):
#   Ask the user to enter:
#     - Student name
#     - Final grade (can be a floating point number)
#   Based on the grade, print:
#     grade >= 85            -> Excellent
#     grade >= 70 and < 85    -> Very Good
#     grade >= 50 and < 70    -> Pass
#     grade < 50              -> Fail
# ============================================================

# --- Get input from the user ---
read -p "Enter student name: " name
read -p "Enter final grade: " grade

# --- Floating point comparisons need "bc", because bash's
#     built-in [ ] test only understands whole numbers. ---
is_excellent=$(echo "$grade >= 85" | bc -l)
is_very_good=$(echo "$grade >= 70 && $grade < 85" | bc -l)
is_pass=$(echo "$grade >= 50 && $grade < 70" | bc -l)

# --- Decide which message to print ---
if (( is_excellent == 1 )); then
    echo "$name: Excellent"
elif (( is_very_good == 1 )); then
    echo "$name: Very Good"
elif (( is_pass == 1 )); then
    echo "$name: Pass"
else
    echo "$name: Fail"
fi

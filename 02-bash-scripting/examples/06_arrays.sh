#!/bin/bash
# ============================================================
# 06_arrays.sh
# Topic: Arrays (Lab 2).
# ============================================================

courses=("Math" "Physics" "Chemistry")

echo "First element:  ${courses[0]}"   # indexing starts at 0
echo "Second element: ${courses[1]}"
echo "All elements:   ${courses[@]}"
echo "Element count:  ${#courses[@]}"

# Looping through every element of an array:
for course in "${courses[@]}"; do
    echo "Course: $course"
done

# Adding an element to the end of an array:
courses+=("Biology")
echo "After adding one more: ${courses[@]}"

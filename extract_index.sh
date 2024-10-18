#!/bin/bash

# Define the directory and output file
input_directory="."
output_file="name.txt"

# Find all *.bag files in the directory and export their filenames to the output file
find "$input_directory" -type f -name "*.bag" -exec basename {} \; > "$output_file"

# Notify the user that the task is complete
echo "All *.bag filenames from '$input_directory' have been exported to '$output_file'."


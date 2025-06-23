#!/bin/bash

# merge all csv file (evo's ouptut) in folder into one csv.

# Output file
output="/media/larry/M2-SSD/Trajectory/all/merge_rpe.csv"

folder="/media/larry/M2-SSD/Trajectory/all/raw_rpe/"


# Check if folder exists
if [ ! -d $folder ]; then
    echo "Error: 'folder' directory does not exist!"
    exit 1
fi

# Check if there are CSV files
if [ -z "$(ls $folder/*.csv 2>/dev/null)" ]; then
    echo "Error: No CSV files found in 'folder'!"
    exit 1
fi

# Get the header from the first CSV file
first_file=$(ls $folder/*.csv | head -n 1)
head -n 1 "$first_file" > "$output"

# Append all other CSV files (excluding headers)
for file in $folder/*.csv; do
    tail -n +2 "$file" >> "$output"
done

echo "All CSV files merged into $output!"
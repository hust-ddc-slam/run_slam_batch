
#!/bin/bash

# Define the folder and output file
folder="/media/larry/M2-SSD/ChronoOutput-1226"
output_file="names.txt"

# Check if the folder exists
if [ -d "$folder" ]; then
    # List all files and directories in the folder and output to names.txt
    ls -1 "$folder" > "$output_file"
    echo "File and folder names have been written to $output_file"
else
    echo "Directory '$folder' does not exist."
fi

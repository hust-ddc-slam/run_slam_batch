
#!/bin/bash

# Define the folder and output file
folder="/home/larry/data/3dof_street_0423"
output_file="name.txt"

# From folder.
# Check if the folder exists
if [ -d "$folder" ]; then
    # List all files and directories in the folder and output to names.txt
    ls -1 "$folder" > "$output_file"
    echo "File and folder names have been written to $output_file"
else
    echo "Directory '$folder' does not exist."
fi

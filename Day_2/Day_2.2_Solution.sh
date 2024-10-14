#!/bin/bash

function display_usage {
	echo "Useage: ./Day_2.2_Solution.sh <explore directory path>"
}

if [ $# -eq 0 ] 
then
	display_usage
	exit 1
fi

# Part 1: File and Directory Exploration
echo "Welcome to the Interactive File and Directory Explorer!"


explore_dir=$1

echo "Files and Directories in the Current Path: $explore_dir"

# List files and directories with their sizes
ls -lh "$explore_dir" | awk '{print "- " $9 " (" $5 ")"}'

# Part 2: Character Counting
while true; do
    echo -n "Enter a line of text (Press Enter without text to exit): "
    read user_input
    
    # Exit condition
    if [ -z "$user_input" ]; then
        echo "Exiting the Interactive Explorer. Goodbye!"
        break
    fi
    
    # Count characters in the input
    char_count=${#user_input}
    echo "Character Count: $char_count"
done

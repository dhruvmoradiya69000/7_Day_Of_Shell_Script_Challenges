#!/bin/bash

# Part 1: File and Directory Exploration
echo "Welcome to the Interactive File and Directory Explorer!"

function display_usage {
	echo "Useage: ./Day_2.2_Solution.sh <Directory Explorer path>"
}

if [ $# -eq 0 ] 
then
	display_usage
	exit 1
fi

target_dir=$1

while true; do
    # List all files and directories in the current path
    echo "Files and Directories in the Current Path: $target_dir"
    for item in "$target_dir"/*; do
        if [ -e "$item" ]; then
            size=$(du -sh "$item" | cut -f1)
            echo "- ($size) $(basename "$item") "
        fi
    done

    # Part 2: Character Counting
    read -p "Enter a line of text (Press Enter without text to exit): " input

    # Exit if the user enters an empty string
    if [[ -z $input ]]; then
        echo "Exiting the Interactive Explorer. Goodbye!"
        break
    fi

    # Calculate and print the character count for the input line
    char_count=$(echo -n "$input" | wc -m)
    echo "Character Count: $char_count"
done

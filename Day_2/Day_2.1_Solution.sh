#!/bin/bash
# this is script for backup 3 day rotetion
# Useage: ./Day_2.1_Solution.sh <path to source> <path to backup folder>
function display_usage {
	echo "Useage: ./Day_2.1_Solution.sh <path to source> <path to backup folder>"
}

if [ $# -eq 0 ] 
then
	display_usage
	exit 1
fi

source_dir=$1
backup_dir=$2
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')

function create_backup {
	# Create a zip archive of the source directory with a timestamp
	zip -r "${backup_dir}/backup_${timestamp}.zip" "${source_dir}" > /dev/null 
	
	# Check if the backup was successful
	if [[ $? -eq 0 ]]
	then
		echo "backup generated:${backup_dir}_${timestamp}"
	else
		echo "backup failed:${backup_dir}_${timestamp}"
		exit 1
	fi
}

function delete_old_file {
	# Get a list of backup files sorted by modification time
	backup=($(ls -t "${backup_dir}/backup_"*.zip 2> /dev/null))

	if [ ${#backup[@]} -gt 3 ]
	then
		echo "performing rotation for 3 days."

		# Remove older backup files beyond the 3-day rotation period
		remove=("${backup[@]:3}") 

		for backup in "${remove[@]}"
		do
			rm -f ${backup}
		done	
	else
        echo "No backups found for rotation."
    fi
}

create_backup
delete_old_file
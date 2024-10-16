#!/bin/bash

# Function to check if a process is running
check_process() {
    local process_name="$1"
    pgrep "$process_name" &> /dev/null
    if [[ $? -eq 0 ]]; then
        echo "Process '$process_name' is running."
        return 0
    else
        echo "Process '$process_name' is not running."
        return 1
    fi
}

# Function to restart a process
restart_process() {
    local process_name="$1"
    local max_restarts=3
    local attempts=0

    while [[ $attempts -lt $max_restarts ]]; do
        echo "Attempting to restart process '$process_name' (Attempt #$((attempts + 1)))..."
        # Assuming the process can be restarted by its name
        $process_name &> /dev/null &
        sleep 2  # Allow some time for the process to start

        if check_process "$process_name"; then
            echo "Process '$process_name' restarted successfully."
            return 0
        else
            echo "Failed to restart process '$process_name'."
        fi
        attempts=$((attempts + 1))
    done

    echo "Maximum restart attempts reached. Manual intervention may be required."
    # BONUS: Send an alert/notification if desired (e.g., via email, Slack, etc.)
    return 1
}

# Main function to monitor the process
monitor_process() {
    local process_name="$1"

    if [[ -z "$process_name" ]]; then
        echo "Usage: $0 <process_name>"
        exit 1
    fi

    # Check if the process is running, and restart if not
    check_process "$process_name"
    if [[ $? -ne 0 ]]; then
        restart_process "$process_name"
    fi
}

# Run the script
monitor_process "$1"

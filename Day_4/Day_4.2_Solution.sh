#!/bin/bash

# Function to display CPU, Memory, and Disk Usage
display_metrics() {
    echo "------------------- System Metrics -------------------"
    
    # CPU Usage
    echo -e "\nCPU Usage:"
    top -bn1 | grep "Cpu(s)" | \
    awk '{print "CPU Load: " $2 + $4 "%"}'
    
    # Memory Usage
    echo -e "\nMemory Usage:"
    free -h | awk '/^Mem:/ {print "Used: "$3" / Total: "$2}'
    
    # Disk Usage
    echo -e "\nDisk Usage:"
    df -h | grep '^/dev/' | awk '{print $1": "$3" used / "$2" total ("$5" full)"}'
    
    echo "------------------------------------------------------"
}

# Function to monitor a service
monitor_service() {
    local service_name="$1"

    # Check if service is running
    systemctl is-active --quiet "$service_name"
    if [[ $? -eq 0 ]]; then
        echo "Service '$service_name' is running."
    else
        echo "Service '$service_name' is not running."
        echo "Would you like to start the service? (y/n)"
        read -r start_choice
        if [[ $start_choice == "y" ]]; then
            sudo systemctl start "$service_name"
            if [[ $? -eq 0 ]]; then
                echo "Service '$service_name' started successfully."
            else
                echo "Failed to start the service. Please check the service name and try again."
            fi
        fi
    fi
}

# Function to display the menu
menu() {
    echo "------------------- Monitoring Menu -------------------"
    echo "1. View CPU, Memory, and Disk Usage"
    echo "2. Monitor a specific service (default: nginx)"
    echo "3. Set sleep interval for continuous monitoring"
    echo "4. Exit"
    echo "-------------------------------------------------------"
    echo "Please select an option (1-4):"
}

# Function for error handling
error_message() {
    echo "Invalid input. Please try again."
}

# Main monitoring function
monitoring_loop() {
    local sleep_interval="$1"
    local service_name="nginx"  # Default service

    while true; do
        clear
        menu
        read -r user_option

        case $user_option in
            1)
                display_metrics
                ;;
            2)
                echo "Enter the service name to monitor (default: nginx):"
                read -r service_input
                if [[ -n $service_input ]]; then
                    service_name="$service_input"
                fi
                monitor_service "$service_name"
                ;;
            3)
                echo "Enter the sleep interval (in seconds):"
                read -r sleep_input
                if [[ $sleep_input =~ ^[0-9]+$ ]]; then
                    sleep_interval="$sleep_input"
                    echo "Sleep interval set to $sleep_interval seconds."
                else
                    error_message
                fi
                ;;
            4)
                echo "Exiting the monitoring script."
                exit 0
                ;;
            *)
                error_message
                ;;
        esac

        echo "Next update in $sleep_interval seconds. Press [Ctrl+C] to stop."
        sleep "$sleep_interval"
    done
}

# Entry point of the script
if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

echo "Welcome to the System Monitoring Script!"
monitoring_loop 5  # Default sleep interval is 5 seconds

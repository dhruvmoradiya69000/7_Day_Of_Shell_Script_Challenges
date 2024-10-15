#!/bin/bash

# Function to display help information
display_help() {
    echo "Usage: $0 [OPTION]"
    echo "Manage user accounts on the system."
    echo
    echo "Options:"
    echo "  -c, --create    Create a new user account"
    echo "  -d, --delete    Delete an existing user account"
    echo "  -r, --reset     Reset password for an existing user account"
    echo "  -l, --list      List all user accounts"
    echo "  -h, --help      Display this help message"
}

# Function to create a new user account
create_account() {
    read -p "Enter new username: " username
    if id "$username" &>/dev/null; then
        echo "Error: User '$username' already exists."
        exit 1
    fi
    
    read -s -p "Enter password for $username: " password
    echo
    
    useradd -m "$username"
    echo "$username:$password" | chpasswd
    
    echo "User account '$username' created successfully."
}

# Function to delete a user account
delete_account() {
    read -p "Enter username to delete: " username
    if ! id "$username" &>/dev/null; then
        echo "Error: User '$username' does not exist."
        exit 1
    fi
    
    userdel -r "$username"
    echo "User account '$username' deleted successfully."
}

# Function to reset a user's password
reset_password() {
    read -p "Enter username to reset password: " username
    if ! id "$username" &>/dev/null; then
        echo "Error: User '$username' does not exist."
        exit 1
    fi
    
    read -s -p "Enter new password for $username: " password
    echo
    
    echo "$username:$password" | chpasswd
    echo "Password for user '$username' reset successfully."
}

# Function to list all user accounts
list_accounts() {
    echo "User accounts on the system:"
    echo "Username:UID"
    echo "------------"
    cut -d: -f1,3 /etc/passwd | sort
}

# Main script logic
if [ $# -eq 0 ]; then
    echo "Error: No option provided."
    display_help
    exit 1
fi

case "$1" in
    -c|--create)
        create_account
        ;;
    -d|--delete)
        delete_account
        ;;
    -r|--reset)
        reset_password
        ;;
    -l|--list)
        list_accounts
        ;;
    -h|--help)
        display_help
        ;;
    *)
        echo "Error: Invalid option '$1'"
        display_help
        exit 1
        ;;
esac
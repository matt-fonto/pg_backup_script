#!/bin/bash

# Function to prompt user for input
prompt_for_input() {
    read -p "Enter PostgreSQL Host: " HOST
    read -p "Enter PostgreSQL User: " USER
    read -p "Enter PostgreSQL Database: " DATABASE
    read -s -p "Enter PostgreSQL Password: " PASSWORD
    echo ""
    read -p "Enter Backup File Name (leave empty for default naming): " BACKUP_FILE_NAME
}

# Prompt user for input
prompt_for_input

# Generate a backup file name with date and time if not provided
if [ -z "$BACKUP_FILE_NAME" ]; then
    BACKUP_FILE_NAME="backup_${DATABASE}_$(date +%Y%m%d_%H%M%S).dump"
else
    # Append .dump extension if not present
    if [[ "$BACKUP_FILE_NAME" != *.dump ]]; then
        BACKUP_FILE_NAME="${BACKUP_FILE_NAME}.dump"
    fi
fi

# Set PGPASSWORD environment variable
export PGPASSWORD=${PASSWORD}

# Perform the backup
pg_dump -h ${HOST} -U ${USER} -d ${DATABASE} -F c > ${BACKUP_FILE_NAME}

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup completed successfully and saved to ${BACKUP_FILE_NAME}"
else
    echo "Backup failed"
fi

# Unset PGPASSWORD
unset PGPASSWORD


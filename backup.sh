#!/bin/bash

# Backup script variables
SOURCE_DIR="$1"  # The directory to be backed up (first argument)
REMOTE_USER="your_username"  # Remote server username
REMOTE_HOST="your_remote_server"  # Remote server hostname/IP
REMOTE_DIR="/path/to/backup/location"  # Remote directory to store the backup
LOG_FILE="/var/log/backup.log"  # Log file path
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_NAME="backup_${TIMESTAMP}.tar.gz"

# Function to log messages
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$LOG_FILE"
}

# Ensure the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    log_message "ERROR: Source directory $SOURCE_DIR does not exist."
    exit 1
fi

# Create a tar.gz archive of the source directory
log_message "Creating archive of $SOURCE_DIR..."
tar -czf /tmp/"$BACKUP_NAME" "$SOURCE_DIR" 2>> "$LOG_FILE"

if [ $? -ne 0 ]; then
    log_message "ERROR: Failed to create archive of $SOURCE_DIR."
    exit 1
fi
log_message "Archive created successfully: /tmp/$BACKUP_NAME"

# Transfer the backup to the remote server using rsync
log_message "Transferring backup to $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR..."
rsync -avz /tmp/"$BACKUP_NAME" "$REMOTE_USER"@"$REMOTE_HOST":"$REMOTE_DIR" 2>> "$LOG_FILE"

if [ $? -ne 0 ]; then
    log_message "ERROR: Failed to transfer backup to remote server."
    exit 1
fi

# Clean up the local backup file after transfer
rm /tmp/"$BACKUP_NAME"

log_message "Backup completed successfully and transferred to $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/$BACKUP_NAME"
echo "Backup operation completed successfully. Check $LOG_FILE for details."

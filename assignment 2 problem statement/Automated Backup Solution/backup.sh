
#!/bin/bash

# Automated Backup Script

# Configuration
SOURCE_DIR="/home/user/important-data"
REMOTE_USER="backupuser"
REMOTE_HOST="192.168.1.100"
REMOTE_DIR="/backups"
LOG_FILE="/var/log/backup.log"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

# Logging function
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log_message "Starting backup..."

# Validate source directory
if [ ! -d "$SOURCE_DIR" ]; then
    log_message "FAILED: Source directory does not exist."
    exit 1
fi

# Create remote backup directory
ssh "$REMOTE_USER@$REMOTE_HOST" \
    "mkdir -p '$REMOTE_DIR/$DATE'"

if [ $? -ne 0 ]; then
    log_message "FAILED: Cannot connect to remote server."
    exit 1
fi

# Perform backup using rsync
rsync -avz --delete \
    "$SOURCE_DIR/" \
    "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/$DATE/"

if [ $? -eq 0 ]; then
    log_message "SUCCESS: Backup completed successfully."
    log_message "Backup location: $REMOTE_DIR/$DATE"
    exit 0
else
    log_message "FAILED: Backup operation encountered an error."
    exit 1
fi

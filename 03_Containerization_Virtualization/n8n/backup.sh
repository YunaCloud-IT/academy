#!/bin/bash

# ==============================================================================
# n8n & PostgreSQL Backup Script
# ==============================================================================

# Set backup directory and timestamp
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="n8n_backup_$TIMESTAMP"
TARGET_DIR="$BACKUP_DIR/$BACKUP_NAME"

echo "Starting n8n backup process..."

# Create backup directories if they don't exist
mkdir -p "$TARGET_DIR"

# 1. Check for and load the .env file
if [ -f .env ]; then
  # Source the .env file to get database variables
  export $(grep -v '^#' .env | xargs)
  echo "✓ Found .env file."
else
  echo "❌ Error: .env file not found! Please run this script from your project root."
  rm -rf "$TARGET_DIR"
  exit 1
fi

# 2. Backup the .env file (Crucial for the N8N_ENCRYPTION_KEY)
cp .env "$TARGET_DIR/.env.backup"
echo "✓ Backed up .env file."

# 3. Backup the PostgreSQL Database
# We use docker exec to run pg_dump safely inside the running container
echo "⏳ Backing up PostgreSQL database..."
if docker exec n8n-postgres pg_dump -U "$DB_USER" "$DB_NAME" > "$TARGET_DIR/database_dump.sql"; then
    echo "✓ Database backup successful."
else
    echo "❌ Error: Database backup failed."
    rm -rf "$TARGET_DIR"
    exit 1
fi

# 4. Compress the backup into a single tar.gz archive
echo "⏳ Compressing backup files..."
tar -czf "$BACKUP_DIR/$BACKUP_NAME.tar.gz" -C "$BACKUP_DIR" "$BACKUP_NAME"

# 5. Clean up the uncompressed temporary folder
rm -rf "$TARGET_DIR"

echo "🎉 Backup completed successfully!"
echo "📁 Your backup is located at: $BACKUP_DIR/$BACKUP_NAME.tar.gz"

# Optional: Delete backups older than 30 days to save space
# find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +30 -delete

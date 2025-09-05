#!/bin/bash
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="/backups/motortown_$TIMESTAMP"

echo "💾 Creating backup at $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"
cp -r /server/save_data "$BACKUP_DIR"
echo "✅ Backup complete."

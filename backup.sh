#!/bin/bash

echo "🗂️ Backing up server files..."
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
mkdir -p /motortown/backup/archive
cp -r /motortown/server "/motortown/backup/archive/server_backup_$TIMESTAMP"
echo "✅ Backup complete."

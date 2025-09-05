#!/bin/bash

set -e

echo "🚀 Starting Motor Town Dedicated Server..."

# Load environment variables
source /motortown/.env

EXE_PATH="/motortown/server/$EXE_NAME"

if [ ! -f "$EXE_PATH" ]; then
  echo "❌ Server executable not found at $EXE_PATH"
  exit 1
fi

# Optional: create backup before launch
if [ -f /motortown/backup/backup.sh ]; then
  echo "📦 Running backup script..."
  bash /motortown/backup/backup.sh
fi

# Launch server
xvfb-run wine "$EXE_PATH" "$MAP_NAME?listen?" -server -log -useperfthreads

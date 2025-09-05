#!/bin/bash
set -e

echo "🚀 Starting Motor Town Dedicated Server..."

# Load environment variables
source /motortown/.env

CONFIG_PATH="/motortown/config/serverconfig.json"
EXE_PATH="/motortown/server/$EXE_NAME"

# Validate executable
if [ ! -f "$EXE_PATH" ]; then
  echo "❌ Server executable not found at $EXE_PATH"
  exit 1
fi

# Parse config JSON
if [ -f "$CONFIG_PATH" ]; then
  echo "📖 Loading server config..."
  MAP=$(jq -r '.WorldSettings.Map // env.MAP_NAME' "$CONFIG_PATH")
  USE_PERF=$(jq -r '.Performance.UsePerfThreads // env.USE_PERF_THREADS' "$CONFIG_PATH")
  HEADLESS=$(jq -r '.Performance.Headless // env.HEADLESS' "$CONFIG_PATH")
  ENABLE_LOG=$(jq -r '.Logging.EnableLog // env.ENABLE_LOG' "$CONFIG_PATH")
else
  echo "⚠️ Config file not found, falling back to .env"
  MAP="$MAP_NAME"
  USE_PERF="$USE_PERF_THREADS"
  HEADLESS="$HEADLESS"
  ENABLE_LOG="$ENABLE_LOG"
fi

# Optional backup
if [ "$ENABLE_BACKUP" = "true" ] && [ -f /motortown/backup/backup.sh ]; then
  echo "📦 Running backup..."
  bash /motortown/backup/backup.sh
fi

# Build launch command
CMD="$EXE_PATH $MAP?listen? -server"
[ "$ENABLE_LOG" = "true" ] && CMD="$CMD -log"
[ "$USE_PERF" = "true" ] && CMD="$CMD -useperfthreads"
[ "$HEADLESS" = "true" ] && CMD="$CMD -nographics"

echo "🧨 Launching: wine $CMD"
xvfb-run wine $CMD

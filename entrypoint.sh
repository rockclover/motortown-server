#!/bin/bash
set -e
trap 'echo "❌ Script failed at line $LINENO"; exit 1' ERR

echo "🚀 Starting Motor Town Dedicated Server..."

# Load environment variables
export $(grep -v '^#' /motortown/.env | xargs)

CONFIG_PATH="/motortown/config/serverconfig.json"
EXE_PATH="/motortown/server/$EXE_NAME"

# Optional SteamCMD update
if [ "$USE_STEAMCMD" = "true" ]; then
  echo "🔐 Running SteamCMD for auxiliary updates..."
  /steamcmd/steamcmd.sh +login "$STEAM_USERNAME" "$STEAM_PASSWORD" \
    +force_install_dir /motortown/server \
    +app_update 1376480 validate \
    +quit
fi

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

# Verbose output
echo "🧩 Map: $MAP"
echo "🧩 UsePerfThreads: $USE_PERF"
echo "🧩 Headless: $HEADLESS"
echo "🧩 EnableLog: $ENABLE_LOG"

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

# Resilient launch loop
while true; do
  echo "🧨 Launching: wine $CMD"
  xvfb-run wine $CMD
  echo "⚠️ Server exited. Restarting in 10 seconds..."
  sleep 10
done

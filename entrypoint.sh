#!/bin/bash
set -euo pipefail
trap 'echo "❌ Script failed at line $LINENO"; exit 1' ERR

echo "🚀 Motor Town Dedicated Server Entrypoint"

# Load environment variables
if [ ! -f ".env" ]; then
  echo "❌ .env file not found"
  exit 1
fi
source .env

# Validate executable
if [ ! -f "$EXE_NAME" ]; then
  echo "❌ Executable not found: $EXE_NAME"
  exit 1
fi

# Validate config
CONFIG_PATH="./config/serverconfig.json"
if ! jq empty "$CONFIG_PATH"; then
  echo "❌ Invalid JSON in $CONFIG_PATH"
  exit 1
fi

# Validate required keys in config
REQUIRED_KEYS=(
  '.Server.Name' '.Server.MaxPlayers' '.WorldSettings.Map'
  '.Performance.UsePerfThreads' '.Logging.EnableLog'
)
for KEY in "${REQUIRED_KEYS[@]}"; do
  VALUE=$(jq -r "$KEY // empty" "$CONFIG_PATH")
  if [ -z "$VALUE" ]; then
    echo "❌ Missing key: $KEY in config"
    exit 1
  fi
done

# Prepare log path
LOG_PATH="./logs/server.log"
mkdir -p "$(dirname "$LOG_PATH")"
touch "$LOG_PATH"

# Build launch command
CMD="$EXE_NAME -batchmode -nographics -map $MAP_NAME -port1 $PORT_1 -port2 $PORT_2"

# Optional flags
[ "${USE_PERF_THREADS:-false}" = "true" ] && CMD="$CMD -usePerfThreads"
[ "${ENABLE_LOG:-false}" = "true" ] && CMD="$CMD -logFile $LOG_PATH"
[ "${HEADLESS:-false}" = "true" ] && CMD="$CMD -headless"

echo "🧠 Launch command: $CMD"
echo "📄 Logging to: $LOG_PATH"

# Run server with virtual framebuffer and capture all

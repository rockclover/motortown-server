#!/bin/bash
set -e

# Optional .env sourcing
[ -f /mnt/server/.env ] && source /mnt/server/.env

# Fallbacks
STEAM_USERNAME="${STEAM_USERNAME:-your_steam_username}"
STEAM_PASSWORD="${STEAM_PASSWORD:-your_steam_password}"
EXE_NAME="${EXE_NAME:-MotorTownServer-Win64-Shipping.exe}"
MAP_NAME="${MAP_NAME:-Jeju_World}"
PORT_1="${PORT_1:-27015}"
PORT_2="${PORT_2:-27016}"
USE_PERF_THREADS="${USE_PERF_THREADS:-true}"
ENABLE_LOG="${ENABLE_LOG:-true}"
HEADLESS="${HEADLESS:-false}"

echo "🚀 Launching Motor Town Dedicated Server"
echo "🧾 Executable: $EXE_NAME"
echo "🗺️ Map: $MAP_NAME"
echo "📡 Ports: $PORT_1 / $PORT_2"
echo "👤 Steam: $STEAM_USERNAME"
echo "⚙️ Flags: HEADLESS=$HEADLESS, LOG=$ENABLE_LOG, PERF=$USE_PERF_THREADS"

# Launch logic (example)
wine64 "/mnt/server/$EXE_NAME" \
  -log \
  -map=$MAP_NAME \
  -port=$PORT_1 \
  -queryport=$PORT_2 \
  -USE_PERF_THREADS=$USE_PERF_THREADS \
  -ENABLE_LOG=$ENABLE_LOG \
  -HEADLESS=$HEADLESS

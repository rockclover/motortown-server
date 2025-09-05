#!/bin/bash
set -euo pipefail
trap 'echo "❌ Install failed at line $LINENO"; exit 1' ERR

echo "🔧 Motor Town Server Installer"

# Step 0: Bootstrap .env if missing
if [ ! -f ".env" ]; then
  echo "⚠️ .env not found. Creating from .env.example..."
  cp .env.example .env
  echo "✅ .env created. Please edit it with your Steam credentials before rerunning."
  exit 1
fi

# Step 1: Load .env
echo "🔍 Loading environment variables..."
set -a
source .env
set +a

# Step 2: Validate .env
bash scripts/validate_env.sh

# Step 3: Validate config.json
CONFIG_PATH="config/serverconfig.json"
if [ ! -f "$CONFIG_PATH" ]; then
  echo "❌ Config file not found at $CONFIG_PATH"
  exit 1
fi
bash scripts/validate_config.sh

# Step 4: Pull latest server binary via SteamCMD
echo "🎮 Pulling latest Motor Town server binary..."
docker run --rm \
  -v "$(pwd)/server:/home/steam/Steam" \
  cm2network/steamcmd:latest \
  +login "$STEAM_USERNAME" "$STEAM_PASSWORD" \
  +force_install_dir /home/steam/Steam/motortown \
  +app_update 1623730 validate \
  +quit

# Step 5: Build Docker image
echo "🐳 Building Docker image..."
docker build -t motortown-server .

# Step 6: Launch container
echo "🚀 Launching server with Docker Compose..."
docker-compose up -d

echo "✅ Server launched successfully."

#!/bin/bash
CONFIG_PATH="./config/serverconfig.json"

echo "🔍 Validating config.json..."
jq empty "$CONFIG_PATH" || { echo "❌ Invalid JSON format"; exit 1; }

REQUIRED_KEYS=(
  '.Server.Name' '.Server.MaxPlayers' '.WorldSettings.Map'
  '.Performance.UsePerfThreads' '.Logging.EnableLog'
)

for KEY in "${REQUIRED_KEYS[@]}"; do
  VALUE=$(jq -r "$KEY // empty" "$CONFIG_PATH")
  if [ -z "$VALUE" ]; then
    echo "❌ Missing key: $KEY"
    exit 1
  fi
done
echo "✅ config.json validation passed."

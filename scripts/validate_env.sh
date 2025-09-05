#!/bin/bash
REQUIRED_VARS=(
  STEAM_USERNAME STEAM_PASSWORD EXE_NAME MAP_NAME
  USE_PERF_THREADS ENABLE_LOG HEADLESS PORT_1 PORT_2
  ENABLE_BACKUP BACKUP_PATH
)

echo "🔍 Validating .env file..."
for VAR in "${REQUIRED_VARS[@]}"; do
  if ! grep -q "^$VAR=" .env; then
    echo "❌ Missing $VAR in .env"
    exit 1
  fi
done
echo "✅ .env validation passed."

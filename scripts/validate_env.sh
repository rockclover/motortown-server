#!/bin/bash

REQUIRED_VARS=(
  STEAM_USERNAME
  STEAM_PASSWORD
  EXE_NAME
  MAP_NAME
  PORT_1
  PORT_2
)

echo "🔍 Validating environment variables..."

for var in "${REQUIRED_VARS[@]}"; do
  value="${!var}"
  if [ -z "$value" ]; then
    echo "⚠️  $var is not set. Using fallback or default."
  else
    echo "✅ $var = $value"
  fi
done

echo "✅ Validation complete."

#!/bin/bash

echo "🚀 Starting Motor Town Dedicated Server..."

if [ ! -f /motortown/server/MotorTownServer-Win64-Shipping.exe ]; then
  echo "❌ Server executable not found in /motortown/server/"
  exit 1
fi

xvfb-run wine /motortown/server/MotorTownServer-Win64-Shipping.exe Jeju_World?listen? -server -log -useperfthreads

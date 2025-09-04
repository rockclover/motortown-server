# Motor Town Dedicated Server (Docker + Wine)

This stack automatically installs and runs a Motor Town server using Wine and SteamCMD inside a Docker container. Designed for deployment via Portainer.

## Features
- Auto-installs server via SteamCMD
- Runs Windows-only server using Wine
- Supports admin config via `ServerConfig.json`
- Scheduled backups via `backup.sh`
- Manual restart via `restart.sh`

## Setup
1. Add your Steam credentials to `.env`
2. Deploy the stack in Portainer using Git
3. Enjoy your server!
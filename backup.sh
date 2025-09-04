#!/bin/bash
source .env
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
zip -r "${BACKUP_PATH}/motortown_backup_${TIMESTAMP}.zip" "${SERVER_DATA_PATH}"
find "${BACKUP_PATH}" -type f -name "*.zip" -mtime +7 -exec rm {} \;
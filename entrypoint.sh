#!/bin/sh
set -e
exec > /home/LogFiles/entrypoint_log.txt 2>&1

echo "--- Entrypoint script started at $(date) ---"

# --- THIS IS THE NEW DEBUGGING LINE ---
echo "--- Checking for Azure Storage Connection String ---"
if [ -n "$AZURE_STORAGE_CONNECTION_STRING" ]; then
  echo "SUCCESS: AZURE_STORAGE_CONNECTION_STRING variable was found."
else
  echo "FAILURE: AZURE_STORAGE_CONNECTION_STRING variable IS NOT SET."
fi
echo "------------------------------------------------"

echo "--- Running database migrations ---"
python manage.py migrate --noinput
# ... rest of the script ...
#!/bin/sh
set -e

echo "--- Entrypoint script started at $(date) ---"

# --- THIS IS THE NEW DEBUGGING LINE ---
echo "--- Checking for Azure Storage Connection String ---"
if [ -n "$AZURE_STORAGE_CONNECTION_STRING" ]; then
  echo "SUCCESS: AZURE_STORAGE_CONNECTION_STRING variable was found."
else
  echo "FAILURE: AZURE_STORAGE_CONNECTION_STRING variable IS NOT SET."
fi
echo "------------------------------------------------"

echo "--- Entrypoint: Applying database migrations ---"
python manage.py migrate --noinput

echo "--- Entrypoint: Collecting static files ---"
python manage.py collectstatic --noinput

echo "--- Entrypoint: Starting Gunicorn server ---"
# The "$@" CMD from the Dockerfile will be passed here
exec "$@"
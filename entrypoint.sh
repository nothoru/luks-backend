#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

echo "--- Entrypoint script started at $(date) ---"

# --- NEW DEBUGGING BLOCK ---
echo "--- VERIFYING CRITICAL ENVIRONMENT VARIABLES ---"
echo "WEBSITE_HOSTNAME is: [${WEBSITE_HOSTNAME}]"
echo "AZURE_STORAGE_CONNECTION_STRING is: [${AZURE_STORAGE_CONNECTION_STRING}]"
echo "--- END OF VERIFICATION ---"

echo "--- Entrypoint: Applying database migrations ---"
python manage.py migrate --noinput

echo "--- Entrypoint: Collecting static files ---"
python manage.py collectstatic --noinput

echo "--- Entrypoint: Starting Gunicorn server ---"
# The "$@" CMD from the Dockerfile will be passed here
exec "$@"
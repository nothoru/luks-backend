#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Redirect all output to a new log file to be sure we're not seeing old data

echo "--- Entrypoint script started at $(date) ---"

# --- THIS IS OUR CRITICAL DEBUGGING LINE ---
echo "Value of AZURE_STORAGE_CONNECTION_STRING is: [${AZURE_STORAGE_CONNECTION_STRING}]"
# --- END OF DEBUGGING LINE ---

echo "--- Entrypoint: Applying database migrations ---"
python manage.py migrate --noinput

echo "--- Entrypoint: Collecting static files ---"
python manage.py collectstatic --noinput

echo "--- Entrypoint: Starting Gunicorn server ---"
# The "$@" CMD from the Dockerfile will be passed here
exec "$@"
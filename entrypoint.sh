#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Redirect all output (stdout and stderr) to a log fil
# This is the crucial debugging step.
exec > /home/LogFiles/entrypoint_log.txt 2>&1

echo "--- Entrypoint script started at $(date) ---"

echo "--- Running database migrations ---"
python manage.py migrate --noinput

echo "--- Migrations complete ---"

echo "--- Starting Gunicorn server ---"
# Start the Gunicorn server
# The "$@" CMD from the Dockerfile will be passed here
exec "$@"
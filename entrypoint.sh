#!/bin/sh

set -e

# Redirect all output to a log file for debugging
exec > /home/LogFiles/entrypoint_log.txt 2>&1

echo "--- Entrypoint script started at $(date) ---"

echo "--- Running database migrations using absolute path ---"
# Use the full path to the python executable in the venv
/opt/venv/bin/python manage.py migrate --noinput

echo "--- Migrations complete ---"

echo "--- Starting Gunicorn server ---"
# Start the Gunicorn server
exec "$@"
#!/bin/sh
set -e
exec > /home/LogFiles/entrypoint_log.txt 2>&1

echo "--- Entrypoint script started at $(date) ---"

# --- TEMPORARILY DISABLED ---
# echo "--- Running database migrations ---"
# /opt/venv/bin/python manage.py migrate --noinput
# echo "--- Collecting static files ---"
# /opt/venv/bin/python manage.py collectstatic --noinput

# --- NEW TEST COMMAND ---
echo "--- Running storage test command ---"
/opt/venv/bin/python manage.py test_storage

echo "--- Entrypoint finished, now starting Gunicorn ---"
exec "$@"
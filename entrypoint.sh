#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

echo "--- Entrypoint: Applying database migrations ---"
python manage.py migrate --noinput

echo "--- Entrypoint: Collecting static files ---"
python manage.py collectstatic --noinput

echo "--- Entrypoint: Starting Gunicorn server ---"
# The "$@" CMD from the Dockerfile will be passed here
exec "$@"
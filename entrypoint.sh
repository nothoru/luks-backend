#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Apply database migrations
echo "Applying database migrations..."
python manage.py migrate

# Start the Gunicorn server
# The "$@" CMD from the Dockerfile will be passed here
exec "$@"
#!/bin/sh

set -e

JOB_NAME=$1

echo "--- Job runner started at $(date) for job: $JOB_NAME ---"

case $JOB_NAME in
  "daily_analytics")
    echo "Running daily analytics generation..."
    python manage.py generate_analytics
    ;;
  "weekly_recommendation")
    echo "Running weekly recommendation generation..."
    python manage.py generate_recommendation
    ;;
  "cancel_orders")
    echo "Running cancellation for old pending orders..."
    python manage.py cancel_old_pending_orders
    ;;
  *)
    echo "Error: Unknown job name '$JOB_NAME'"
    exit 1
    ;;
esac

echo "--- Job '$JOB_NAME' finished successfully at $(date) ---"
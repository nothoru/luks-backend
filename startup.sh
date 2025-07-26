#!/bin/bash

# Install the missing graphics library needed by OpenCV
apt-get update && apt-get install -y libgl1-mesa-glx libglib2.0-0
# Start the Gunicorn server
gunicorn --bind=0.0.0.0 --timeout 600 backend.wsgi
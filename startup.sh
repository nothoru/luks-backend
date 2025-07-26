#!/bin/bash

# Install the missing graphics library needed by OpenCV
apt-get update && apt-get install -y libgl1-mesa-glx

# Start the Gunicorn server
gunicorn --bind=0.0.0.0 --timeout 600 backend.wsgi
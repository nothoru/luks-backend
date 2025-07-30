# luks-backend/Dockerfile (Highly Optimized)

# --- Stage 1: Builder ---
# Use a more complete Debian-based image for building, as it has better support for complex packages.
FROM python:3.11-bookworm as builder

# Set an argument for the environment to avoid writing pyc files
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install build-time system dependencies
RUN apt-get update && apt-get install -y build-essential

# Create a virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy and install Python requirements
COPY requirements.txt .
# --no-cache-dir is crucial here to keep this layer smaller
RUN pip install --no-cache-dir -r requirements.txt


# --- Stage 2: Final Production Image ---
# Start from a clean, slim base image again
FROM python:3.11-slim-bookworm

# Set the same environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install ONLY the required RUNTIME system dependencies.
# These are the bare minimum libraries needed for OpenCV and others to run.
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the clean virtual environment from the builder stage.
# This is the most important step. We are NOT copying any build tools or cache.
COPY --from=builder /opt/venv /opt/venv

# Copy the application code
COPY . .

# Set the PATH to use the Python from our virtual environment
ENV PATH="/opt/venv/bin:$PATH"

RUN python manage.py collectstatic --noinput

# Expose the port
EXPOSE 8000

# Run the application
CMD ["gunicorn", "backend.wsgi:application", "--bind", "0.0.0.0:8000", "--timeout", "120"]

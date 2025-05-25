#!/bin/bash

echo "Starting the application..."

# Activate the virtual environment
source venv/bin/activate
gunicorn -c gunicorn_config.py wsgi:app

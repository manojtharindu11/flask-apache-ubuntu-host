#!/bin/bash
echo "Starting the application..."
source .venv/bin/activate
mkdir -p /var/log/gunicorn
gunicorn -c gunicorn_config.py wsgi:app

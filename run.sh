#!/bin/bash
echo "Starting the application..."
gunicorn -c gunicorn_config.py wsgi:app

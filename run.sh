#!/bin/bash
echo "Starting the application..."
source .venv/bin/activate

mkdir -p /var/log/gunicorn

echo "[+] Launching Gunicorn..."
gunicorn --workers 3 --bind 127.0.0.1:8000 wsgi:app \
  --access-logfile /var/log/gunicorn/access.log \
  --error-logfile /var/log/gunicorn/error.log

echo "[✓] Gunicorn started successfully."

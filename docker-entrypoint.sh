#!/bin/sh
# Web container entrypoint.
#
# When RUN_MIGRATIONS=true, database migrations are applied before the web
# server starts. Enable it on the web service so every redeploy migrates once;
# the worker keeps its own command and does not run migrations.
set -e

if [ "${RUN_MIGRATIONS:-false}" = "true" ]; then
    echo "[entrypoint] RUN_MIGRATIONS=true -> applying database migrations..."
    python manage.py migrate --noinput
fi

exec gunicorn config.wsgi:application \
    --bind "0.0.0.0:${PORT:-8000}" \
    --workers "${GUNICORN_WORKERS:-2}" \
    --threads "${GUNICORN_THREADS:-2}"

#!/bin/sh

set -e

. /venv/bin/activate

gunicorn --bind 0.0.0.0:80 -t 240 --workers=2 --forwarded-allow-ips='*' wsgi:app

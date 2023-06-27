#!/bin/sh
set -eo pipefail

gunicorn --threads=3 --bind=localhost:8000 wsgi

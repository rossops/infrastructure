#!/bin/sh
set -eo pipefail

gunicorn --threads=3 --bind=0.0.0.0:8000 wsgi

#!/bin/bash
set -e

exec supervisord -c /app/supervisord.conf

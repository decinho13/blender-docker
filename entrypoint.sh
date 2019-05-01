#!/bin/bash
set -e

exec supervisord -c /opt/app-root/bin/supervisord.conf

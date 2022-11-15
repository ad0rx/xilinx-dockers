#!/usr/bin/bash
#
# Commit the container, thus tagging an image

# Exit on error
set -e

CONTAINER=50

# Allow clients to connect to local X
xhost +

# Run Vivado GUI mode as user
docker commit $CONTAINER vivado-complete:2020.1

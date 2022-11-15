#!/usr/bin/bash
#
# Build the Docker image for Vivado 2020.1

# Exit on error
set -e

# Build the image
docker build --tag vivado:2020.1 --build-arg UNAME=$USER             \
       --build-arg UID=$(id -u)  --build-arg GID=$(id -g)            \
       --rm - < Dockerfile

#!/usr/bin/bash
#
# run the Docker image for Vivado 2020.1
# first command line arg is containter id, first 2 numbers works
#
# details on xterm fonts
# http://www.futurile.net/2016/06/14/xterm-setup-and-truetype-font-configuration/

# Exit on error
set -e

CONTAINER=$1

# Allow clients to connect to local X
xhost +

# Exec / Attach to the container as bwhitlock
# this is just an example, a7 is running container
# need to parameterize container
docker exec $CONTAINER xterm -fa "DejaVu Sans Mono" -fs 20 &

# as root
# docker exec -u 0 $CONTAINER xterm

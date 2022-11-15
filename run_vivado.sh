#!/usr/bin/bash
#
# Run Vivado as user

# Exit on error
set -e

CONTAINER=c4

# Allow clients to connect to local X
xhost +

# Run Vivado GUI mode as user
docker exec -d $CONTAINER bash -c ". /opt/Xilinx/Vivado/2020.1/settings64.sh; vivado"

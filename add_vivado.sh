#!/usr/bin/bash
#
# Add vivado 2020.1

# Exit on error
set -e

CONTAINER=50

# Allow clients to connect to local X
xhost +

# Copy the locally modified os-release into container
# This is needed in order to get the install to run happily
# in GUI mode
docker exec -u 0 $CONTAINER cp ~/03_peraton_laptop/docker/os-release          \
       /etc/release

# Run the vivado installer, in batch mode
docker exec -u 0 $CONTAINER sh -c                                             \
       "/home/bwhitlock/Downloads/Xilinx_Unified_2020.1_0602_1208/xsetup \
       --batch Install                                                \
       --location /opt/Xilinx/                                        \
       --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA                   \
       --edition \"Vitis Unified Software Platform\"                  \
       -c /home/bwhitlock/03_peraton_laptop/docker/install_config.txt"

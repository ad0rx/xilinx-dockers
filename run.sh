#!/usr/bin/env bash
#
# run the Docker image for Vivado 2020.1

# Exit on error
set -e

# Capture output here, which contains the container ID
OUTFILE=/tmp/run.sh.out

NETWORK=none
CPU_SHARES=1024
if [ -n "$1" ]
then

    NETWORK=host
    echo "Setting NETWORK=$NETWORK"

    CPU_SHARES=128
    echo "Setting CPU_SHARES=$CPU_SHARES"

fi

# Run the image / create container
#       -v "$HOME/.Xauthority:/root/.Xauthority:rw"                   \
#       -v /tmp/.X11-unix:/tmp/.X11-unix -v /home:/home --rm          \
#       --network=host                                                \
#       --expose 22                                                   \
docker run -itd --hostname=dkr --env DISPLAY=:0.0                    \
       --privileged                                                  \
       --network=${NETWORK}                                          \
       -e HOME=${HOME} -w ${HOME}                                    \
       -v "${HOME}/.Xauthority:/${HOME}/.Xauthority:rw"              \
       -v /tmp/.X11-unix:/tmp/.X11-unix                              \
       -v /home:/home                                                \
       --rm --cpu-shares=${CPU_SHARES}                               \
       --cpus=6                                                      \
       --name vivado-2020.1-${NETWORK}                               \
       vivado/2020.1:009 | tee ${OUTFILE}

ID=`cat ${OUTFILE}`

#echo "here1" | tee -a ${OUTFILE}

# Start the SSH server in the container, using the root user
#docker exec -it -u0 ${ID} service ssh start | tee -a ${OUTFILE}

#echo "here2"  | tee -a ${OUTFILE}
rm -f ${OUTFILE}

#
# Notes for next time:
# create a dkr user in the machine and somehow map to USER that is running the machine?
# want to be able to run machine as arbitrary user
# -u command to docker run? seems to work '-u 1001' map to user on local system
#
# add vivado
# add python 3.6
# add ws_tester
# add questa

# fake /etc/os-version VERSION=18.04.4 LTS (Bionic Beaver)
# installer will run
# or run installer in batch mode
#
# go to uncompressed top directory and run sudo ./xsetup --batch Install --location /tools/Xilinx/ --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA --edition "Vitis Unified Software Platform"
#
#
# chmod 666 /var/run/docker.sock
#
# docker run -it --hostname=dkr --network=host --env DISPLAY=$DISPLAY --privileged --volume="$HOME/.Xauthority:/root/.Xauthority:rw" -v /tmp/.X11-unix:/tmp/.X11-unix -v /home:/home --rm test-vivado:2020.1 &
#
# docker exec -it <container> xterm &
# docker commit <container> <name>:<version>

# docker build --tag test-vivado:2020.1 --build-arg UNAME=$USER --build-arg UID=$(id -u) --build-arg GID=$(id -g) - < Dockerfile
# docker run myvivado
#
# to run the container as root
# docker exec -u 0 <container> xterm
#
# to allow docker to connect to X on host: xhost +
#
# Pull base image.
FROM ubuntu:18.04

# Defaults, get overridden by build command above
ARG UNAME=developer
ARG UID=1000
ARG GID=1000

ARG UHOME=/home/$UNAME
#ENV LANG zh_TW.UTF-8
RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

# Install.
RUN apt-get clean
RUN apt-get update
RUN apt-get -y upgrade
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get -y upgrade && apt-get install -y -q
RUN apt-get -y upgrade &&           \
    apt-get install -y              \
            dialog apt-utils        \
            libboost-filesystem-dev \
            libtinfo5               \
            libx11-6                \
            libxext6                \
            libxrender1             \
            libxtst6                \
            libxi6                  \
            libxslt1.1              \
            libfreetype6            \
            libfontconfig           \
            libatk1.0-0             \
            libavformat57           \
            build-essential         \
            libxxf86vm1             \
            libcairo2               \
            libglib2.0-0            \
            libgtk-3-0              \
            libasound2              \
            libopenjfx-jni          \
            libavcodec57            \
            libgtk2.0-0             \
            libcairo-gobject2       \
            openjdk-11-jre-zero     \
            xterm                   \
            less                    \
            nano                    \
            git                     \
            strace                  \
            wget                    \
            unzip

#RUN apt-get upgrade && apt-get install -y libasound2
#                                   liboss4-salsa-asound2 \

# to get python 3.10 available
#RUN add-apt-repository ppa:deadsnakes/ppa
#RUN apt-get upgrade && apt-get install -y software-properties-common

RUN apt-get upgrade &&    \
    apt-get install -y    \
            python3       \
            python3-dev   \
            python3-numpy \
            python3-scipy \
            python3-pip   \
        &&                \
        rm -rf /var/lib/apt/lists/*

# Set the username for running the following commands
USER $UNAME
ENV PATH $PATH:/home/$UNAME/.local/bin
RUN python3 -m pip install --upgrade \
    pip setuptools wheel scipy cython pybind11

# Set environment variables.
ENV HOME $UHOME

# Define working directory.
WORKDIR $UHOME

# Install ws_tester.py

# Define default command.
CMD ["bash"]

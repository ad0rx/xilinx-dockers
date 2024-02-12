#-*- mode: sh -*-
# Create a Vivado 2022.2 Development Environment
#
# Vivado is installed in a wrapper script 'build' in same dir as this
# file.
#
# Used Perl Dockerfile as example:
# https://github.com/perl/docker-perl/blob/\
#    f70e8ace49994efef8e90cbf730554a3e3201da7/5.036.000-main-bullseye/Dockerfile
#
# When updating this file, remember that lines that are added
# invalidate all following lines, necessitating a new build instead of
# using the existing image archive. Therefore, try to add new things
# toward the bottom of this file.
#######################################################################

# Pull base image.
FROM ubuntu:18.04

# Defaults, can be (and is) overridden by build command in 'build'
ARG UNAME=developer
ARG UID=1000
ARG GID=1000

ARG UHOME=/home/$UNAME

RUN true \
    && groupadd -g $GID -o $UNAME \
    && useradd  -m -u $UID -g $GID -o -s /bin/bash $UNAME

# Base Updates
RUN true                                                                              \
    && apt-get clean                                                                  \
    && apt-get update                                                                 \
    && apt-get -y upgrade                                                             \
    && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get install -y -q

# End Base Updates ####################################################

# Begin deps for Xilinx Vivado
RUN true \
    && apt-get update               \
    && apt-get -y upgrade           \
    && apt-get install -y           \
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
            unzip                   \
            locales                 \
    && locale-gen en_US.UTF-8       \
    && rm -rf /var/lib/apt/lists/*

# END Vivado Dependencies #############################################

# Begin Python support for ws_tester

# make python 3.10 available
#RUN add-apt-repository ppa:deadsnakes/ppa
#RUN apt-get upgrade && apt-get install -y software-properties-common
RUN true                  \
    && apt-get update     \
    && apt-get upgrade    \
    && apt-get install -y \
            python3.8     \
            python3-dev   \
            python3-numpy \
            python3-scipy \
            python3-pip   \
    && rm -rf /var/lib/apt/lists/*

# This dir is used to store the required repos hc-attack and
# testing-framework. Files are copied into this dir by the top-level
# script which executes after the container is up and running
RUN true                            \
    && mkdir -p /ws_tester          \
    && chown -R $UID:$GID /ws_tester

USER $UNAME
ENV PATH $PATH:/home/$UNAME/.local/bin
RUN true                                       \
    && python3.8 -m pip install --upgrade pip  \
    && python3.8 -m pip install --upgrade      \
                 setuptools wheel              \
    && python3.8 -m pip install --upgrade      \
                 cython pybind11 scipy numpy

USER $UNAME
COPY support/hc-attack-hardcider-2018.zip /ws_tester/
COPY support/testing-framework-master.zip /ws_tester/
WORKDIR /ws_tester
RUN true                                  \
    && unzip hc-attack-hardcider-2018.zip \
    && unzip testing-framework-master.zip

WORKDIR /ws_tester/hc-attack-hardcider-2018
RUN python3.8 -m pip install --user .

WORKDIR /ws_tester/testing-framework-master
RUN python3.8 -m pip install --user .

# End ws_tester support ###############################################

# Begin personal deps #################################################
RUN true                            \
    && apt-get update               \
    && apt-get -y upgrade           \
    && apt-get install -y           \
               rsync
# End personal deps ###################################################

USER root
COPY support/bashrc /home/$UNAME/.bashrc
RUN chown $UNAME:$UNAME /home/$UNAME/.bashrc

# Set to actual user name in the build command in 'build'
USER $UNAME
ARG GIT_EMAIL="user@default.com"
ARG GIT_NAME="John Doe"
RUN true                                            \
    && git config --global user.email  "$GIT_EMAIL" \
    && git config --global user.name   "$GIT_NAME"  \
    && git config --global core.editor nano

# Set environment variables.
ENV HOME $UHOME

# Define working directory.
WORKDIR $UHOME

# Define default command.
CMD ["bash"]

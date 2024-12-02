#-*- mode: sh -*-
# Create image for hosting Peraton's  IT tools
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
FROM ubuntu:20.04

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
    && echo 'debconf debconf/frontend select noninteractive' | debconf-set-selections \
    && apt-get install -y -q

RUN true \
    && dpkg --add-architecture i386 \
    && apt update

# End Base Updates ####################################################

# Begin deps ##########################################################
USER root
RUN true                            \
    && apt-get update               \
    && apt-get -y upgrade           \
    && apt-get install -y           \
               nano                 \
               rsync                \
               cron                 \
               wget                 \
               systemctl            \
               curl                 \
               gpg                  \
               wireless-tools

# End deps ############################################################

USER root
COPY support/bashrc /home/$UNAME/.bashrc
RUN chown $UNAME:$UNAME /home/$UNAME/.bashrc

# Add the Peraton Labs IT tools
COPY support/plabs-ubuntu-addons.sh /home/$UNAME/
RUN chmod +x /home/$UNAME/plabs-ubuntu-addons.sh
RUN chown $UNAME:$UNAME /home/$UNAME/plabs-ubuntu-addons.sh

# Make default shell bash
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

#######################################################################
USER $UNAME

# Set environment variables.
ENV HOME $UHOME

# Define working directory.
WORKDIR $UHOME

# Define default command.
CMD ["bash"]

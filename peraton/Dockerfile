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

# Begin PetaLinux Dependencies ########################################
# RUN true \
#     && apt-get update                  \
#     && apt-get -y upgrade              \
#     && apt-get install -y              \
#                zlib1g:i386             \
#                zlib1g-dev:i386         \
#                iproute2                \
#                gawk                    \
#                gcc                     \
#                net-tools               \
#                ncurses-dev             \
#                zlib1g-dev              \
#                openssl                 \
#                flex                    \
#                bison                   \
#                xterm                   \
#                bc                      \
#                autoconf                \
#                libtool                 \
#                texinfo                 \
#                gcc-multilib            \
#                build-essential         \
#                automake                \
#                screen                  \
#                pax                     \
#                libstdc++-9-dev         \
#                g++-9                   \
#                python3-pip             \
#                xz-utils                \
#                zlib1g-dev              \
#                cpp                     \
#                python3-git             \
#                python3-jinja2          \
#                python3-pexpect         \
#                diffutils               \
#                debianutils             \
#                iputils-ping            \
#                libegl1-mesa            \
#                libsdl1.2-dev           \
#                pylint3                 \
#                python3                 \
#                cpio                    \
#                gnupg                   \
#                netstat-nat             \
#                git                     \
#                python                  \
#                git                     \
#                make                    \
#                libncurses5-dev         \
#                tftpd                   \
#                tftp                    \
#                libssl-dev              \
#                libselinux1             \
#                libtinfo5               \
#                wget                    \
#                git-core                \
#                diffstat                \
#                chrpath                 \
#                socat                   \
#                tar                     \
#                unzip                   \
#                gcc-multilib            \
#                screen                  \
#                pax                     \
#                gzip                    \
#                locales                 \
#                xxd                     \
#     && locale-gen en_US.UTF-8          \
#     && rm -rf /var/lib/apt/lists/*
# END Petalinux Dependencies ##########################################

# Begin personal deps #################################################
USER root
RUN true                            \
    && apt-get update               \
    && apt-get -y upgrade           \
    && apt-get install -y           \
               nano                 \
               rsync
# End personal deps ###################################################

USER root
COPY support/bashrc /home/$UNAME/.bashrc
RUN chown $UNAME:$UNAME /home/$UNAME/.bashrc

# Make default shell bash
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash

#######################################################################

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

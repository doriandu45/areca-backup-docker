
# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.12-glibc

# Download URLs
ARG ARECA_URL=https://downloads.sourceforge.net/project/areca/areca-stable/areca-7.5/areca-7.5-linux-gtk-64.tar.gz
ARG JSCH_URL=https://sourceforge.net/projects/jsch/files/jsch.jar/0.1.55/jsch-0.1.55.jar/download

# Define working directory
WORKDIR /tmp

# Download Areca and Jsch
RUN \
    add-pkg --virtual build-dependencies \
        curl \
        && \
    mkdir -p /defaults && \
    # Download.
    wget -O /defaults/areca.tar.gz ${ARECA_URL} && \
    wget -O /defaults/jsch.jar ${JSCH_URL} && \
    # Cleanup.
    del-pkg build-dependencies && \
    rm -rf /tmp/* /tmp/.[!.]*

# Unpack Areca
RUN \
    tar -xvzf /defaults/areca.tar.gz -C /defaults && \
    rm -f /defaults/areca.tar.gz

# Install dependencies.
RUN \
    add-pkg \
        openjdk11-jre \
        gtk+2.0 \
        bash

# Copy the fixed Jsch lib
RUN \
    rm -f /defaults/areca/lib/jsch.jar && \
    mv /defaults/jsch.jar /defaults/areca/lib/jsch.jar

ENV APP_NAME="Areca Backup" \
    S6_KILL_GRACETIME=8000

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://www.areca-backup.org/images/logo.jpg && \
    install_app_icon.sh "$APP_ICON_URL"

COPY startapp.sh /startapp.sh

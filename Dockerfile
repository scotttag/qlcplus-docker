# Define QLC+ version
ARG QLC_VER=4.14.3
ARG BASEIMAGE_VER=ubuntu-24.04-v4.10.5

# Multi-stage build for better layer caching
FROM ubuntu:24.04 AS downloader
ARG QLC_VER
ADD qlcplus_${QLC_VER}_amd64.deb /tmp/qlcplus.deb

# Pull base image with version pinning
FROM jlesage/baseimage-gui:${BASEIMAGE_VER}

# Re-declare ARG for use in this stage
ARG QLC_VER

# Add metadata labels
LABEL maintainer="scotttag" \
      version="${QLC_VER}" \
      description="QLC+ lighting control software in Docker" \
      org.opencontainers.image.source="https://github.com/scotttag/qlcplus-docker"

# Define working directory
WORKDIR /tmp

# Copy QLC+ package from downloader stage
COPY --from=downloader /tmp/qlcplus.deb /tmp/qlcplus.deb

# Install dependencies and QLC+ in a single layer
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get -y install \
        libasound2-dev \
        libfftw3-double3 \
        libftdi1-2 \
        libqt5core5a \
        libqt5gui5 \
        libqt5multimedia5 \
        libqt5multimediawidgets5 \
        libqt5network5 \
        libqt5script5 \
        libqt5widgets5 \
        libqt5serialport5 \
        libqt5websockets5 \
        libusb-1.0-0 && \
    dpkg -i /tmp/qlcplus.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/qlcplus.deb

# Create directory for custom fixtures
RUN mkdir -p /usr/share/qlcplus/fixtures/custom

# Environment variables with better documentation
ENV OPERATE_MODE="" \
    QLC_WEB_SERVER="" \
    WORKSPACE_FILE=""

# Expose necessary ports
EXPOSE 5800 5900 9999

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD pgrep qlcplus || exit 1

# Create volumes for fixtures and data
VOLUME ["/usr/share/qlcplus/fixtures/custom", "/data"]

# Copy startup scripts
COPY rootfs/ /

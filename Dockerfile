# Define QLC+ version
ARG QLC_VER=4.14.4

# Multi-stage build for better layer caching
FROM ubuntu:24.04 AS downloader
ARG QLC_VER
ADD qlcplus_${QLC_VER}_amd64.deb /tmp/qlcplus.deb

# Pull base image with version pinning
FROM jlesage/baseimage-gui:ubuntu-24.04-v4.11.3

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
        libasound2t64 \
	libc6 \
        libfftw3-double3 \
        libftdi1-2 \
	libgcc-s1 \
        libusb-1.0-0 \
	libqt6core6t64 \
	libqt6gui6t64 \
	libqt6multimedia6 \
	libqt6multimediawidgets6 \
	libqt6network6t64 \
	libqt6qml6 \
	libqt6serialport6 \
	libqt6websockets6 \
	libqt6widgets6t64 \
	libstdc++6 \
	libudev1 \
	qt6-websockets-abi && \
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

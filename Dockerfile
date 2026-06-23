# Pull base image with version pinning
FROM jlesage/baseimage-gui:ubuntu-26.04-v4.12.5

# Define QLC+ version
ARG QLC_VER=4.14.4

# Add metadata labels
LABEL maintainer="scotttag" \
      version="${QLC_VER}" \
      description="QLC+ lighting control software in Docker" \
      org.opencontainers.image.source="https://github.com/scotttag/qlcplus-docker"

# Install dependencies and QLC+ in a single layer
RUN \
	apt-get update && \
	apt-get -y dist-upgrade && \
	rm /var/log && \
	apt-get -y install qlcplus || true && \
	dpkg --remove --force-remove-reinstreq systemd-resolved && \
	apt --fix-broken install && \
	apt-get clean && \
	ln -s /config/log /var/log

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

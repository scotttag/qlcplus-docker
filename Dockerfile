# Define software download URLs.
ARG QLC_URL=https://www.qlcplus.org/downloads/4.13.1/qlcplus_4.13.1_amd64.deb

# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-22.04-v4

# Define working directory.
WORKDIR /tmp

ARG QLC_URL

ADD $QLC_URL /tmp/qlcplus.deb

RUN apt-get update

RUN apt-get dist-upgrade -y

# Install dependencies.
RUN \
  apt-get -y install \
    libasound2 \
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
    libusb-1.0-0 

RUN apt-get clean

RUN dpkg -i /tmp/qlcplus.deb

COPY rootfs/ /

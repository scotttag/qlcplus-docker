# Define QLC .deb
ARG QLC_VER=4.14.2

# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-22.04-v4.8.0

# Define working directory.
WORKDIR /tmp

ARG QLC_VER

ADD qlcplus_${QLC_VER}_amd64.deb /tmp/qlcplus.deb

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
    libqt5websockets5 \
    libusb-1.0-0 

RUN apt-get clean

RUN dpkg -i /tmp/qlcplus.deb

RUN rm /tmp/qlcplus.deb

ENV \
	OPERATE_MODE= \
	QLC_WEB_SERVER= \
	WORKSPACE_FILE=

COPY rootfs/ /

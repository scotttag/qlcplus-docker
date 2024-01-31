#!/bin/sh

set -u # Treat unset variables as an error.

start_qlc() {
	/usr/bin/qlcplus -m
}

log_debug "starting QLC+..."
start_qlc

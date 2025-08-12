#!/bin/bash

set -euo pipefail

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Validation functions
validate_file() {
    if [ -n "${WORKSPACE_FILE:-}" ] && [ ! -f "$WORKSPACE_FILE" ]; then
        log "Warning: Workspace file $WORKSPACE_FILE not found"
    fi
}

# Graceful shutdown handler
shutdown_handler() {
    log "Received shutdown signal, stopping QLC+..."
    if [ -n "${qlc_pid:-}" ]; then
        kill "$qlc_pid" 2>/dev/null || true
        wait "$qlc_pid" 2>/dev/null || true
    fi
    log "QLC+ stopped"
    exit 0
}

# Set up signal handlers
trap shutdown_handler SIGTERM SIGINT

# Initialize variables
command="/usr/bin/qlcplus"
params="-m"

# Build command parameters
if [ -n "${OPERATE_MODE:-}" ]; then
    params="$params -p"
    log "Operating mode enabled"
fi

if [ -n "${QLC_WEB_SERVER:-}" ]; then
    params="$params -w"
    log "Web server enabled on port 9999"
fi

if [ -n "${WORKSPACE_FILE:-}" ]; then
    validate_file
    params="$params -o $WORKSPACE_FILE"
    log "Loading workspace file: $WORKSPACE_FILE"
fi

log "Starting QLC+ with command: $command $params"

# Start QLC+ in background and capture PID
start_qlc() {
    $command $params &
    qlc_pid=$!
    log "QLC+ started with PID $qlc_pid"
    
    # Wait for the process to finish
    wait $qlc_pid
}

# Ensure data directory exists
mkdir -p /data

log "QLC+ Docker container starting..."
start_qlc

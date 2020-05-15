#!/bin/bash

## Use crazy-max/csgo-server-launcher to install SteamCMD and CSGo server
## Info here: https://github.com/crazy-max/csgo-server-launcher

# Declare some constants
DEBUG_LOG_DIR="/var/log/csgo-install-debug.log"
INSTALL_SCRIPT_PATH="/tmp/install.sh"
CONFIG_FILE="/etc/csgo-server-launcher/csgo-server-launcher.conf"
TEMP_CONFIG_FILE="/tmp/csgo-server-launcher.conf"
CONFIG_LOCK_FILE="/etc/csgo-server-launcher/.no-update"

# Declare some functions
log() {
  level=$1
  message=$2
  echo "[$level] $message"
}
fatal() {
  log "FATAL" "See $DEBUG_LOG_DIR for more information"
  exit 1
}

# Pull and run script if install doesn't exist
if [ ! -f "$CONFIG_LOCK_FILE" ]; then
  log "INFO" "Running install.sh"
  chmod +x "$INSTALL_SCRIPT_PATH" 2>&1 >> $DEBUG_LOG_DIR || {
    log "ERROR" "Failed to add executable bit!"
    fatal
  }
  $INSTALL_SCRIPT_PATH 2>&1 >> $DEBUG_LOG_DIR || {
    log "ERROR" "Install script failed!"
    fatal
  }
else
  log "WARN" "Previous installation found, skipping"
fi

# Install CSGO Server
if [ ! -f "$CONFIG_LOCK_FILE" ]; then
  log "INFO" "Installing CSGo Server, this may take a while..."
  log "INFO" "Tail $DEBUG_LOG_DIR for progress"
  /etc/init.d/csgo-server-launcher create 2>&1 >> $DEBUG_LOG_DIR || {
    log "ERROR" "Failed to install CSGo Server!"
    fatal
  }
else
  log "WARN" "Previous installation found, skipping"
fi

# Create config lock to avoid reinstall
touch $CONFIG_LOCK_FILE

log "INFO" "Overwrite config with latest provisioned file"
cp $TEMP_CONFIG_FILE $CONFIG_FILE 2>&1 >> $DEBUG_LOG_DIR || {
  log "ERROR" "Failed to copy config file!"
  fatal
}

log "INFO" "Starting CSGO server!"
sudo /etc/init.d/csgo-server-launcher start
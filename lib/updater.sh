#!/bin/bash

# Check for updates and self-update
function update {

  # Skip updates
  if [ -n "${1:-}" ] && [ "$1" == "--no-update" ]; then
    log "${OK} Update check skipped"
    return 0
  fi

  checkUpdate

  if [ $? -eq 0 ]; then # No update or error
    return
  fi

  log_temp "${PENDING} Downloading update..."

  tempFile
  local updateLog=$RETURN
  script /dev/null -qec "git pull" > $updateLog

  local output=$(script -q /dev/null -c "git pull" > /dev/null)

  if [ $? -eq 0 ]; then
    log "${OK} Update complete"
    sleep 0.5
    log "${WARN} Restarting..."
    sleep 1
    exec ./run.sh "$2"
  fi

  log "${ERROR} Update failed:"
  echo
  cat ${updateLog}
  echo
  log "${WARN} Continuing..."
}

# Check if a newer version is available
function checkUpdate() {

  # Check if git is installed
  if [ -z "$(command -v git)" ]; then
    log "${ERROR} Unable to check for updates, git is not installed"
    log "Try ${BOLD}apt install git${RESET}"
    return 0
  fi

  # Check if this is a git repository
  if ! [ -d ./.git ] && ! git rev-parse --git-dir > /dev/null 2>&1; then
    log "${WARN} Update check skipped, not in a git repository"
    return 0
  fi

  local branch=$(git symbolic-ref --short -q HEAD) || "(detached)"

  if ! [ $branch = "master" ]; then
    log "${WARN} Update check skipped, not on ${BOLD}master${RESET} branch,"
    return 0
  fi

  log_temp "${PENDING} Checking for updates..."

  git fetch &> /dev/null

  if [ $? -ne 0 ]; then
    log "${ERROR} Error while checking for updates"
    return 0
  fi

  headHash=$(git rev-parse HEAD)
  upstreamHash=$(git rev-parse master@{upstream})

  if [ "$headHash" != "$upstreamHash" ]; then
    log "${WARN} An update is available (${upstreamHash:0:7})"
    log_temp "${PROMPT} Apply update (recommended)? [Y/n]: "

    read -n 1 ans
    echo -ne "\033F" # Move up one line
    if [ "$ans" = "n" ]; then
      return 0;
    fi

    return 1
  fi

  log "${OK} You have the latest version (${headHash:0:7})"
  return 0
}

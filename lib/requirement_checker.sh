#!/bin/bash

# Check if required command line tools are available
function checkRequirements() {
  log_temp "${PENDING} Checking requirements..."

  _testRequirement "g++" "The g++ compiler is required to compile the program"
  _testRequirement "time" "The time command is required to measure program execution time"
  _testRequirement "script" "The script command is required to capture command output"

  log "${OK} Requirements met"
}

function _testRequirement() {
  if [ -z "$(command -v $1)" ]; then
      log "${ERROR} The ${BOLD}${1}${RESET} command is not availiable"

      echo
      log "$2"
      log "Try ${BOLD}apt install ${1}${RESET}"
      exit 1
  fi
}

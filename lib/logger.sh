# Terminal constants
RESET="\033[0m"
BOLD="\033[1m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
GREY="\033[37m"
CLEAR_LINE="\033[K"

# Pretty Symbols
OK="${GREEN}✓${RESET} "
ERROR="${RED}✗${RESET} "
PENDING="${CYAN}→${RESET} "
WARN="${YELLOW}⚠${RESET} "
PROMPT="${BLUE}?${RESET} "
INFO="${BLUE}i${RESET} "

clearBeforeWrite=0

function log_temp() {
  log_raw "$1"
  clearBeforeWrite=1
}

function log() {
  log_raw "$1"
  echo
}

function log_raw() {
  if [ "$clearBeforeWrite" = "1" ]; then
    echo -en "\r${CLEAR_LINE}"
    clearBeforeWrite=0
  fi

  echo -en "  $1"
}
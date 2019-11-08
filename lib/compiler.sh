COMPILE_ARGS="-std=c++11 -Wall -Wextra -O3 -fvisibility-inlines-hidden -pedantic"

# Compile the user's program
function compile() {

  # Check the an argument was provided
  if [ -z "$1" ]; then
    echo "$1"
    log "${WARN} No source file was provided\n"
    log "Usage: ${BOLD}./run.sh ../path/to/source.cpp${RESET}\n"
    exit
  fi

  # Check that the source exists
  if [ ! -r "$1" ]; then
    log "${ERROR} Cannot read provided source file:"
    log "   ${BOLD}$1${RESET}"
    log "${INFO} Make sure that relative/absolute path is correct\n"
    exit 1
  fi

  local src=$(realpath "$1")

  # Compile the source
  log_temp "${PENDING} Compiling user program..."

  tempFile # Populates $RETURN with a temporary file
  local userProgram=$RETURN

  local compileOutput=$(script /dev/null -qec "g++ ${COMPILE_ARGS} -o \"$userProgram\" \"$src\"")

  # Show compile errors
  if [ -n "$compileOutput" ]; then
    log "${ERROR} User program compilation failed"
    sleep 0.5
    echo
    log "g++ compilation options used:"
    log "${BOLD}${COMPILE_ARGS}${RESET}"
    echo
    log "The compiler returned the following:\n"
    echo ${compileOutput}
    exit 1
  fi

  log "${OK} User program successfully compiled"
  chmod +x "$userProgram" # Add execute permissions
  RETURN=$userProgram

}

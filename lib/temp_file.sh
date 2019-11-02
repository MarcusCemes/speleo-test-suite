TEMP_FILES=()

# Remove temp files on quit
function _cleanTempFiles {
  if [ ${#TEMP_FILES[@]} -ne 0 ]; then
    for file in ${TEMP_FILES[@]}; do
      rm -f $file
    done
  fi
}

trap _cleanTempFiles EXIT

# Create a temporary file, return path as global $RETURN
function tempFile() {
  RETURN=$(mktemp)
  TEMP_FILES+=("$RETURN")
}

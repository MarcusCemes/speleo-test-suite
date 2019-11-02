#!/bin/bash

# Strict execution
set -u

VERSION="2.0.0"

# Parse args
userProgramArg=$(realpath "${1:-.}")
noUpdateArg="${2:-}"

# Set the working directory to the script location
if [ -z "${BASH_SOURCE%/*}" ] ; then
  echo "BASH_SOURCE variable is not set!"
  echo "Will try to continue, but errors may occur"
fi
cd "$(realpath "${BASH_SOURCE%/*}")"

# Load libraries
for file in ./lib/* ; do
if [ -f "$file" ] ; then
    . "$file"
fi
done

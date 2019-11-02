#!/bin/bash

DEMO="demo_program"
TESTS="tests"
RESULTS="results"

# Run all tests on user and demo program
function runTests() {

  rm -rf "./$RESULTS"
  local runDemo=1

  if ! [ -r "./$DEMO" ]; then
    local runDemo=0
    log "${WARN} Demo program not found, comparison will be skipped"
  fi

  local userProgram=$1

  if ! [ -r "$userProgram" ]; then
    log "${ERROR} Compiled user program missing. This is likely a bug."
  fi

  # Locate all tests
  local tests=()
  for test in ./$TESTS/*; do
    if [ -r "$test" ]; then
      local tests+=("$test")
    fi
  done

  local nTests=${#tests[@]} # number of tests

  if [ $nTests -eq 0 ]; then
    log "${WARN} There are no tests to run"
    return
  fi

  if ! [ -d "./$RESULTS" ]; then
    mkdir "./$RESULTS"
  else
    rm -rf ./$RESULTS/*
  fi

  # Set time format for time command
  TIMEFORMAT="%3U"

  # Run the tests
  for i in ${!tests[@]}; do
    log_temp "${PENDING} Runnning test $i/$nTests";

    local test=${tests[$i]}
    local testName=$(basename "$test")
    local testDir="./$RESULTS/$testName"

    if ! [ -d "$testDir" ]; then
      mkdir "$testDir"
    else
      rm -rf $testDir/*
    fi

    local demoResult="$testDir/demo_output"
    local demoTime="$testDir/demo_time"
    local userResult="$testDir/user_output"
    local userTime="$testDir/user_time"

    # Run demo program
    if [ "$runDemo" = "1" ]; then
      ( time ./$DEMO < $test 1> $demoResult ) 2> $demoTime
      sleep 0.5 # Allow CPU to "cool off"
    fi

    # Run user program
    ( time $userProgram < $test 1> $userResult ) 2> $userTime

    sleep 0.5 # Allow CPU to "cool off"
  done

  log "${OK} $nTests tests completed"

}

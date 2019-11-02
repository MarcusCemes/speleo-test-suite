#!/bin/bash

RESULTS="results"

# Analyse the user program's performance
function anaylsePerformance() {

  # Locate all results
  local results=()
  for result in ./${RESULTS}/* ; do
    if [ -d "$result" ]; then
      local results+=("$result")
    fi
  done

  if [ ${#results[@]} -eq 0 ] || [ ${#results[@]} -eq 1 ] && ! [ -d ${#results[0]} ]; then
    return
  fi

  # Collect point scoring
  local points=0
  local total=0

  # Print helpful information about problems
  local printSimilar=0
  local printIncorrect=0
  local printAcceptable=0
  local printSlow=0

  # Table header
  echo
  log "              ${BOLD}-- Performance Analysis --${RESET}\n"
  printf "  ${BOLD}%12s  %12s  %10s  %10s${RESET}\n" "Test" "Output" "Demo time" "User time";

  for i in ${!results[@]}; do
    local result=${results[$i]}

    # Compare for exact results
    cmp --silent "$result/demo_output" "$result/user_output"
    if [ $? -eq 0 ]; then
      local comparison="Correct"
      local comparisonColour="${GREEN}"
      ((points+=3))
      ((total+=3))
    else

      # Compare for similar results, ignoring spacing
      tempFile
      local demoStripped=$RETURN
      tempFile
      local userStripped=$RETURN

      cat "$result/demo_output" | tr -d " \t\n\r" > $demoStripped
      cat "$result/user_output" | tr -d " \t\n\r" > $userStripped


      diff --strip-trailing-cr -w -B "$demoStripped" "$userStripped" > /dev/null
      if [ $? -eq 0 ]; then
        local comparison="Similar"
        local comparisonColour="${YELLOW}"
        local printSimilar=1
        ((points+=1))
        ((total+=3))
      else
        # It's just... wrong.
        local comparison="Incorrect"
        local comparisonColour="$RED$BOLD"
        local printIncorrect=1
        ((total+=3))
      fi
    fi

    # Compare times
    local demoTime=$(cat "$result/demo_time")
    local userTime=$(cat "$result/user_time")
    local userTimeColour="${RESET}"

    local notNegligible=$(echo "$demoTime > 0.1" | bc -l) # Negligible means faster than 100ms (imprecise timing)
    local faster=$(echo "$demoTime > $userTime" | bc -l)
    local acceptable=$(echo "2 * $demoTime > $userTime " | bc -l)

    if [ "$notNegligible" == "1" ]; then
      if [ "$acceptable" == "1" ]; then
        if [ "$faster" == "1" ]; then
          local userTimeColour="${GREEN}"
          if [ "$comparison" != "Incorrect" ]; then
            ((points+=3))
          fi
          ((total+=3))
        else
          local userTimeColour="${YELLOW}"
          local printAcceptable=1
          if [ "$comparison" != "Incorrect" ]; then
            ((points+=1))
          fi
          ((total+=3))
        fi
      else
        local userTimeColour="${RED}"
        local printSlow=1
        ((points+=0))
        ((total+=3))
      fi
    fi

    local testName=$(basename "$result")
    printf "  %12s %b %12s %b %10s %b %10s %b\n" ${testName:0:12} "$comparisonColour" $comparison "$RESET" "${demoTime}s" "$userTimeColour" "${userTime}s" "$RESET";

  done

  # Print total score
  local percentage=$(echo "$points / $total * 100" | bc -l | awk '{print int($1)}')
  echo
  log "You scored ${BOLD}${points}/${total}${RESET} (${percentage}%) points\n"

  # Print pointers
  if [ "$printSimilar" == "1" ]; then
    log "${YELLOW}Similar${RESET}: Your program's output matched the demo with spacing removed"
  fi

  if [ "$printIncorrect" == "1" ]; then
    log "${RED}Incorrect${RESET}: Your program's output did not match the demo"
  fi

  if [ "$printAcceptable" == "1" ]; then
    log "${YELLOW}Acceptable${RESET}: You were 1-2x slower than the demo"
  fi

  if [ "$printSlow" == "1" ]; then
    log "${RED}Too slow${RESET}: You were more than 2x slower than the demo"
  fi

  # Require a certain amount of tests passed
  if [ $points -eq $total ] && [ $total -ge 12 ]; then
    echo
    log "${BOLD}Congratulations! You are ${YELLOW}GOLDEN${RESET}${BOLD}!${RESET}\n"
  fi

}

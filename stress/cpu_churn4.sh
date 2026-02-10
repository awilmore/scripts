#!/bin/bash

# Script to stress CPU cores for a specified duration.

# --- Configuration & Constants ---
PROG_NAME=$(basename "$0")

# --- Functions ---

# Function to display usage instructions
usage() {
  echo "Usage: ${PROG_NAME} <number_of_cores> <duration_in_seconds>"
  echo "Example: ${PROG_NAME} 4 60  (Stresses 4 cores for 60 seconds)"
  exit 1
}

# Function to clean up background processes
# Takes PIDs as arguments
cleanup() {
  echo
  echo "Cleaning up stress processes..."
  for pid in "$@"; do
    # Check if the process exists before trying to kill it
    if ps -p "${pid}" > /dev/null; then
      echo "Killing process ${pid}..."
      kill "${pid}"
      # Wait a moment for the process to terminate gracefully
      # If it doesn't, force kill (optional, kill should be sufficient for simple loops)
      # sleep 0.1
      # if ps -p "${pid}" > /dev/null; then
      #   kill -9 "${pid}"
      # fi
    else
      echo "Process ${pid} already terminated."
    fi
  done
  echo "Cleanup complete."
}

# --- Argument Validation ---

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
  echo "Error: Incorrect number of arguments."
  usage
fi

NUMBER_OF_CORES=$1
DURATION_IN_SECONDS=$2

# Validate if number_of_cores is a positive integer
if ! [[ "${NUMBER_OF_CORES}" =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: <number_of_cores> must be a positive integer."
  usage
fi

# Validate if duration_in_seconds is a positive integer
if ! [[ "${DURATION_IN_SECONDS}" =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: <duration_in_seconds> must be a positive integer."
  usage
fi

# --- Main Script Logic ---

echo "Starting CPU stress test..."
echo "Number of cores to stress: ${NUMBER_OF_CORES}"
echo "Duration: ${DURATION_IN_SECONDS} seconds"
echo "Press Ctrl+C to interrupt and clean up early."

# Array to store Process IDs (PIDs) of the stress tasks
pids=()

# Trap SIGINT (Ctrl+C) and SIGTERM to ensure cleanup
# Pass the PIDs array to the cleanup function when expanded
trap 'echo "Interrupt received, cleaning up..."; cleanup "${pids[@]}"; exit 130' SIGINT
trap 'echo "Termination signal received, cleaning up..."; cleanup "${pids[@]}"; exit 143' SIGTERM

# Start stress tasks
for i in $(seq 1 "${NUMBER_OF_CORES}"); do
  echo "Starting stress process for core ${i}..."
  # This is a simple infinite loop to consume CPU.
  # 'yes > /dev/null &' is also a common alternative.
  (while :; do :; done) &
  pids+=($!) # Store the PID of the last backgrounded process
done

echo "All ${NUMBER_OF_CORES} stress processes started. PIDs: ${pids[*]}"
echo "Stress test running for ${DURATION_IN_SECONDS} seconds. Monitor your CPU usage."

# Wait for the specified duration
sleep "${DURATION_IN_SECONDS}"

echo
echo "Duration of ${DURATION_IN_SECONDS} seconds reached."

# Clean up the background processes
cleanup "${pids[@]}"

echo "CPU stress test finished."
exit 0


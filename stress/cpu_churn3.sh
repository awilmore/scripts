#!/bin/bash

# Via gemini

# Function to consume CPU; an infinite loop is highly CPU-intensive.
consume_cpu() {
  while :; do
    : # The colon ':' is a built-in bash command that does nothing, efficiently.
  done
}

# --- Main script ---

# Check if the number of cores to stress is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <number_of_cores_to_stress>"
  echo "Example: $0 4  (to stress 4 CPU cores)"
  echo ""
  echo "You can find the number of available cores on your system using commands like 'nproc' or 'lscpu'."
  echo "For example, to stress all available cores: $0 \$(nproc)"
  exit 1
fi

# Validate that the input is a positive integer
if ! [[ "$1" =~ ^[0-9]+$ ]] || [ "$1" -eq 0 ]; then
  echo "Error: Please provide a positive integer for the number of cores."
  exit 1
fi

num_cores_to_stress=$1
declare -a pids_array=() # Array to store Process IDs (PIDs) of the stress tasks

# Function to clean up (kill) all started stress processes
cleanup() {
  echo -e "\nStopping CPU stress..."
  if [ ${#pids_array[@]} -gt 0 ]; then
    kill "${pids_array[@]}" 2>/dev/null # Suppress errors if PIDs are already gone
    echo "All stress processes (${pids_array[*]}) terminated."
  else
    echo "No stress processes to terminate."
  fi
  exit 0
}

# Set up a trap to call the cleanup function on script exit (Ctrl+C, termination signal)
trap cleanup SIGINT SIGTERM EXIT

echo "Starting CPU stress on $num_cores_to_stress core(s)..."
echo "Each core will be targeted by an infinite loop process."

# Launch the specified number of CPU consuming processes in the background
for i in $(seq 1 "$num_cores_to_stress"); do
  consume_cpu &      # Run the function in the background
  pids_array+=($!)   # Store the PID of the last backgrounded process
done

echo "CPU stress initiated. Processes launched with PIDs: ${pids_array[*]}"
echo "Press Ctrl+C to stop all stress processes and exit the script."

# Keep the script running while the background jobs do their work.
# The 'wait' command will pause the script here until all child background
# processes (our stress workers) have exited, or until the script itself
# is terminated (e.g., by Ctrl+C), which then triggers the 'trap'.
wait

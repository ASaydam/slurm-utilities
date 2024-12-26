#!/bin/bash

# Get the user's Slurm jobs
jobs=$(squeue -u "$USER" --format="%A %j %T" | tail -n +2)

# Check if the user has any jobs
if [ -z "$jobs" ]; then
  echo "You have no running jobs."
  exit 0
fi

# Display jobs with an index for selection
echo "Your running Slurm jobs:"
echo "------------------------------------------------------"
echo "$jobs" | nl -w2 -s". " | awk '{printf "%-5s %-10s %-20s %s\n", $1, $2, $3, $4}'
echo "------------------------------------------------------"

# Ask the user to select jobs to cancel
read -p "Enter the job numbers to stop (e.g., 1 3 5), or 'all' to stop all: " input

# Parse the input
if [[ "$input" == "all" ]]; then
  job_ids=$(echo "$jobs" | awk '{print $1}')
else
  indices=($input)
  job_ids=$(echo "$jobs" | nl -w2 -s". " | awk -v indices="${indices[*]}" '
    BEGIN {split(indices, idx_array)}
    {for (i in idx_array) if ($1 == idx_array[i]) print $2}
  ')
fi

# Check if any jobs are selected
if [ -z "$job_ids" ]; then
  echo "No valid jobs selected. Exiting."
  exit 1
fi

# Confirm before cancelling
echo "The following job IDs will be stopped: $job_ids"
read -p "Are you sure? [y/N]: " confirm
if [[ "$confirm" =~ ^[yY]$ ]]; then
  # Cancel the jobs
  for job_id in $job_ids; do
    scancel "$job_id"
    echo "Cancelled job $job_id"
  done
else
  echo "No jobs were cancelled."
fi


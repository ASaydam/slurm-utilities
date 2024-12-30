#!/bin/bash

# Get parent directory and create logs directoy if not exist
scriptDir=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
mkdir -p $scriptDir/logs

# Function to prompt user for input with a default value
prompt() {
  local prompt_text=$1
  local default_value=$2
  read -p "$prompt_text [$default_value]: " input
  echo "${input:-$default_value}"
}

# Set timeout
set timeout 60

# Collect user input
job_name=$(prompt "Enter the job name" "default_job")
memory=$(prompt "Enter the memory required (e.g., "4G" or just "4")" "4G")
cpus=$(prompt "Enter the number of CPUs required" "1")
time=$(prompt "Enter the runtime for this job" "1-00:00:00")
use_gpu=$(prompt "Do you want to use a GPU? (yes/no)" "no")

# Ensure the memory input ends with G
if [[ ! $memory =~ G$ ]]; then
  memory="${memory}G"
fi

# GPU settings based on user input
gpu_constraint=""
if [[ $use_gpu == "yes" ]]; then
  # set gpu setting to 1
  gpu_settings="#SBATCH --gres=gpu:1"

  # Display GPU Tiers and Their Details
  echo "Available GPU Tiers:"
  echo "1. Low-Tier: "
  echo "   - Tesla K80: 24 GB (12 GB per GPU in dual-GPU setup), 4,992 CUDA cores"
  echo ""
  echo "2. Mid-Tier: "
  echo "   - Tesla T4: 16 GB, 2,560 CUDA cores"
  echo ""
  echo "3. High-Tier: "
  echo "   - Tesla V100: 32 GB, 5,120 CUDA cores"
  echo ""
  
  tier=$(prompt "Select GPU tier (low, mid, high)" "mid")
  case $tier in
    low)
      gpu_constraint="#SBATCH --constraint=tesla_k80"
      ;;
    mid)
      gpu_constraint="#SBATCH --constraint=tesla_t4"
      ;;
    high)
      gpu_constraint="#SBATCH --constraint=tesla_v100"
      ;;
    *)
      echo "Invalid tier selected. Defaulting to mid-tier."
      gpu_constraint="#SBATCH --constraint=tesla_t4"
    ;;
  esac
fi

# Generate the SLURM script from the template
slurm_script=$scriptDir/job_script.slurm
cp $scriptDir/template.slurm $slurm_script
sed -i "s/<JOB_NAME>/$job_name/" $slurm_script
sed -i "s/<MEMORY>/$memory/" $slurm_script
sed -i "s/<CPUS>/$cpus/" $slurm_script
sed -i "s/<TIME>/$time/" $slurm_script
sed -i "s#<LOGS>#${scriptDir}/logs#" $slurm_script
sed -i "s|<GPU_SETTINGS>|$gpu_settings|" $slurm_script
sed -i "s|<GPU_CONSTRAINT>|$gpu_constraint|" $slurm_script

# Submit the job with sbatch
echo "Submitting the job..."
sbatch_output=$(sbatch $slurm_script)

# Extract the job ID from sbatch output
job_id=$(echo "$sbatch_output" | awk '{print $4}')

# Report outcome
if [[ $sbatch_output == Submitted* ]]; then
  echo "Job submitted with ID: $job_id"
else
  echo "Failed to submit job."
fi

# Check if the job ID is successfully captured
if [[ -z $job_id ]]; then
  echo "Failed to retrieve job ID from sbatch output."
  exit 1
fi

# Wait for the log file to be created
log_file="$scriptDir/logs/jupyter-${job_id}.log"
echo "Waiting for the log file: $log_file"

# Loop until the log file exists and contains the SSH line
while [[ ! -f $log_file || ! $(grep '^ssh' "$log_file") ]]; do
  sleep 2
done

# Extract the entire line starting with 'ssh' from the log file
ssh_line=$(grep '^ssh' "$log_file")

# Check if the SSH line was successfully extracted
if [[ -n $ssh_line ]]; then
  echo "SSH command extracted from the log file:"
  echo "$ssh_line"
else
  echo "No SSH command found in the log file."
fi

# Wait for the log file to be updated and contain the URL line
echo "Waiting for url line, this can take up to 1 minute"

while true; do
  result=$(grep -o 'http://127[^ ]*' "$log_file")
  if [[ -n "$result" ]]; then
    # Echo the link in green color
    echo -e "\e[32mFound link: $result\e[0m"
    break
  fi
  sleep 1  # Wait 1 second before checking again
done

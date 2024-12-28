# SLURM Jupyter Job Submission Script

This script simplifies the process of submitting SLURM jobs to run a Jupyter Notebook server on a compute cluster. It includes options for configuring resources (CPUs, memory, runtime, and GPUs) and automatically generates the required SLURM script based on user input. Logs are saved in a specified directory, and the script extracts the SSH command and Jupyter URL from the logs for easy access.

---

## Features

- Interactive prompts to configure job parameters:
  - **Job Name**
  - **Memory**
  - **CPUs**
  - **Runtime**
  - **GPU usage and tier selection (optional)**
- Automatic generation of a SLURM submission script from a template.
- Saves logs in a `logs` directory within the script's parent directory.
- Extracts and displays the SSH command and Jupyter URL after job submission.
- Ensures the required logs are created and accessible before proceeding.

---

## Prerequisites

- A SLURM-managed cluster.
- `sbatch` command available and configured for submission.
- A SLURM script template named `template.slurm` located in the same directory as this script.
- Python and Jupyter Notebook installed on the cluster.
- Proper permissions to create and modify files in the script's directory.

---

## Usage

### 1. Clone or download the script

```bash
git clone https://github.com/ASaydam/slurm-utilities.git
cd slurm-utilities
```

# usage notes
add these lines to .bashrc for ease of use (change the paths according to your folder location)
```bash
alias jupyter='$HOME/../run-jupyter/run_slurm.sh'
alias stop='$HOME/../slurm-commands/stop_slurm_jobs.sh'
```

# SLURM Job Management Script

This script helps you manage and cancel your running jobs on a Slurm workload manager. It lists your currently running jobs, allows you to select specific jobs to cancel, and provides confirmation before taking any actions.

---

## Features

- Lists all running jobs for the current user in an indexed format.
- Provides an option to:
  - Cancel specific jobs by their index.
  - Cancel all running jobs at once.
- Confirms actions before canceling the selected jobs.
- Outputs the status of canceled jobs.

---

## Prerequisites

- A Slurm workload manager configured for your user account.
- Access to the `squeue` and `scancel` commands.
- Bash shell environment.

---

## Usage

### 1. Clone or download the script

```bash
git clone https://github.com/your-repository/stop-slurm-jobs.git
cd stop-slurm-jobs

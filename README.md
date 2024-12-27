# usage notes
add these lines to .bashrc for ease of use (change the paths according to your folder location)

alias jupyter='$HOME/../run-jupyter/run_slurm.sh'
alias stop='$HOME/../slurm-commands/stop_slurm_jobs.sh'

# log files
the script creates a log folder and puts all log files here

# universal jupyter notebook directory
jupyter server initiates from home directory regardless of the folder it's called from

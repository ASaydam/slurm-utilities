#!/bin/bash
#
# ASaydam (c) 2024
#
# You should only work under the /scratch/users/<username> directory.
#
# Jupyter job submission script
#
#SBATCH --job-name=<JOB_NAME>
#SBATCH --nodes 1
#SBATCH --ntasks-per-node=<CPUS>
#SBATCH --mem=<MEMORY>
#SBATCH --partition=ai
#SBATCH --account=ai
#SBATCH --qos=ai
#SBATCH --time=<TIME>
#SBATCH --output=<LOGS>/jupyter-%J.log
##SBATCH --mail-type=ALL
##SBATCH --mail-user=alpersaydam@live.com
<GPU_SETTINGS>

################################################################################
##################### !!! DO NOT EDIT BELOW THIS LINE !!! ######################
################################################################################

# Load Anaconda
echo "======================="
echo "Loading Anaconda Module..."
#module load anaconda/2.7
module load conda/latest
conda init
source activate py311
echo "======================="

echo
echo "============================== ENVIRONMENT VARIABLES ==============================="
env
echo "===================================================================================="
echo
echo

# Set stack size to unlimited
#echo "Setting stack size to unlimited..."
#ulimit -s unlimited
#ulimit -l unlimited
#ulimit -a
echo

################################################################################
##################### !!! DO NOT EDIT ABOVE THIS LINE !!! ######################
################################################################################

# get tunneling info
XDG_RUNTIME_DIR=""
port=$(shuf -i 6000-6999 -n1)
node=$(hostname -s)
user=$(whoami)

# print tunneling instructions jupyter-log
echo -e "
====================================================================================

 Here is the MobaXterm info:

Forwarded port:same as remote port
Remote server: ${node}
Remote port: ${port}
SSH server: 172.20.240.205
SSH login: $user
SSH port: 22

====================================================================================
# MacOS or linux terminal command to create your ssh tunnel on your local machine:

ssh -N -L ${port}:${node}:${port} ${user}@172.20.240.205
====================================================================================

Jupyter server information is below
"
# DON'T USE ADDRESS BELOW. 
# DO USE TOKEN BELOW
jupyter-lab --no-browser --port=${port} --ip="*" --notebook-dir=$HOME
#jupyter-lab --no-browser --ip $(hostname -f)


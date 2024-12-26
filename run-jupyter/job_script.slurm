#!/bin/bash
# 
# ASaydam (c) 2024
# 
# You should only work under the /scratch/users/<username> directory.
#
# Jupyter job submission script
#
# -= Resources =-
#

#SBATCH --job-name=default_job
#SBATCH --nodes 1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=4G
#SBATCH --partition=ai
#SBATCH --account=ai
#SBATCH --qos=ai
#SBATCH --time=1-00:00:00
#SBATCH --output=jupyter-%J.log
##SBATCH --mail-type=ALL
##SBATCH --mail-user=alpersaydam@live.com



################################################################################
##################### !!! DO NOT EDIT BELOW THIS LINE !!! ######################
################################################################################

# Load Anaconda
echo "======================="
echo "Loading Anaconda Module..."
#module load anaconda/2.7
module load anaconda/3.21.05
echo "======================="

echo
echo "============================== ENVIRONMENT VARIABLES ==============================="
env
echo "===================================================================================="
echo
echo

# Set stack size to unlimited
echo "Setting stack size to unlimited..."
ulimit -s unlimited
ulimit -l unlimited
ulimit -a
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
SSH server: login.kuacc.ku.edu.tr
SSH login: $user
SSH port: 22

====================================================================================
# MacOS or linux terminal command to create your ssh tunnel on your local machine:

ssh -N -L ${port}:${node}:${port} ${user}@login.kuacc.ku.edu.tr
====================================================================================

Jupyter server information is below
"
# DON'T USE ADDRESS BELOW. 
# DO USE TOKEN BELOW
jupyter-notebook --no-browser --port=${port} --ip="*"


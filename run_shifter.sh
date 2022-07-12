#!/bin/bash
#SBATCH -A nstaff_g
#SBATCH -C gpu
#SBATCH -q regular_ss11
#SBATCH --nodes 2
#SBATCH --ntasks-per-node=4
#SBATCH --gpus-per-node=4
#SBATCH --time 10 
#SBATCH --image=nvcr.io/nvidia/pytorch:22.05-py3

echo ========== BUILDING NCCL TESTS ==========
if [ ! -e nccl-tests ]; then
    git clone https://github.com/NVIDIA/nccl-tests.git
    cd nccl-tests
    git checkout 8274cb4 
    shifter bash -c "make -j 10 MPI=1 MPI_HOME=/usr/local/mpi"
    cd ..
else
    echo Skipping ... nccl-tests directory already exists
fi

srun --mpi=pmi2 shifter --module gpu bash -c "
    source env_nccl.sh
    nccl-tests/build/all_reduce_perf -b 8 -e 4G -f 2
"

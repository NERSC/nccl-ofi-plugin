#!/bin/bash
#SBATCH -A nstaff_g
#SBATCH -C gpu
#SBATCH -q regular_ss11
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=4
#SBATCH --gpus-per-node=4
#SBATCH --time=10
#SBATCH --image=nvcr.io/nvidia/pytorch:22.11-py3
#SBATCH -o slurm-test-shifter-%j.out

echo ========== BUILDING NCCL TESTS ==========
if [ ! -e nccl-tests-shifter ]; then
    git clone https://github.com/NVIDIA/nccl-tests.git nccl-tests-shifter
    cd nccl-tests-shifter
    #git checkout 8274cb4 
    shifter bash -c "make -j 10 MPI=1 MPI_HOME=/usr/local/mpi NCCL_HOME=$PWD/install"
    cd ..
else
    echo Skipping ... nccl-tests-shifter directory already exists
fi

echo ========== RUNNING NCCL TESTS ==========
srun --mpi=pmi2 shifter --module gpu bash -c "
    source env_nccl.sh
    nccl-tests-shifter/build/all_reduce_perf -b 8 -e 4G -f 2
"

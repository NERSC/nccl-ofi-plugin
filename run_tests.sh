#!/bin/bash
#SBATCH -A nstaff_g
#SBATCH -C gpu
#SBATCH -q regular_ss11
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=4
#SBATCH --gpus-per-node=4
#SBATCH --time=10 
#SBATCH -o slurm-test-%j.out

module load libfabric/1.15.0.0
module load cudatoolkit/11.7
module load craype-accel-nvidia80

export NCCL_HOME=$PWD/install
export N=10
export CC=cc
export CXX=CC
export MPICC=CC
export MPI_HOME=$CRAY_MPICH_DIR
export MPICH_GPU_SUPPORT_ENABLED=1
export CRAY_ACCEL_TARGET=nvidia80
export NVCC_GENCODE="-gencode=arch=compute_80,code=sm_80"

export LD_LIBRARY_PATH=$NCCL_HOME/lib:$LD_LIBRARY_PATH
export NCCL_CROSS_NIC=1
export NCCL_DEBUG=INFO
export NCCL_SOCKET_IFNAME=hsn
export NCCL_NET="AWS Libfabric"

echo ========== BUILDING NCCL TESTS ==========
if [ ! -e nccl-tests ]; then
    git clone https://github.com/NVIDIA/nccl-tests.git
    cd nccl-tests
    #git checkout 8274cb4 
    make -j $N MPI=1
    cd ..
else
    echo Skipping ... nccl-tests directory already exists
fi

echo ========== RUNNING NCCL TESTS ==========
srun nccl-tests/build/all_reduce_perf -b 8 -e 4G -f 2

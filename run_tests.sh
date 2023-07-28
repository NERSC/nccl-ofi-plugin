#!/bin/bash
#SBATCH -A nstaff
#SBATCH -C gpu
#SBATCH -q regular
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=4
#SBATCH --gpus-per-node=4
#SBATCH --time=10 
#SBATCH -o slurm-test-%j.out

module load cudatoolkit/11.7

export NCCL_HOME=$PWD/install
export MPICH_GPU_SUPPORT_ENABLED=1

export LD_LIBRARY_PATH=$NCCL_HOME/lib:$LD_LIBRARY_PATH
export FI_CXI_DISABLE_HOST_REGISTER=1
export NCCL_CROSS_NIC=1
export NCCL_DEBUG=INFO
export NCCL_SOCKET_IFNAME=hsn
export NCCL_NET="AWS Libfabric"
export NCCL_NET_GDR_LEVEL=PHB

echo ========== RUNNING NCCL TESTS ==========
srun nccl-tests/build/all_reduce_perf -b 8 -e 4G -f 2

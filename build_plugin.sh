#!/bin/bash
#SBATCH -C gpu
#SBATCH -A nstaff_g
#SBATCH -q debug_ss11
#SBATCH --nodes=1
#SBATCH --gpus-per-node=4
#SBATCH --time=30
#SBATCH -o slurm-build-%j.out

# This script will download, patch, build, and install NCCL and AWS-OFI-NCCL.
# NCCL tests can then be built in a container or baremetal for testing.

set -e

module load libfabric/1.15.0.0
module load cudatoolkit/11.7
module load craype-accel-nvidia80
module unload darshan

export INSTALL_DIR=`pwd`/install
export NCCL_HOME=$INSTALL_DIR
export LIBFABRIC_HOME=/opt/cray/libfabric/1.15.0.0
export GDRCOPY_HOME=/usr
export CRAY_ACCEL_TARGET=nvidia80
export NVCC_GENCODE="-gencode=arch=compute_80,code=sm_80"

export N=10
export CC=cc
export CXX=CC

echo ========== BUILDING NCCL ==========
if [ ! -e nccl ]; then
    git clone --branch v2.13.4-1 https://github.com/NVIDIA/nccl.git
    cd nccl
    make -j $N src.build
    make PREFIX=$NCCL_HOME install
    cd ..
else
    echo Skipping ... nccl directory already exists
fi

echo ========== BUILDING OFI PLUGIN ==========
if [ ! -e aws-ofi-nccl ]; then
    git clone -b rel/nersc-1 https://github.com/jdinan/aws-ofi-nccl.git
    cd aws-ofi-nccl

    ./autogen.sh
    ./configure --with-nccl=$NCCL_HOME --with-cuda=$CUDA_HOME --with-libfabric=$LIBFABRIC_HOME --prefix=$INSTALL_DIR --with-gdrcopy=$GDRCOPY_HOME
    make -j $N install
    cd ..
else
    echo Skipping ... aws-ofi-nccl directory already exists
fi

echo ========== PREPARING DEPENDENCIES ==========
mkdir -p install/deps/lib
cp -P $(cat dependencies) install/deps/lib/

echo
echo ========== DONE ==========
echo

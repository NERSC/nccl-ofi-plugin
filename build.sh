#!/bin/bash
#SBATCH -C gpu
#SBATCH -A nstaff
#SBATCH -q debug
#SBATCH --nodes=1
#SBATCH --gpus-per-node=4
#SBATCH --time=30
#SBATCH -o slurm-build-%j.out

# This script will download, patch, build, and install NCCL and AWS-OFI-NCCL.
# NCCL tests can then be built in a container or baremetal for testing.

set -e

module load PrgEnv-gnu
module load cudatoolkit/12.2
module unload craype-accel-nvidia80

export INSTALL_DIR=${INSTALL_DIR:-`pwd`/install}
export PLUGIN_DIR=$INSTALL_DIR/plugin
export NCCL_HOME=$INSTALL_DIR
export LIBFABRIC_HOME=/opt/cray/libfabric/1.15.2.0
export GDRCOPY_HOME=/usr
export MPI_HOME=$CRAY_MPICH_DIR

export MPICH_GPU_SUPPORT_ENABLED=0
export NVCC_GENCODE="-gencode=arch=compute_80,code=sm_80"

export N=10
export MPICC=CC
export CC=gcc #cc
export CXX=g++ #CC

echo ========== BUILDING NCCL ==========
if [ ! -e nccl ]; then
    git clone --branch v2.19.4-1 https://github.com/NVIDIA/nccl.git
    cd nccl
    make -j $N PREFIX=$NCCL_HOME src.build
    make PREFIX=$NCCL_HOME install
    cd ..
else
    echo Skipping ... nccl directory already exists
fi

echo ========== BUILDING OFI PLUGIN ==========
if [ ! -e aws-ofi-nccl ]; then
    git clone -b v1.6.0 https://github.com/aws/aws-ofi-nccl.git
    cd aws-ofi-nccl
    ./autogen.sh
    ./configure --with-cuda=$CUDA_HOME --with-libfabric=$LIBFABRIC_HOME --prefix=$PLUGIN_DIR --with-gdrcopy=$GDRCOPY_HOME --disable-tests
    make -j $N install
    cd ..
else
    echo Skipping ... aws-ofi-nccl directory already exists
fi

echo ========== BUILDING NCCL TESTS ==========
if [ ! -e nccl-tests ]; then
    git clone https://github.com/NVIDIA/nccl-tests.git
    cd nccl-tests
    make -j $N MPI=1 CC=cc CXX=CC
    cd ..
else
    echo Skipping ... nccl-tests directory already exists
fi

echo ========== PREPARING DEPENDENCIES ==========
mkdir -p ${PLUGIN_DIR}/deps/lib
cp -P $(cat dependencies.txt) ${PLUGIN_DIR}/deps/lib/

echo
echo ========== DONE ==========
echo
echo "Warning: This is a pre-release build of NCCL, performance is"
echo "         a work in progress. Please do not distribute."
echo
echo "NCCL is installed in $NCCL_HOME"
echo "NCCL tests are installed in `pwd`/nccl-tests/build"
echo
echo "To run NCCL tests (e.g. on two nodes):"
echo
echo "  $ source env_nccl.sh"
echo "  $ srun -n 8 nccl-tests/build/all_reduce_perf -b 8 -e 4G -f 2"
echo

# Source this script in your shifter container
# to pull in NCCL with the OFI plugin

export NCCL_HOME=$(dirname "${BASH_SOURCE[0]}")/install
export LD_LIBRARY_PATH=$NCCL_HOME/plugin/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$NCCL_HOME/plugin/deps/lib:$LD_LIBRARY_PATH

export FI_CXI_DISABLE_HOST_REGISTER=1
#export NCCL_CROSS_NIC=1
export NCCL_SOCKET_IFNAME=hsn
export NCCL_NET_GDR_LEVEL=PHB
export NCCL_NET="AWS Libfabric"

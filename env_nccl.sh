export INSTALL_DIR=`pwd`/install
export LD_LIBRARY_PATH=$INSTALL_DIR/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$INSTALL_DIR/deps/lib:$LD_LIBRARY_PATH
export NCCL_CROSS_NIC=1
export NCCL_DEBUG=INFO
export NCCL_SOCKET_IFNAME=hsn

# If you want it to fail when plugin load unsuccesful
export NCCL_NET="AWS Libfabric"

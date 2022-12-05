export INSTALL_DIR=`pwd`/install
export LD_LIBRARY_PATH=$INSTALL_DIR/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$INSTALL_DIR/deps/lib:$LD_LIBRARY_PATH

export FI_CXI_DISABLE_HOST_REGISTER=1
export NCCL_CROSS_NIC=1
export NCCL_DEBUG=INFO
export NCCL_SOCKET_IFNAME=hsn
export NCCL_NET_GDR_LEVEL=PHB

# If you want it to fail when plugin load unsuccesful
export NCCL_NET="AWS Libfabric"

# A short term workaround to some Linux kernel setting HPE says needs to be set but isn't.
export FI_MR_CACHE_MONITOR=memhooks

# You may also need this
#export LD_PRELOAD=$INSTALL_DIR/deps/lib/libcrypto.so.1.1:$INSTALL_DIR/deps/lib/libssl.so.1.1

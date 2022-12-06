help([[
This module loads the NVIDIA NCCL library with the AWS OFI plugin.
]])

local pkgName = "NCCL"
local fullVersion = "2.15.5"
-- test path on alvarez
local base = "/ascratch/sd/s/sfarrell/nccl-ofi-plugin/install"
local URL = "https://developer.nvidia.com/nccl"
local Description = "The NVIDIA Collective Communication Library (NCCL) implements multi-GPU and multi-node communication primitives optimized for NVIDIA GPUs and Networking. NCCL provides routines such as all-gather, all-reduce, broadcast, reduce, reduce-scatter as well as point-to-point send and receive that are optimized to achieve high bandwidth and low latency over PCIe and NVLink high-speed interconnects within a node and over NVIDIA Mellanox Network across nodes."

whatis("Name: ".. pkgName)
whatis("Version: " .. fullVersion)
whatis("URL: " .. URL)
whatis("Description: " .. Description)

setenv("NCCL_VERSION",  fullVersion)
setenv("NCCL_DIR", base)
setenv("NCCL_HOME", base)
setenv("NCCL_SOCKET_IFNAME", "hsn")
setenv("NCCL_CROSS_NIC", 1)
setenv("NCCL_NET", "AWS Libfabric")
setenv("NCCL_NET_GDR_LEVEL", "PBH")
setenv("FI_CXI_DISABLE_HOST_REGISTER", 1)

prepend_path("LD_LIBRARY_PATH", pathJoin(base,"lib"))
prepend_path("CMAKE_PREFIX_PATH", base)

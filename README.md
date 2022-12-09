# nccl-ofi-plugin

This package is used to build NCCL with the OFI plugin for use at NERSC.
The plugin is provided by AWS at https://github.com/aws/aws-ofi-nccl
with modifications by Jim Dinan at NVIDIA.

Build the plugin with
  > ./build_plugin.sh

Run on SS11 gpu nodes with shifter:
  > sbatch run_tests_shifter.sh

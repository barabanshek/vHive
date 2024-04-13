# End-to-end Serverless infrastructure for Sabre

Implementation of Sabre plugin for Firecracker described in the paper ["Sabre: Improving Memory Prefetching in Serverless MicroVMs with Near-Memory Hardware-Accelerated Compression"]().

This reposirtory is fork of [vHive](https://github.com/vhive-serverless/vHive) which allows to run Serverless images in firecracker and invoke end-to-end functions.

### Build Firecracker with Sabre

First, we need to build firecracker with Sabre. Follow instructions in our [firecracker repository](https://github.com/barabanshek/firecracker/tree/sabre/sabre).

Second, we need to build firecracker-containerd with Sabre and install it in the system. Follow instructions in our [firecracker-containerd repository](https://github.com/barabanshek/firecracker-containerd/tree/sabre/sabre).


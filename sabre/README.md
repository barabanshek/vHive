# End-to-end Serverless infrastructure for Sabre

Implementation of Sabre plugin for Firecracker described in the paper ["Sabre: Improving Memory Prefetching in Serverless MicroVMs with Near-Memory Hardware-Accelerated Compression"]().

This reposirtory is fork of [vHive](https://github.com/vhive-serverless/vHive) which allows to run Serverless images in firecracker and invoke end-to-end functions.


## Prerequisites

* First, we need to build firecracker with Sabre. Follow instructions in our [firecracker repository](https://github.com/barabanshek/firecracker/tree/sabre/sabre). You are welcome to run all tests and benchmarks from it to make sure the system is working correctly.

* Second, we need to build firecracker-containerd with Sabre and install it in the system. Follow instructions in our [firecracker-containerd repository](https://github.com/barabanshek/firecracker-containerd/tree/sabre/sabre). Make sure the example tests run succesfully.


## Running hello-world examples

The bellow instruction assumes `firecracker` and `firecracker-containerd` were installed **exactly** as specified earlier.

### Basic

The hello-world test will start a uVM with the default hello-world docker image (`docker.io/library/hello-world:latest`) or any image you provide, run it for 5 seconds, and terminate.

```
# Start firecracker-containerd
sudo firecracker-containerd --config /etc/firecracker-containerd/config.toml

# Run a hello-world test
sudo env "PATH=$PATH" go run hello_world.go -image=docker.io/library/hello-world:latest -memsize=512
```

### With default snapshotting

### With Sabre snapshotting

### With REAP snapshotting

### With REAP + Sabre snapshotting

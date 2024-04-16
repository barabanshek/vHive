# End-to-end Serverless infrastructure for Sabre

Implementation of Sabre plugin for Firecracker described in the paper ["Sabre: Improving Memory Prefetching in Serverless MicroVMs with Near-Memory Hardware-Accelerated Compression"]().

This reposirtory is fork of [vHive](https://github.com/vhive-serverless/vHive) which allows to run Serverless images in firecracker, invoke end-to-end functions, and make/manage snapshots from golang applications.


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
sudo env "PATH=$PATH" go run hello_world.go -image=docker.io/library/hello-world:latest -memsize=256 -example=start-stop
```

### With default Full snapshotting

This example will start a uVM with the specified container, run it for a bit, pause, make a **default** **Full** snapshot, terminate, and restore from the snapshot.

```
sudo env "PATH=$PATH" go run hello_world.go -image=docker.io/library/hello-world:latest -memsize=256 -example=start-snapshot-stop-resume-stop

# Check the snapshot file (`mem_file` size should be equal to uVM's memsize size)
ls -sh /fccd/snapshots/myrev-4/*
```

### With default Diff snapshotting

This example will start a uVM with the specified container, run it for a bit, pause, make a **default** **Diff** snapshot (default dirty-page based snapshot from original `firecracker`), terminate, and restore from the snapshot.

```
sudo env "PATH=$PATH" go run hello_world.go -image=docker.io/library/hello-world:latest -memsize=256 -example=start-diff-snapshot-stop-resume-stop

# Check the snapshot file (`mem_file` size should be less than uVM's memsize size)
ls -sh /fccd/snapshots/myrev-4/*
```

### With Sabre snapshotting

This example will start a uVM with the specified container, run it for a bit, pause, make a **Sabre** **Diff** snapshot (compressed dirty-page based snapshot based on Sabre), terminate, and restore from the snapshot.

```
```

### With REAP snapshotting

### With REAP + Sabre snapshotting

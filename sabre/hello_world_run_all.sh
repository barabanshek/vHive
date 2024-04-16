#!/usr/bin/env bash

# Please, manually run firecracker-containerd in a different window:
#   sudo firecracker-containerd --config /etc/firecracker-containerd/config.toml

#
IMAGE='docker.io/library/busybox:latest'

#
sudo rm /fccd/snapshots/myrev-4/*
sudo env "PATH=$PATH" go run hello_world.go -image=${IMAGE} -memsize=256 -example=start-stop

#
sudo rm /fccd/snapshots/myrev-4/*
sudo env "PATH=$PATH" go run hello_world.go -image=${IMAGE} -memsize=256 -example=start-snapshot-stop-resume-stop
SIZE_1=`ls -sh /fccd/snapshots/myrev-4/mem_file | awk '{ print $1 }'`

#
sudo rm /fccd/snapshots/myrev-4/*
sudo env "PATH=$PATH" go run hello_world.go -image=${IMAGE} -memsize=256 -example=start-diff-snapshot-stop-resume-stop
SIZE_2=`ls -sh /fccd/snapshots/myrev-4/mem_file | awk '{ print $1 }'`

#
sudo rm /fccd/snapshots/myrev-4/*
sudo env "PATH=$PATH" go run hello_world.go -image=${IMAGE} -memsize=256 -example=start-sabre-diff-snapshot-stop-resume-stop
SIZE_3=`ls -sh /fccd/snapshots/myrev-4/mem_file.snapshot | awk '{ print $1 }'`

#
echo "Sizes: " ${SIZE_1} ${SIZE_2} ${SIZE_3}

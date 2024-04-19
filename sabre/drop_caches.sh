#!/bin/sh

# Drop all caches.
echo 3 | sudo tee /proc/sys/vm/drop_caches

# Pre-warm grpc client.
${GRPC_CLI}/grpc_cli call localhost:11111 fibonacci.Greeter/nop 'nop'

echo "Cache dropped!"

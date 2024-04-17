#!/bin/sh

# Drop all caches.
echo 3 | sudo tee /proc/sys/vm/drop_caches

# Pre-warm grpc client.
/home/nikita/grpc/cmake/build/grpc_cli call 127.0.0.1:11111 fibonacci.Greeter/nop 'nop'

echo "Cache dropped!"

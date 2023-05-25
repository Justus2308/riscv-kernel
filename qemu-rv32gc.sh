#!/bin/bash

cd "$(dirname "$0")"

qemu-system-riscv32 -M virt -smp 1
echo "exit code: $?"

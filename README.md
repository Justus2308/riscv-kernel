# RISCV Kernel

## Build

To build the kernel run  
```
$ make TARGET
```  
with the appropiate target.

### Makefile targets:

* **all:** build executable (default)
* **run:** build executable and boot in qemu
* **clean:** remove build results

### Debug targets:

* **debug:** build executable and boot in qemu with gdb instance
* **dump:** build and objdump executable
* **elfclasses:** compile without linking and print elf classes of objects
* **symbols:** compile without linking and print all defined symbols

### Dependencies:

* qemu-system-riscv32
* riscv64-unknown-elf-gcc [with 32bit support]
* riscv64-unknown-elf-ld [with 32bit support]
* optionally for debugging: qemu's gdb and riscv64-unknown-elf-objdump
# riscv-kernel
A basic kernel for the RISCV platform

## Goals

* for qemu rv32gc [virt Generic Virtual Platform](https://www.qemu.org/docs/master/system/riscv/virt.html)

* M-mode up to kernel, then S-mode

* implement [recommended RISC-V boot flow](https://riscv.org/wp-content/uploads/2019/12/Summit_bootflow.pdf)

* 1 core, 1 hart

* PLIC/CLINT interrupt handling

* output to stdout via mmio

* implement ramfb
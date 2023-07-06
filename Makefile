include Makefile.config # BIDWIDTH is set there

ifndef BITWIDTH
	ERR := $(error Error: Makefile.config invalid or missing)
else ifeq ($(BITWIDTH),64)
	ABI := lp64d
else ifeq ($(BITWIDTH),32)
	ABI := ilp32d
else
	ERR := $(error Error: Invalid bit width. Check Makefile.config)
endif

SRC_DIR := src
OBJ_DIR := obj
OUT_DIR := bin

TARGET := $(OUT_DIR)/kernel-qemu-virt-rv$(BITWIDTH)gc

SRCS := $(shell find $(SRC_DIR) -name '*.c' -or -name '*.S')
OBJS := $(SRCS:%=$(OBJ_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

CC := riscv64-unknown-elf-gcc
CPPFLAGS := -MMD -MP -Iinclude/ -D__RV_BITWIDTH=$(BITWIDTH)
CFLAGS := -mabi=$(ABI) -march=rv$(BITWIDTH)gc -Wall -Wextra -nostdlib -nostartfiles -lgcc -Tsrc/linker.ld
LDFLAGS := -Wl,-m,elf$(BITWIDTH)lriscv,-b,elf$(BITWIDTH)-littleriscv,--oformat,elf$(BITWIDTH)-littleriscv

QEMU := qemu-system-riscv$(BITWIDTH)
QEMUFLAGS := -M virt -smp 1 -bios none -kernel $(TARGET) -nographic# -serial stdio


.PHONY: all run clean set32 set64 debug dump elfclasses symbols help


### BUILD TARGETS ###

all: $(TARGET)

run: $(TARGET)
	@$(QEMU) $(QEMUFLAGS)

$(TARGET): $(OBJS)
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) -o $@

$(OBJ_DIR)/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.S.o: %.S
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -O0 -c $< -o $@

clean:
	@rm -r $(OBJ_DIR) $(OUT_DIR)


### CONFIG TARGETS ###

set32:
	@sed -i '' 's/BITWIDTH :=.*/BITWIDTH := 32/' Makefile.config

set64:
	@sed -i '' 's/BITWIDTH :=.*/BITWIDTH := 64/' Makefile.config


### DEBUG TARGETS ###

debug: $(TARGET)
	@$(QEMU) -s -S $(QEMUFLAGS)

dump: $(TARGET)
	@riscv64-unknown-elf-objdump -d --target=elf$(BITWIDTH)-littleriscv $(TARGET)

elfclasses: $(OBJS)
	@for object in $(OBJS) ; do \
		echo $$object && readelf -h $$object | grep Class ; \
	done

symbols: $(OBJS)
	@for object in $(OBJS) ; do \
		echo ======== $$object && nm $$object ; \
	done


### HELP TARGET ###

help:
	@echo "For documentation on all available targets visit the repo of this project at:\n"\
	"https://github.com/Justus2308/riscv-kernel"


-include $(DEPS)

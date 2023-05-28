SRC_DIR := src
OUT_DIR := out

TARGET := $(OUT_DIR)/kernel-qemu-virt-rv32gc

SRCS := $(shell find $(SRC_DIR) -name '*.c' -or -name '*.S')
OBJS := $(SRCS:%=$(OUT_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

CC := riscv64-unknown-elf-gcc
CPPFLAGS := -MMD -MP -Iinclude/
CFLAGS := -mabi=ilp32d -march=rv32gc -Wall -Wextra
LDFLAGS := -Wl,-b elf32-littleriscv -Wl,--oformat elf32-littleriscv -Wl,-nostdlib -Wl,-Tsrc/linker.ld


.PHONY: all run debug dump elfclasses clean

all: $(TARGET)

run: $(TARGET)
	qemu-system-riscv32 -M virt -smp 1 -kernel $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $@

$(OUT_DIR)/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(OUT_DIR)/%.S.o: %.S
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -O0 -c $< -o $@

clean:
	@rm -r $(OUT_DIR)


### DEBUG TARGETS ###

debug: $(TARGET)
	qemu-system-riscv32 -s -S -M virt -smp 1 -kernel $(TARGET)

dump: $(TARGET)
	riscv64-unknown-elf-objdump -d --target=elf32-littleriscv $(TARGET)

elfclasses: $(OBJS)
	@for object in $(OBJS) ; do \
		echo $$object && readelf -h $$object | grep Class ; \
	done

symbols: $(OBJS)
	@for object in $(OBJS) ; do \
		echo ======== $$object && nm $$object ; \
	done


-include $(DEPS)

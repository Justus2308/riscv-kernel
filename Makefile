SRC_DIRS := src include
OUT_DIR := out

TARGET := $(OUT_DIR)/boot-qemu-virt-rv32gc

SRCS := $(shell find $(SRC_DIRS) -name '*.c' -or -name '*.S')
OBJS := $(SRCS:%=$(OUT_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CC := zig cc
CPPFLAGS := $(INC_FLAGS) -MMD -MP
CFLAGS := -target riscv32-freestanding -Wall -Wextra
LDFLAGS := -fuse-ld=mold -nostdlib -Tlinker.ld

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $@

$(OUT_DIR)/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(OUT_DIR)/%.S.o: %.S
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -O0 -c $< -o $@

$(OBJ) $(OUT):
	mkdir -p $@

clean:
	@rm -r $(BUILD_DIR)

-include $(DEPS)

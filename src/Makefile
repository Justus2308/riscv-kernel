SRC := src
OBJ := obj
OUT := bin

CC := clang
CPPFLAGS := -Iinclude/
CFLAGS := -Wall -Wextra -march=riscv32
LDFLAGS := -fuse-ld=mold -nostdlib -Tlinker.ld


.PHONY: all clean

all: linker.ld kernel.o kprint.o serial.o async_handler.o sync_handler.o trap_handler.o interrupt_vectable.o util.o
	$(CC) $(LDFLAGS) $(EXE_REQ) -o $(OUT)/boot-qemu-virt-rv32gc

kernel.o: kernel.c kprint.h debug.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(SRC)/kernel.c -c $(OBJ)/kernel.o

kprint.o: kprint.c kprint.h debug.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(SRC)/kprint.c -c $(OBJ)/kprint.o

serial.o: serial.S kprint.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -O0 $(SRC)/serial.S -c $(OBJ)/serial.o

async_handler.o: async_handler.c async_handler.h debug.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(SRC)/async_handler.c -c $(OBJ)/async_handler.o

sync_handler.o: async_handler.c async_handler.h debug.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(SRC)/sync_handler.c -c $(OBJ)/sync_handler.o

trap_handler.o: trap_handler.c async_handler.h sync_handler.h debug.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(SRC)/trap_handler.c -c $(OBJ)/trap_handler.o

interrupt_vectable.o: interrupt_vectable.S
	$(CC) $(CFLAGS) $(CPPFLAGS) -O0 $(SRC)/interrupt_vectable.S -c $(OBJ)/interrupt_vectable.o

util.o: util.c util.h
	$(CC) $(CFLAGS) $(CPPFLAGS) $(SRC)/util.c -c $(OBJ)/util.o

clean:
	@rm -rf $(OBJ) $(OUT)

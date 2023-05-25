CC=clang
CFLAGS=-Tlinker.ld -Iinclude/
OBJ=obj
OUT=bin

.PHONY: all clean

all:

ram_init.o: ram_init.c
	$(CC) $(CFLAGS) startup.c -c $(OBJ)/startup.o

clean:
	rm -rf *.o

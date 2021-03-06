#!/usr/bin/env sh

MAINCFLAGS="-Ike/include -nostartfiles -static"

rm -rf build
mkdir build

sparc64-linux-gnu-as -o build/boot.o ke/arch/sparcv9/sparcboot.s
sparc64-linux-gnu-gcc $MAINCFLAGS -o build/kernel.o ke/main.c
sparc64-linux-gnu-ld -T ke/arch/sparcv9/sparcboot.ld -o build/boot.bin build/boot.o build/kernel.o

#dd if=/dev/zero of=build/bootblock.bin bs=2048 count=4
#dd if=build/boot.bin of=build/bootblock.bin bs=512 seek=1 conv=notrunc

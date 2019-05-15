all: clean system

clean:
	rm -rf build

system:
	mkdir -p build
#	sparc-elf-gdc -c sys/kernel/kernel.d -o build/kernel.o
	sparc-elf-as boot/sparcboot.S -o build/sparcboot.o
	sparc-elf-ld build/sparcboot.o build/kernel.o -T boot/sparcboot.link -o build/kernel

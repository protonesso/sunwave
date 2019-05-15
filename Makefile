TARGET ?= sparc-elf-

all: clean system

clean:
	rm -rf build

system:
	mkdir -p build
	$(TARGET)gdc -c sys/kernel/kernel.d -o build/kernel.o
	$(TARGET)as boot/sparcboot.S -o build/sparcboot.o
	$(TARGET)ld build/sparcboot.o build/kernel.o -T boot/sparcboot.link -o build/kernel

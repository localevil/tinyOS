all:
	mkdir -p build/tmp
	nasm -g -f elf32 asm/boot.asm -o build/tmp/boot.o
	gcc -g -c -m32 src/main.c -o build/tmp/main.o -ffreestanding -std=c17 # -Wall -Wextra -Werror
	gcc -g -c -m32 src/kstdio.c -o build/tmp/kstdio.o -ffreestanding -std=c17 # -Wall -Wextra -Werror 
	ld -melf_i386 -T linker.ld -nostdlib -nmagic -o build/tmp/kernel.elf build/tmp/boot.o build/tmp/kstdio.o build/tmp/main.o
	objcopy -O binary build/tmp/kernel.elf build/kernel
run: build/kernel
	qemu-system-x86_64 -fda build/kernel

run_debug:
	qemu-system-x86_64 -s -S -fda build/kernel &
	gdb -x gdb_comands

clean:
	rm -r build/*


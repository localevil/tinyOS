all:
	mkdir -p build/tmp
	nasm -f elf32 asm/boot.asm -o build/tmp/boot.o
	gcc -c -m32 src/main.c -o build/tmp/main.o -ffreestanding -std=c17 -Wall -Wextra -Werror
	gcc -c -m32 src/kstdio.c -o build/tmp/kstdio.o -ffreestanding -std=c17 -Wall -Wextra -Werror 
	ld -melf_i386 -T linker.ld -nostdlib -nmagic -o build/tmp/kernel.elf build/tmp/boot.o build/tmp/kstdio.o build/tmp/main.o
	objcopy -O binary build/tmp/kernel.elf build/kernel.bin
run:
	qemu-system-x86_64 -fda build/kernel.bin

#include "../hdr/kstdio.h"

static short* vga = (short*)0xb8000;
static const int cols = 80;
static const int videoPort = 0x3d4;
static const short color = 0x0F00;
static unsigned int cursor = 0;

void writePort(unsigned char data, unsigned int reg) {
	__asm__(
		"movw %[reg], %%dx;"
		"movb %[data], %%al;"
		"outb %%al, %%dx;"
		:
		: [reg] "o" (reg), [data] "o" (data)
		);
}

unsigned int readPort(unsigned int reg) {
	unsigned int result = 123;
	__asm__(
		"movw %[reg], %%dx;"
		"movl $0, %%eax;"
		"inb %%dx, %%al;"
		"movl %%eax, %[result];"
		: [result] "=r" (result)
		: [reg] "o" (reg)
		);
	return result;
}

void set_cur_pos(unsigned int cur) {
	int pos = ((cur % cols) + cur) * 2;
	writePort(0xE, videoPort);
	writePort(0xff & (pos >> 9), videoPort + 1);
	writePort(0xF, videoPort);
	writePort(0xff & (pos >> 1), videoPort + 1);
}

void print(const char* str) {
	unsigned int i = 0;
	while(1) {
		const char ch = str[i++];
		if(ch == 0) {
			break;
		}
		if(ch == '\n') {
			cursor += 80 - cursor % 80;
			continue;
		}
		vga[cursor++] = color | ch;
	}
	writePort(0xE, videoPort);
	int x = readPort(videoPort + 1);
	set_cur_pos(cursor);
	writePort(0xE, videoPort);
	x = readPort(videoPort + 1);
}

unsigned int strlen(const char* str) {
	unsigned int count = 0;
	for(int i = 0; 1; ++i) {
		if(str[i] == 0)
			return count;
		count++;
	}
}

void clear() {
	while(cursor + 1) {
		vga[cursor--] = color | 0x0000;
	}
}

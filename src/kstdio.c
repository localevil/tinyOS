#include "../hdr/kstdio.h"

static short* vga = (short*)0xb8000;
static unsigned int cursor = 0;
void print(const char* str) {
	const short color = 0x0F00;
	for(unsigned int i = 0; i<strlen(str); ++i) {
		if(str[i] == '\n') {
			cursor += 80 - cursor % 80;
			continue;
		}
		vga[cursor] = color | str[i];
		cursor++;
	}
}

unsigned int strlen(const char* str) {
	unsigned int count = 0;
	for(int i = 0; 1; ++i) {
		if(str[i] == 0)
			return count;
		count++;
	}
}

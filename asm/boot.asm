section .boot
bits 16

global boot
boot:
	mov ax, 0x2401
	int 0x15
	mov ax, 0x3
	int 0x10

	mov [disk],dl

	mov ah,0x2
	mov al,6
	mov ch,0
	mov dh,0
	mov cl,2
	mov dl,[disk]
	mov bx, copy_target
	int 0x13

	cli

	lgdt [gdt_pointer]
	mov eax, cr0
	or eax, 0x1
	mov cr0,eax
	jmp CODE_SEG:boot2

gdt_start:
	dq 0x0
gdt_code:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0
gdt_data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0
gdt_end:

gdt_pointer:
	dw gdt_end - gdt_start
	dd gdt_start
disk:
	db 0x0
	
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

times 510 - ($-$$) db 0;
dw 0xaa55

copy_target:
	hello: db "Hello world from 512",0
bits 32
boot2:
	mov ax, DATA_SEG
	mov ds,ax
	mov es,ax
	mov fs,ax
	mov gs,ax
	mov ss,ax

halt:	mov esp,kernal_stack_top
	extern kmain
	call kmain
	cli
	hlt

section .bss
align 4
kernal_stack_bottom: equ $
	resb 16384
kernal_stack_top:

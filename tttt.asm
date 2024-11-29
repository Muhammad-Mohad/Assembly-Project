[org 0x0100]

start:
	call display_instructions
	mov ax, 0x4c00
	int 0x21


display_instructions:
	push es
	push ax
	push cx
	push di

	mov ax, 0xb800
	mov es, ax 
	mov di, 0

	mov ah, 0x3f
	mov al, ' '
	mov cx, 2000
	
	cld 
	rep stosw

	mov ah, 0x30
	mov al, 'T'
	mov [es:2000], ax 

	pop di 
	pop cx
	pop ax
	pop es
	ret
[org 0x0100]

jmp start

ob1: dw 60
ob2: dw 104
ob3: dw 156
height1: dw 14
height2: dw 5
height3: dw 10
bird_start: dw 1460
bird_status: db 'd'
seed: dw 987
old1: dw 0
old2: dw 0
game_over: db 0    ; New variable to track game state

start:
    ; removes that blinking underscore
    mov ah, 0x01
    mov cx, 0x2607
    int 0x10

    mov ax, 0
    mov es, ax
    mov ax, [es:9*4]
    mov word [old1], ax
    mov ax, [es:9*4+2]
    mov word [old2], ax
    cli
    mov word [es:9*4], movement
    mov word [es:9*4+2], cs
    call start_screen
    jmp waait

resume:
    call background

continue:
    cmp byte [game_over], 1    ; Check if game is over
    je end                      ; If game over, end the game
    call clear
    call move_ground
    call ground
    call obloop
    call check_collision       ; Check collision after updating obstacles
    jmp continue 

check_collision:
    push ax
    push bx
    push cx
    push dx
    push di

    ; Get bird's current row and column
    mov ax, [bird_start]
    mov di, ax
    shr ax, 1           ; Convert to column number
    mov cx, 160
    xor dx, dx
    div cx              ; Get row number in ax
    
    ; Check collision with each obstacle
    call check_obstacle1
    call check_obstacle2
    call check_obstacle3

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret

check_obstacle1:
    mov bx, [ob1]
    shr bx, 1           ; Convert obstacle position to column number
    cmp ax, bx
    jne no_collision_ob1

    ; Check row overlap for obstacle height
    cmp dx, [height1]
    jbe collision_detected    ; If bird is above gap, collision
    cmp dx, [height1 + 5]
    jae collision_detected    ; If bird is below gap, collision

no_collision_ob1:
    ret

check_obstacle2:
    mov bx, [ob2]
    shr bx, 1
    cmp ax, bx
    jne no_collision_ob2

    cmp dx, [height2]
    jbe collision_detected
    cmp dx, [height2 + 5]
    jae collision_detected

no_collision_ob2:
    ret

check_obstacle3:
    mov bx, [ob3]
    shr bx, 1
    cmp ax, bx
    jne no_collision_ob3

    cmp dx, [height3]
    jbe collision_detected
    cmp dx, [height3 + 5]
    jae collision_detected

no_collision_ob3:
    ret

collision_detected:
    mov byte [game_over], 1    ; Set game over flag
    call display_game_over     ; Display game over message
    ret

display_game_over:
    push ax
    push di
    mov ax, 0xb800
    mov es, ax
    mov di, 1960        ; Center of screen
    mov ah, 0x4F        ; White on red background
    mov al, 'G'
    mov [es:di], ax
    add di, 2
    mov al, 'A'
    mov [es:di], ax
    add di, 2
    mov al, 'M'
    mov [es:di], ax
    add di, 2
    mov al, 'E'
    mov [es:di], ax
    add di, 2
    mov al, ' '
    mov [es:di], ax
    add di, 2
    mov al, 'O'
    mov [es:di], ax
    add di, 2
    mov al, 'V'
    mov [es:di], ax
    add di, 2
    mov al, 'E'
    mov [es:di], ax
    add di, 2
    mov al, 'R'
    mov [es:di], ax
    pop di
    pop ax
    ret

end:
    cli
    mov ax, 0
    mov es, ax
    mov ax, [old1]
    mov [es:9*4], ax
    mov ax, [old2]
    mov [es:9*4+2], ax

    mov ah, 0x01
    mov cx, 0x0607          ; Standard DOS blinking underscore
    int 0x10

    mov ax, 0xb800
    mov es, ax
    mov di, 0
    mov cx, 2000
    mov ax, 0x0720
    rep stosw

    mov al, 0x20
    out 0x20, al

    sti

    mov ax, 0x4c00
    int 0x21

okay:
	mov word [ob1], 156
	call clear_pipe
	jmp cont
	
okay2:
	mov word [ob2], 156
	call clear_pipe
	jmp cont2
	
okay3:
	mov word [ob3], 156
	call clear_pipe
	jmp cont3
	
obloop:
	cont:
		push word [ob1]
		push word [height1]
		call obstacle
		sub word [ob1], 2
		cmp word [ob1], 0
		jz okay
	
	cont2:
		push word [ob2]
		push word [height2]
		call obstacle
		sub word [ob2], 2
		cmp word [ob2], 0
		jz okay2
		
	cont3:
		push word [ob3]
		push word [height3]
		call obstacle
		sub word [ob3], 2
		cmp word [ob3], 0
		jz okay3

    psl:
		call gogo
		
	call delay1
	call delay1
	call delay
	call delay
	call delay1
	; call delay1

	
clear_pipe:
	push es
	push ax
	push di
	push cx
	
	mov ax, 0xb800
	mov es, ax
	mov di, 0
	mov cx, 22
	
	mov al, ' '
	mov ah, 0x3f
	
	fake:	
		mov [es:di], ax
		add di, 160
		loop fake
		
	mov di, 2
	mov cx, 22
	
	fake2:
		mov [es:di], ax
		add di, 160
		loop fake2
		
	pop es
	pop ax
	pop di
	pop cx
	ret
	
; displaying background
background:	
	push es
	push ax
	push cx
	push di

	mov ax, 0xb800
	mov es, ax 
	mov di, 0

	mov ah, 0x3f
	mov al, ' '
	mov cx, 1760
	
	cld 
	rep stosw

	pop di 
	pop cx
	pop ax
	pop es
	ret
	
clear:
	push es
	push ax
	push cx
	push di

	mov ax, 0xb800
	mov es, ax 
	mov di, 3520

	mov ah, 0x67
	mov al, ' '
	mov cx, 240
	
	cld 
	rep stosw

	pop di 
	pop cx
	pop ax
	pop es
	ret

; displaying ground
ground:
	push es
	push ax
	push cx
	push di

	mov ax, 0xb800
	mov es, ax 
	mov di, 3520

	mov ah, 0x67
	mov al, '.'
	mov cx, 240
	
	cld 
	rep stosw

	pop di 
	pop cx
	pop ax
	pop es
	ret
	
delay:
	mov cx, 0x0fff
	delay_loop:
		loop delay_loop
	ret
		
delay1:
	mov cx, 0xffff
	delay1_loop:
		loop delay1_loop
	ret
	
move_ground:
	push di
	push ax
	push es
	push cx
	push bx
	
	mov di, 3520
	mov ax, 0xb800
	mov es, ax
	mov cx, 239
	
	loop_over:
		mov bx, [es:di]
		add di, 2
		mov [es:di], bx
		dec cx
		jnz loop_over
		
	pop bx
	pop cx
	pop es
	pop ax
	pop di
	
	ret

obstacle:
	push bp
	mov bp, sp
	push es
	push ax
	push cx
	push di
	push dx

	; Clear previous obstacle (upper and lower parts)
	mov di, [bp + 6]    ; di holds the obstacle's current position
	mov ax, 0xb800
	mov es, ax
	
	mov cx, [bp + 4]    ; obstacle height
	mov ah, 0x3f
	mov al, ' '         ; clear with spaces
	
	clear_upper:
		mov [es:di], ax       ; write spaces in upper part
		add di, 160           ; move to the next line (next row in VGA text mode)
		dec cx
		jnz clear_upper
		
	mov di, [bp + 6]
	add di, 2                ; move to lower part
	mov cx, [bp + 4]
	
	clear_lower:
		mov [es:di], ax       ; write spaces in lower part
		add di, 160           ; move to the next line (next row in VGA text mode)
		dec cx
		jnz clear_lower
		
	
	mov di, 0
	mov cx, [bp + 4]
	add cx, 5               
	
	multiplyfff:
		add di, 160
		dec cx
		jnz multiplyfff
		
	add di, [bp + 6]
	
	mov cx, 22
	mov dx, [bp + 4]
	sub cx, dx
	sub cx, 5
	
	clr:
		mov [es:di], ax
		add di, 160
		dec cx
		jnz clr
		
	mov di, 0
	mov cx, [bp + 4]
	add cx, 5                
	
	multiply22:
		add di, 160
		dec cx
		jnz multiply22
		
	add di, [bp + 6]
	add di, 2
	
	mov cx, 22
	mov dx, [bp + 4]
	sub cx, dx
	sub cx, 5 
	
	clr2:
		mov [es:di], ax
		add di, 160
		dec cx
		jnz clr2


	sub word [bp + 6], 2

	ok:
	mov di, [bp + 6]          ; di holds the new position
	mov ax, 0xb800
	mov es, ax
	
	mov cx, [bp + 4]          ; obstacle height
	mov ah, 0x20
	mov al, '.'               ; draw the obstacle
	
	len:
		mov [es:di], ax       ; write obstacle character in upper part
		add di, 160           ; move to the next line (next row in VGA text mode)
		dec cx
		jnz len
		
	mov di, [bp + 6]
	add di, 2                ; move to lower part
	mov cx, [bp + 4]
	
	len2:
		mov [es:di], ax       ; write obstacle character in lower part
		add di, 160           ; move to the next line (next row in VGA text mode)
		dec cx
		jnz len2
	

	mov di, 0
	mov cx, [bp + 4]
	add cx, 7                ; the space between pipes
	
	multiply:
		add di, 160
		dec cx
		jnz multiply
		
	add di, [bp + 6]
	
	mov cx, 22
	mov dx, [bp + 4]
	sub cx, dx
	sub cx, 7                ; the space between pipes
	
	len3:
		mov [es:di], ax
		add di, 160
		dec cx
		jnz len3
		
	mov di, 0
	mov cx, [bp + 4]
	add cx, 7                ; the space between pipes
	
	multiply2:
		add di, 160
		dec cx
		jnz multiply2
		
	add di, [bp + 6]
	add di, 2
	
	mov cx, 22
	mov dx, [bp + 4]
	sub cx, dx
	sub cx, 7                ; the space between pipes
	
	len4:
		mov [es:di], ax
		add di, 160
		dec cx
		jnz len4
	
	pop di
	pop cx
	pop ax
	pop es
	pop dx
	pop bp
	ret 4


bird:
	push bp
	mov bp, sp
	push es
	push ax
	push di
	
	mov ax, 0xb800
	mov es, ax

	mov ah, 0xc7
	mov al, 'o'
	mov di, [bp + 4]
	mov [es:di], ax
	mov al, ' '
	add di, 2
	mov [es:di], ax
	mov al, 'o'
	add di, 2
	mov [es:di], ax
	mov al, '|'
	add di, 158
	mov [es:di], ax

	pop es
	pop di
	pop ax
	pop bp
	ret 2

start_screen:
	ret

clear_bird:
	push bp
	mov bp, sp
	push es
	push ax
	push di
	
	mov ax, 0xb800
	mov es, ax

	mov ah, 0x3f
	mov al, ' '
	mov di, [bp + 4]
	mov [es:di], ax
	mov al, ' '
	add di, 2
	mov [es:di], ax
	mov al, ' '
	add di, 2
	mov [es:di], ax
	mov al, ' '
	add di, 158
	mov [es:di], ax

	pop es
	pop di
	pop bp
	ret 2

gogo:
    call delay
    push ax
    cmp byte [bird_status], 'd'
    je bird_down
    cmp byte [bird_status], 'u'
    je bird_up

return:
    pop ax
    ret

bird_down:
	push word [bird_start]
	call clear_bird
    mov ax, 160
    add word [bird_start], ax
    push word [bird_start]
	call bird
    jmp return

bird_up:
	push word [bird_start]
	call clear_bird
    mov ax, 160
    sub word [bird_start], ax
    push word [bird_start]
	call bird
    jmp return

movement:
    push ax
    push bx
    in al, 0x60
    cmp al, 0x48
    je go_up
    cmp al, 0xc8
    je go_down
    cmp al, 0x01
    je end
    jmp end_service

go_up:
    mov byte [bird_status], 'u'
    jmp end_service
go_down:
    mov byte [bird_status], 'd'
    jmp end_service

end_service:
    mov al, 0x20
    out 0x20, al
    pop bx
    pop ax
    iret

waait:
    in al, 0x64
    and al, 1
    jz waait
    sti
    jmp resume
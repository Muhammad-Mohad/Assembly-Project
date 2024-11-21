[org 0x0100]

jmp start

object1: dw 50
object2: dw 100
object3: dw 150
height1: dw 8
height2: dw 5
height3: dw 12
bird_start: dw 1460
bird_status: db 'd'
bird_delay: dw 0
seed: dw 987
oldisr: dd 0
game_over: db 0

start:
    ; removes that blinking underscore
    mov ah, 0x01
    mov cx, 0x2607
    int 0x10

    mov ax, 0
    mov es, ax
    mov ax, [es:9*4]
    mov word [oldisr], ax
    mov ax, [es:9*4+2]
    mov word [oldisr + 2], ax
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
    call animation
    call check_collision       ; Add collision detection
    jmp continue 

check_collision:
    push ax
    push bx
    push dx
    
    ; Check if bird hits the ground (bottom of screen)
    cmp word [bird_start], 3520    ; Bottom screen limit
    jae collision_detected

	; checking collision with obstacle 1
	mov ax, [object1]
	mov bx, [bird_start]
	add bx, 6
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 1120
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected

	; checking collision with obstacle 2
	mov ax, [object2]
	mov bx, [bird_start]
	add bx, 6
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 1120
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected

	; checking collision with obstacle 3
	mov ax, [object3]
	mov bx, [bird_start]
	add bx, 6
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 1120
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected
	add ax, 160
	cmp ax, bx
	je collision_detected

    
    pop dx
    pop bx
    pop ax
    ret

collision_detected:
    mov byte [game_over], 1    ; Set game over flag
    
    pop dx
    pop bx
    pop ax
    ret

end:
    cli
    mov ax, 0
    mov es, ax
    mov ax, [oldisr]
    mov [es:9*4], ax
    mov ax, [oldisr + 2]
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

clearpipe1:
	mov word [object1], 156
	call clear_pipe
	jmp continue_animation_1
	
clearpipe2:
	mov word [object2], 156
	call clear_pipe
	jmp continue_animation_2
	
clearpipe3:
	mov word [object3], 156
	call clear_pipe
	jmp continue_animation_3
	
animation:
	continue_animation_1:
		push word [object1]
		push word [height1]
		call obstacle
		sub word [object1], 2
		cmp word [object1], 0
		jz clearpipe1
	
	continue_animation_2:
		push word [object2]
		push word [height2]
		call obstacle
		sub word [object2], 2
		cmp word [object2], 0
		jz clearpipe2
		
	continue_animation_3:
		push word [object3]
		push word [height3]
		call obstacle
		sub word [object3], 2
		cmp word [object3], 0
		jz clearpipe3

    check:
		call status
		
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
	
	l1:	
		mov [es:di], ax
		add di, 160
		loop l1
		
	mov di, 2
	mov cx, 22
	
	l2:
		mov [es:di], ax
		add di, 160
		loop l2
		
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
	
	l3:
		add di, 160
		dec cx
		jnz l3
		
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
	
	l4:
		add di, 160
		dec cx
		jnz l4
		
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

	l5:
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
	
	l6:
		add di, 160
		dec cx
		jnz l6
		
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
	
	l7:
		add di, 160
		dec cx
		jnz l7
		
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

	pop es
	pop di
	pop ax
	pop bp
	ret 2


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

	pop es
	pop di
	pop ax
	pop bp
	ret 2

status:
    call delay
    push ax

    cmp word [bird_delay], 0
    jne decrement_delay 

    cmp byte [bird_status], 'd'
    je bird_down
    cmp byte [bird_status], 'u'
    je bird_up

    jmp return

decrement_delay:
    dec word [bird_delay]
    jmp return

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
	mov word [bird_delay], 1
    jmp return

bird_up:
    push word [bird_start]
    call clear_bird

    cmp word [bird_start], 20
    jle stay_at_top  

    mov ax, 640
    sub word [bird_start], ax
    cmp word [bird_start], 20
    jl set_to_top  

    push word [bird_start]
    call bird
    mov word [bird_delay], 1  
    jmp return

set_to_top:
    mov word [bird_start], 20
    push word [bird_start]
    call bird

    mov word [bird_delay], 1
    jmp return

stay_at_top:
    push word [bird_start]
    call bird
    mov word [bird_delay], 1
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

start_screen:
    push ax
    push es
    push di
    push cx
    mov ax, 0xb800
	mov es, ax 
	mov di, 0
	mov ax, 0x7020
	mov cx, 2000
	
	cld 
	rep stosw

	mov di, 1146
    mov ax, 0x4420
    mov [es:di], ax
	add di, 160
    mov [es:di], ax
    add di, 160
    mov [es:di], ax
    add di, 160
    mov [es:di], ax
    add di, 160
    mov [es:di], ax
    add di, 160
    mov [es:di], ax
    sub di, 800
    add di, 2
    mov [es:di], ax
    add di, 2
    mov [es:di], ax
    add di, 2
    mov [es:di], ax
    add di, 2
    mov [es:di], ax
    add di, 2
    mov [es:di], ax
    add di, 320
    sub di, 8
    mov [es:di], ax
    add di, 2
    mov [es:di], ax    
    add di, 2
    mov [es:di], ax
    add di, 4
    mov [es:di], ax
    add di, 160
    mov [es:di], ax
    add di, 160
    mov [es:di], ax
    add di, 160
    mov [es:di], ax
    add di, 2
    mov [es:di], ax
    add di, 2
    mov [es:di], ax
    add di, 2
    mov [es:di], ax
	add di, 4
	sub di, 480
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 2
	sub di, 480
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 160
	mov [es:di], ax	
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	sub di, 4
	sub di, 160
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 6
	sub di, 320
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	sub di, 480
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	sub di, 2
	mov [es:di], ax
	sub di, 2
	mov [es:di], ax
	add di, 8
	sub di, 320
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	sub di, 160
	mov [es:di], ax
	sub di, 160
	mov [es:di], ax
	sub di, 160
	mov [es:di], ax
	sub di, 2
	mov [es:di], ax
	sub di, 2
	mov [es:di], ax
	add di, 8
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	sub di, 6
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 4
	sub di, 480
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 4
	sub di, 480
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	sub di, 320
	mov [es:di], ax
	sub di, 160
	mov [es:di], ax
	add di, 640
	mov [es:di], ax
	sub di, 2
	mov [es:di], ax
	sub di, 2
	mov [es:di], ax
	sub di, 2
	mov [es:di], ax
	add di, 10
	sub di, 640
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 2
	sub di, 480
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	sub di, 2
	mov [es:di], ax
	sub di, 2
	mov [es:di], ax
	add di, 8
	sub di, 320
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	sub di, 6
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	sub di, 2
	mov [es:di], ax
	sub di, 2
	mov [es:di], ax
	sub di, 2
	mov [es:di], ax
	add di, 10
	sub di, 640
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 160
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	sub di, 4
	sub di, 320
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	sub di, 4
	sub di, 320
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	add di, 2
	mov [es:di], ax
	
	
	mov di, 3842
	mov ah, 0x71
	mov al, 'M'
	mov [es:di], ax
	mov al, 'o'
	add di, 2
	mov [es:di], ax
	mov al, 'h'
	add di, 2
	mov [es:di], ax
	mov al, 'a'
	add di, 2
	mov [es:di], ax
	mov al, 'd'
	add di, 2
	mov [es:di], ax
	add di, 2
	mov al, '('
	mov [es:di], ax
	add di, 2
	mov al, '2'
	mov [es:di], ax
	mov al, '3'
	add di, 2
	mov [es:di], ax
	mov al, 'L'
	add di, 2
	mov [es:di], ax
	mov al, '-'
	add di, 2
	mov [es:di], ax
	mov al, 'O'
	add di, 2
	mov [es:di], ax
	mov al, '7'
	add di, 2
	mov [es:di], ax
	mov al, '8'
	add di, 2
	mov [es:di], ax
	mov al, '4'
	add di, 2
	mov [es:di], ax
	mov al, ')'
	add di, 2
	mov [es:di], ax
	
	mov di, 3966
	mov al, 'R'
	mov [es:di], ax
	add di, 2
	mov al, 'u'
	mov [es:di], ax
	add di, 2
	mov al, 's'
	mov [es:di], ax
	add di, 2
	mov al, 't'
	mov [es:di], ax
	add di, 2
	mov al, 'a'
	mov [es:di], ax
	add di, 2
	mov al, 'm'
	mov [es:di], ax
	add di, 2
	mov al, '('
	mov [es:di], ax
	add di, 2
	mov al, '2'
	mov [es:di], ax
	add di, 2
	mov al, '3'
	mov [es:di], ax
	add di, 2
	mov al, 'L'
	mov [es:di], ax
	add di, 2
	mov al, '-'
	mov [es:di], ax
	add di, 2
	mov al, '3'
	mov [es:di], ax
	add di, 2
	mov al, 'O'
	mov [es:di], ax
	add di, 2
	mov al, '4'
	mov [es:di], ax
	add di, 2
	mov al, '1'
	mov [es:di], ax
	add di, 2
	mov al, ')'
	mov [es:di], ax
	
	mov di, 3094
	mov al, 'P'
	mov ah, 0xf0
	mov [es:di], ax
	add di, 2
	mov al, 'r'
	mov [es:di], ax
	add di, 2
	mov al, 'e'
	mov [es:di], ax
	add di, 2
	mov al, 's'
	mov [es:di], ax
	add di, 2
	mov al, 's'
	mov [es:di], ax
	add di, 2
	mov al, ' '
	mov [es:di], ax
	add di, 2
	mov al, 'A'
	mov [es:di], ax
	add di, 2
	mov al, 'n'
	mov [es:di], ax
	add di, 2
	mov al, 'y'
	mov [es:di], ax
	add di, 2
	mov al, ' '
	mov [es:di], ax
	add di, 2
	mov al, 'K'
	mov [es:di], ax
	add di, 2
	mov al, 'e'
	mov [es:di], ax
	add di, 2
	mov al, 'y'
	mov [es:di], ax
	add di, 2
	mov al, ' '
	mov [es:di], ax
	add di, 2
	mov al, 'T'
	mov [es:di], ax
	add di, 2
	mov al, 'o'
	mov [es:di], ax
	add di, 2
	mov al, ' '
	mov [es:di], ax
	add di, 2
	mov al, 'C'
	mov [es:di], ax
	add di, 2
	mov al, 'o'
	mov [es:di], ax
	add di, 2
	mov al, 'n'
	mov [es:di], ax
	add di, 2
	mov al, 't'
	mov [es:di], ax
	add di, 2
	mov al, 'i'
	mov [es:di], ax
	add di, 2
	mov al, 'n'
	mov [es:di], ax
	add di, 2
	mov al, 'u'
	mov [es:di], ax
	add di, 2
	mov al, 'e'
	mov [es:di], ax
	
	mov ah, 0x70
	mov di, 550
	mov al, 'W'
	mov [es:di], ax
	add di, 2
	mov al, 'e'
	mov [es:di], ax
	add di, 2
	mov al, 'l'
	mov [es:di], ax
	add di, 2
	mov al, 'c'
	mov [es:di], ax
	add di, 2
	mov al, 'o'
	mov [es:di], ax
	add di, 2
	mov al, 'm'
	mov [es:di], ax
	add di, 2
	mov al, 'e'
	mov [es:di], ax
	add di, 314
	mov al, 'T'
	mov [es:di], ax
	add di, 2
	mov al, 'o'
	mov [es:di], ax
	
	mov ah, 0x71
	mov di, 0
	mov al, '('
	mov [es:di], ax
	add di, 2
	mov al, 'F'
	mov [es:di], ax
	add di, 2
	mov al, 'a'
	mov [es:di], ax
	add di, 2
	mov al, 'l'
	mov [es:di], ax
	add di, 2
	mov al, 'l'
	mov [es:di], ax
	add di, 2
	mov al, ' '
	mov [es:di], ax
	add di, 2
	mov al, '2'
	mov [es:di], ax
	add di, 2
	mov al, 'O'
	mov [es:di], ax
	add di, 2
	mov al, '2'
	mov [es:di], ax
	add di, 2
	mov al, '4'
	mov [es:di], ax
	add di, 2
	mov al, ')'
	mov [es:di], ax
	
	
    pop cx
    pop di
    pop es
    pop ax
	ret
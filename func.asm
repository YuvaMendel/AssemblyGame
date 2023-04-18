IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
	num dw 201
	newLinw db 10, 13, '$'
	X dw 07D0h
	Y dw 0640h
; --------------------------

CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
	; sub sp, 2
	; push 9dh
	; push 0d100h
	; call Sqrt2
	; pop ax
	; call printAxDec
	sub sp, 4
	push 0000h
	push 018h
	call XYtoAddWithIncline
	mov ax, 13h
	int 10h	
	push 0a000h
	pop es
	pop dx
	pop cx
loopHere:
	sub sp, 2
	mov di, [X]
	mov si, [Y]
	mov ax, di
	SHL ax, 12
	cmp ax, 1000000000000000b
	jna NoInc
	add di, 10000b
NoInc:
	mov ax, si
	SHL ax, 12
	cmp ax, 1000000000000000b
	jna NoInc2
	add si, 10000b
NoInc2:
	SHR si, 4
	SHR di, 4
Done:
	push di
	push si
	call XYToMemory
	pop bx
	mov [byte es:bx], 2
	call LoopDelay1Sec
	add [X], dx
	add [Y], cx
	
	jmp loopHere
	
	
; --------------------------

exit:
	mov ax, 4c00h
	int 21h
	
proc LoopDelay1Sec
	push cx
	mov cx ,100
@@Self1:
	push cx
	mov cx,3000   
@@Self2:	
	loop @@Self2
	pop cx
	loop @@Self1
	pop cx
	ret
endp LoopDelay1Sec



proc printAxDec  
	   
       push bx
	   push dx
	   push cx
	           	   
       mov cx,0   ; will count how many time we did push 
       mov bx,10  ; the divider
   
put_next_to_stack:
       xor dx,dx
       div bx
       add dl,30h
	   ; dl is the current LSB digit 
	   ; we cant push only dl so we push all dx
       push dx    
       inc cx
       cmp ax,9   ; check if it is the last time to div
       jg put_next_to_stack

	   cmp ax,0
	   jz pop_next_from_stack  ; jump if ax was totally 0
       add al,30h  
	   mov dl, al    
  	   mov ah, 2h
	   int 21h        ; show first digit MSB
	       
pop_next_from_stack: 
       pop ax    ; remove all rest LIFO (reverse) (MSB to LSB)
	   mov dl, al
       mov ah, 2h
	   int 21h        ; show all rest digits
       loop pop_next_from_stack

	   pop cx
	   pop dx
	   pop bx
	   
       ret
endp printAxDec

proc Sqrt
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	
	cmp [word bp + 4], 1
	ja @@Not1
	mov ax, [bp + 4]
	mov [bp + 6], ax
	jmp @@EndOfProc
@@Not1:
	mov ax, [bp + 4]
	shr ax, 1
	mov bx, ax
	
	mov ax, [bp + 4]
	xor dx, dx
	div bx
	add ax, bx
	shr ax, 1
	mov cx, ax
	
@@WhileLoop:
	cmp cx, bx
	jae @@EndOfLoop
	mov bx, cx
	mov ax, [bp + 4]
	xor dx, dx
	div bx
	add ax, bx
	shr ax, 1
	mov cx, ax
	jmp @@WhileLoop
	
@@EndOfLoop:
	mov [bp + 6], bx
	
@@EndOfProc:
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 2
endp Sqrt
;Description: Calculates the square root of a 32 - bit number
;Input: through Stack in this order: 1.High Order word 2.Low Order word
;Output: 16 bit through Stack
;Requirements: Make room for returning value in stack (sub sp, 2)
proc Sqrt2
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push di
	push si
	push dx
	
	cmp [word bp + 4], 1
	ja @@Not1
	cmp [word bp + 6], 0
	jnz @@Not1
	mov ax, [bp + 4]
	mov [bp + 8], ax
@@Not1:
	mov bx, [bp + 4]
	mov si, [bp + 6]
	shr bx, 1
	shr si, 1
	jnc @@NoCarry1
	or bx, 1000000000000000b
@@NoCarry1:
	mov ax, [bp + 4]
	mov dx, [bp + 6]
	div bx
	mov di, si
	add ax, bx
	jnc @@NoCarry2
	inc di
@@NoCarry2:
	shr ax, 1
	shr di, 1
	jnc @@NoCarry3
	or ax, 1000000000000000b
@@NoCarry3:
	mov cx, ax
	
	
	@@WhileLoop:
	cmp di, si
	ja @@EndOfLoop
	jb @@NoEndOfLoop
	cmp cx, bx
	jae @@EndOfLoop
@@NoEndOfLoop:
	mov bx, cx
	mov si, di
	mov ax, [bp + 4]
	mov dx, [bp + 6]
	div bx
	mov di, si
	add ax, bx
	jnc @@NoCarry4
	inc di
@@NoCarry4:
	shr ax, 1
	shr di, 1
	jnc @@NoCarry5
	or ax, 1000000000000000b
@@NoCarry5:
	mov cx, ax
	jmp @@WhileLoop

@@EndOfLoop:
	mov [bp + 8], bx
@@EndOfProc:
	pop dx
	pop si
	pop di
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
endp Sqrt2
;Input: Through Stack: 1.Incline 2.units
;Output: Through Stack: 1.X 2.Y
;Requirements: Make room in stack before (sub sp, 4)
proc XYtoAddWithIncline
	push bp
	mov bp, sp
	push ax
	push bx
	push dx
	
	mov ax, [bp + 6];incline
	mul ax
	shr ax, 4;Fixed Decimal point Correction
	add ax, 10000b
	jnc @@NoCarry
	inc dx
@@NoCarry:

	sub sp, 2
	push dx
	push ax
	call Sqrt2
	pop bx
	SHL bx, 2
	
	xor dx, dx
	mov ax, [bp + 4];units
	
	
	div bx
	
	shl ax, 4;Fixed Decimal Point
	push ax;save
	
	Shl dx, 4;Sheerit
	mov ax, dx
	xor dx, dx
	div bx

	
	mov [bp + 8], ax; X part 1
	
	pop ax
	
	add [bp + 8], ax; X part 2
	
	cmp [word bp + 8], 0;These 3 lines are rounding all the fraction that are rounded to 0 to 1/16
	jnz @@XisSet
	mov [word bp + 8], 1
@@XisSet:
	
	xor dx, dx
	mov ax, [bp + 8]
	mov bx, [bp + 6]
	mul bx
	
	shr ax, 4
	mov [bp + 10], ax;Y
	
	pop dx
	pop bx
	pop ax
	pop bp
	ret 4
endp XYtoAddWithIncline

proc XYToMemory
	push bp
	mov bp, sp
	push ax
	push bx
	push dx
	xor dx, dx
	mov bx, 320
	mov ax, [bp + 4]
	mul bx
	add ax, [bp + 6]
	mov [bp + 8], ax
	pop dx
	pop bx
	pop ax
	pop bp
	ret 4
endp XYToMemory
END start



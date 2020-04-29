[BITS 16]
[ORG 1770h]

push 	cs
pop 	ds

mov 	bl, 0
mov 	[count], bl

mov 	ah, 01h
mov 	[pages], ah
mov 	di, content

jmp Start_Editor

Start_Editor:
	mov 	ah, 05h
	mov 	al, 01h
	int 	10h
	call 	config
	jmp 	MyCode
	
config:
	mov 	bl, [ds:0CF2h]
	cmp 	bl, 10
	je 		move_cursor
	jmp 	erase_screen
	
	erase_screen:
		call 	Clear_Screen
		jmp 	move_cursor
		
	move_cursor:
		mov 	ah, 02h
		mov 	bh, [pages]
		mov 	dh, 1
		mov 	dl, 1
		int 	10h
		call 	print_info
		jmp 	ret_config
		
	ret_config:
		ret
	
print_info:
	mov 	bl, [ds:0CF2h]
	cmp 	bl, 2
	je 		print_now
	jmp 	ret11
	print_now:
		mov 	di, si
		call 	print_str
		jmp 	ret11
	ret11:
		ret
	
Clear_Screen:
		mov 	ah, 06h
		mov 	al, 0
		mov 	bh, 0000_1111b
		mov 	ch, 0
		mov 	cl, 0
		mov 	dh, 24
		mov 	dl, 79
		int 	10h
		ret
	
Despop:
	mov 	bl, -1
	mov 	[stack], bl
	ret
		
	
print_str:
	mov 	ah, 0eh
	xor 	bx, bx
	mov 	bl, [count]
	jmp 	prints
	prints:
		mov 	al, [si]
		cmp 	al, 0
		jz 		ret10
		cmp 	al, 0Dh
		je 		GetLine
		inc 	si
		int 	10h
		inc 	bl
		cmp 	al, 0Ah
		je 		IncCol
		jmp 	prints
	IncCol:
		mov 	ah, 03h
		mov 	bh, [pages]
		int 	10h
		mov 	ah, 02h
		inc 	dl
		int 	10h
		mov 	ah, 0Eh
		jmp 	prints
	GetLine:
		mov 	ah, 03h
		mov 	bh, [pages]
		int 	10h
		push 	bx
		xor 	bx, bx
		mov 	bl, [stack]
		inc 	bl
		mov 	[stack], bl
		mov 	[ds:4000h+bx], dl
		xor 	bx, bx
		pop 	bx
		mov 	ah, 0Eh
		mov 	al, 0Dh
		inc 	si
		int 	10h
		inc 	bl
		jmp 	prints
	ret10: 
		mov 	[count], bl
		xor 	bx, bx
		ret
		
MyCode:
	mov 	bl, 0
	mov 	ah, 00h
	int 	16h
	call 	Verify_Keys_Special
	cmp 	al, 27
	je 		Esc_Key
	cmp 	bl, 1
	je 		Continue
	call 	Save_Chars
	jmp 	Continue
Continue:
	cmp 	al, 0Dh
	je 		Enter_Key
	mov 	ah, 0eh
	int 	10h
	mov 	ah, 03h
	mov 	bh, [pages]
	int 	10h
	cmp 	dl, 0
	je 		Column
	cmp		dl, 78
	je		Enter_Key
	jmp 	MyCode

Enter_Key:				;FUNCAO PRONTA, NAO ALTERAR!
	mov 	ah, 03h
	mov 	bh, [pages]
	int 	10h
	xor 	bx, bx
	mov 	bl, [stack]
	inc 	bl
	mov 	[stack], bl
	mov 	[ds:4000h+bx], dl
	call 	SUBDL     
	mov 	ah, 02h
	mov 	bh, [pages]
	inc 	dh
	mov 	dl, 1
	int 	10h
	call 	Rolls_Up
	jmp 	MyCode
	
	
Verify_Keys_Special:
	cmp 	ah, 4Dh
	je 		Right
	cmp 	ah, 4Bh
	je 		Left
	cmp 	ah, 48h
	je		Up
	cmp 	ah, 50h
	je 		Down
	cmp 	al, 8
	je 		BackSpace
	jmp 	ret7
	Right:
		call 	Change_Cursor_Right
		call 	Verify_Position
		mov 	bl, 1
		jmp 	ret7
	Left:
		call 	Change_Cursor_Left
		call 	Verify_Position
		mov 	bl, 1
		jmp 	ret7
	Up:
		call 	Change_Cursor_Up
		call 	Verify_Position
		mov 	bl, 1
		jmp 	ret7
	Down:
		call 	Change_Cursor_Down
		call 	Verify_Position
		mov 	bl, 1
		jmp 	ret7
	BackSpace:
		xor 	bx, bx
		mov 	bl, [count]
		dec 	bl
		mov 	[count], bl
		mov 	al, 0
		mov 	[di+bx], al
		mov 	ah, 0eh
		mov 	al, 8
		int 	10h
		mov 	al, 32
		int 	10h
		mov 	al, 8
		mov 	bl, 1
		jmp 	ret7
	ret7:
		ret
		
	
Verify_Position:
	mov 	bl, 0
	mov 	[count], bl
	mov 	ah, 03h
	mov 	bh, 01h
	int 	10h
	mov 	cl, 1
	cmp 	cl, dh
	je 		VerifyColumn
	xor 	bx, bx
	jmp  	VerifyLine
	VerifyLine:
		mov 	al, [di+bx]
		inc 	bl
		mov 	[count], bl
		cmp 	al, 0Dh
		jne 	VerifyLine
		inc 	bl
		mov 	[count], bl
		inc 	cl
		cmp 	cl, dh
		je 		VerifyColumn
		jmp 	VerifyLine
	VerifyColumn:
		mov 	cl, 0
		dec 	bl
		mov 	[count], bl
		jmp 	Search_Column
	Search_Column:
		inc 	bl
		mov 	[count], bl
		inc 	cl
		cmp 	cl, dl
		jne 	Search_Column
		jmp 	Ret_Position
Ret_Position:
	ret
		
	
Esc_Key:
	mov 	ah, 00h
	int 	16h
	cmp 	al, '0'
	je 		Back
	cmp 	al, 27
	je 		MyCode
	call	Verify_Key_Page
	jmp 	Esc_Key
	
Back:
	call 	Despop
	jmp 	0800h:052Eh

Verify_Key_Page:
	cmp 	ah, 4Dh
	je 		VerifyPage2
	cmp 	ah, 4Bh
	je 		VerifyPage3
	jmp 	ret2
	VerifyPage2:
		cmp 	bh, 16
		jb 		RightPage
		jmp 	ret2
	VerifyPage3:
		cmp 	bh, 1
		ja 		LeftPage
		jmp 	ret2
	RightPage: 	
		call 	Inc_Page
		jmp 	ret2
	LeftPage:
		call 	Dec_Page
		jmp 	ret2
	
	ret2:
		ret
		
Save_Chars:
	xor 	bx, bx
	mov 	bl, [count]
	mov 	[di+bx], al
	inc 	bl
	mov 	[count], bl
	xor 	bx, bx
	cmp 	al, 0Dh
	je 		ADD0A
	jmp 	ret_char
	ADD0A:
		mov 	bl, [count]
		mov 	al, 0Ah
		mov 	[di+bx], al
		inc 	bl
		mov 	[count], bl
		xor 	bx, bx
		mov 	al, 0Dh
		jmp 	ret_char
	ret_char:
		ret
	
	
Column:
	cmp 	dh, 1
	je 		Line
	;pop		dx
	dec 	dh
	xor 	bx, bx
	mov 	bl, [stack]
	mov 	dl, [ds:4000h+bx]
	dec 	bl
	mov 	[stack], bl
	mov 	ah, 02h
	mov 	bh, [pages]
	int		10h
	jmp 	MyCode
	
Line:
	mov 	ah, 02h
	mov 	bh, [pages]
	add		dl, 1
	int 	10h
	call 	Rolls_Down
	jmp 	MyCode
	
;rotinas para o editor negro

	
SUBDL:
	cmp 	dl, 0
	jne		subcol
	jmp 	retnow
	subcol:
		sub 	dl, 1
		jmp 	retnow
	retnow:
		ret
		
Rolls_Up:
	;pop 	dx
	;push 	dx
	cmp 	dh, 23
	je 		roll_line1
	jmp 	retback
	roll_line1:
		call 	Inc_Page
		jmp 	retback
	retback:
		ret
		
		
Rolls_Down:
	cmp 	dh, 1
	je 		roll_line2
	jmp 	retback1
	roll_line2:
		call 	Dec_Page	
		jmp 	retback1
	retback1:
		ret
		
		
		
Inc_Page:				;FUNCAO PRONTA, NAO ALTERAR!
	mov 	ah, 05h
	mov 	al, [pages]
	inc 	al
	mov 	[pages], al
	int 	10h
	call 	VerifyActivePage 
	mov 	ah, 02h
	mov 	bh, al
	mov 	dh, 1
	mov 	dl, 1
	int 	10h
	ret
	
VerifyActivePage:    ;FUNCAO PRONTA, NAO ALTERAR!
	xor 	bx, bx
	mov 	ah, 0
	mov 	si, savepages
	mov 	bx, ax
	mov 	dh, [si+bx]
	cmp 	dh, 0
	je 		UpdateSave
	jmp 	ret14
	UpdateSave:
		mov 	dh, 1
		mov 	[si+bx], dh
		xor 	bx, bx
		call 	Clear_Screen
		jmp 	ret14
	ret14:
		ret
	
Dec_Page:				;FUNCAO PRONTA, NAO ALTERAR!
	mov 	ah, 05h
	mov 	al, [pages]
	cmp 	al, 01h
	je 	 	ret1
	dec 	al
	mov 	[pages], al
	int 	10h
	mov 	ah, 02h
	mov 	bh, al
	mov 	dh, 1
	mov 	dl, 1
	int 	10h
	jmp 	ret1
ret1:
	ret
	
Change_Cursor_Up:				;FUNCAO PRONTA, NAO ALTERAR!
		mov 	ah, 03h
		mov 	bh, [pages]
		int 	10h
		cmp 	dh, 1
		je 		VerifyPage
		mov 	ah, 02h
		dec 	dh
		int 	10h
		jmp 	ret3
	VerifyPage:
		cmp 	bh, 1
		ja 		DecPage
		jmp 	ret3
	DecPage:
		call 	Dec_Page
		jmp 	ret3
	ret3:
		ret
Change_Cursor_Down:				;FUNCAO PRONTA, NAO ALTERAR!
		mov 	ah, 03h
		mov 	bh, [pages]
		int 	10h
		cmp 	dh, 23
		je		VerifyPage1
		mov 	ah, 02h
		inc 	dh
		int 	10h
		jmp 	ret6
	VerifyPage1:
		cmp 	bh, 16
		jb 		IncPage
		jmp 	ret6
	IncPage:
		call 	Inc_Page
		jmp 	ret6
	ret6:
		ret
		
Change_Cursor_Right:				;FUNCAO PRONTA, NAO ALTERAR!
		mov 	ah, 03h
		mov 	bh, [pages]
		int 	10h
		cmp 	dl, 1
		je 		ret4
		mov 	ah, 02h
		inc 	dl
		int 	10h
		jmp 	ret4
	ret4:
		ret
Change_Cursor_Left:				;FUNCAO PRONTA, NAO ALTERAR!
		mov 	ah, 03h
		mov 	bh, [pages]
		int 	10h
		cmp 	dl, 79
		je 		ret5
		mov 	ah, 02h
		dec 	dl
		int 	10h
		jmp 	ret5
	ret5:
		ret
	


content times 512 db 0
count db 0
stack db -1
pages db 0
savepages db 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	
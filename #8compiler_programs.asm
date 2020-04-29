[BITS 16]
[ORG 1D00h]

;Test Program

mov 	bl, [ds:0CF2h]
cmp 	bl, 3
je 		Start_Comp
cmp 	bl, 4
je 		Exec_Code

Start_Comp:
	mov si, initialmsg
	mov dh, 7
	call Print_Msg

	call Read_Sector

	mov si, buffer_source
	mov bx, si
	mov [ds:3000h], bx

	jmp Compile_Code

Compile_Code:
	mov bl, 0
	mov [state], bl
	mov [cont], bl
	mov [cont1], bl
	
	call CompareTo

	mov bl, [state]
	cmp bl, 1
	je  Convert

	jmp ErrorCode


CompareTo:
	jmp Strs
Strs:
	mov bx, [ds:3000h]
	mov si, bx
	xor bx, bx
	mov bl, [cont]
	inc bl
	mov [cont], bl
	cmp bl, 1
	je Str1
	cmp bl, 2
	je Str2
	cmp bl, 3
	je Str3
	cmp bl, 4
	je Str4
	cmp bl, 5
	je Str5
	cmp bl, 6
	je Str6
	cmp bl, 7
	je Str7
	cmp bl, 8
	je Str8
	cmp bl, 9
	je Str9
	cmp bl, 10
	je Str10
	cmp bl, 11
	je Str11
	cmp bl, 12
	je Str12
	cmp bl, 13
	je Str13
	cmp bl, 14
	je Str14
	cmp bl, 15
	je Str15
	cmp bl, 16
	je Str16
	cmp bl, 17
	je Str17
	cmp bl, 18
	je Str18
	cmp bl, 19
	je Str19
	cmp bl, 20
	je Str20
	cmp bl, 21
	je Str21
	cmp bl, 22
	je Str22
	cmp bl, 23
	je Str23
	cmp bl, 24
	je Str24
	cmp bl, 25
	je Str25
	cmp bl, 26
	je Str26
	cmp bl, 27
	je Str27
	cmp bl, 28
	je Str28
	cmp bl, 29
	je Str29
	cmp bl, 30
	je Str30
	cmp bl, 31
	je Str31
	cmp bl, 32
	je Str32
	cmp bl, 33
	je Str33
	cmp bl, 34
	je Str34
	cmp bl, 35
	je Str35
	cmp bl, 36
	je Str36
	cmp bl, 37
	je Str37
	cmp bl, 38
	je Str38
	cmp bl, 39
	je Str39
	cmp bl, 40
	je Str40
	cmp bl, 41
	je Str41
	cmp bl, 42
	je Str42
	cmp bl, 43
	je Str43
	cmp bl, 44
	je Str44
	cmp bl, 45
	je Str45
	cmp bl, 46
	je Str46
	cmp bl, 47
	je Str47
	cmp bl, 48
	je Str48
	cmp bl, 49
	je Str49
	jmp  RetCompare
Str1:
	mov di, inst_mov1
	jmp Compare
Str2:
	mov di, inst_mov2
	jmp Compare
Str3:
	mov di, inst_mov3
	jmp Compare
Str4:
	mov di, inst_mov4
	jmp Compare
Str5:
	mov di, inst_mov5
	jmp Compare
Str6:
	mov di, inst_mov6
	jmp Compare
Str7:
	mov di, inst_mov7
	jmp Compare
Str8:
	mov di, inst_mov8
	jmp Compare
Str9:
	mov di, inst_mov9
	jmp Compare
Str10:
	mov di, inst_mov10
	jmp Compare
Str11:
	mov di, inst_mov11
	jmp Compare
Str12:
	mov di, inst_mov12
	jmp Compare
Str13:
	mov di, inst_int13
	jmp Compare
Str14:
	mov di, inst_mov14
	jmp Compare
Str15:
	mov di, inst_mov15
	jmp Compare
Str16:
	mov di, inst_mov16
	jmp Compare
Str17:
	mov di, inst_mov17
	jmp Compare
Str18:
	mov di, inst_mov18
	jmp Compare
Str19:
	mov di, inst_mov19
	jmp Compare
Str20:
	mov di, inst_mov20
	jmp Compare
Str21:
	mov di, inst_mov21
	jmp Compare
Str22:
	mov di, inst_mov22
	jmp Compare
Str23:
	mov di, inst_mov23
	jmp Compare
Str24:
	mov di, inst_mov24
	jmp Compare
Str25:
	mov di, inst_mov25
	jmp Compare
Str26:
	mov di, inst_mov26
	jmp Compare
Str27:
	mov di, inst_mov27
	jmp Compare
Str28:
	mov di, inst_mov28
	jmp Compare
Str29:
	mov di, inst_mov29
	jmp Compare
Str30:
	mov di, inst_mov30
	jmp Compare
Str31:
	mov di, inst_mov31
	jmp Compare
Str32:
	mov di, inst_mov32
	jmp Compare
Str33:
	mov di, inst_inc1
	jmp Compare
Str34:
	mov di, inst_inc2
	jmp Compare
Str35:
	mov di, inst_inc3
	jmp Compare
Str36:
	mov di, inst_inc4
	jmp Compare
Str37:
	mov di, inst_inc5
	jmp Compare
Str38:
	mov di, inst_inc6
	jmp Compare
Str39:
	mov di, inst_inc7
	jmp Compare
Str40:
	mov di, inst_inc8
	jmp Compare
Str41:
	mov di, inst_dec1
	jmp Compare
Str42:
	mov di, inst_dec2
	jmp Compare
Str43:
	mov di, inst_dec3
	jmp Compare
Str44:
	mov di, inst_dec4
	jmp Compare
Str45:
	mov di, inst_dec5
	jmp Compare
Str46:
	mov di, inst_dec6
	jmp Compare
Str47:
	mov di, inst_dec7
	jmp Compare
Str48:
	mov di, inst_dec8
	jmp Compare
Str49:
	mov di, inst_ret
	jmp Compare
	
Compare:            ;COMPARAÇÃO FUNCIONANDO
	mov al, [si]
	cmp [di], al
	je IncRegs
	mov al, 1
	cmp [di], al
	je SetState
	jmp Strs
IncRegs:
	inc si    ;incrementa buffer_source
	mov al, [si]
	inc di    ;incrementa inst_mov*
	mov al, [di]
	jmp Compare
SetState:           ;SETSTATE EXECUTA - FUNCIONANDO
	mov bl, 0
	call Verify_Value  
	mov bl, 1
	mov [state], bl
	jmp  RetCompare
RetCompare:
	ret 
	
Verify_Value:
	mov bl, [cont]
	cmp bl, 13
	jbe Verify
	jmp Ret_Verify
	Verify:
		inc si
		call Get_Next_Value
		jmp Ret_Verify
	Ret_Verify:
		xor bx, bx
		ret
		
Get_Next_Value:
   jmp Get_Next
   Get_Next:
	mov al, [si]
	cmp al, 0Dh
	je Get_Char
	cmp al, 0
	je Get_Char
	push ax
	inc si
	mov bl, [cont1]
	inc bl
	mov [cont1], bl
	jmp Get_Next
	
	Get_Char:
		dec bl
		mov [cont1], bl
		mov dl, 0
		pop ax
		cmp al, 'h'
		je Get_Hex
		;cmp al, 'b'
		;je Get_Bin
		;cmp al, 'd'
		;je Get_Dec
		;cmp al, 'o'
		;je Get_Oct
		jmp Ret_Get_Next
	Get_Hex:
		cmp dl, bl
		je Ret_Get_Next
		cmp dl, 0
		je First_Hex
		cmp dl, 1
		je Second_Hex
		cmp dl, 2
		je Third_Hex
		cmp dl, 3
		je Four_Hex
		jmp Ret_Get_Next
	First_Hex:
		pop ax
		call Conv_Letter
		mov cl, al
		inc dl
		jmp Get_Hex
	Second_Hex:
		pop ax
		push dx
		call Conv_Letter
		push cx
		xor cx, cx
		mov cx, 16
		mul cx
		xor cx, cx
		pop cx
		add cl, al
		pop dx
		inc dl
		jmp Get_Hex
	Third_Hex:
		xor ax, ax
		mov ax, 16
		push cx
		xor cx, cx
		mov cx, 16
		mul cx
		xor cx, cx
		xor bx, bx
		mov bx, ax
		pop cx
		pop ax
		call Conv_Letter
		mul bx
		add cl, al
		inc dl
		jmp Get_Hex
	Four_Hex:
		xor ax, ax
		mov ax, 16
		push cx
		xor cx, cx
		mov cx, 16
		mul cx
		mul cx
		xor cx, cx
		xor bx, bx
		mov bx, ax
		pop cx
		pop ax
		call Conv_Letter
		mul bx
		add cl, al
		inc dl
		jmp Get_Hex
	Ret_Get_Next:
		ret
		
Conv_Letter:
	cmp al, '0'
	je  Conv0
	cmp al, '1'
	je  Conv1
	cmp al, '2'
	je  Conv2
	cmp al, '3'
	je  Conv3
	cmp al, '4'
	je  Conv4
	cmp al, '5'
	je  Conv5
	cmp al, '6'
	je  Conv6
	cmp al, '7'
	je  Conv7
	cmp al, '8'
	je  Conv8
	cmp al, '9'
	je  Conv9
	cmp al, 'A'
	je  ConvA
	cmp al, 'B'
	je  ConvB
	cmp al, 'C'
	je  ConvC
	cmp al, 'D'
	je  ConvD
	cmp al, 'E'
	je  ConvE
	cmp al, 'F'
	je  ConvF
	cmp al, 'a'
	je  ConvA
	cmp al, 'b'
	je  ConvB
	cmp al, 'c'
	je  ConvC
	cmp al, 'd'
	je  ConvD
	cmp al, 'e'
	je  ConvE
	cmp al, 'f'
	je 	ConvF
	jmp Ret_Conv
Conv0:
	mov al, 0
	jmp Ret_Conv
Conv1:
	mov al, 1
	jmp Ret_Conv
Conv2:
	mov al, 2
	jmp Ret_Conv
Conv3:
	mov al, 3
	jmp Ret_Conv
Conv4:
	mov al, 4
	jmp Ret_Conv
Conv5:
	mov al, 5
	jmp Ret_Conv
Conv6:
	mov al, 6
	jmp Ret_Conv
Conv7:
	mov al, 7
	jmp Ret_Conv
Conv8:
	mov al, 8
	jmp Ret_Conv
Conv9:
	mov al, 9
	jmp Ret_Conv
ConvA:
	mov al, 10
	jmp Ret_Conv
ConvB:
	mov al, 11
	jmp Ret_Conv
ConvC:
	mov al, 12
	jmp Ret_Conv
ConvD:
	mov al, 13
	jmp Ret_Conv
ConvE:
	mov al, 14
	jmp Ret_Conv
ConvF:
	mov al, 15
	jmp Ret_Conv
Ret_Conv:
	ret
	

Convert:
	mov di, buffer_code
	xor bx, bx
	mov bl, [cont]
	cmp bl, 1
	je code1
	cmp bl, 2
	je code2
	cmp bl, 3
	je code3
	cmp bl, 4
	je code4
	cmp bl, 5
	je code5
	cmp bl, 6
	je code6
	cmp bl, 7
	je code7
	cmp bl, 8
	je code8
	cmp bl, 9
	je code9
	cmp bl, 10
	je code10
	cmp bl, 11
	je code11
	cmp bl, 12
	je code12
	cmp bl, 13
	je code13
	cmp bl, 14
	je code14
	cmp bl, 15
	je code15
	cmp bl, 16
	je code16
	cmp bl, 17
	je code17
	cmp bl, 18
	je code18
	cmp bl, 19
	je code19
	cmp bl, 20
	je code20
	cmp bl, 21
	je code21
	cmp bl, 22
	je code22
	cmp bl, 23
	je code23
	cmp bl, 24
	je code24
	cmp bl, 25
	je code25
	cmp bl, 26
	je code26
	cmp bl, 27
	je code27
	cmp bl, 28
	je code28
	cmp bl, 29
	je code29
	cmp bl, 30
	je code30
	cmp bl, 31
	je code31
	cmp bl, 32
	je code32
	cmp bl, 33
	je code33
	cmp bl, 34
	je code34
	cmp bl, 35
	je code35
	cmp bl, 36
	je code36
	cmp bl, 37
	je code37
	cmp bl, 38
	je code38
	cmp bl, 39
	je code39
	cmp bl, 40
	je code40
	cmp bl, 41
	je code41
	cmp bl, 42
	je code42
	cmp bl, 43
	je code43
	cmp bl, 44
	je code44
	cmp bl, 45
	je code45
	cmp bl, 46
	je code46
	cmp bl, 47
	je code47
	cmp bl, 48
	je code48
	cmp bl, 49
	je code49
code1:
	mov al, 0xB8
	jmp conv
code2:
	mov al, 0xBB
	jmp conv
code3:
	mov al, 0xB9
	jmp conv
code4:
	mov al, 0xBA
	jmp conv
code5:
	mov al, 0xB4
	jmp conv
code6:
	mov al, 0xB0
	jmp conv
code7:
	mov al, 0xB7
	jmp conv
code8:
	mov al, 0xB3
	jmp conv
code9:
	mov al, 0xB5
	jmp conv
code10:
	mov al, 0xB1
	jmp conv
code11:
	mov al, 0xB6
	jmp conv
code12:
	mov al, 0xB2
	jmp conv
code13:
	mov al, 0xCD
	jmp conv
code14:
	mov al, 0x8E
	mov cl, 0xD8
	jmp conv
code15:
	mov al, 0x8E
	mov cl, 0xDB
	jmp conv
code16:
	mov al, 0x8E
	mov cl, 0xD9
	jmp conv
code17:
	mov al, 0x8E
	mov cl, 0xDA
	jmp conv
code18:
	mov al, 0x8E
	mov cl, 0xC0
	jmp conv
code19:
	mov al, 0x8E
	mov cl, 0xC3
	jmp conv
code20:
	mov al, 0x8E
	mov cl, 0xC1
	jmp conv
code21:
	mov al, 0x8E
	mov cl, 0xC2
	jmp conv
code22:
	mov al, 0x8E
	mov cl, 0xD0
	jmp conv
code23:
	mov al, 0x8E
	mov cl, 0xD3
	jmp conv
code24:
	mov al, 0x8E
	mov cl, 0xD1
	jmp conv
code25:
	mov al, 0x8E
	mov cl, 0xD2
	jmp conv
code26:
	mov al, 0x89
	mov cl, 0xC4
	jmp conv
code27:
	mov al, 0x89
	mov cl, 0xDC
	jmp conv
code28:
	mov al, 0x89
	mov cl, 0xCC
	jmp conv
code29:
	mov al, 0x89
	mov cl, 0xD4
	jmp conv
code30:
	mov al, 0x89
	mov cl, 0xDE
	jmp conv
code31:
	mov al, 0x89
	mov cl, 0xDF
	jmp conv
code32:
	mov al, 0x8A
	mov cl, 0x04
	jmp conv
code33:
	mov al, 0x40
	jmp conv1
code34:
	mov al, 0x43
	jmp conv1
code35:
	mov al, 0x41
	jmp conv1
code36:
	mov al, 0x42
	jmp conv1
code37:
	mov al, 0x44
	jmp conv1
code38:
	mov al, 0x46
	jmp conv1
code39:
	mov al, 0x47
	jmp conv1
code40:
	mov al, 0x45
	jmp conv1
code41:
	mov al, 0x48
	jmp conv1
code42:
	mov al, 0x4B
	jmp conv1
code43:
	mov al, 0x49
	jmp conv1
code44:
	mov al, 0x4A
	jmp conv1
code45:
	mov al, 0x4C
	jmp conv1
code46:
	mov al, 0x4E
	jmp conv1
code47:
	mov al, 0x4F
	jmp conv1
code48:
	mov al, 0x4D
	jmp conv1
code49:
	mov al, 0xC3
	jmp conv1
conv:
	xor bx, bx
	mov bl, [pos]
	mov [di+bx], al
	inc bx
	mov [di+bx], cl
	inc bx
	mov [pos], bl
	jmp Compilation
conv1:
	xor bx, bx
	mov bl, [pos]
	mov [di+bx], al
	inc bx
	mov [pos], bl
	jmp Compilation
Compilation:
	pop bx
	xor bx, bx
	mov al, [si]
	cmp al, 0
	jnz Read_Next_Line
	mov [ds:3000h], bx
	call Write_Sector_Code
	jmp SuccessCode
Read_Next_Line:
	inc si
	inc si
	mov bx, si
	mov [ds:3000h], bx
	jmp Compile_Code

Write_Sector_Code:
	mov ah, 03h
	mov al, 1
	mov ch, 0
	mov cl, [ds:174Fh]   ;pegar setor de arq plax + 20
	mov dh, 0
	mov dl, 80h
	mov bx, 0800h
	mov es, bx
	mov bx, buffer_code
	int 13h
ret

Read_Sector_Code:
	mov 	ah, 02h
	mov 	ch, 0
	mov 	dh, 0
	mov 	dl, 80h
	mov 	al, 1
	mov 	cl, [ds:174Fh]    ;pegar setor de arq plax + 20
	mov 	bx, 0800h
	mov 	es, bx
	mov 	bx, buffer_code
	int 	13h
ret
 	
Read_Sector:
	mov 	ah, 02h
	mov 	ch, 0
	mov 	dh, 0
	mov 	dl, 80h
	mov 	al, 1
	mov 	cl, [ds:174Eh]     ;pegar setor de arq plax
	mov 	bx, 0800h
	mov 	es, bx
	mov 	bx, buffer_source
	int 	13h
ret		
	
		
ErrorCode:
;Exibir mensagem de erro e voltar
	mov si, errormsg
	mov dh, 8
	call Print_Msg
	mov ah, 00h
	int 16h
	jmp 0800h:052Eh	
	
SuccessCode:
;Exibir mensagem de sucesso e voltar
	mov si, successmsg
	mov dh, 8
	call Print_Msg
	mov ah, 00h
	int 16h
	jmp 0800h:052Eh

Print_Msg:
	mov 	ah, 02h
	mov 	bh, 00h
	mov 	dl, 12
	int 	10h
	mov 	ah, 0eh
	jmp 	printmsg
	printmsg:
		mov 	al, [si]
		cmp 	al, 0
		jz		ret_print
		inc 	si
		int 	10h
		jmp 	printmsg
		
	ret_print:
		ret	
		
Print_Code:
	mov 	ah, 02h
	mov 	dh, 9
	mov 	bh, 00h
	mov 	dl, 12
	int 	10h
	mov 	ah, 0eh
	jmp 	printc
	printc:
		mov 	al, [si]
		cmp 	al, 0
		jz		verify_next
		inc 	si
		int 	10h
		jmp 	printc
	verify_next:
		inc 	si
		mov 	al, [si]
		cmp 	al, 0
		jz 		ret_printc
		mov 	al, 'N'
		int 	10h
		mov 	al, 'U'
		int 	10h
		mov 	al, 'L'
		int  	10h
		jmp 	printc
	ret_printc:
		ret	
	
Exec_Code:
	call 	Read_Sector_Code	
	mov 	ah, 02h
	mov 	bh, 00h
	mov 	dh, 7
	mov 	dl, 12
	int 	10h
	call 	buffer_code
	jmp 	wait_key
	wait_key:
		mov 	ah, 00h
		int 	16h
		cmp 	al, 27
		jne 	wait_key
		jmp 0800h:052Eh	
	
		
inst_mov1 db "mov ax,",1  		;B8
inst_mov2 db "mov bx,",1 		;BB
inst_mov3 db "mov cx,",1		;B9
inst_mov4 db "mov dx,",1		;BA
inst_mov5 db "mov ah,",1		;B4
inst_mov6 db "mov al,",1		;B0
inst_mov7 db "mov bh,",1		;B7
inst_mov8 db "mov bl,",1		;B3
inst_mov9 db "mov ch,",1		;B5
inst_mov10 db "mov cl,",1		;B1
inst_mov11 db "mov dh,",1		;B6
inst_mov12 db "mov dl,",1		;B2
inst_int13 db "int",1			;CD

inst_mov14 db "mov ds, ax",1 	;8E D8
inst_mov15 db "mov ds, bx",1	;8E DB
inst_mov16 db "mov ds, cx",1	;8E D9
inst_mov17 db "mov ds, dx",1	;8E DA
inst_mov18 db "mov es, ax",1	;8E C0
inst_mov19 db "mov es, bx",1	;8E C3
inst_mov20 db "mov es, cx",1	;8E C1
inst_mov21 db "mov es, dx",1	;8E C2
inst_mov22 db "mov ss, ax",1	;8E D0
inst_mov23 db "mov ss, bx",1	;8E D3
inst_mov24 db "mov ss, cx",1	;8E D1
inst_mov25 db "mov ss, dx",1	;8E D2
inst_mov26 db "mov sp, ax",1	;89 C4
inst_mov27 db "mov sp, bx",1	;89 DC
inst_mov28 db "mov sp, cx",1	;89 CC
inst_mov29 db "mov sp, dx",1 	;89 D4
inst_mov30 db "mov si, bx",1 	;89 DE
inst_mov31 db "mov di, bx",1 	;89 DF
inst_mov32 db "mov al, [si]",1  ;8A 04

inst_inc1 db "inc ax",1			;40
inst_inc2 db "inc bx",1			;43
inst_inc3 db "inc cx",1			;41
inst_inc4 db "inc dx",1			;42
inst_inc5 db "inc sp",1			;44
inst_inc6 db "inc si",1			;46
inst_inc7 db "inc di",1			;47
inst_inc8 db "inc bp",1			;45

inst_dec1 db "dec ax",1			;48
inst_dec2 db "dec bx",1			;4B
inst_dec3 db "dec cx",1			;49
inst_dec4 db "dec dx",1			;4A
inst_dec5 db "dec sp",1			;4C
inst_dec6 db "dec si",1			;4E
inst_dec7 db "dec di",1			;4F
inst_dec8 db "dec bp",1			;4D
inst_ret db "ret",1				;C3

conf db "Estado setado",0

initialmsg db "Compilando codigo atual...",0
errormsg db "Um erro foi encontrado no codigo!",0
successmsg db "Codigo compilado com sucesso!",0

buffer_source times 512 db 0
buffer_code times 512 db 0

state db 0
cont db 0
cont1 db 0
pos db 0

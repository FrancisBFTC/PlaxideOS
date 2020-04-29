[BITS 16]
[ORG 052Eh]


push 	cs
pop 	ds



	mov 	ah, 05h
	mov 	al, 00h
	int 	10h


	mov 	ah, 06h
	mov 	al, 0
	mov 	bh, 0000_1111b
	mov 	ch, 7
	mov 	cl, 12
	mov 	dh, 22
	mov 	dl, 68
	int 	10h
	
	
	
call 	Count_Source
call 	Existing_Files

jmp 	write_cursor


write_cursor:
	mov 	ah, 02h
	mov		bh, 00h
	mov		dh, 7
	mov 	dl, 12
	int 	10h
	jmp 	text
	
text:
	mov 	bl, 0
	mov 	ah, 00h
	int 	16h
	cmp 	al, 27
	je 		escc
	cmp 	al, 0Dh
	je 		enters
	mov 	ah, 0eh
	int 	10h
	mov 	ah, 03h
	mov 	bh, 00h
	int 	10h
	cmp 	dl, 11
	je 		column
	cmp		dl, 68
	je		enters
	jmp 	text


column:
	cmp 	dh, 7
	je 		line
	pop		dx
	mov 	ah, 02h
	mov 	bh, 00h
	int		10h
	jmp 	text
	
line:
	mov 	ah, 02h
	mov 	bh, 00h
	add		dl, 1
	int 	10h
	jmp 	text
	
;rotina para alternancia de botões
escc:
	mov 	ah, 00h
	int 	16h
	cmp 	al, '+'
	je 		selectbutfront
	cmp 	al, '-'
	je 		selectbutback
	cmp 	ah, 4Bh
	je 		Left_Files
	cmp 	al, 27
	je		write_clear
	cmp 	al, 0Dh
	je 		Go_Events
	cmp 	al, '0'
	je 		Power_Off
	cmp 	al, '1'
	je 		Reboot
	jmp 	escc
	
;rotinas para atualizar e limpar botões
clear_update:
	call 	blue
	call	gravar_update
	call 	blue
	call	ler_update
	call 	blue
	call	compilar_update
	call 	blue
	call	executar_update
	ret
write_clear:
	call 	clear_update
	jmp 	write_cursor
	
;rotinas para os eventos dos botões
Go_Events:
	call 	clear_update
	cmp 	bl, 0
	je 		selectbutfront
	jmp 	events
	
events:
	mov 	[ds:0CF2h], bl
	jmp 	0800h:0CF9h

;rotinas para efeitos em botões
	
selectbutfront:
	inc 	bl
	call 	repaint_but	
	cmp 	bl, 1
	je 		selectbut1
	cmp 	bl, 2
	je 		selectbut2
	cmp 	bl, 3
	je 		selectbut3
	cmp 	bl, 4
	je 		selectbut4
	dec 	bl
	jmp 	escc
	
selectbutback:
	cmp 	bl, 0
	je 		escc
	dec 	bl
	call 	repaint_but
	cmp 	bl, 1
	je 		selectbut1
	cmp 	bl, 2
	je 		selectbut2
	cmp 	bl, 3
	je 		selectbut3
	cmp 	bl, 0
	je 		escc
	
	
repaint_but:
	mov 	ch, 5
	mov 	dh, ch
	ret

blue:
	mov     bh, 0001_1111b
	ret
	
green:
	mov     bh, 0010_1111b
	ret
	
selectbut1:
	call  	green
	call 	gravar_update
	call 	blue
	call 	ler_update
	jmp 	escc

selectbut2:
	call 	blue
	call 	gravar_update
	call 	green
	call 	ler_update
	call 	blue
	call 	compilar_update
	jmp 	escc
	
selectbut3:  
	call	blue
	call 	ler_update
	call 	green
	call 	compilar_update
	call 	blue
	call 	executar_update
	jmp 	escc
	
selectbut4:
	call 	blue
	call 	compilar_update
	call 	green
	call 	executar_update
	jmp 	escc
	
gravar_update:
	call	button1
	call	alt_cursor
	mov 	si, gravar
	call 	print_string
	ret
	
ler_update:
	call 	button2
	call	alt_cursor
	mov 	si, ler
	call 	print_string
	ret
	
compilar_update:
	call 	button3
	call	alt_cursor
	mov 	si, compilar
	call 	print_string
	ret
	
executar_update:
	call 	button4
	call	alt_cursor
	mov 	si, executar
	call 	print_string
	ret
	
button1: 
	mov     ah, 06h         
    mov     cl, 17                       
    mov     dl, 24       
    int     10h
	ret
	
button2:  
	mov     ah, 06h          
    mov     cl, 27                       
    mov     dl, 31       
    int     10h
	ret
	
button3:
	mov     ah, 06h 	            
    mov     cl, 35                       
    mov     dl, 44       
    int     10h
	ret
	
button4: 
	mov     ah, 06h              
    mov     cl, 47                       
    mov     dl, 56       
    int     10h
	ret
	
print_string:
	mov 	ah, 0eh
	print:
		mov 	al, [si]
		cmp 	al, 0
		jz		return
		inc 	si
		int 	10h
		jmp 	print
		
	return:
		ret


alt_cursor:
	mov 	ah, 02h
	mov 	bh, 00h
	mov		dh, ch
	add		cl, 1
	mov 	dl, cl
	int 	10h
	ret
	
;rotinas para o editor negro
enters:
	mov 	ah, 03h
	mov 	bh, 00h
	int 	10h
	;mov 	[ds:0C4Ch], dh ;Error
	call 	subdl
	push	dx        
	mov 	ah, 02h
	mov 	bh, 00h
	inc 	dh
	mov 	dl, 12
	int 	10h
	jmp 	text
	
subdl:
	cmp 	dl, 12
	jne		subcol
	jmp 	retnow
	subcol:
		sub 	dl, 1
		jmp 	retnow
	retnow:
		ret

Read_File_Names:
	mov 	ah, 02h
	mov 	ch, 0
	mov 	dh, 0
	mov 	dl, 80h
	mov 	al, 1
	mov 	cl, 31
	mov 	bx, 0800h
	mov 	es, bx
	mov 	bx, names
	int 	13h
	ret
	
Count_Source:
	mov 	ah, 02h
	mov 	ch, 0
	mov 	dh, 0
	mov 	dl, 80h
	mov 	al, 1
	mov 	cl, 45
	mov 	bx, 0800h
	mov 	es, bx
	mov 	bx, countinfo
	int 	13h
	ret
	
Existing_Files:
	mov 	si, countinfo
	mov 	al, [si+2]
	cmp 	al, 1
	je 		Read_Files
	jmp 	Ret_Existing
	Read_Files:
		call 	Read_File_Names
		call 	Show_Files_Plax
		jmp 	Ret_Existing
	Ret_Existing:
		ret
		
Move_Line_Lateral:
	mov  	ah, 02h
	mov 	bh, 00h
	inc 	dh
	mov 	dl, 1
	int 	10h	
	ret
	
Show_Files_Plax:
	push 	di
	mov 	di, sectors
	mov 	si, names
	mov 	dh, 6  ;Move_Line
	xor 	bx, bx
	push 	bx
	jmp 	Show
	Show:
		call 	Move_Line_Lateral
		call 	print_string
		inc 	si
		mov 	al, [si]
		pop 	bx
		mov 	[di+bx], al
		inc 	bx
		push 	bx
		add 	si, 2
		mov 	al, [si]
		cmp 	al, 1
		je 		Ret_Show
		jmp 	Show
	Ret_Show:
		pop 	bx
		pop 	di
		xor 	bx, bx
		ret
		
Left_Files:
	mov 	si, names
	mov 	dh, 6  ;Move_Line
	jmp 	Search_Name_Down
	Search_Name_Down:
		push 	si
		mov  	ah, 02h
		mov 	bh, 00h
		inc 	dh
		mov 	dl, 1
		int 	10h	
		jmp 	Get_Name
	Search_Name_Up:
		push 	si
		mov  	ah, 02h
		mov 	bh, 00h
		dec 	dh
		mov 	dl, 1
		int 	10h
		jmp 	Get_Name
	Get_Name:
		mov 	ah, 09h
		mov 	bh, 00h
		mov 	bl, 74h
		mov 	cx, 1
		mov 	al, [si]
		cmp 	al, 0
		jz 		Next
		inc 	si
		int 	10h
		mov  	ah, 02h
		inc 	dl
		int 	10h	
		jmp 	Get_Name
	Next:
		inc 	si
		mov 	al, [si]
		push 	ax
		add 	si, 2
		jmp 	Read_Key
	Read_Key:
		mov 	ah, 00h
		int 	16h
		cmp 	ah, 48h
		je		Back_Name
		cmp 	ah, 50h
		je 		Front_Name
		cmp 	al, 0Dh
		je 		Go_Menu_Read
		cmp 	al, 27
		je 		Go_Exit
	Front_Name:
		mov 	al, [si]
		cmp 	al, 1
		je 	Read_Key
		pop 	ax
		pop 	si
		push 	si
		mov 	ah, 02h
		mov 	dl, 1
		int 	10h
		jmp 	Repaint_Back
	Repaint_Back:
		mov 	ah, 09h
		mov 	bh, 00h
		mov 	bl, 70h
		mov 	cx, 1
		mov 	al, [si]
		cmp 	al, 0
		jz 		Next_Front
		inc 	si
		int 	10h
		mov  	ah, 02h
		inc 	dl
		int 	10h	
		jmp 	Repaint_Back
	Next_Front:
		inc 	si
		mov 	al, [si]
		push 	ax
		add 	si, 2
		jmp 	Search_Name_Down
	Back_Name:
		pop 	ax
		pop 	si
		push 	si
		mov 	ah, 02h
		mov 	dl, 1
		int 	10h
		jmp 	Repaint_Front
	Repaint_Front:
		mov 	ah, 09h
		mov 	bh, 00h
		mov 	bl, 70h
		mov 	cx, 1
		mov 	al, [si]
		cmp 	al, 0
		jz 		Next_Back
		inc 	si
		int 	10h
		mov  	ah, 02h
		inc 	dl
		int 	10h	
		jmp 	Repaint_Front
	Next_Back:
		inc 	si
		mov 	al, [si]
		push 	ax
		pop 	ax
		pop 	si
		pop 	ax
		pop 	si
		jmp 	Search_Name_Up
	Go_Menu_Read:
		call 	Read_File_Names
		call 	Show_Files_Plax
		mov 	bl, 1
		mov 	[ds:0CF3h], bl
		jmp 	selectbutfront
	Go_Exit:
		call 	Read_File_Names
		call 	Show_Files_Plax
		jmp 	write_clear
	
Power_Off:
	mov  ah , 53h             ; este é um comando do APM 
	mov  al , 00h             ; comando de verificação da instalação 
	xor  bx , bx              ; id do dispositivo (0 = BIOS do APM) 

	int  15h     
	mov  ah , 53h                ; este é um comando APM 
	mov  al , 01h 		 		; veja a descrição acima 
	xor  bx , bx                 ; id do dispositivo (0 = APM BIOS) 
	int  15h                  

	mov  ah , 53h                ; este é um comando do APM 
	mov  al , 04h                ; comando de desconexão da interface 
	xor  bx , bx                 ; id do dispositivo (0 = BIOS do APM) 
	int  15h

	mov  ah , 53h                ; este é um comando APM 
	mov  al , 0eh                ; comando de versão suportada pelo driver 
	mov  bx , 0000h              ; ID do dispositivo do BIOS do sistema 
	mov  ch , 01h                ; versão principal do driver APM 
	mov  cl , 01h                ; versão secundária do driver APM (pode 01h ou 02h se o último for suportado) 
	int  15h

	mov  ah , 53h               ; este é um comando do APM 
	mov  al , 08h               ; Alterar o estado do gerenciamento de energia ... 
	mov  bx , 0001h             ; ... em todos os dispositivos para ... 
	mov  cx , 0001h             ; ... gerenciamento de energia ativado. 
	int  15h 

	mov  ah , 53h               ; este é um comando do APM 
	mov  al , 07h               ; Defina o estado de energia ... 
	mov  bx , 0001h             ; ... em todos os dispositivos para ... 
	mov  cx , 03h		     	; veja acima 
	int  15h
	
Reboot:
	mov ax, 0x0040
	mov ds, ax
	mov ax, 0x1234
	mov [0x0072], ax
	jmp 0xFFFF:0x0000
		
	
gravar db "Gravar",0
ler db "Ler",0
compilar db "Compilar",0
executar db "Executar",0

names times 512 db 0
sectors times 20 db 0
countinfo times 512 db 0
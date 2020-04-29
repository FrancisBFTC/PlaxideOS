[BITS 16]
[ORG 0CF9h]

push 	cs
pop		ds



	mov 	ah, 06h
	mov 	al, 0
	mov 	bh, 0000_1111b
	mov 	ch, 7
	mov 	cl, 12
	mov 	dh, 22
	mov 	dl, 68
	int 	10h
		
	mov 	dl, 7
	mov 	[dhs], dl 

jmp Verify_Event


Verify_Event:
	mov 	bl, [ds:0CF2h]
	cmp 	bl, 1
	je 		func_gravar
	cmp 	bl, 2
	je		func_ler
	cmp 	bl, 3
	je 		func_compilar_executar
	cmp 	bl, 4
	je 		func_compilar_executar


func_gravar:
	call 	Move_line
	call 	Cont_Source_Read
	mov 	si, write
	call 	print_str
	call 	Move_line
	mov 	si, op1
	call 	print_str
	call 	Move_line
	mov 	si, op2
	call 	print_str
	call 	Move_line
	jmp 	Choose_Gravar
	
	
func_ler:
	call 	Move_line
	mov 	bl, [ds:0CF3h]
	cmp 	bl, 1
	je 		dispop
	jmp 	Ret_Error
	dispop:
		mov 	si, desireread
		call 	print_str
		pop ax
		pop si
		mov 	bl, al
		mov 	[ds:174Eh], bl
		call 	print_str
		mov 	si, yesorno
		call 	print_str
		jmp 	choose_op_ler
	Ret_Error:
		mov 	si, msgerror
		call 	print_str
		mov 	ah, 00h
		int 	16h
		jmp 	0800h:052Eh
	
choose_op_ler:
	mov 	ah, 00h
	int 	16h
	mov 	ah, 0eh
	cmp 	al, 'y'
	je 		read_now
	cmp 	al, 'n'
	je 		Back_Interface
	jmp 	choose_op_ler
	
read_now:
	call 	Choose_Ler
	mov 	si, content1
	jmp 	Go_Editor
	
func_compilar_executar:
	call 	Move_line
	mov 	bl, [ds:0CF3h]
	cmp 	bl, 1
	jne 	Ret_Error
	pop ax
	pop si
	mov 	bl, al
	mov 	[ds:174Eh], bl
	add 	bl, 20
	mov 	[ds:174Fh], bl
	jmp  	0800h:1D00h
	
		
Capture_Names:
	mov 	al, [si+2]
	cmp 	al, 0
	jnz 	Capture
	jmp 	Ret_Capture
	Capture:	
		call 	Read_Name
		jmp 	Ret_Capture
	Ret_Capture:
		ret
		
Update_State_Names:
	mov 	si, contfiles
	mov 	bl, 1
	mov 	[si+2], bl
	ret
	
;Escolha de rotina gravar
Choose_Gravar:
		mov 	ah, 00h
		int 	16h
		cmp 	al, '1'
		je 		ask_name
		cmp 	al, '2'
		je 		mensage1
		jmp 	Choose_Gravar
	ask_name:
		mov 	bl, 0
		mov 	[ds:0CF3h], bl
		mov 	di, filename
		mov 	si, namefile
		call 	print_str
		mov 	si, contfiles
		mov 	al, [si+1]
		mov 	[count1], al
		call 	Capture_Names
		jmp 	write_name
	write_name:
		mov 	ah, 00h
		int 	16h
		call 	save_chars
		mov 	bl, [count1]
		push di
		mov 	di, contfiles
		mov 	[di+1], bl
		pop di
		cmp 	al, 0Dh
		je 		mensage2
		mov 	ah, 0eh
		int 	10h
		jmp 	write_name
	mensage1:
		mov 	bl, 10
		mov 	[ds:0CF2h], bl
		mov 	bl, [ds:0CF3h]
		cmp 	bl, 0
		jz 		Write_Last_Sector
		jmp 	Write_Selected_Sector
		Write_Last_Sector:
			xor 	bx, bx
			mov 	si, contfiles
			mov 	bl, [si]
			jmp 	Write_Sector
		Write_Selected_Sector:
			mov 	bl, [ds:174Eh]
			jmp 	Write_Sector
		Write_Sector:
			call 	Rewrite_File
			call 	Move_line
			mov 	si, success1
			call 	print_str
			jmp 	choose
	mensage2:
		mov 	bl, 1
		mov 	[ds:0CF2h], bl
		
		;call 	Exibir_Filename
		
		call 	Name_Write
		
		;call 	Zerar_Filename
		;call 	Read_Name
		;call 	Exibir_Filename
		;call 	Zerar_Filename
		
		call 	Update_State_Names
		xor 	bx, bx
		mov 	bl, [si]
		inc 	bl
		mov 	[ds:0CF2h], bl
		call 	Create_File
		xor 	bx, bx
		mov 	bl, [ds:0CF2h]
		mov 	di, contfiles
		mov 	[di], bl
		call 	Cont_Source_Write
		
		;call 	Move_line
		;call 	Zerar_Contfiles
		;call 	Cont_Source_Read
		;mov 	si, contfiles
		;call 	print_str
		;call 	Zerar_Contfiles
		
		call 	Move_line
		mov 	si, success2
		call 	print_str
		jmp 	choose
	choose:
		mov 	ah, 00h
		int 	16h
		cmp 	al, 'y'
		je	 	Go_Editor
		cmp 	al, 'n'
		je 		Back_Interface
		jmp 	choose
		
Zerar_Filename:
	xor 	bx, bx
	jmp 	zerar
	zerar:
		mov 	al, 0
		mov 	[di+bx], al
		inc 	bl
		cmp 	bl, 15
		je 		ret_zerar
		jmp 	zerar
	ret_zerar:
		ret
		
Zerar_Contfiles:
	xor 	bx, bx
	jmp 	zerarcont
	zerarcont:
		mov 	al, 0
		mov 	[di+bx], al
		inc 	bl
		cmp 	bl, 3
		je 		ret_zerc
		jmp 	zerarcont
	ret_zerc:
		ret
		

		
Exibir_Filename:
	call 	Move_line
	mov 	si, filename
	call 	print_name
	ret
	
save_chars:
	cmp 	al, 0Dh
	jne 	save1
	jmp 	ret_save
	save1:
		xor 	bx, bx
		mov 	bl, [count1]
		mov 	[di+bx], al
		inc 	bl
		mov 	[count1], bl
		xor 	bx, bx
		jmp 	ret12
	ret_save:
		xor 	bx, bx
		mov 	bl, [count1]
		mov 	al, 0
		mov 	[di+bx], al
		inc 	bl
		mov 	si, contfiles
		mov 	al, [si]
		inc 	al
		mov 	[di+bx], al
		inc 	bl
		mov 	al, 0
		mov 	[di+bx], al
		inc 	bl
		mov 	[count1], bl
		mov 	al, 1
		mov 	[di+bx], al
		xor 	bx, bx
		mov 	al, 0Dh
		jmp 	ret12
	ret12:
		ret
	
Choose_Ler:
	mov 	ah, 02h
	mov 	ch, 0
	mov 	dh, 0
	mov 	dl, 80h
	mov 	al, 1
	mov 	cl, bl  ;setor
	mov 	bx, 0800h
	mov 	es, bx
	mov 	bx, content1
	int 	13h
	ret
	
Read_Name:
	mov 	ah, 02h
	mov 	ch, 0
	mov 	dh, 0
	mov 	dl, 80h
	mov 	al, 1
	mov 	cl, 31
	mov 	bx, 0800h
	mov 	es, bx
	mov 	bx, filename
	int 	13h
	ret	

Name_Write:
	mov 	ah, 03h
	mov 	ch, 0
	mov 	dh, 0
	mov 	dl, 80h
	mov 	al, 1
	mov 	cl, 31
	mov 	bx, 0800h
	mov 	es, bx
	mov 	bx, filename
	int 	13h
	ret
	
Create_File:
	mov 	ah, 03h
	mov 	ch, 0
	mov 	dh, 0
	mov 	dl, 80h
	mov 	al, 1
	mov 	cl, bl  ;setor
	mov 	bx, 0800h
	mov 	es, bx
	mov 	bx, content1
	int 	13h
	ret

Rewrite_File:
	mov 	ah, 03h
	mov 	ch, 0
	mov 	dh, 0
	mov 	dl, 80h
	mov 	al, 1
	mov 	cl, bl  ;setor
	mov 	bx, 0800h
	mov 	es, bx
	mov 	bx, di  ;content/content1
	int 	13h
	ret
	
Cont_Source_Read:
	mov 	ah, 02h
	mov 	ch, 0
	mov 	dh, 0
	mov 	dl, 80h
	mov 	al, 1
	mov 	cl, 45
	mov 	bx, 0800h
	mov 	es, bx
	mov 	bx, contfiles
	int 	13h
	ret
	
Cont_Source_Write:
	mov 	ah, 03h
	mov 	ch, 0
	mov 	dh, 0
	mov 	dl, 80h
	mov 	al, 1
	mov 	cl, 45
	mov 	bx, 0800h
	mov 	es, bx
	mov 	bx, contfiles 
	int 	13h
	ret	
	
;rotinas auxiliares	
print_str:
	mov ah, 0eh
	jmp 	print
	print:
		mov al, [si]
		cmp al, 0
		jz ret_name
		inc si
		int 10h
		jmp print
	ret_name: 
		ret

print_name:
	mov ah, 0eh
	jmp 	printn
	printn:
		mov al, [si]
		cmp al, 1
		jz r
		inc si
		int 10h
		jmp printn
	r: 
		ret
		
Move_line:
	mov 	ah, 02h
	mov 	bh, 00h
	mov 	dh, [dhs]
	mov 	dl, 12
	int 	10h
	inc 	dh	
	mov 	[dhs], dh
	ret
	
;ir para editor	
Go_Editor:
	jmp 	0800h:1770h
	
;voltar para interface
Back_Interface:
	jmp 	0800h:052Eh
	
desireread db "Deseja ler o arquivo: '",0
yesorno db "'?(y/n) ",0

write db "Como deseja gravar um arquivo? ",0
op1 db "     1. Criar um novo",0
op2 db "     2. Reescrever arquivo atual",0
namefile db "Digite o nome do arquivo: ",0
success2 db "Arquivo criado com sucesso!Deseja Editar?(y/n)",0
success1 db "Arquivo Reescrito com sucesso!Deseja Editar?(y/n)",0
msgerror db "Erro! Nenhum arquivo foi selecionado!",0

contfiles times 512 db 0
filename times 512 db 0
content1 times 512 db 0

dhs db 0
count1 db 0


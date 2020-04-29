[BITS 16]
[ORG 0250h]

push 	cs
pop		ds


mov 	ah, 00h
mov 	al, 03h
int 	10h


call 	Back_Screen
call 	Editor
call 	Back_Green_Left
call 	Back_Green_Right
call 	Paint_Lateral_Left
call 	Paint_Lateral_Right
call 	Paint_Bottom
call 	Details_Print
call 	Initial_Cursor

jmp		0800h:03F0h


Back_Screen:                		
    mov     ah, 06h
	mov 	al, 0
    mov     bh, 0001_1111b      
    mov     ch, 1               
    mov     cl, 1               
    mov     dh, 25            
    mov     dl, 80             
    int     10h                     
    ret 
	

Editor:                		
    mov     ah, 06h
	mov 	al, 0
    mov     bh, 0000_1111b      
    mov     ch, 7               
    mov     cl, 12               
    mov     dh, 22            
    mov     dl, 68             
    int     10h                     
    ret 
	
Initial_Cursor:
	mov 	ah, 02h
	mov 	bh, 00h
	mov 	dh, 7
	mov 	dl, 12
	int 	10h
	ret
	
Back_Green_Left:
    mov     ah, 06h
	mov 	al, 0
    mov     bh, 0010_1111b      
    mov     ch, 6               
    mov     cl, 1               
    mov     dh, 22            
    mov     dl, 11             
    int     10h                     
    ret
	
Back_Green_Right:
    mov     ah, 06h
	mov 	al, 0
    mov     bh, 0010_1111b      
    mov     ch, 6               
    mov     cl, 69               
    mov     dh, 22            
    mov     dl, 80             
    int     10h                     
    ret
	
Paint_Lateral_Left:               		
    mov     ah, 06h
	mov 	al, 0
    mov     bh, 0111_0000b      
    mov     ch, 7               
    mov     cl, 1               
    mov     dh, 22            
    mov     dl, 10             
    int     10h                     
    ret 
	
Paint_Lateral_Right:               		
    mov     ah, 06h
	mov 	al, 0
    mov     bh, 0111_0000b      
    mov     ch, 7               
    mov     cl, 70               
    mov     dh, 22           
    mov     dl, 80             
    int     10h                     
    ret

Paint_Bottom:               		
    mov     ah, 06h
	mov 	al, 0
    mov     bh, 0001_1111b      
    mov     ch, 24               
    mov     cl, 0               
    mov     dh, 25            
    mov     dl, 80             
    int     10h                     
    ret 

Details_Print:
	jmp 	Det_Plax
	Det_Plax:
		mov  	ah, 02h
		mov 	bh, 00h
		mov 	dh, 6
		mov 	dl, 1
		int 	10h
		mov 	si, plaxfiles
		call 	Print_Text
		jmp 	Det_Syx
	Det_Syx:
		mov  	ah, 02h
		mov 	bh, 00h
		mov 	dh, 6
		mov 	dl, 70
		int 	10h
		mov 	si, syxfiles
		call 	Print_Text
		jmp 	Det_Help1
	Det_Help1:
		mov  	ah, 02h
		mov 	bh, 00h
		mov 	dh, 23
		mov 	dl, 1
		int 	10h	
		mov 	si, helptext1
		call 	Print_Text
		jmp 	Det_Help2
	Det_Help2:
		mov  	ah, 02h
		mov 	bh, 00h
		mov 	dh, 24
		mov 	dl, 1
		int 	10h	
		mov 	si, helptext2
		call 	Print_Text
		jmp 	Ret_Details		
	Ret_Details:
		ret
		
Print_Text:
	mov 	ah, 0eh
	prints:
		mov 	al, [si]
		cmp 	al, 0
		jz		ret_print
		inc 	si
		int 	10h
		jmp 	prints
	ret_print:
		ret	
		

		
plaxfiles db "PLAX Arqs",0
syxfiles db "SYX Arqs",0
helptext1 db "Comandos ESC -> +/- : Selecionar Menu  |  LEFT/RIGHT : Selecionar Arquivos  |",0
helptext2 db "0 : Desligar  |  1 : Reiniciar  |  ENTER : Escolher",0
	
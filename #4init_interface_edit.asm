[BITS 16]
[ORG 03F0h]


push 	cs
pop 	ds

mov 	bl, 0
mov 	[ds:0CF3h], bl
mov 	si, Mensagem

call 	top
jmp 	program

Load_Next_System:
	jmp 	0800h:052Eh

top: 
	mov 	ah, 06h
	mov 	bh, 0010_1111b
	mov 	ch, 0
	mov 	cl, 1
	mov 	dh, 3
	mov 	dl, 80
	int 	10h
	mov 	ah, 02h
	mov 	bh, 00h
	mov 	dh, 2
	mov 	dl, 10
	int 	10h
	ret

program:
	mov 	ah, 0eh
	mov 	al, [si]
	cmp 	al, 0
	jz 		button1
	inc 	si
	int 	10h
	jmp 	program

button1:
	mov     ah, 06h        
    mov     bh, 0001_1111b     
    mov     ch, 5           
    mov     cl, 17            
    mov     dh, ch           
    mov     dl, 24       
    int     10h
	mov 	ah, 02h
	mov 	bh, 00h
	mov		dh, ch
	add		cl, 1
	mov 	dl, cl
	int 	10h
	mov 	ah, 01h
	mov 	ch, 5
	mov 	cl, 5
	int 	10h
	mov 	ah, 0eh
	mov 	si, gravar
	jmp 	but_gravar

but_gravar:
	mov 	al, [si]
	cmp 	al, 0
	jz 		button2
	int 	10h
	inc 	si
	jmp 	but_gravar

button2:
	mov     ah, 06h        
    mov     bh, 0001_1111b     
    mov     ch, 5           
    mov     cl, 27            
    mov     dh, ch           
    mov     dl, 31       
    int     10h
	mov 	ah, 02h
	mov 	bh, 00h
	mov		dh, ch
	add		cl, 1
	mov 	dl, cl
	int 	10h
	mov 	ah, 0eh
	mov 	si, ler
	jmp 	but_ler

but_ler:
	mov 	al, [si]
	cmp 	al, 0
	jz 		button3
	int 	10h
	inc 	si
	jmp 	but_ler

button3:
	mov     ah, 06h        
    mov     bh, 0001_1111b     
    mov     ch, 5           
    mov     cl, 35            
    mov     dh, ch           
    mov     dl, 44       
    int     10h
	mov 	ah, 02h
	mov 	bh, 00h
	mov		dh, ch
	add		cl, 1
	mov 	dl, cl
	int 	10h
	mov 	si, compilar
	mov 	ah, 0eh
	jmp 	but_compilar

but_compilar:
	mov 	al, [si]
	cmp 	al, 0
	jz 		button4
	int 	10h
	inc 	si
	jmp 	but_compilar

button4:
	mov     ah, 06h        
    mov     bh, 0001_1111b     
    mov     ch, 5           
    mov     cl, 47            
    mov     dh, ch           
    mov     dl, 56       
    int     10h
	mov 	ah, 02h
	mov 	bh, 00h
	mov		dh, ch
	add		cl, 1
	mov 	dl, cl
	int 	10h
	mov 	ah, 0eh
	mov		si, executar
	jmp but_executar

but_executar:
	mov 	al, [si]
	cmp 	al, 0
	jz 		cursor
	int 	10h
	inc 	si
	jmp 	but_executar

cursor:
	mov 	ah, 02h
	mov 	bh, 00h
	mov 	dh, 7
	mov 	dl, 12
	int 	10h
	jmp 	Load_Next_System
	
	
Mensagem db "Plax IDE Operativa",0
gravar db "Gravar",0
ler db "Ler",0
compilar db "Compilar",0
executar db "Executar",0
                       
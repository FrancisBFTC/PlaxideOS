[BITS 16]
[ORG 0000h]

push 	cs
pop 	ds

mov 	ax, 7c00h
mov		ss, ax
mov 	sp, 03FEh

xor 	ax, ax
mov 	ds, ax

call 	Sectors_Reader
jmp 	0800h:0250h

Sectors_Reader:
	
	jmp 	init_interface
	init_interface:
		mov 	ah, 02h
		mov 	ch, 0
		mov 	dh, 0
		mov 	dl, 80h
		mov 	al, 1
		mov 	cl, 3
		mov 	bx, 0800h
		mov 	es, bx
		mov 	bx, 0250h
		int 	13h
		jmp 	init_interface_edit
	init_interface_edit:
		mov 	ah, 02h
		mov 	ch, 0
		mov 	dh, 0
		mov 	dl, 80h
		mov 	al, 1
		mov 	cl, 4
		mov		bx, 0800h
		mov 	es, bx
		mov 	bx, 03F0h
		int 	13h
		jmp 	interface_effects
	interface_effects:
		mov 	ah, 02h
		mov 	ch, 0
		mov 	dh, 0
		mov 	dl, 80h
		mov 	al, 4
		mov 	cl, 5
		mov 	bx, 0800h
		mov 	es, bx
		mov 	bx, 052Eh
		int 	13h
		jmp 	interface_events
	interface_events:
		mov 	ah, 02h
		mov 	ch, 0
		mov 	dh, 0
		mov 	dl, 80h
		mov 	al, 6
		mov 	cl, 9
		mov 	bx, 0800h
		mov 	es, bx
		mov 	bx, 0CF9h
		int 	13h
		jmp 	black_editor
	black_editor:
		mov 	ah, 02h
		mov 	ch, 0
		mov 	dh, 0
		mov 	dl, 80h
		mov 	al, 3
		mov 	cl, 15
		mov 	bx, 0800h
		mov 	es, bx
		mov 	bx, 1770h
		int 	13h
		jmp 	compile_programs
	compile_programs:
		mov 	ah, 02h
		mov 	ch, 0
		mov 	dh, 0
		mov 	dl, 80h
		mov 	al, 7
		mov 	cl, 18
		mov 	bx, 0800h
		mov 	es, bx
		mov 	bx, 1D00h
		int 	13h

ret	

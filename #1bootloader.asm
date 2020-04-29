[BITS 16]
[ORG 0x7C00]

call	Load_Systems
jmp 	0800h:0000h

Load_Systems:
	mov     ah, 02h      ;subfuncao de leitura
	mov     al, 1        ;numero de setores para ler
	mov     ch, 0        ;trilha (cylinder)
	mov     cl, 2        ;setor
	mov     dh, 0        ;cabeca
	mov     dl, 80h      ;drive (00h = A:)
	mov     bx, 0800h    ;ES:BX aponta para o local da memoria
	mov     es, bx       ;onde vai ser escrito os dados
	mov     bx, 0000h    ;0800:0000h (ES = 0800h, BX = 0000h)
	int     13h
	ret	
	
times 510 - ($-$$) db 0
dw 0xAA55
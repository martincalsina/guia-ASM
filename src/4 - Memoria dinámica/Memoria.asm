extern malloc
extern free
extern fprintf

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
; a --> RDI
; b --> RSI ambos son punteros, 64 bits.
strCmp:

	mov DL, byte [RDI + 0] ;primer caracter de a
	mov CL, byte [RSI + 0] ;primer caracter de b
	
	.loop_while:
		cmp DL, CL ;los char ocupan 1 byte, debo compararlos asi
		jg .end_a_grater_than_b
		jl .end_a_lower_than_b
		mov R9B, DL
		or R9B, CL ;combino los bits del caracter a y b que estoy leyendo en R9
		test R9B, R9B ;chequeo si ambos eran 0 al mismo tiempo, solo me importa el byte de abajo pq es un char
		je .end_a_equals_b 

		;si no pasa nada de eso, puedo seguir buscando caracteres
		add RDI, 1 ;incremento el puntero de a
		add RSI, 1 ;lo mismo con el de b

		;tomo los nuevos caracteres
		mov DL, byte [RDI]
		mov CL, byte [RSI]

		jmp .loop_while



	.end_a_grater_than_b:
		mov EAX, -1
		jmp .end
	
	.end_a_lower_than_b:
		mov EAX, 1
		jmp .end
	
	.end_a_equals_b:
		xor EAX, EAX
		jmp .end
	
	.end:
		ret

; char* strClone(char* a)
strClone:
	ret

; void strDelete(char* a)
strDelete:
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	ret

; uint32_t strLen(char* a)
; a --> RDI pq es un puntero, son todos de 64 bits
strLen:
	xor RAX, RAX
	mov RSI, [RDI + 0]
	
	.loop_while:
		test SIL, SIL ;evaluo si RSI es el caracter nulo, pero como son chars solo veo de a un byte
		je .end ;si lo es, termino

		add RAX, 1
		mov RSI, [RDI+RAX] ;veo el siguiente caracter
		jmp .loop_while

	.end:
		ret



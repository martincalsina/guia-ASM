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
strCmp:
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



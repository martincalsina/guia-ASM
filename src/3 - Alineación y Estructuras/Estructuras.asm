

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
NODO_OFFSET_NEXT EQU 0
NODO_OFFSET_CATEGORIA EQU 8
NODO_OFFSET_ARREGLO EQU 16
NODO_OFFSET_LONGITUD EQU 24
NODO_SIZE EQU 32
PACKED_NODO_OFFSET_NEXT EQU 0
PACKED_NODO_OFFSET_CATEGORIA EQU 8
PACKED_NODO_OFFSET_ARREGLO EQU 9
PACKED_NODO_OFFSET_LONGITUD EQU 17
PACKED_NODO_SIZE EQU 21
LISTA_OFFSET_HEAD EQU 0
LISTA_SIZE EQU 8
PACKED_LISTA_OFFSET_HEAD EQU 0
PACKED_LISTA_SIZE EQU 8

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global cantidad_total_de_elementos
global cantidad_total_de_elementos_packed

;########### DEFINICION DE FUNCIONES
;extern uint32_t cantidad_total_de_elementos(lista_t* lista);
;registros: lista[?]
;lista --> rdi, es un puntero
cantidad_total_de_elementos:

	push RBP
	mov RBP, RSP

	xor RAX, RAX; inicializo en 0 la cant de elems
	mov RSI, [RDI + LISTA_OFFSET_HEAD] ;

	.loop_start:
		test RSI, RSI; hace un rsi & rsi y actualiza el flag de jump.
		je .end; salta si el flag esta en 0, o sea si rsi & rsi = 0 si y solo si rsi = 0 = NULL 

		add EAX, DWORD [RSI + NODO_OFFSET_LONGITUD]
		mov RSI, [RSI + NODO_OFFSET_NEXT]

		jmp .loop_start ;saltamos si o si

	.end:

		pop RBP
		ret

;extern uint32_t cantidad_total_de_elementos_packed(packed_lista_t* lista);
;registros: lista[?]
; lista --> RDI, es un puntero de 64 bits
cantidad_total_de_elementos_packed:

	push RBP
	mov RBP, RSP

	xor EAX, EAX; contador
	mov RSI, [RDI + PACKED_LISTA_OFFSET_HEAD]
	.loop_start:
		test RSI, RSI
		je .end

		add EAX, DWORD [RSI + PACKED_NODO_OFFSET_LONGITUD]
		mov RSI, [RSI + PACKED_NODO_OFFSET_NEXT]

		jmp .loop_start

	.end:
		pop RBP
		ret


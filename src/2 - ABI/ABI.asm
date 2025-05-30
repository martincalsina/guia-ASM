extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_using_c
global alternate_sum_4_using_c_alternative
global alternate_sum_8
global alternate_sum_8_using_sum_4
global product_2_f
global product_9_f

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4:
  sub EDI, ESI
  add EDI, EDX
  sub EDI, ECX

  mov EAX, EDI
  ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4_using_c:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  push R12
  push R13	; preservo no volatiles, al ser 2 la pila queda alineada

  mov R12D, EDX ; guardo los parámetros x3 y x4 ya que están en registros volátiles
  mov R13D, ECX ; y tienen que sobrevivir al llamado a función

  call restar_c 
  ;recibe los parámetros por EDI y ESI, de acuerdo a la convención, y resulta que ya tenemos los valores en esos registros
  
  mov EDI, EAX ;tomamos el resultado del llamado anterior y lo pasamos como primer parámetro
  mov ESI, R12D
  call sumar_c

  mov EDI, EAX
  mov ESI, R13D
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  pop R13 ;restauramos los registros no volátiles
  pop R12
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


alternate_sum_4_using_c_alternative:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  sub RSP, 16 ; muevo el tope de la pila 8 bytes para guardar x4, y 8 bytes para que quede alineada

  mov [RBP-8], RCX ; guardo x4 en la pila

  push RDX  ;preservo x3 en la pila, desalineandola
  sub RSP, 8 ;alineo
  call restar_c 
  add RSP, 8 ;restauro tope
  pop RDX ;recupero x3
  
  mov EDI, EAX
  mov ESI, EDX
  call sumar_c

  mov EDI, EAX
  mov ESI, [RBP - 8] ;leo x4 de la pila
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  add RSP, 16 ;restauro tope de pila
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[?], x2[?], x3[?], x4[?], x5[?], x6[?], x7[?], x8[?]
; usando la convencion de System V AMBD64 ABI, los primeros 6 argumentos de izquierda a derecha
; se pasan a los registros (como son ints de 32 bits):
; x1 --> EDI 
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
; x5 --> R8D
; X6 --> R9D
; y los otros que no tienen registro caen en la pila pusheados de derecha a izquierda.
; una vez cambiado el rbo al rsp actual:
; x7 --> [rbp + 16] //mas cerquita pq se pushea luego de x8
; x8 --> [rbp + 24] //notar que rbp + 0 es el nuevo base pointer, rbp + 8 es donde esta el valro de retorno
alternate_sum_8:
	;prologo
  push rbp ;justo dsp del valor de retorno, pila alineada
  mov rbp, rsp
  
  ;paso a guardar los registros en la pila para que no se mueran al hacer llamadas
  push R9 ;x6
  push R8 ;x5
  push RCX ;x4
  push RDX ;x3

  ;hago x1 - x2
  call restar_c ;usa EDI = x1, ESI = x2 y hace la resta, la devuelve en EAX
  mov EDI, EAX
  pop RDX ;pila desalineada
  sub RSP, 8 ;pila alineada
  mov ESI, EDX
  
  call sumar_c; usa EDI = x1-x2, ESI= x3 y suma
  mov EDI, EAX
  add RSP, 8 ;pila desalineada
  pop RCX ;pila alineada
  mov ESI, ECX

  call restar_c ;usa EDI = x1-x2+x3 ESI = x4 y resta
  mov EDI, EAX
  pop R8 ;pila desalineada
  sub RSP, 8 ;pila alineada
  mov ESI, R8D ;usa EDI = x1-x2+x3-x4, ESI = x5 y suma

  call sumar_c
  mov EDI, EAX
  add RSP, 8 ;pila desalineada
  pop R9 ;pila alineada
  mov ESI, R9D ;us EDI = x1-x2+x3-x4+x5 y ESI = x6, toca restar

  call restar_c
  mov EDI, EAX
  mov ESI, DWORD [rbp + 16] ;tengo el alternate de 6 en EDI y en ESI me traigo x7

  call sumar_c
  mov EDI, EAX
  mov ESI, DWORD [rbp + 24] ;me traigo el x8 y termino la resta

  call restar_c

	;epilogo
  pop rbp ;me traigo el viejo basepointer con el que trabajaba mi funcion invocadora
	ret ;vuelvo la suma alternada total quedó en EAX 

; lo mismo que antes pero llamando a sum_4
alternate_sum_8_using_sum_4:
  ;prologo
  push rbp
  mov rbp, rsp

  ;a sum_4 le voy a pasar x1, x2, x3, x4 que estan en EDI, ESI, EDX, ECX ya
  ;debo hacr que x5 y x6 sobreviva a los llamados
  push R9; //x6 son los bits de abajo
  push R8; x5 son los bits de abajo

  call alternate_sum_4_using_c
  
  ;ahora EAX tiene x1-x2+x3-x4, puedo hacer x5-x6+x7-x8 y sumar ambos resultados
  pop RDI ;x5
  pop RSI ;x6
  mov EDX, DWORD [rbp + 16] ;x7
  mov ECX, DWORD [rbp + 24] ;x8
  push RAX ;me guardo el viejo resultado, RAX es EAX en 64 bits

  call alternate_sum_4_using_c
  ;ahora EAX tiene x5-x6+x7-x8
  pop RDI ;x1-x2+x3-x4
  mov ESI, EAX ;x5-x6+x7-x8

  call sumar_c ;sumo los res parciales

  ;prólogo
  pop rbp;
  ret



; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[?], x1[?], f1[?]
;dst --> RDI pq es un puntero. Los punteros son todos de 64 bits
;x1 --> ESI pq es un int
;f1 --> XMMO pq es un float
product_2_f:
  ;prólogo
  push rbp
  mov rbp, rsp
  
  ;los paso ambos a double para que la multiplicacion sea mas precisa, le estaba errando por uno al resultado
  cvtsi2sd XMM1, ESI     ; int → double
  cvtss2sd XMM0, XMM0    ; float → double
  mulsd XMM0, XMM1       ; double * double

  cvttsd2si EAX, XMM0    ; truncar double → int

  mov [RDI], EAX ;muevo el valor al destination

  pop rbp

	ret


;extern void product_9_f(double * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila: destination[rdi], x1[?], f1[?], x2[?], f2[?], x3[?], f3[?], x4[?], f4[?]
;	, x5[?], f5[?], x6[?], f6[?], x7[?], f7[?], x8[?], f8[?],
;	, x9[?], f9[?]
; dst --> EDI
; f1 --> XMM0
; x1 --> ESI
; f2 --> XMM1
; x2 --> EDX
; f3 --> XMM2
; x3 --> ECX
; f4 --> XMM3
; x4 --> R8D
; f5 --> XMM4
; x5 --> R9D
; f6 --> XMM5
; x6 --> [RBP + 16] 
; f7 --> XMM6
; x7 --> [RBP + 24]
; f8 --> XMM7
; x8 --> [RBP + 32]
; f9 --> [RBP + 48]
; x9 --> [RBP + 40]

product_9_f:
	;prologo
	push rbp
	mov rbp, rsp

	;convertimos los flotantes de cada registro xmm en doubles
	cvtss2sd XMM0, XMM0
  cvtss2sd XMM1, XMM1
  cvtss2sd XMM2, XMM2
  cvtss2sd XMM3, XMM3
  cvtss2sd XMM4, XMM4
  cvtss2sd XMM5, XMM5
  cvtss2sd XMM6, XMM6
  cvtss2sd XMM7, XMM7

  movss XMM8, DWORD [RBP + 48] ;es un scalar single, se lee con esto y un DWORD pq los floats son de 32 bits

  cvtss2sd XMM8, XMM8

	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
	mulsd XMM0, XMM1
  mulsd XMM0, XMM2
  mulsd XMM0, XMM3
  mulsd XMM0, XMM4
  mulsd XMM0, XMM5
  mulsd XMM0, XMM6
  mulsd XMM0, XMM7
  mulsd XMM0, XMM8

	; convertimos los enteros en doubles y los multiplicamos por xmm0.
	cvtsi2sd XMM1, ESI
  cvtsi2sd XMM2, EDX
  cvtsi2sd XMM3, ECX
  cvtsi2sd XMM4, R8D
  cvtsi2sd XMM5, R9D
  cvtsi2sd XMM6, DWORD [RBP + 16]
  cvtsi2sd XMM7, DWORD [RBP + 24]
  cvtsi2sd XMM8, DWORD [RBP + 32]
  cvtsi2sd XMM9, DWORD [RBP + 40]

  mulsd XMM0, XMM1
  mulsd XMM0, XMM2
  mulsd XMM0, XMM3
  mulsd XMM0, XMM4
  mulsd XMM0, XMM5
  mulsd XMM0, XMM6
  mulsd XMM0, XMM7
  mulsd XMM0, XMM8
  mulsd XMM0, XMM9

  movsd [RDI], XMM0 

	; epilogo
	pop rbp
	ret


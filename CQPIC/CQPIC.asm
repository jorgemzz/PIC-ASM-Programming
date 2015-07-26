;==================== Encabezado ====================

		LIST	P=16F84A
		INCLUDE	"P16F84A.INC"

;================= Mapa de Memoria ===================

	LLAVES	EQU	0X0C			;ALMACENARA EL STATUS DE LAS LLAVES
 	PDel0 	EQU	0X0D
 	PDel1 	EQU	0X0E
	MOVW	EQU	0X0F
;============== Configuración de puertos =================

	ORG	0X00

	GOTO INICIO
	ORG	0X05

INICIO
	BSF		STATUS,RP0			;CAMBIO AL BANCO 1 DEL PIC
	MOVLW	0X0F				;0X1F_CAMBIO PARA NO USAR UN TIMER EXTERNO
	MOVWF	TRISA				;ASIGNA EL PUERTO A COMO ENTRADA,RB4
	MOVLW	0X00
	MOVWF	TRISB				;Y PUERTO B COMO SALIDA
	BCF		STATUS,RP0			;REGRESO AL BANCO 0
	CLRF	PORTA				;LIMPIA EL PUERTO A
	CLRF	PORTB				;LIMPIA EL PUERTO B

SWITCH
	MOVF	PORTA,0			;CARGA W CON EL PUERTO A
	ANDLW	0X0F			;RETIENE LOS CUATRO BITS DE INTERES(LAS LLAVES)
	MOVWF	LLAVES			;Y LOS GUARDA EN LLAVES
	XORLW	0X00			;VERIFICA SI ES EL PRIMER EFECTO
	BTFSC	STATUS,Z		;SI ES ASI
	CALL	EFECT1			;LO LLAMA Y LO EJECUTA
	MOVF	LLAVES,0		;SI NO CARGO LLAVES EN W
	XORLW	0X01			;VERIFICA SI ES EL SEGUNDO EFECTO
	BTFSC	STATUS,Z		;SI ES ASI 
	CALL	EFECT2			;LO LLAMA Y LO EJECUTA
	MOVF	LLAVES,0		;SI NO CARGA LLAVES EN W
	XORLW	0X02
	BTFSC	STATUS,Z
	CALL	EFECT3
	MOVF	LLAVES,0
	XORLW	0X03
	BTFSC	STATUS,Z
	CALL	EFECT4
	MOVF	LLAVES,0
	XORLW	0X04
	BTFSC	STATUS,Z
	CALL	EFECT5
	MOVF	LLAVES,0
	XORLW	0X05
	BTFSC	STATUS,Z
	CALL	EFECT6
	MOVF	LLAVES,0
	XORLW	0X06
	BTFSC	STATUS,Z
	CALL	EFECT7
	MOVF	LLAVES,0
	XORLW	0X07
	BTFSC	STATUS,Z
	CALL	EFECT8
	MOVF	LLAVES,0
	XORLW	0X08
	BTFSC	STATUS,Z
	CALL	EFECT9
	MOVF	LLAVES,0
	XORLW	0X09
	BTFSC	STATUS,Z
	CALL	EFECT10
	MOVF	LLAVES,0
	XORLW	0X0A
	BTFSC	STATUS,Z
	CALL	EFECT11
	MOVF	LLAVES,0
	XORLW	0X0B
	BTFSC	STATUS,Z
	CALL	EFECT12
	MOVF	LLAVES,0
	XORLW	0X0C
	BTFSC	STATUS,Z
	CALL	EFECT13
	MOVF	LLAVES,0
	XORLW	0X0D
	BTFSC	STATUS,Z
	CALL	EFECT14			
	MOVF	LLAVES,0
	XORLW	0X0E
	BTFSC	STATUS,Z
	CALL	EFECT15
	MOVF	LLAVES,0
	XORLW	0X0F
	BTFSC	STATUS,Z
	CALL	EFECT16
	GOTO	SWITCH			;COMIENZA A REVIZAR DE NUEVO

;======================== Efectos =========================

EFECT1	 
	CLRF	PORTB 			; limpia el puerto B
	BSF		PORTB,7 		; (10000000)
	CALL	clokon
	BSF		PORTB,6 		; (11000000)
	CALL 	clokon
	BSF 	PORTB,5 		; (11100000)
	CALL 	clokon
	BSF 	PORTB,4 		; (11110000)
	CALL 	clokon
	BSF 	PORTB,3 		; (11111000)
	CALL	clokon
	BSF 	PORTB,2 		; (11111100)
	CALL	clokon
	BSF 	PORTB,1 		; (11111110)
	CALL	clokon
	BSF 	PORTB,0 		; (11111111)
	CALL 	clokon
	BCF 	PORTB,7 		; (01111111)
	CALL 	clokon
	BCF 	PORTB,6 		; (00111111)
	CALL 	clokon
	BCF 	PORTB,5 		; (00011111)
	CALL 	clokon
	BCF 	PORTB,4 		; (00001111)
	CALL 	clokon
	BCF 	PORTB,3 		; (00000111)
	CALL 	clokon
	BCF 	PORTB,2 		; (00000011)
	CALL 	clokon
	BCF 	PORTB,1 		; (00000001)
	CALL 	clokon
	CLRF 	PORTB 			; (00000000)
	CALL 	clokon
TRECE						;trece
	BSF 	PORTB,0 		; (00000001)
	CALL 	clokon
	BSF 	PORTB,1 		; (00000011)
	CALL 	clokon
	BSF 	PORTB,2 		; (00000111)
	CALL 	clokon
	BSF 	PORTB,3 		; (00001111)
	CALL 	clokon
	BSF 	PORTB,4 		; (00011111)
	CALL 	clokon
	BSF 	PORTB,5 		; (00111111)
	CALL 	clokon
	BSF 	PORTB,6 		; (01111111)
	CALL 	clokon
	BSF 	PORTB,7 		; (11111111)
	CALL 	clokon
	BCF 	PORTB,0 		; (11111110)
	CALL 	clokon
	BCF 	PORTB,1 		; (11111100)
	CALL 	clokon
	BCF 	PORTB,2 		; (11111000)
	CALL 	clokon
	BCF 	PORTB,3 		; (11110000)
	CALL 	clokon
	BCF 	PORTB,4 		; (11100000)
	CALL 	clokon
	BCF 	PORTB,5 		; (11000000)
	CALL 	clokon
	BCF 	PORTB,6 		; (10000000)
	CALL 	clokon
	RETURN 					; a revisar nuevamente las llaves

EFECT2
	CLRF 	PORTB 			; limpia el puerto B
	BSF 	PORTB,7 		; (10000000) EFECTO ACUMULATIVO EN "0"
	CALL 	clokon
	BCF 	PORTB,7 		; (00000000)
	BSF 	PORTB,6 		; (01000000)
	CALL 	clokon
	BCF 	PORTB,6 		; (00000000)
	BSF 	PORTB,5 		; (00100000)
	CALL 	clokon
	BCF 	PORTB,5 		; (00000000)
	BSF 	PORTB,4 		; (00010000)
	CALL	clokon
	BCF 	PORTB,4 		; (00000000)
	BSF 	PORTB,3 		; (00001000)
	CALL	clokon
	BCF 	PORTB,3		 	; (00000000)
	BSF 	PORTB,2 		; (00000100)
	CALL	clokon
	BCF 	PORTB,2 		; (00000000)
	BSF 	PORTB,1 		; (00000010)
	CALL	clokon
	BCF 	PORTB,1 		; (00000000)
	BSF 	PORTB,0 		; (00000001)
	CALL	clokon
	BSF 	PORTB,7 		; (10000001)
	CALL	clokon
	BCF 	PORTB,7 		; (00000001)
	BSF 	PORTB,6 		; (01000001)
	CALL	clokon
	BCF 	PORTB,6 		; (00000001)
	BSF 	PORTB,5 		; (00100001)
	CALL	clokon
	BCF 	PORTB,5 		; (00000001)
	BSF 	PORTB,4 		; (00010001)
	CALL	clokon
	BCF 	PORTB,4 		; (00000001)
	BSF 	PORTB,3 		; (00001001)
	CALL	clokon
	BCF 	PORTB,3 		; (00000001)
	BSF 	PORTB,2 		; (00000101)
	CALL	clokon
	BCF 	PORTB,2 		; (00000001)
	BSF 	PORTB,1	 		; (00000011)
	CALL	clokon
	BSF 	PORTB,7 		; (10000011)
	CALL	clokon
	BCF 	PORTB,7 		; (00000011)
	BSF 	PORTB,6 		; (01000011)
	CALL	clokon
	BCF 	PORTB,6 		; (00000011)
	BSF 	PORTB,5 		; (00100011)
	CALL	clokon
	BCF 	PORTB,5 		; (00000011)
	BSF 	PORTB,4 		; (00010011)
	CALL	clokon
	BCF 	PORTB,4 		; (00000011)
	BSF 	PORTB,3 		; (00001011)
	CALL	clokon	
	BCF 	PORTB,3 		; (00000011)
	BSF 	PORTB,2 		; (00000111)
	CALL	clokon
	BSF 	PORTB,7 		; (10000111)
	CALL	clokon
	BCF 	PORTB,7 		; (00000111)
	BSF 	PORTB,6 		; (01000111)
	CALL	clokon
	BCF 	PORTB,6 		; (00000111)
	BSF 	PORTB,5 		; (00100111)
	CALL	clokon
	BCF 	PORTB,5 		; (00000111)
	BSF 	PORTB,4 		; (00010111)
	CALL	clokon
	BCF 	PORTB,4 		; (00000111)
	BSF 	PORTB,3 		; (00001111)
	CALL	clokon
	BSF 	PORTB,7 		; (10001111)
	CALL	clokon
	BCF 	PORTB,7 		; (00001111)
	BSF 	PORTB,6 		; (01001111)
	CALL	clokon
	BCF 	PORTB,6 		; (00001111)
	BSF 	PORTB,5 		; (00101111)
	CALL	clokon
	BCF 	PORTB,5 		; (00001111)
	BSF 	PORTB,4 		; (00011111)
	CALL	clokon
	BSF 	PORTB,7 		; (10011111)
	CALL	clokon
	BCF 	PORTB,7 		; (00011111)
	BSF 	PORTB,6 		; (01011111)
	CALL	clokon
	BCF 	PORTB,6 		; (00011111)
	BSF 	PORTB,5 		; (00111111)
	CALL	clokon
	BSF 	PORTB,7 		; (10111111)
	CALL	clokon
	BCF 	PORTB,7 		; (00111111)
	BSF 	PORTB,6 		; (01111111)
	CALL	clokon
	BSF 	PORTB,7 		; (11111111)
	CALL	clokon
	RETURN
EFECT3 
	CLRF 	PORTB 			; limpia el puerto B
	CALL 	clokon
	BSF 	PORTB,0 		; (00000001)
	CALL	clokon
	BCF 	PORTB,0 		; (00000000)
	BSF 	PORTB,1 		; (00000010)
	CALL	clokon
	BCF 	PORTB,1 		; (00000000)
	BSF 	PORTB,2 		; (00000100)
	CALL	clokon
	BCF 	PORTB,2 		; (00000000)
	BSF 	PORTB,3 		; (00001000)
	CALL 	clokon
	BCF 	PORTB,3 		; (00000000)
	BSF 	PORTB,4 		; (00010000)
	CALL	clokon
	BCF 	PORTB,4 		; (00000000)
	BSF 	PORTB,5 		; (00100000)
	CALL	clokon
	BCF 	PORTB,5 		; (00000000)
	BSF 	PORTB,6 		; (01000000)
	CALL	clokon
	BCF 	PORTB,6 		; (00000000)
	BSF 	PORTB,7 		; (10000000)
	CALL	clokon
	BSF 	PORTB,0 		; (10000001)
	CALL	clokon
	BCF 	PORTB,0 		; (10000000)
	BSF 	PORTB,1 		; (10000010)
	CALL	clokon
	BCF 	PORTB,1 		; (10000000)
	BSF 	PORTB,2 		; (10000100)
	CALL	clokon
	BCF 	PORTB,2 		; (10000000)
	BSF 	PORTB,3 		; (10001000)
	CALL	clokon
	BCF 	PORTB,3 		; (10000000)
	BSF 	PORTB,4 		; (10010000)
	CALL	clokon
	BCF 	PORTB,4 		; (10000000)
	BSF 	PORTB,5 		; (10100000)
	CALL	clokon
	BCF 	PORTB,5 		; (10000000)
	BSF 	PORTB,6 		; (11000000)
	CALL	clokon
	BSF 	PORTB,0 		; (11000001)
	CALL	clokon
	BCF 	PORTB,0 		; (11000000)
	BSF 	PORTB,1 		; (11000010)
	CALL	clokon
	BCF 	PORTB,1 		; (11000000)
	BSF 	PORTB,2 		; (11000100)
	CALL	clokon
	BCF 	PORTB,2 		; (11000000)
	BSF 	PORTB,3 		; (11001000)
	CALL	clokon
	BCF 	PORTB,3 		; (11000000)
	BSF 	PORTB,4 		; (11010000)
	CALL	clokon
	BCF 	PORTB,4 		; (11000000)
	BSF 	PORTB,5 		; (11100000)
	CALL	clokon
	BSF 	PORTB,0 		; (11100001)
	CALL	clokon
	BCF 	PORTB,0 		; (11100000)
	BSF 	PORTB,1 		; (11100010)
	CALL	clokon
	BCF 	PORTB,1 		; (11100000)
	BSF 	PORTB,2 		; (11100100)
	CALL	clokon
	BCF 	PORTB,2 		; (11100000)
	BSF 	PORTB,3 		; (11101000)
	CALL	clokon
	BCF 	PORTB,3 		; (11100000)
	BSF 	PORTB,4 		; (11110000)
	CALL	clokon
	BSF 	PORTB,0 		; (11110001)
	CALL	clokon
	BCF 	PORTB,0 		; (11110000)
	BSF 	PORTB,1 		; (11110010)
	CALL	clokon
	BCF 	PORTB,1 		; (11110000)
	BSF 	PORTB,2 		; (11110100)
	CALL	clokon
	BCF 	PORTB,2 		; (11110000)
	BSF 	PORTB,3 		; (11111000)
	CALL	clokon
	BSF 	PORTB,0 		; (11111001)
	CALL	clokon
	BCF 	PORTB,0 		; (11111000)
	BSF 	PORTB,1 		; (11111010)
	CALL	clokon
	BCF 	PORTB,1 		; (11111000)
	BSF 	PORTB,2 		; (11111100)
	CALL	clokon
	BSF 	PORTB,0 		; (11111101)
	CALL	clokon
	BCF 	PORTB,0 		; (11111100)
	BSF 	PORTB,1 		; (11111110)
	CALL	clokon
	BSF 	PORTB,0 		; (11111111)
	CALL	clokon
	RETURN
EFECT4
	CLRF 	PORTB 		; limpia el puerto B
	BSF 	PORTB,7 	; (10000000)
	BSF 	PORTB,0 	; (10000001)
	CALL	clokon
	BSF 	PORTB,6 	; (11000001)
	BSF 	PORTB,1 	; (11000011)
	CALL	clokon
	BSF 	PORTB,5 	; (11100011)
	BSF 	PORTB,2 	; (11100111)
	CALL	clokon
	BSF 	PORTB,4 	; (11110111)
	BSF 	PORTB,3 	; (11111111)
	CALL	clokon
	BCF 	PORTB,7 	; (01111111)
	BCF 	PORTB,0 	; (01111110)
	CALL	clokon
	BCF 	PORTB,6 	; (00111110)
	BCF 	PORTB,1 	; (00111100)
	CALL	clokon
	BCF 	PORTB,5 	; (00011100)
	BCF 	PORTB,2 	; (00011000)
	CALL	clokon
	BCF 	PORTB,4 	;(00001000)
	BCF 	PORTB,3 	; (00000000)
	CALL	clokon
	CALL	clokon
	BSF 	PORTB,3 	; (00001000)
	BSF 	PORTB,4 	; (00011000)
	CALL	clokon
	BSF 	PORTB,5 	; (00111000)
	BSF 	PORTB,2 	; (00111100)
	CALL	clokon
	BSF 	PORTB,6 	; (01111100)
	BSF 	PORTB,1 	; (01111110)
	CALL	clokon
	BSF 	PORTB,7 	; (11111110)
	BSF 	PORTB,0 	; (11111111)
	CALL	clokon
	BCF 	PORTB,3 	; (11110111)
	BCF 	PORTB,4 	; (11100111)
	CALL	clokon
	BCF 	PORTB,5 	; (11000111)
	BCF 	PORTB,2 	; (11000011)
	CALL	clokon
	BCF 	PORTB,6 	; (10000011)
	BCF 	PORTB,1 	; (10000001)
	CALL	clokon
	BCF 	PORTB,7 	; (00000001)
	BCF 	PORTB,0 	; (00000000)
	CALL	clokon
	RETURN
EFECT5 		;PARA ESTE EFECTPO COMO ESTOY USANDO UN RETARDO 
			;W QUEDA AFECTADO AL REGRESAR DEL RETARDO SE PIERDE EL VALOR
			;CONTENIDO PARA LA SECUENCIA......ENTONCES ANTES DE LLAMAR AL RETARDO
			;GUARDO W EN MOVW	Y LUEGO DEL RETARDO LO NUELVO A CARGAR EN W
			;......EH.....QUE TAL
	CLRF 	PORTB 		; limpia el puerto B
	MOVLW 	0X01 		; comienza con (00000001)
	MOVWF	MOVW
	MOVWF 	PORTB 		; lo envía a la salida
cinco
	MOVF	MOVW,0 
	BSF 	STATUS,0 	; pone a 1 el bit C de status (carry)
	MOVWF	MOVW
	CALL	clokon
	MOVF	MOVW,0 
	MOVWF 	PORTB 		; lo envía a la salida
	RLF 	PORTB,0 	; rota a la izquierda y pasa el valor a W
	MOVWF 	PORTB 		; lo envía a la salida
	MOVWF	MOVW
	CALL	clokon
	MOVF	MOVW,0 
	CLRF 	PORTB 		; (00000000)
	MOVWF	MOVW
	CALL	clokon
	MOVF	MOVW,0 
	MOVWF 	PORTB 		; repite
	MOVWF	MOVW
	CALL	clokon
	MOVF	MOVW,0 
	CLRF 	PORTB 		; (00000000)
	MOVWF	MOVW
	CALL	clokon
	MOVF	MOVW,0 
	MOVWF	PORTB 		; lo envía a la salida
	BTFSS	PORTB,7		; ve si terminó de rotar
	GOTO 	cinco
	CALL 	clokon
	BCF 	PORTB,7 	; (01111111)
	CALL	clokon
	BCF 	PORTB,6 	; (00111111)
	CALL	clokon
	BCF 	PORTB,5 	; (00011111)
	CALL	clokon
	BCF 	PORTB,4 	; (00001111)
	CALL	clokon
	BCF 	PORTB,3 	; (00000111)
	CALL	clokon
	BCF 	PORTB,2 	; (00000011)
	CALL	clokon
	BCF 	PORTB,1 	; (00000001)
	CALL	clokon
	RETURN
EFECT6 
	CLRF	PORTB 		; limpia el puerto B
	MOVLW 	0x01 		; comienza con (00000001)
	MOVWF 	PORTB 		; lo envía a la salida
tres 
	BCF 	STATUS,0 	; pone a 0 el bit C de status (carry)
	MOVWF	MOVW
	CALL	clokon
	MOVF	MOVW,0 
	MOVWF	PORTB 		; lo envía a la salida
	RLF 	PORTB,0 	; rota a la derecha y pasa el valor a W
	MOVWF	PORTB 		; lo envía a la salida
	MOVWF	MOVW
	CALL	clokon
	MOVF	MOVW,0 		;FIN
	CLRF 	PORTB 		; (00000000)
	MOVWF	MOVW
	CALL	clokon
	MOVF	MOVW,0 		;FIN
	MOVWF	PORTB 		; repite
	MOVWF	MOVW
	CALL	clokon
	MOVF	MOVW,0 		;FIN
	CLRF 	PORTB 		; (00000000)
	MOVWF	MOVW
	CALL	clokon
	MOVF	MOVW,0 		;FIN
	MOVWF	PORTB 		; lo envía a la salida
	BTFSS	PORTB,7 	; ve si terminó de rotar
	GOTO 	tres
	MOVWF	MOVW
	CALL	clokon
	MOVF	MOVW,0 		;FIN
	RETURN
EFECT7
 	CLRF 	PORTB 		; limpia el puerto B
	CALL 	clokon
	BSF 	PORTB,0 	; (00000001)
	CALL 	clokon
	BCF 	PORTB,0 	; (00000000)
	BSF 	PORTB,1 	; (00000010)
	CALL 	clokon
	BCF 	PORTB,1 	; (00000000)
	BSF 	PORTB,2 	; (00000100)
	CALL	clokon
	BCF 	PORTB,2 	; (00000000)
	BSF 	PORTB,3 	; (00001000)
	CALL	clokon
	BCF 	PORTB,3 	; (00000000)
	BSF 	PORTB,4 	; (00010000)
	CALL	clokon
	BCF 	PORTB,4 	; (00000000)
	BSF 	PORTB,5 	; (00100000)
	CALL	clokon
	BCF 	PORTB,5 	; (00000000)
	BSF 	PORTB,6 	; (01000000)
	CALL	clokon
	BCF 	PORTB,6 	; (00000000)
	BSF 	PORTB,7 	; (10000000)
	CALL	clokon
	BSF 	PORTB,6 	; (11000000)
	CALL	clokon
	BCF 	PORTB,6 	; (10000000)
	BSF 	PORTB,5 	; (10100000)
	CALL	clokon
	BCF 	PORTB,5 	; (10000000)
	BSF 	PORTB,4 	; (10010000)
	CALL	clokon
	BCF 	PORTB,4 	; (10000000)
	BSF 	PORTB,3 	; (10001000)
	CALL	clokon
	BCF 	PORTB,3 	; (10000000)
	BSF 	PORTB,2 	; (10000100)
	CALL	clokon
	BCF 	PORTB,2 	; (10000000)
	BSF 	PORTB,1 	; (10000010)
	CALL	clokon
	BCF 	PORTB,1 	; (10000000)
	BSF 	PORTB,0 	; (10000001)
	CALL	clokon
	BSF 	PORTB,1 	; (10000011)
	CALL	clokon
	BCF 	PORTB,1 	; (10000001)
	BSF 	PORTB,2 	; (10000101)
	CALL	clokon
	BCF 	PORTB,2 	; (10000001)
	BSF 	PORTB,3 	; (10001001)
	CALL	clokon
	BCF 	PORTB,3 	; (10000001)
	BSF 	PORTB,4 	; (10010001)
	CALL	clokon
	BCF 	PORTB,4 	; (10000001)
	BSF 	PORTB,5 	; (10100001)
	CALL	clokon
	BCF 	PORTB,5 	; (10000001)
	BSF 	PORTB,6 	; (11000001)
	CALL	clokon
	BSF 	PORTB,5 	; (11100001)
	CALL	clokon
	BCF 	PORTB,5 	; (11000001)
	BSF 	PORTB,4 	; (11010001)
	CALL	clokon
	BCF 	PORTB,4 	; (11000001)
	BSF 	PORTB,3 	; (11001001)
	CALL	clokon
	BCF 	PORTB,3 	; (11000001)
	BSF 	PORTB,2 	; (11000101)
	CALL	clokon
	BCF 	PORTB,2 	; (11000001)
	BSF 	PORTB,1 	; (11000011)
	CALL	clokon
	BSF 	PORTB,2 	; (11000111)
	CALL	clokon
	BCF 	PORTB,2 	; (11000011)
	BSF 	PORTB,3 	; (11001011)
	CALL	clokon
	BCF 	PORTB,3 	; (11000011)
	BSF 	PORTB,4 	; (11010011)
	CALL	clokon
	BCF 	PORTB,4 	; (11000011)
	BSF 	PORTB,5 	; (11100011)
	CALL	clokon
	BSF 	PORTB,4 	; (11110011)
	CALL	clokon
	BCF 	PORTB,4 	; (11100011)
	BSF 	PORTB,3 	; (11101011)
	CALL	clokon
	BCF 	PORTB,3 	; (11100011)
	BSF 	PORTB,2 	; (11100111)
	CALL	clokon
	BSF 	PORTB,3 	; (11101111)
	CALL	clokon
	BCF 	PORTB,3 	; (11100111)
	BSF 	PORTB,4 	; (11110111)
	CALL	clokon
	BSF 	PORTB,3 	; (11111111)
	CALL	clokon
	BCF 	PORTB,2 	; (11111011)
	CALL	clokon
	BSF 	PORTB,2 	; (11111111)
	CALL	clokon
	BCF 	PORTB,1 	; (11111101)
	CALL	clokon
	BSF 	PORTB,1 	; (11111111)
	CALL 	clokon
	BCF 	PORTB,0 	; (11111110)
	CALL	clokon
	BSF 	PORTB,0 	; (11111111)
	CALL	clokon
	BCF 	PORTB,0 	; (11111110)
	CALL	clokon
	BCF 	PORTB,1 	; (11111100)
	CALL	clokon
	BCF 	PORTB,2 	; (11111000)
	CALL	clokon
	BCF 	PORTB,3 	; (11110000)
	CALL 	clokon
	BCF 	PORTB,4 	; (11100000)
	CALL 	clokon
	BCF 	PORTB,5 	; (11000000)
	CALL 	clokon
	BCF 	PORTB,6 	; (10000000)
	CALL 	clokon
	BCF 	PORTB,7 	; (00000000)
	CALL 	clokon
	RETURN
EFECT8 
	CALL 	EFECT3 		; combinan el efecto 3
	CALL 	EFECT2 		; con el efecto 2
	RETURN
EFECT9 
	CLRF 	PORTB 		; limpia el puerto B
	MOVLW 	0xEE 		; comienza con (11101110)
	MOVWF 	PORTB 		; lo pasa a portb
	BSF 	STATUS,0 	; pone el carry a 1
rotar
 	CALL 	clokon
	RLF 	PORTB,1 	; inicia la rotación
	BTFSC 	PORTB,7 	; ve si terminó de rotar
	GOTO 	rotar 		; sino continúa
	CALL 	clokon
	RETURN 				; terminó, ver si cambió efecto
EFECT10 
	CLRF 	PORTB 		; limpia el puerto B
	MOVLW 	0xFE 		; comienza con (11111110)
	MOVWF 	PORTB 		; lo pasa a PORTB
	BSF 	STATUS,0 	; pone el carry a 1
rotar1
 	CALL 	clokon
	RLF 	PORTB,1 	; inicia la rotación
	BTFSC 	PORTB,7 	; ve si terminó de rotar
	GOTO 	rotar1 		; sino continúa
rotar2 
	CALL 	clokon
	RRF 	PORTB,1 	; ahora rota al revés
	BTFSC 	PORTB,0 	; ve si terminó de rotar
	GOTO 	rotar2 		; sino continúa
	CALL 	clokon
	RETURN 				; terminó, ver si cambió efecto
EFECT11 
	CLRF 	PORTB 		; limpia el puerto B
	BSF 	PORTB,0 	; (00000001)
	CALL 	clokon
	BSF 	PORTB,1 	; (00000011)
	CALL 	clokon
	BSF 	PORTB,2 	; (00000111)
	CALL 	clokon
	BSF 	PORTB,3 	; (00001111)
	CALL 	clokon
	BSF 	PORTB,4 	; (00011111)
	CALL 	clokon
	BSF 	PORTB,5 	; (00111111)
	CALL 	clokon
	BSF 	PORTB,6 	; (01111111)
	CALL 	clokon
	BSF 	PORTB,7 	; (11111111)
	BCF 	STATUS,0 	; pone el carry a 0
uno 
	CALL 	clokon
	RRF 	PORTB,1 	; rotará uno apagado
	BTFSC 	PORTB,0 	; ve si es (11111110)
	GOTO 	uno 		; sino continúa
	CALL 	clokon
	BCF 	PORTB,1 	; (11111100)
	CALL 	clokon
	BCF 	PORTB,2 	; (11111000)
	CALL 	clokon
	BCF 	PORTB,3 	; (11110000)
	CALL 	clokon
	BCF 	PORTB,4 	; (11100000)
	CALL 	clokon
	BCF 	PORTB,5 	; (11000000)
	CALL 	clokon
	BCF 	PORTB,6 	; (10000000)
	BCF 	STATUS,0 	; pone el carry a 0
dos 
	CALL 	clokon
	RRF 	PORTB,1 	; rotará uno encendido
	BTFSS 	PORTB,0 	; ve si es (00000001)
	GOTO 	dos 		; sino continúa
	CALL 	clokon
	RETURN 				; terminó, ver si cambió efecto
EFECT12 
	CLRF 	PORTB 		; limpia el puerto B
	BSF 	PORTB,0 	; (00000001)
	CALL 	clokon
	BSF 	PORTB,1 	; (00000011)
	CALL 	clokon
	BSF 	PORTB,2 	; (00000111)
	CALL 	clokon
	BSF 	PORTB,3 	; (00001111)
	CALL 	clokon
	BSF 	PORTB,4 	; (00011111)
	CALL 	clokon
	BSF 	PORTB,5 	; (00111111)
	CALL 	clokon
	BSF 	PORTB,6 	; (01111111)
	CALL 	clokon
	BSF 	PORTB,7 	; (11111111)
	CALL 	clokon
	CLRF 	PORTB 		; (00000000)
	CALL 	clokon
	MOVLW 	0xFF
	MOVWF 	PORTB 		;(11111111) enciendo todo
	CALL 	clokon
	CLRF 	PORTB 		; (00000000)
	CALL 	clokon
	MOVLW 	0xFF
	MOVWF 	PORTB 		; (11111111) enciendo todo
	CALL 	clokon
	CLRF 	PORTB 		; (00000000)
	CALL 	clokon
	MOVLW 	0xFF
	MOVWF 	PORTB 		; (11111111) enciendo todo
	CALL 	clokon
	CLRF 	PORTB 		; (00000000)
	CALL 	clokon
	MOVLW 	0xFF
	MOVWF 	PORTB 		; (11111111) enciendo todo
	CALL 	clokon
	BCF 	PORTB,7 	; (01111111)
	CALL 	clokon
	BCF 	PORTB,6 	; (00111111)
	CALL 	clokon
	BCF 	PORTB,5 	; (00011111)
	CALL 	clokon	
	BCF 	PORTB,4 	; (00001111)
	CALL 	clokon
	BCF 	PORTB,3 	; (00000111)
	CALL 	clokon
	BCF 	PORTB,2 	; (00000011)
	CALL 	clokon
	BCF 	PORTB,1 	; (00000001)
	CALL 	clokon
	RETURN
EFECT13 
	CLRF 	PORTB 		; limpia el puerto B
	CALL 	TRECE 		; ejecuta parte del efecto 1
	RETURN
EFECT14 
	CLRF 	PORTB 		; limpia el puerto B
	BSF 	PORTB,7 	; (10000000) EFECTO ENCIENDE DE AFUERA AL CENTRO
	BSF 	PORTB,0 	; (10000001)-----
	CALL 	clokon
	CLRF 	PORTB
	BSF 	PORTB,6 	; (01000000)
	BSF 	PORTB,1 	; (01000010)-----
	CALL 	clokon
	CLRF 	PORTB
	BSF 	PORTB,5 	; (00100000)
	BSF 	PORTB,2 	; (00100100)-----
	CALL 	clokon
	CLRF 	PORTB
	BSF 	PORTB,4 	; (00010000)
	BSF 	PORTB,3 	; (00011000)-----
	CALL	clokon
	BSF 	PORTB,5 	; (00111000)
	BSF 	PORTB,2 	; (00111100)
	CALL	clokon
	BSF 	PORTB,6 	; (01111100)
	BSF 	PORTB,1 	; (01111110)
	CALL 	clokon
	BSF 	PORTB,7 	; (11111110)
	BSF 	PORTB,0 	; (11111111)
	CALL 	clokon
	BCF 	PORTB,3 	; (11110111)
	BCF 	PORTB,4 	; (11100111)
	CALL 	clokon
	BCF 	PORTB,5 	; (11000111)
	BCF 	PORTB,2 	; (11000011)
	CALL 	clokon
	BCF 	PORTB,6 	; (10000011)
	BCF 	PORTB,1 	; (10000001)
	CALL 	clokon
	BCF 	PORTB,7 	; (00000001)
	BCF 	PORTB,0 	; (00000000)
	CALL 	clokon
	RETURN
EFECT15 
	CLRF 	PORTB 		; limpia el puerto B
	MOVLW 	0x80 		; comienza con (10000000)
	MOVWF 	PORTB 		; lo envía a la salida
cuatro 
	BCF 	STATUS,0 	; pone a 0 el bit C de status (carry)
	MOVWF	MOVW
	CALL	clokon
	MOVF	MOVW,0 		;FIN
	MOVWF 	PORTB 		; lo envía a la salida
	RRF 	PORTB,0 	; rota a la izquierda y pasa el valor a W
	MOVWF 	PORTB 		; lo envía a la salida
	MOVWF	MOVW
	CALL	clokon
	MOVF	MOVW,0 		;FIN
	CLRF 	PORTB 		; (00000000)
	MOVWF	MOVW
	CALL	clokon
	MOVF	MOVW,0 		;FIN
	MOVWF 	PORTB 		; repite
	MOVWF	MOVW
	CALL	clokon
	MOVF	MOVW,0 		;FIN
	CLRF 	PORTB 		; (00000000)
	MOVWF	MOVW
	CALL	clokon
	MOVF	MOVW,0 		;FIN
	MOVWF 	PORTB 		; lo envía a la salida
	BTFSS 	PORTB,0 	; ve si terminó de rotar
	GOTO 	cuatro
	CALL 	clokon
	RETURN
EFECT16 
	CLRF 	PORTB 		; limpia el puerto B
	BSF 	PORTB,7 	; (10000000)
	BCF 	STATUS,0 	; pone a 0 el bit C de status (el 1º bit)
seis 
	CALL 	clokon
	RRF 	PORTB,1 	; rota a la derecha
	BTFSS 	PORTB,0 	; ve si terminó de rotar
	GOTO 	seis
	CLRF 	PORTB 		; (00000000)
	BSF 	PORTB,0 	; (00000001)
	BCF 	STATUS,0 	; pone el carry a 0
siete 
	CALL 	clokon
	RLF 	PORTB,1 	; rota a la izquierda
	BTFSS 	PORTB,7 	; ve si terminó de rotar
	GOTO 	siete
	CALL 	clokon
	RETURN

;============ control de pulsos de clock ==================

clokon 
PDelay  movlw     .197      ; 1 set number of repetitions (B)
        movwf     PDel0     ; 1 |
PLoop1  movlw     .253      ; 1 set number of repetitions (A)
        movwf     PDel1     ; 1 |
PLoop2  clrwdt              ; 1 clear watchdog
        clrwdt              ; 1 cycle delay
        decfsz    PDel1, 1  ; 1 + (1) is the time over? (A)
        goto      PLoop2    ; 2 no, loop
        decfsz    PDel0,  1 ; 1 + (1) is the time over? (B)
        goto      PLoop1    ; 2 no, loop
PDelL1  goto PDelL2         ; 2 cycles delay
PDelL2 
		CLRW 
        return              ; 2+2 Done

;USO ESTE RETARDO DE 500ms PARA NO USAR SEÑAL DE RELOJ EXTERNO

	;BTFSS 	PORTA,4 	; prueba si es 1
	;GOTO 	clokon 		; sino espera
;clokoff 
	;BTFSC 	PORTA,4 	; prueba si termina el pulso
	;GOTO 	clokoff 	; sino espera que termine
	;RETURN 				; regresa y continúa

;========================= final ==========================

	END

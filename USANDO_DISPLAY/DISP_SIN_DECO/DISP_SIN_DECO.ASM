;----------------ENCABEZADO-------------

		LIST		P=16F84A
		INCLUDE		"P16F84A.INC"

;------------VARIABLES UTILIZADAS---------

	CBLOCK		0X0C

		REG1
		REG2
		REG3
		REG4
		CONT

	ENDC

;----------CONFIGURACION DE PUERTOS-----------

	ORG		0X00
	GOTO	INICIO
	ORG		0X05

INICIO	BSF		STATUS,RP0			;CONFIGURANDO PUERTOS
		CLRF	TRISB				;PORT B ES SALIDA
		BCF		STATUS,RP0

;--------------PROGRAMA PRINCIPAL--------------

REINI	CLRF	CONT			;PONE EL CONTADOR A 0
		MOVF	CONT,W			;PASA EL CONTADOR A W
		CALL	TABLA			;LLAMA A TABLA
		MOVWF	PORTB			;PASA EL DATO OBTENIDO A PORTB
		CALL	RETARDO

DISP_	MOVF	CONT,W
		XORLW	0X09			;VERIFICA  SI EL CONTADOR  LLEGO A 9
		BTFSC	STATUS,Z		;SINO SE SALTA UNA LINEA
		GOTO	REINI			;SI LLEGHO A 9 LO ATIENDE EN REINI
		INCF	CONT,F			;INCREMENTA EL CONTADOR	
		MOVF	CONT,W			;PASA EL CONTADOR A W
		CALL	TABLA			;LLAMA A LA TABLA
		MOVWF	PORTB			;PASA EL DATO OBTENIDO DE  LA TABLA A PORTB
		CALL	RETARDO
		GOTO	DISP_

;---------------------TABLA--------------------

TABLA	ADDWF	PCL,F			;SE INCREMENTA EL CONTADOR DE PROGRAMA
		;DISPLAY	.G F E D C B A		SEGMENTOS DEL DISPLAY
		
		RETLW B'01101101' ; c�digo para el 5 
		RETLW B'01100110' ; c�digo para el 4
		RETLW B'01001111' ; c�digo para el 3 
		RETLW B'01011011' ; c�digo para el 2 
		RETLW B'00000110' ; c�digo para el 1 
		RETLW B'00111111' ; c�digo para el 0

		RETLW B'00111000' ; c�digo para el L 
		RETLW B'00111111' ; c�digo para el O 
		RETLW B'01111100' ; c�digo para el B 
		RETLW B'10111111' ; c�digo para el O.

;-----RUTINA DE RETARDO----------

RETARDO	MOVLW	10			;CARGO CON 10 EN HEADEC A REG 1
		MOVWF	REG1

TRES	MOVLW	20
		MOVWF	REG2

DOS		MOVLW	15
		MOVWF	REG3

UNO		MOVLW	20
		MOVWF	REG4

CERO	DECFSZ	REG4,1		;COMIENZA A DECREMENTAR REG4 SI LLEGAA 0 SE SALTA UNA INSTRUCCION
		GOTO    CERO		;PARA DECREMENTAR REG4 HASTA CERO
		DECFSZ	REG3,1		;Cuando reg4 llegue a 0 decrementar� reg3 en una unidad
		GOTO 	UNO			;volver� a cargar reg4y lo decrementar� nuevamente
		DECFSZ	REG2,1		; para reci�n restarle otra unidad a reg3
		GOTO	DOS			;as�... hasta que reg2 se haga cero.
		DECFSZ	REG1,1		;todo esto ocurrir� hasta que reg1 se haga igual a cero.
		GOTO	TRES
		RETLW	0X0			;REGRESO A DONDE  SE HIZO LA LLAMADA CARGANDE W CON 0

;--------------------

	END 		;FIN


		
		
;PROYECTO TÖPICO 2
;"MENSAJE DE BIENVENIDA SOBRE LCD"
 
 
;Programa que muestra la palabra "HOLA" en la l¡nea 1 del LCD
 
 
;DIRECTIVAS DEL PROGRAMA
 
 
		LIST 	p=16F84 	; Se emplea el PIC 16F84
		RADIX 	HEX 		; Sistema de numeraci¢n hexadecimal
 
 
;ETIQUETAS DEL PROGRAMA
 
 
		INCLUDE "PIC16CXX.INC" ; Etiquetas gen‚ricas para los PIC 16CXX

			RESUL 	EQU 0x0C 
			TEMPO1 	EQU 0x0D
			OFFSET 	EQU 0x0E
			OPCION 	EQU 0x81^80H
			LCD_VAR EQU 0x0F
 
 
;PROGRAMA PRINCIPAL 

	 ORG 	0 		; El programa comienza en la direcci¢n 0 y salta a la 
	 goto 	INICIO 		; direcci¢n 5 para sobrepasar el vector de interrupci¢n
	 ORG 	5 	
	 INCLUDE "LCD_CXX.ASM"
INICIO 	 call 	UP_LCD 		; Configura el PIC para el uso del LCD
	 bsf 	STATUS,RP0 	; Selecci¢n del banco 1
	 movlw 	b'10000111'
	 movwf 	OPCION 		;Asigna preescaler al TMR0
	 bcf 	STATUS,RP0
	 call 	LCD_INI 	;Inicializa el LCD
INICIO_1 call 	BORRA_Y_HOME
	 call 	DISPLAY_ON_CUR_OFF
	 movlw 	0x80 		; Primera posici¢n de primera fila
	 call 	LCD_REG
	 movlw 	b'00000110' 	; Entry Mode Set. Inc de cursor
	 call 	LCD_REG
	 clrf 	OFFSET 		; Direcci¢n del mensaje
	 call 	MENS
BUCLE 	 goto 	BUCLE 		; El programa acaba en un bucle infinito
	
 
;RUTINA MENS: Esta rutina saca mensajes por la pantalla LCD,
;siendo el primer car cter aquel que est  en la posici¢n apuntada
;por OFFSET, y debiendo ser el £ltimo 0x00
 
 
MENS 	clrf 	RESUL 		;Inicializa contador de caracteres
MENS_1 	movf 	OFFSET,W 	;Coge el desplazamiento
	addwf 	RESUL,W 	;Calcula el car cter a coger
	call 	DATOS 		;Coge el car cter
	iorlw 	0 		;Actualiza flags
	btfsc 	STATUS,2 	;Comprueba si es el £ltimo	
	return 			;Si es el £ltimo vuelve	
	call 	LCD_DATO 	;Visualiza el car cter
	incf 	RESUL,F 	;Incrementa contador de caracteres
	movlw 	d'10'
	movwf 	TEMPO1
	goto 	MENS_1
 
;TABLA CON LOS DATOS A SACAR POR EL LCD
 
 
DATOS 	addwf 	PCL,1
	retlw 	'H' 		; OFFSET = 0x00
	retlw 	'O'
	retlw 	'L'
	retlw 	'A'
	retlw 	0x00
 
 
		END

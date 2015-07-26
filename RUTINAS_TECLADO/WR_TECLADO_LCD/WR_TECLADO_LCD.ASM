;PROYECTO TÖPICO 3
;"ESCRITURA DE MENSAJES DE TECLADO SOBRE LCD"
;Se desea realizar un programa que visualice sobre el LCD las teclas
;que se vayan pulsando. Cada pulsaci¢n ir  acompa¤ada de un "beep" de
;0,25 segundos sobre el zumbador piezoel‚ctrico conectado a RA3
 
;DIRECTIVAS DEL PROGRAMA
 
 
		LIST 	P=16F84 ; Se emplea el PIC 16F84
		RADIX 	HEX 	; Sistema de numeraci¢n hexadecimal 
 
;ETIQUETAS DEL PROGRAMA 
 
		INCLUDE  "P16F84A.INC"
		TEMP_1 	 EQU 0x0C 
		DELAY_1  EQU 0x0D
		DELAY_2  EQU 0x0E
		DELAY_3  EQU 0x0F
		LCD_VAR  EQU 0x10
		KEY_VAR  EQU 0x12
	 
 
;POSICIONAMIENTO DE LA RUTINA DE INICIO 
 
 
		ORG 	0 	; El programa comienza en la direcci¢n 0 y 
		goto 	INICIO	; salta a la direcci¢n 5 para sobrepasar el
		ORG 	5 	; vector de interrupci¢n
 
;RUTINA HEX_ASCII: Rutina que pasa el valor HEXADECIMAL que contiene
;W a valor ASCII, para ser mostrado por el LCD 
 
 
HEX_ASCII	addwf PCL,1
		retlw '0'
		retlw '1'
		retlw '2'
		retlw '3'
		retlw '4'
		retlw '5'
		retlw '6'
		retlw '7'
		retlw '8'
		retlw '9'
		retlw 'A'
		retlw 'B'
		retlw 'C'
		retlw 'D'
		retlw 'E'
		retlw 'F'
	
;PROGRAMA PRINCIPAL
 
 
	INCLUDE "LCD_CXX.ASM"
	INCLUDE "TECLADO.ASM"
INICIO 	call 	UP_LCD
	call 	LCD_INI
	call 	DISPLAY_ON_CUR_OFF 
	bsf 	STATUS,RP0 		; Selecci¢n del banco 1
	clrf 	PORTA			; Puerta A como salida
	movlw 	b'10000111' 
	movwf 	OPTION_REG
	bcf 	STATUS,RP0 
	bsf 	PORTA,3 		; Desactivaci¢n del zumbador 
NO_HAY 	call 	KEY_SCAN 		; Se hace un chequeo del teclado
	movlw 	0x80
	subwf 	TECLA,W 		; Sobre TECLA quedar  la tecla pulsada o 0x80 
	btfsc 	STATUS,Z
	goto 	NO_HAY 			; No se ha pulsado ninguna tecla
	call 	KEY_OFF 		; S¡ se ha pulsado. Se espera a que se suelte
	bcf 	PORTA,3 		; Se genera un "beep"
	movlw 	d'25'
	movwf 	TEMP_1
	call 	DELAY10 		; Se crea una temporizaci¢n de 25 ms
	bsf 	PORTA,3 		; Se desactiva zumbador
	call 	KEY_HEX 		; Se pasa a valor hexadecimal
	call 	HEX_ASCII 		; Se pasa el valor hexadecimal a c¢digo ASCII
	movwf 	TECLA 			; Se guarda temporalmente en TECLA 
	call 	UP_LCD 
	call 	BORRA_Y_HOME
	call 	DISPLAY_ON_CUR_OFF 
	movlw 	0x81 			; Primer car cter de primera l¡nea
	call 	LCD_REG
	movf 	TECLA,W 
	call 	LCD_DATO 		; Se saca por el LCD
	goto 	NO_HAY 			; Se vuelve a empezar
		
 
;RUTINA DE DELAY DE 10 MS: Esta rutina utiliza el TMR0. 
;Es una temporizaci¢n de 10 ms que se repite tantas veces 
;como indique la variable TEMPO1
 
 
DELAY10 	bcf 	INTCON,2 	; Borra flag del TMR0
		movlw 	0xD8
		movwf 	TMR0 		; Carga el TMR0 con valor 39
DELAY10_1 	btfss 	INTCON,2 	; Espera rebosamiento del TMR0 
		goto 	DELAY10_1
		decfsz 	TEMP_1,F
		goto 	DELAY10
		return
 
 
;RUTINA DE DELAY DE 1 SEGUNDO: Se basa en la rutina de 10ms, repiti‚ndola 100 veces
 
 
DELAY1S 	movlw 	0x64
		movwf 	TEMP_1
		call 	DELAY10
		return
 
 
;RUTINA KEY_OFF: Esta rutina espera que la tecla reci‚n pulsada sea soltada.
;Debe usarse justo despu‚s de llamar a la rutina KEY_SCAN 
 
 
KEY_OFF 	movf 	TECLA,W 
		movwf 	TEMP_1 		; Guarda temporalmente la tecla
KEY_OFF_NO	call 	KEY_SCAN 	; Mira si se ha soltado
		movlw 	0x80
		subwf 	TECLA,W
		btfss 	STATUS,Z
		goto 	KEY_OFF_NO 	; Bucle mientras no se suelte
		movf 	TEMP_1,W 	; Ya se ha soltado
		movwf 	TECLA 		; Se repone la tecla
		return
 
 
;RUTINA DE DELAY VARIABLE: Esta rutina realiza una temporizaci¢n que
;depende del valor del acumulador en el momento en que se le llama
 
DELAY_V 	movwf 	DELAY_1
		clrf 	DELAY_3
		clrf 	DELAY_2
DELAY_LOOP 	decfsz 	DELAY_3,F
		goto 	DELAY_LOOP
		decfsz 	DELAY_2,F
		goto 	DELAY_LOOP
		decfsz	DELAY_1,F
		goto 	DELAY_LOOP
		return
 
 
		END
 

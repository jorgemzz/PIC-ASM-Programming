;PROYECTO TÖPICO 1
;"TECLADO MUSICAL"
 
 
;Se desea realizar un programa que genere un pitido por el zumbador 
;piezoel‚ctrico conectado a RA3, cuya duraci¢n dependa del valor de
;la tecla pulsada, siendo la "0" la tecla de pitido m s corto, y la 
;"F" la de pitido m s largo.
 
 
;DIRECTIVAS DEL PROGRAMA
 
	LIST 	P=16F84 	; Se emplea el PIC 16F84
	RADIX 	HEX 		; Sistema de numeraci¢n hexadecimal	
 
 
;ETIQUETAS DEL PROGRAMA
 
 
        INCLUDE         "P16F84A.INC"     ; Etiquetas gen‚ricas para los PIC 16CXX
	TEMP_1 		EQU 0x0C 
	TEMP_2		EQU	0x0D
	DELAY_1 	EQU	0x0E
	DELAY_2 	EQU	0x0F
	DELAY_3 	EQU	0x10
	KEY_VAR		EQU	0x11
				
 
;PROGRAMA PRINCIPAL
 
	ORG 	0 		; El programa comienza en la direcci¢n 0 y 
	goto 	INICIO 		; salta a la direcci¢n 5 para sobrepasar el
	ORG 	5 		; vector de interrupci¢n
	INCLUDE "TECLADO.ASM"	; Coloca las rutinas tras el vector de interrupci¢n
INICIO	bsf 	STATUS,RP0	; Selecci¢n del banco 1
	clrf 	TRISA		; Se configura la puerta A como salida
	bcf	STATUS,RP0
	bsf 	PORTA,3		; Se desactiva el zumbador
NO_HAY	call	KEY_SCAN	; Se hace un chequeo del teclado
	movlw	0x80
	subwf	TECLA,W		; Sobre TECLA quedar  la tecla pulsada o 0x80 
	btfsc	STATUS,Z
	goto	NO_HAY		; No se ha pulsado ninguna tecla
	call 	KEY_OFF		; S¡ se ha pulsado. Se espera a que se suelte
	call	KEY_HEX		; Se pasa el valor a hexadecimal
	movf	TECLA,W		; Ese valor servir  para determinar la duraci¢n del beep
	addlw	0x01		; Se suma 1 para que el "0" no sea el de mayor temporizaci¢n		
	bcf		PORTA,3			; Se activa el zumbador (por nivel bajo
	call	DELAY_V
	bsf		PORTA,3		; Se desactiva el zumbador
	goto	NO_HAY		; Se vuelve a empezar
		 		
;RUTINA KEY_OFF: Esta rutina espera que la tecla reci‚n pulsada sea soltada.
;Debe usarse justo despu‚s de llamar a la rutina KEY_SCAN 
 
 
KEY_OFF	   movf 	TECLA,W	
	   movwf	TEMP_1	 	 ; Guarda temporalmente la tecla
KEY_OFF_NO call	 	KEY_SCAN	 ; Mira si se ha soltado
	   movlw	0x80
	   subwf	TECLA,W
	   btfss	STATUS,Z
	   goto		KEY_OFF_NO	 ; Bucle mientras no se suelte
	   movf		TEMP_1,W	 ; Ya se ha soltado
	   movwf	TECLA		 ; Se repone la tecla
	   return
 
 
;RUTINA DE DELAY VARIABLE: Esta rutina realiza una temporizaci¢n que 
;depende del valor del acumulador en el momento en que se le llama
 
 
DELAY_V		movwf	DELAY_1
		clrf	DELAY_3
		clrf	DELAY_2
DELAY_LOOP	decfsz 	DELAY_3,F
		goto	DELAY_LOOP
		decfsz 	DELAY_2,F
		goto	DELAY_LOOP
		decfsz 	DELAY_1,F
		goto	DELAY_LOOP
		return
	
	 	END


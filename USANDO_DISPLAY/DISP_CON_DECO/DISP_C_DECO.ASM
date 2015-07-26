

	LIST		P=16F84A
	INCLUDE		"P16F84A.INC"

;-----------------------------------
	
	CBLOCK		0X0C
	PDel0 
	PDel1
	ENDC

;---------CONFIGURACION DE PUERTOS------

		ORG		0X00
		GOTO	INICIO
		ORG		0X04
		GOTO	ISR
		ORG		0X05
INICIO
		BSF		STATUS,RP0			;CONFIGURANDO LOS PUERTOS
		MOVLW	0X00				;CARGO W CON 00000000
		MOVWF	TRISA				;PORT A ES SALIDA
		MOVLW	0X01				;CARGA W CON 00000001
		MOVWF	TRISB				;RB0 ES ENTRADA  DE INTERRUPCION EXTERNA

		BSF		OPTION_REG,6		;SELECCIONAMOS FLANCO ASCENDENTE PARA LA INTERRUPCION
									;CUANDO SOLTEMOS EL PULSADOR SE PRODUCIRA LA INTERRUPCION
		BCF		STATUS,RP0			;PULSADOR A TIERRA

;--------HABILITACION DE INTERRUPCIONES-----

		BSF		INTCON,GIE		;HABILITACION DE TODAS LAS INTERRUPCIONES
		BSF		INTCON,INTE		;QUE SEN INTERRUPCIONES EXTERNAS

;-------------PROGRAMA PRINCIPAL--------------

		CLRF	PORTA			
ESPERA	SLEEP
		GOTO	ESPERA			;EL MICRO PASA A BAJO CONSUMO
		
ISR		BTFSS	PORTB,0			;VERIFICAMOS QUE SUELTEN EL PULSADOR
		GOTO	ISR
		CALL	PDelay			;RETARDO PARA AMOETIGUAR LAS SEÑALES DEL PULSADOR(50ms)	

		MOVF	PORTA,W			;PASAMOS LO QUE HAY EN PORTA A W
		XORLW	0X09			;COMPARA PARA SABER SI TERMINO LA CUENTA
		BTFSC	STATUS,Z		;SINNO TERMINO SALTA UNA LINEA
		GOTO	REINI			;Y SI TERMINO IRA A REINICIARLA
		INCF	PORTA,F			;INCREMENTA EN UNO PORTA U L0 RETIENE
		BCF		INTCON,INTF		;BORRO BANDERA DE INTERRUPCION
		
		RETFIE					;REGRESA A MODO SLEEP

REINI	CLRF	PORTA			
		BCF		INTCON,INTF		;BORRO BANDERA DE INTERRUPCION
		
		RETFIE

;--------AMORTIGUANDO----------

PDelay  movlw     .55       ; 1 set number of repetitions (B)
        movwf     PDel0     ; 1 |
PLoop1  movlw     .181      ; 1 set number of repetitions (A)
        movwf     PDel1     ; 1 |
PLoop2  clrwdt              ; 1 clear watchdog
        clrwdt              ; 1 cycle delay
        decfsz    PDel1, 1  ; 1 + (1) is the time over? (A)
        goto      PLoop2    ; 2 no, loop
        decfsz    PDel0,  1 ; 1 + (1) is the time over? (B)
        goto      PLoop1    ; 2 no, loop
        return              ; 2+2 Done

;----------------------------------------------
	END
:----------------------------------------

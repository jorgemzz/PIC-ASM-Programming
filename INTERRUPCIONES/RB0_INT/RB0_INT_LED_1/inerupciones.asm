
		LIST	P=16F84A
		INCLUDE	"P16F84A.INC"

;-------MAPA DE MEMORIA---------	
REG1	EQU	0X0C
REG2	EQU	0X0D
REG3	EQU	0X0E
PDel0	EQU	0X0F
PDel1	EQU	0X10
SWITCH	EQU	0X11


;---DEFINO ALGUNAS INTRUCIONES--------

#DEFINE	BANK1	BSF		STATUS,5	;IR AL BANCO 1
#DEFINE	BANK0	BCF		STATUS,5	;IR AL BANCO 0

;---------INICIA EL PROGRAMA--------

	ORG	000H	;INDICA AL ENSAMBLADOR LA DIRECICON DE MEMORIA 
			;DE LA SIGUIENTE INSTRUCCION
	GOTO	INICIO

	ORG	004H	;INDICA AL ENSAMBLADOR LA DIRECCION DE MORIA DE LA SIG
			;INSTRUCCION(LA INTERRUPCOIN)

;-------LA INTERRUPCION-----

	CALL	PDelay			;RETARDO PARA AMOETIGUAR LAS SE�ALES DEL PULSADOR(50ms)	
	BSF		PORTA,0			;APAGO EL LED CONECTADO A RA0
INTERRUPCION				;SERIA CONVENIENTE CREAR UN RETARDO AQUI(50 ms)
	BTFSS	INTCON,1		;ES INTERRUPCION 
	RETFIE					;SI NO REGRESA DE INTERRUPCION
	BTFSC	SWITCH,0		;PROBAR EL ESTADO ACTUAL DEL BIT 0 DEL REGISTRO SWITCH
	GOTO	PONER0			;SI ES 1 LO PONE A 0
							;Y SI ES 0 LO PONE A 1
PONER1
	MOVLW	B'00000001'
	MOVWF	SWITCH			;PONE A UNO EL BIT 0 DE REGISTRO SWITCH
	GOTO	ESPERA
	;CALL	PDelay

PONER0
	CLRF	SWITCH			;BORRA EL REGISTRO SWITCH
	;CALL	PDelay

ESPERA
	BTFSS	PORTB,0			;ESPERA A QUE SE SUELTE EL PULSADOR
	GOTO	ESPERA
	CALL	PDelay			;AMORTIGUAR PICOS PRODUCIDOS POR EL PULSASOR	
	BCF		INTCON,1		;SI SE SOLTO PULSADOR BORRA LA BANDERA INTF
	RETFIE						;(NO SE HA PRODUCIDO LA INTERRUPCION)
					;RETORNA DE INTERRUPCION Y GIE=1(PERMISO DE INTERRUPCION)

;------PROGRAMA PRINCIPAL-------

INICIO

	BANK1				;SELECCION DEL BANCO 1
	MOVLW	B'00000000'		;CARGO 00000000 EN W PARA
	MOVWF	TRISA		;SELECCION DE EL PORTA COMO SALIDA
	BANK0				;SELECCION DEL BANCO 0
	BSF		PORTA,0		;APAGO EL LED CONECTADO A RA0
	CLRF	SWITCH		;PONGO A CERO ON OFF

;-------PROGRAMACION DE INTERRUPCION-------

	BSF		INTCON,4		;HABILITACION DE INTERRUPCION POR FLANCO EN RB0
							;ACTIVAMOS EL BIT NUMERO 4(INTE=1)
	BANK1					;SELECCION DEL BACO1
	BCF		OPTION_REG,6	; INTERRUPCION POR FLANCO DE BAJADA EN PIN INT
	BANK0
	BSF		INTCON,7		;HABILITAR INTERRUPCIONES GLOBALES
	GOTO	SWITCH_LED1			;QUEDA A ESPERA DE INTERRUPCION	
	
SWITCH_LED1
	BTFSS	SWITCH,0	;SI BIT 0 DE SWITCH ES 1 VA A LED 1 
	GOTO	SWITCH_LED1	;SI NO SIGUE ESPERANDO

;--------PROGRAMA LED 1, AQUI ENCIENDE Y APAGA EL LED--------

LED1
		BCF		PORTA,0		;PONE 0 EN RA0(ENCIENDE EL LED)
		CALL	RETARDO		;LLAMA A RETARDO

		BSF		PORTA,0		;PONE UN 1 EN RA0(APAGO EL LED)
		CALL	RETARDO		;LLAMA A RETARDO
		GOTO	SWITCH_LED1	;MIRA SI SE ENCIENDE O NO LED1	

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

;------RUTINA DE RETARDO----------------

RETARDO	MOVLW	20	;AQUI SE CARGAN LOS REGISTROS
		MOVWF	REG1	;REG1 REG2 Y REG3
						;CON LOS VALORES

TRES	MOVLW	30		;10 20 Y 30
		MOVWF	REG2

DOS		MOVLW	30
		MOVWF	REG3

UNO		DECFSZ	REG3,1	;AQUI SE COMIENZA A DECREMENTAR REG3
		GOTO	UNO		;CUANDO REG3 LLEGUE A 0
		DECFSZ	REG2,1	;LE QUITARE 1 A REG2
		GOTO	DOS		;CUANDO REG2 LLEGUE A 0
		DECFSZ	REG1,1	;LE QUITARE 1 A REG1
		GOTO	TRES	;CUANDO REG1 LLEGUE A 0 SE SALTA UNA LINEA
		RETLW	00		;REGRESO AL LUGAR DE DONDE SE HIZO LA LLAMADA
						;Y CARGO EL VALOR 00 EN W

;-----------THE END-------

	END
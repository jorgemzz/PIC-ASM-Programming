
	LIST	P=16F84A
	INCLUDE	"P16F84A.INC"

;--------CONFIGURACION DE PUERTOS--------

		ORG		0X00
		GOTO	INICIO
		ORG		0X04			;ATIENDO LA INTERRUPCION
		BTFSS	PORTB,0			;SI EL LED ESTA APAGADO 
		GOTO	LED				;VOY ALED Y LO ENCIENDO
		BCF		PORTB,0			;SINO LO APAGO
		BCF		INTCON ,2	;LIMPIO LA BANDERA TOIF
		RETFIE					;REGRESO HABILITANDO LA INERRUPCION

LED		BSF		PORTB,0			;ENCIENDO EL LED
		BCF		INTCON,2		;BORRO LA BANDERA TOIF
		RETFIE					;REGRESO HABILITANDO LA INTERRUPCION

INICIO	BSF		STATUS,RP0		;CONFIGURANDO PUERTOS
		CLRF	TRISB			;PUERTO B SALIDA
		MOVLW	0X07			;CARGO W CON 00000111
		MOVWF	OPTION_REG		;EL DIVISOR=256
		BCF		STATUS,RP0		
		MOVLW	0XA0			;CARGO W CON 10100000
		MOVWF	INTCON			;HABILITAMOS GIE Y TOIE
		CLRF	PORTB			;LIMPIAMOS PORT B

TIEMPO	MOVLW	0XD8			;CARGO W CON 216
		MOVWF	TMR0			;LO PASO A TIMER 0

NADA	BTFSC	TMR0,7			;ME QUEDO HACIENDO NADA
		GOTO	NADA			;HASTA QUE TMR0 DE DESBORDE , Y ENTONCES
		GOTO	TIEMPO			;VOLVERE A CARGAR TMR0

;-------------------------------------------------

	END
;-------------------------------------------------
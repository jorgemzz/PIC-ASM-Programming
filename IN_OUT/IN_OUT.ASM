

	LIST		P=16F84A
	INCLUDE		"P16F84A.INC"

;----------INICIALIZACION---------

RESET	ORG	0X00
		GOTO	 INICIO
		
		ORG	0X05
INICIO	BSF		STATUS,RP0				;SALTO AL BANCO UNO DE LA RAM
		CLRF	TRISA					;PUERTO A VOMO SALIDA
		MOVLW	0X0F					;DATO PARA LA PROGRAMACOIN DELPORT B
		MOVWF	TRISB					;PARTE ALTA SALIDA Y BAJA COMO ENTRADA

		BCF		OPTION_REG,NOT_RBPU		;ACTIVO LAS RESISTENCIAS PULL UP
		BCF		STATUS,RP0				;REGRRESO AL BANCO 0

LOOP:
		COMF	PORTB,0					;LEE EL POTB, SE COMPLEMENTA DU VALOR Y EL RESULTADO SE PASA A W
		MOVWF	PORTA					;SE PASA EWL RESULTADO DE W A PORTA
		GOTO	LOOP					;EJECUTA LA LECTURA DE DATOS INFINITA

;----------SE ACABO----------

	END

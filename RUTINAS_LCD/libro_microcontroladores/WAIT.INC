
;*******DECLARACION DE CONSTANTES**********

		CONSTANT PRESCstd = b'00000001'	;prescaler estandar para TMR0

;********MACROS*******

	WAIT	macro	timeconst_1

		movlw	timeconst_1
		call	WAITstd
	endm

	WAITX	macro	timeconst_2,PRESCest

		movlw	timeconst_2
		movwf	WCYCLE		;definir espacio de tiempo
		movlw	PRESCext		;definir valor de prescaler
		call	WAIT_x
	endm

;**********subprogramas********

	WAITstd

		movwf	WCYCLE		;definir espacio de tiempo
		movlw	PRESCstd		;definir valor de prescaler

	WAIT_x
		clrf	TMR0
		BANK1
		movwf	OPTION_REG		;atribuir prescaler a TMR0
		BANK0

	WAITa
		BCF		INTCON,TOIF		;PONE A 0 EL FLAG DE DESBORDE DE TMR0
	WAITb
		btfss	INTCON,TOIF		;VERIFICA SI EL FAG DE DESBORDE ES 0
		goto	WAITb			;CONTINUAR A ESPERAR
		decfsz	WCYCLE,1		;REPETIR SI ESTA VARIABLE NO ES 0
		goto	WAITa
	
	RETURN
		

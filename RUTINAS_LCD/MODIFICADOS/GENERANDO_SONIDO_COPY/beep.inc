;declarar constantes

	CONSTANT	PRESCbeep=b'00000111'

;macros

	BEEP	macro	freq,duration
		movlw	freq	
		movwf	Beep_TEMP1
		MOVLW	duration
		call	BEEPsub
			endm

	BEEPinit macro
		bcf		BEEPport
		BANK1
		BCF		BEEPtris
		BANK0
			endm

;subrutinas

	BEEPsub
		movwf	Beep_TEMP2
		clrf	TMR0
		bcf		BEEPport
		BANK1
		bcf		BEEPport
		movlw	PRESCbeep
		movwf	OPTION_REG
		BANK0

	BEEPa
		bcf		INTCON,2
	BEEPb
		bsf		BEEPport
		call	B_Wait
		bcf		BEEPport
		call	B_Wait
		btfss	INTCON,T0IF
		goto	BEEPb
		decfsz	Beep_TEMP2,1
		goto	BEEPa
		RETURN

	B_Wait
		movfw	Beep_TEMP1
		movwf	Beep_TEMP3
	B_Waita
		decfsz	Beep_TEMP3,1
		GOTO	B_Waita
		RETURN
	
	
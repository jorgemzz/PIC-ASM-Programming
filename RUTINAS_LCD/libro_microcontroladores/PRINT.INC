
	PRINT 	macro	Addr,Start,End,Var,Out
			
			Local	Next	;rotulo local
			Local	Exit
			
			movlw	Start		;direccion del primer elemento de  la cadena
			movwf	Var

	Next	movf	Var,w
			call	Addr

			out
			movf	Var,w
			xorlw	End_1
			btfsc	STATUS,Z
			goto	Exit
			incf	Var,f
			goto	Next

	Exit
		endm
			
			
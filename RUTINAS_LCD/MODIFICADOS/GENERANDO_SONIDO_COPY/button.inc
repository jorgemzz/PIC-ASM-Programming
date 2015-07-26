Button	macro	Hilo,Port,Bit,Delay,Adrress
		Local	Exit
		Local	Loop

		if	Hilo==0
		btfsc	Port,Bit
		else	
		btfss	Port,Bit
		endif
		goto	Exit
		
		WAIT	Delay
	Loop
		if	Hilo==0
		btfss	Port,Bit
		else
		btfsc	Port,Bit
		endif
		goto	Loop

		WAIT    Delay
		call	Adrress
    Exit
		endm
	
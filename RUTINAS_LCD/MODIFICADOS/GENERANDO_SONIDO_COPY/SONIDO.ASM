
	LIST	P=16F84A
	INCLUDE	"P16F84A.INC"

;Declarando variables

	CBLOCK	0X0C
		WCYCLE
		PRESCwait
		Beep_TEMP1
		Beep_TEMP2
		Beep_TEMP3
	ENDC

;Definir el hardware

	#define	BEEPport	PORTA,3
	#define	BEEPtris	TRISA,3

;Estructura de la memoria de programa

	ORG	0X00
	goto	Main
	ORG	0X04
	goto	Main

	INCLUDE	"bank.inc"	
	INCLUDE	"button.inc"
	INCLUDE	"wait.inc"
	INCLUDE	"beep.inc"

Main
	BANK1
	movlw	0x17
	movwf	TRISA
	clrf	TRISB
	BANK0

	BEEPinit
	clrf	PORTB

Loop
	Button	0,PORTA,0,.100,Play1
	Button	0,PORTA,1,.100,Play2
	goto	Loop

Play1
	BEEP	0X17,0X3
	BEEP	0X78,0X3
	BEEP	0X1A,0X03
	BEEP	0X3C,0X03	
	RETURN

Play2
	BEEP	0XBB,0X02
	BEEP	0X87,0X05
	BEEP	0XA2,0X03
	BEEP	0X98,0X03
	RETURN

	end
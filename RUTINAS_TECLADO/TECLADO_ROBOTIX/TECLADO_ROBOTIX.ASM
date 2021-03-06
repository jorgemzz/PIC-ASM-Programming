		

		LIST	P=16F84A
		INCLUDE	"P16F84A.INC"

	Tecla	EQU	0X0C
	PDel0	EQU	0X0D
	PDel1	EQU	0X0E

		ORG	0X00
		GOTO	INICIO

		ORG	0X05
INICIO
	BSF		STATUS,RP0
	CLRF	PORTA
	CALL	KB_Port
	
INIXIO		

	
	CALL	KB_Scan	

	BCF		STATUS,RP0
	MOVF	Tecla,W
	MOVWF	PORTA
	CALL	PDelay
	CALL	PDelay

	GOTO	INIXIO

	INCLUDE	"TECLADO.INC"

;-------------------------------------------------------------
; Code generated by PDEL  ver 1.0  on 04/01/1980 at 12:34:07 a.m.
; Description: Waits 300000 cycles
;-------------------------------------------------------------
PDelay  movlw     .154      ; 1 set number of repetitions (B)
        movwf     PDel0     ; 1 |
PLoop1  movlw     .243      ; 1 set number of repetitions (A)
        movwf     PDel1     ; 1 |
PLoop2  clrwdt              ; 1 clear watchdog
PDelL1  goto PDelL2         ; 2 cycles delay
PDelL2  goto PDelL3         ; 2 cycles delay
PDelL3  
        decfsz    PDel1, 1  ; 1 + (1) is the time over? (A)
        goto      PLoop2    ; 2 no, loop
        decfsz    PDel0,  1 ; 1 + (1) is the time over? (B)
        goto      PLoop1    ; 2 no, loop
PDelL4  goto PDelL5         ; 2 cycles delay
PDelL5  clrwdt              ; 1 cycle delay
        return              ; 2+2 Done
;-------------------------------------------------------------
		END
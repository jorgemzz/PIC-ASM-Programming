		CBLOCK
		PDel0		;contadores para los retardos
		PDel1
		PDel2
		ENDC

RETARDO_10MS
PDelay10  movlw     .8        ; 1 set number of repetitions (B)
        movwf     PDel0     ; 1 |
PLoop10  movlw     .249      ; 1 set number of repetitions (A)
        movwf     PDel1     ; 1 |
PLoop210  clrwdt              ; 1 clear watchdog
        clrwdt              ; 1 cycle delay
        decfsz    PDel1, 1  ; 1 + (1) is the time over? (A)
        goto      PLoop210    ; 2 no, loop
        decfsz    PDel0,  1 ; 1 + (1) is the time over? (B)
        goto      PLoop10    ; 2 no, loop
PDelL10  goto PDelL210         ; 2 cycles delay
PDelL210  clrwdt              ; 1 cycle delay
        return              ; 2+2 Done
;------------------------------------------------------------		  
RETARDO_1S
PDelay1  movlw     .14       ; 1 set number of repetitions (C)
        movwf     PDel0     ; 1 |
PLoop01  movlw     .72       ; 1 set number of repetitions (B)
        movwf     PDel1     ; 1 |
PLoop11  movlw     .247      ; 1 set number of repetitions (A)
        movwf     PDel2     ; 1 |
PLoop21  clrwdt              ; 1 clear watchdog
        decfsz    PDel2, 1  ; 1 + (1) is the time over? (A)
        goto      PLoop21    ; 2 no, loop
        decfsz    PDel1,  1 ; 1 + (1) is the time over? (B)
        goto      PLoop11    ; 2 no, loop
        decfsz    PDel0,  1 ; 1 + (1) is the time over? (C)
        goto      PLoop01    ; 2 no, loop
PDelL1  goto 	  PDelL21         ; 2 cycles delay
PDelL21  clrwdt              ; 1 cycle delay
        return              ; 2+2 Done
;----------------------------------------------------------
RETARDO_2S
PDelay2  movlw     .167      ; 1 set number of repetitions (C)
        movwf     PDel0     ; 1 |
PLoop02  movlw     .41       ; 1 set number of repetitions (B)
        movwf     PDel1     ; 1 |
PLoop12  movlw     .72       ; 1 set number of repetitions (A)
        movwf     PDel2     ; 1 |
PLoop22  clrwdt              ; 1 clear watchdog
        decfsz    PDel2, 1  ; 1 + (1) is the time over? (A)
        goto      PLoop22    ; 2 no, loop
        decfsz    PDel1,  1 ; 1 + (1) is the time over? (B)
        goto      PLoop12    ; 2 no, loop
        decfsz    PDel0,  1 ; 1 + (1) is the time over? (C)
        goto      PLoop02    ; 2 no, loop
PDelL12  goto PDelL22         ; 2 cycles delay
PDelL22  clrwdt              ; 1 cycle delay
        return              ; 2+2 Done			
;-------------------------------------------------------------
RETARDO_5S
PDelay5  movlw     .165      ; 1 set number of repetitions (C)
        movwf     PDel0     ; 1 |
PLoop05  movlw     .41       ; 1 set number of repetitions (B)
        movwf     PDel1     ; 1 |
PLoop15  movlw     .147      ; 1 set number of repetitions (A)
        movwf     PDel2     ; 1 |
PLoop25  clrwdt              ; 1 clear watchdog
        clrwdt              ; 1 cycle delay
        decfsz    PDel2, 1  ; 1 + (1) is the time over? (A)
        goto      PLoop25    ; 2 no, loop
        decfsz    PDel1,  1 ; 1 + (1) is the time over? (B)
        goto      PLoop15    ; 2 no, loop
        decfsz    PDel0,  1 ; 1 + (1) is the time over? (C)
        goto      PLoop05    ; 2 no, loop
        return              ; 2+2 Done
;---------------------------------------------------------------
RETARDO_20S
PDelay20  movlw     .71       ; 1 set number of repetitions (C)
        movwf     PDel0     ; 1 |
PLoop0  movlw     .254      ; 1 set number of repetitions (B)
        movwf     PDel1     ; 1 |
PLoop1  movlw     .221      ; 1 set number of repetitions (A)
        movwf     PDel2     ; 1 |
PLoop2  clrwdt              ; 1 clear watchdog
        clrwdt              ; 1 cycle delay
        decfsz    PDel2, 1  ; 1 + (1) is the time over? (A)
        goto      PLoop2    ; 2 no, loop
        decfsz    PDel1,  1 ; 1 + (1) is the time over? (B)
        goto      PLoop1    ; 2 no, loop
        decfsz    PDel0,  1 ; 1 + (1) is the time over? (C)
        goto      PLoop0    ; 2 no, loop
PDelL120  goto PDelL2         ; 2 cycles delay
PDelL2  goto PDelL3         ; 2 cycles delay
PDelL3  clrwdt              ; 1 cycle delay
        return              ; 2+2 Done

;**************************************************************************
;
; CLOCK.ASM
;
; Displays time on a single 7-segment display.  The timing source
; can be an NTSC colour burst crystal (3.579454 MHz) or a 4 MHz
; crystal.
;
; A common anode 7-segment LED display is attached as follows:
;
;    RA0 segment a
;    RA1 segment b
;    RA2 segment c
;    RA3 segment d
;    RA4 segment e
;    RB4 segment f
;    RB5 segment g
;
; Each segment is connected via a 470 ohm resistor.  The common anode
; is connected directly to VDD.  The strange allocation of port bits
; to segments allows RB6 and RB7 to be dedicated to in-circuit serial 
; programming.
;
; The time is displayed digit by digit over a four second period
; every 15 seconds and the display is blank otherwise.  Four LEDs are 
; connected from RB3-RB0 to GND via 470 ohm resistors; these are used
; to indicate the significance of the displayed digit: 10s of hours - 
; hours - 10s of minutes - minutes.
;
; A normally open switch is connected from RB7 to GND via a 470 ohm 
; resistor; no pull-up resistor is needed as an internal weak pull-up 
; is enabled by the program.  To set the clock press the switch when
; the appropriate digit is displayed; the digit can then be incremented 
; by pressing the switch repeatedly.  If the switch is open for about 
; 2 seconds the clock display is restarted allowing another digit to be 
; changed.  It is up to the user to put in sensible times as no checking 
; is done by the program.
;
; To permit the PIC to be programmed in-circuit the /MCLR pin is
; connected to VDD via a 1k resistor in series with a signal diode 
; (e.g. 1N4148) with anode connected to VDD.  
;
;
; Copyright (C) 1998 David Tait (david.tait@man.ac.uk)
;
;**************************************************************************


	LIST            P=16F84 ; no need to change this for the 16C84
	ERRORLEVEL      -302    ; suppress bank selection messages
	__CONFIG        3FF9H   ; XT oscillator (and PWRTE if 16C84)

;#DEFINE _3_58MHZ                ; choose clock speed
#DEFINE _4_00MHZ

PCL     EQU     2               ; registers are defined here to make this
STATUS  EQU     3               ; program self contained.
PORTA   EQU     5
PORTB   EQU     6
INTCON  EQU     0BH
TRISA   EQU     85H
TRISB   EQU     86H
OPTREG  EQU     81H

C       EQU     0               ; bits in STATUS
Z       EQU     2
RP0     EQU     5

T0IF    EQU     2               ; bit in INTCON


;#IFDEF  _3_58MHZ                ; number of ticks per second for 3.58 MHz:
;TCK0    EQU     .109            ; nominal
;TCK1    EQU     .111            ; every 10 secs
;TCK2    EQU     .113            ; every min
;TCK3    EQU     .115            ; every 10 mins
;TCK4    EQU     .114            ; every hour
;TCK5    EQU     .110            ; every 10 hours
;TCK6    EQU     .111            ; every 24 hours
;#ENDIF

#IFDEF  _4_00MHZ                ; as above but for 4 MHz
TCK0    EQU     .122
TCK1    EQU     .123
TCK2    EQU     .121
TCK3    EQU     .123
TCK4    EQU     .124
TCK5    EQU     .125
TCK6    EQU     .125
#ENDIF

	CBLOCK  0CH             ; define variables required

	TICKS                   ; decremented every tick (9.15 ms or 8.19 ms)
	SEGS                    ; one bit per segment: "-gfedcba"
	SEC
	SEC10
	MIN
	MIN10
	HOUR
	HOUR10
	FRAME                   ; used to decide when to display time
	HHMM                    ; one bit per digit displayed
	COUNT                   ; scratch register
	DIGIT                   ; last digit displayed

	ENDC


	;*********************************;
	;         Initialisation          ;
	;*********************************;

	ORG     0

INIT    CLRF    SEC
	CLRF    SEC10
	CLRF    MIN
	CLRF    MIN10
	CLRF    HOUR
	CLRF    HOUR10
	CLRF    FRAME
	CLRF    PORTA
	CLRF    PORTB
	BSF     STATUS,RP0      ; select register bank 1
	CLRF    TRISA
	MOVLW   80H
	MOVWF   TRISB           ; only RB7 is an input
	MOVLW   4
	MOVWF   OPTREG          ; assign prescaler (1:32) to TMR0
	BCF     STATUS,RP0      ; reselect bank 0


	;*********************************;
	;          Main Program           ;
	;*********************************;

MAIN    CALL    CLOCK           ; real-time clock algo called every second
	CALL    SHOW            ; display the time
WAIT    BTFSS   INTCON,T0IF     ; wait for TMR0 to roll over
	 GOTO    WAIT
	CLRF    INTCON
	CALL    CHKSW           ; check for button press
	DECFSZ  TICKS,F
	 GOTO    WAIT
	GOTO    MAIN            ; get here every second


	;*********************************;
	;  Convert digit to segment form  ;
	;*********************************;

SEGTAB  ANDLW   0FH 
	ADDWF   PCL,F
	DT      40,79,24,30,19,12,02,78,00,10
	DT      7F,7F,7F,7F,7F,7F


	;*********************************;
	;  Real-time clock algorithm      ;
	;*********************************;

CLOCK   MOVLW   TCK0            ; increment digits as appropriate
	MOVWF   TICKS           ; and define number of ticks per
	INCF    SEC,F           ; second for next second
	MOVF    SEC,W
	SUBLW   9
	BTFSC   STATUS,C
	 RETURN

	MOVLW   TCK1
	MOVWF   TICKS
	CLRF    SEC
	INCF    SEC10,F
	MOVF    SEC10,W
	SUBLW   5
	BTFSC   STATUS,C
	 RETURN

	MOVLW   TCK2
	MOVWF   TICKS
	CLRF    SEC10
	INCF    MIN,F
	MOVF    MIN,W
	SUBLW   9
	BTFSC   STATUS,C
	 RETURN

	MOVLW   TCK3
	MOVWF   TICKS
	CLRF    MIN
	INCF    MIN10,F
	MOVF    MIN10,W
	SUBLW   5
	BTFSC   STATUS,C
	 RETURN

	MOVLW   TCK4
	MOVWF   TICKS
	CLRF    MIN10
	MOVF    HOUR10,W
	SUBLW   1
	BTFSC   STATUS,C
	 GOTO   INCHR
	INCF    HOUR,F
	MOVF    HOUR,W
	SUBLW   3
	BTFSC   STATUS,C
	  RETURN

	MOVLW   TCK6
	MOVWF   TICKS
	CLRF    HOUR
	CLRF    HOUR10
	RETURN

INCHR   INCF    HOUR,F
	MOVF    HOUR,W
	SUBLW   9
	BTFSC   STATUS,C
	 RETURN

	MOVLW   TCK5
	MOVWF   TICKS
	CLRF    HOUR
	INCF    HOUR10,F
	RETURN


	;*********************************;
	; Displays the time digit by digit;
	;*********************************;

SHOW    CLRF    HHMM            
	INCF    FRAME,F         ; increment place in frame
	MOVF    FRAME,W
	SUBLW   D'14'
	BTFSS   STATUS,C
	 CLRF    FRAME
	MOVF    FRAME,W
	XORLW   1               
	BTFSC   STATUS,Z
	 GOTO    DHOUR10        ; display 10s of hours when frame is 1
	XORLW   1^2
	BTFSC   STATUS,Z
	 GOTO    DHOUR          ; display hour when frame is 2
	XORLW   2^3
	BTFSC   STATUS,Z
	 GOTO    DMIN10         ; display 10s of mins when frame is 3
	XORLW   3^4
	BTFSC   STATUS,Z
	 GOTO    DMIN           ; display mins when frame is 4 
	MOVLW   30              ; otherwise blank display
	MOVWF   PORTB
	MOVLW   1F
	MOVWF   PORTA
	RETURN

DHOUR10 BSF     HHMM,3
	MOVF    HOUR10,W
	GOTO    DISPLAY        

DHOUR   BSF     HHMM,2
	MOVF    HOUR,W
	GOTO    DISPLAY

DMIN10  BSF     HHMM,1
	MOVF    MIN10,W
	GOTO    DISPLAY

DMIN    BSF     HHMM,0
	MOVF    MIN,W           ; falls through to DISPLAY

	
	;*********************************;
	;       Displays digit in W       ;
	;*********************************;

DISPLAY MOVWF   DIGIT           ; save number to be displayed in DIGIT
	CALL    SEGTAB          ; convert to segment form
	MOVWF   SEGS            ; and store
	ANDLW   1FH             ; extract PORTA segments
	MOVWF   PORTA           ; and display
	RRF     SEGS,W
	ANDLW   30H             ; extract PORTB segments
	IORWF   HHMM,W
	MOVWF   PORTB           ; and display
	RETURN


	;*********************************;
	; Checks for a switch press and   ;
	; updates digit if displayed      ;
	;*********************************;

CHKSW   BTFSC   PORTB,7         ; switch closed?
	 RETURN                 ; no
	MOVF    HHMM,F
	BTFSC   STATUS,Z        ; digit displayed?
	 RETURN                 ; no

INCDIG  INCF    DIGIT,F         ; DIGIT is the currently displayed number
	MOVF    DIGIT,W
	SUBLW   9
	BTFSS   STATUS,C
	 CLRF    DIGIT
	MOVF    DIGIT,W
	CALL    DISPLAY
	CALL    DELAY           ; wait for switch to settle
CHKSW0  BTFSS   PORTB,7         ; switch open?
	 GOTO    CHKSW0         ; no
	CALL    DELAY
	BTFSS   PORTB,7         ; still open?
	 GOTO    CHKSW0         ; no
	MOVLW   D'20'
	MOVWF   COUNT
CHKSW1  BTFSS   PORTB,7         ; switch open?
	 GOTO    INCDIG         ; no
	CALL    DELAY
	DECFSZ  COUNT,F
	 GOTO    CHKSW1
	MOVF    DIGIT,W         ; switch was open for around 2 secs
	CLRF    FRAME  
	CLRF    SEC10
	CLRF    SEC
	BTFSC   HHMM,3          ; update correct digit
	 MOVWF  HOUR10
	BTFSC   HHMM,2
	 MOVWF  HOUR
	BTFSC   HHMM,1
	 MOVWF  MIN10
	BTFSC   HHMM,0
	 MOVWF   MIN
	GOTO    MAIN            ; restart the program


	;*********************************;
	; Delay used by switch routine    ;
	;*********************************;

DELAY   MOVLW   D'12'           ; roughly 100ms delay
	MOVWF   TICKS
DEL1    BTFSS   INTCON,T0IF     ; wait for TMR0 to roll over
	 GOTO    DEL1
	CLRF    INTCON
	DECFSZ  TICKS,F
	 GOTO    DEL1
	RETURN

	END


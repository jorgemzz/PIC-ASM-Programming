LIST P=16F84A
INCLUDE "P16F84A.INC"

PRIMERO EQU 0X0C
INDICADOR EQU 0X0D
RESET ORG 0X00

GOTO INICIO
org 0x05
INICIO	BSF		STATUS,RP0
CLRF TRISB
BCF STATUS,RP0
CLRF INDICADOR	
clrf PORTB
bsf PORTB,0
movlw .5
MOVWF PRIMERO
uno
decfsz PRIMERO,1
goto uno

end
;PROBANDO QUE HACE EL PIC SI NO HAY UN BUCLE CERRADO Y SE ENCUENTRA CON EL END
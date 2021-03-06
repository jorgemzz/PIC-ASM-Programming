#define ENABLE       bsf PORTA,2        ;Activa E
#define DISABLE      bcf PORTA,2        ;Desactiva
#define LEER         bsf PORTA,1        ;Pone LCD en Modo RD
#define ESCRIBIR     bcf PORTA,1        ;Pone LCD en Modo WR
#define OFF_COMANDO  bcf PORTA,0        ;Desactiva RS (modo comando)
#define ON_COMANDO   bsf PORTA,0        ;Activa RS

	CBLOCK	Lcd_var	;Inicio de las variables. Ser� la primera						
			Lcd_Temp_1	;direcci�n libre disponible
			Lcd_Temp_2
	ENDC											

;********************************************************************** 
; Rutina de configuraci�n del PIC para el LCD.

UP_LCD          bsf     STATUS,RP0      ;Banco 1
                clrf    PORTB           ;RB <0-7> salidas digitales
                clrf	PORTA           ;RA <0-7> salidas digitales
                bcf     STATUS,RP0      ;Banco 0
                OFF_COMANDO             ;RS=0
                DISABLE                 ;E=0
                Return

;********************************************************************** 
 ;Rutina para lectura del Flag Busy y la direcci�n.

LCD_BUSY        LEER                    ;Pone el LCD en Modo RD
                bsf     STATUS,RP0           
                movlw   H'FF'
                movwf   PORTB           ;Puerta B como entrada
                bcf     STATUS,RP0      ;Selecciona el banco 0
                ENABLE                  ;Activa el LCD
                nop
                btfsc   PORTB,7         ;Chequea bit de Busy
                goto    $-1
                DISABLE                 ;Desactiva LCD
                bsf     STATUS,RP0                               
                clrf    PORTB           ;Puerta B salida
                bcf     STATUS,RP0                              
                ESCRIBIR                ;Pone LCD en modo WR
                return

;**********************************************************************
 ;Esta rutina efect�a un pulso de Enable

LCD_E           ENABLE                  ;Activa E
                nop
                DISABLE                 ;Desactiva E
                return

;Rutina para escritura de datos en DDRAM o CGRAM.El dato es tomado de W

LCD_DATO        OFF_COMANDO             ;Desactiva RS (modo comando)
                movwf   PORTB           ;Valor ASCII a sacar por portb
                call    LCD_BUSY        ;Espera a que se libere el LCD
                ON_COMANDO              ;Activa RS (modo dato).
                goto    LCD_E           ;Genera pulso de E

;********************************************************************** 
 ;Esta rutina efect�a la escritura de un comando en el LCD. El c�digo del comando es toma de W.

LCD_REG         OFF_COMANDO             ;Desactiva RS (modo comando)
                movwf   PORTB           ;C�digo de comando.
                call    LCD_BUSY        ;LCD libre?.
                goto    LCD_E           ;SI. Genera pulso de E.

;**********************************************************************
 ;Rutina para la inicializaci�n del LCD 

LCD_INI			movlw	b'00111000'
				call	LCD_REG		;C�digo de instrucci�n
				call	LCD_DELAY		;Temporiza
				movlw	b'00111000'
				call	LCD_REG		;C�digo de instrucci�n
				call	LCD_DELAY		;Temporiza
				movlw	b'00111000'
				call	LCD_REG		;C�digo de instrucci�n
				call	LCD_DELAY		;Temporiza

;**********************************************************************
 ;Rutina de temporizaci�n de unos 5mS

LCD_DELAY:		clrwdt
                movlw	.10
                movwf	Lcd_Temp_1
                clrf	Lcd_Temp_2
LCD_DELAY_1:	decfsz	Lcd_Temp_2,F
			goto	LCD_DELAY_1
			decfsz	Lcd_Temp_1,F
                  goto	LCD_DELAY_1
			return

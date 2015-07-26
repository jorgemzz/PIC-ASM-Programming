;==================== Encabezado ====================

		LIST	P=16F84A
		INCLUDE	"P16F84A.INC"

;================= Mapa de Memoria ===================

	Digito	EQU	0X0C
	DATO_A 	EQU	0X0D
	DATO_B 	EQU	0X0E		
 	RA	EQU	PORTA
	RB	EQU	PORTB

;<<<<<<----------------- INICIO PROGRAMA PRINCIPAL ------------------->>>>>>>

INICIO      CLRF         Digito             ;Pone a 0 la variable digito 
               CALL         LCD_PORT    ;Puertos en modo LCD 
               BCF           RA,0              ;Desactiva RS del modulo LCD
               BCF           RA,2              ;Desactiva E del modulo LCD 
START    CALL        LCD_INI          ;Inicia LCD (CFG puertos...) 
               MOVLW    b'00000001'   ;Borrar LCD y Home 
               CALL        LCD_REG 
               MOVLW    b'00000110'  
               CALL        LCD_REG 
               MOVLW    b'00001100'   ;LCD On, cursor Off,Parpadeo Off 
               CALL        LCD_REG 
               MOVLW   0x80               ;Direccion caracter
               CALL        LCD_REG 

REPETIR  MOVF      Digito,w          ;W=Digito
               CALL       DATO_1          ;Coge el caracter 
               IORLW     0                      ;Compara 
               BTFSC     STATUS,2       ;Es el ultimo? 
               GOTO      acabar            ;Si 
               CALL       LCD_DATOS   ;Visualiza caracter 
               INCF        Digito,f             ;Incrementa numero de Digito
               GOTO     REPETIR           ;Vuelve a escribir

acabar   nop
              goto        acabar              ;Buclee infinito


;<<<<<<---------------------- TABLA DE DATOS ------------------------->>>>>>> 

DATO_1          ADDWF   PCL,1                  
                RETLW   'H'             
                RETLW   'O'
                RETLW   'L'           
                RETLW   'A'           
                RETLW   '_'           
                RETLW   'L'           
                RETLW   'O'           
                RETLW   'B'           
                RETLW   'O'           
                RETLW   '_' 
                RETLW   'F'           
                RETLW   'E'           
                RETLW   'R'           
                RETLW   'O'           
                RETLW   'Z'     
          		RETLW   ':'

                RETLW 	0x00           
 
		INCLUDE		"LCD.LIB"

	END



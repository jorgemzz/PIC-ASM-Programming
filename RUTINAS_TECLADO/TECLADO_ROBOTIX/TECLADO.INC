;  - TECLADO.LIB -        \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\  
;                                          www.x-robotics.com
; Descipcion:             \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
; Esta libreria realiza un escaneo en un teclado matricial de 4x4 teclas,  
; el escaneo lo realiza poniendo un cero logico en las filas correspondientes
; y verificando las columnas para encontrar la interseccion provocada por   
; el accionamiento de una tecla y asi saber la fila y columna de la tecla.  
; ESTA SUBRUTINA CONVIERTE LA TECLA PULSADA EN SU EQUIVALENTE ASCII
;       para ser usada con el display LCD.
;                                         
; Se tienen que inicializar las siguientes variables en el programa que
; use esta libreria:
;                       - ( Tecla )  ;Devuelve la tecla pulsada
;****************************************** http://www.x-robotics.com *******
                  
KB_Port                        ;Inicializa la puerta B para las entradas del
                               ;teclado. Programa RB0-3 como salidas y RB4-7
                               ;entradas con las resistencias de polarizacion
                               ;habilitadas.           
                BSF     STATUS,RP0      ;Selecciona P gina 1:banco 1             
                MOVLW   0F0h            ;PB4-7 como entradas  
                MOVWF   TRISB           ;y PB0-3 como salidas
                BCF     OPTION_REG,NOT_RBPU     ;Habilita R de polarizacion en entradas
                BCF     STATUS,RP0      ;Vuelve a la p gina 0.
                RETURN                  ;Retorna.
                                        
KB_Scan                                 ;Escanea el teclado
                CLRF    Tecla           ;Borra Tecla y
                INCF    Tecla,f         ;prepara Tecla para primer c¢digo.
                MOVLW   0Eh             ;Saca 0 a la primera fila
                MOVWF   PORTB           ;de la Puerta B
                NOP                     ;Nada para estabilizaci¢n de señal.  
Cheq_Col        BTFSS   PORTB,4         ;Primera columna = 0        
                GOTO    antirebotes     ;Sale si se ha pulsado tecla.
                INCF    Tecla,f         ;Si no tecla pulsada, incrementa tecla.
                BTFSS   PORTB,5         ;Segunda columna = 0
                GOTO    antirebotes     ;Sale si se ha pulsado tecla.
                INCF    Tecla,f         ;Si no tecla pulsada, incrementa tecla.
                BTFSS   PORTB,6         ;Tercera columna = 0
                GOTO    antirebotes     ;Sale si se ha pulsado tecla.
                INCF    Tecla,f         ;Si no tecla pulsada, incrementa tecla.
                BTFSS   PORTB,7         ;Cuarta columna = 0
                GOTO    antirebotes     ;Sale si se ha pulsado tecla.
                INCF    Tecla,f         ;Si no tecla pulsada,incrementa Tecla.
                                        
Ultima_Tecla    MOVLW   d'17'           ;Carga W con el n£mero de Teclas + 1.
                SUBWF   Tecla,w         ;y lo compara con el valor actual de Tecla.
                BTFSC   STATUS,Z        ;Si Tecla + 1 = valor actual.
                GOTO    NTeclas         ;No ha sido pulsada ninguna tecla.
                BSF     STATUS,C        ;Pone a 1 Bit C.    
                RLF     PORTB,f     ;as¡ la Fila 1 pasa a 1 con la rotaci¢n a izqda.
                GOTO    Cheq_Col                                             
                                                            
NTeclas         CLRF    Tecla           ;Coloca variable Tecla a 0
                RETURN                  ;y regresa.         
                                                            
antirebotes	;ahora se espera a que la tecla sea soltada para evitar rebotes
		;y reactivaciones de tecla
		;esta parte puede ser eliminada si para nuestro proyecto no es necesaria
      		;o es un inconveniente.

Espera1         BTFSS   PORTB,4         ;Si no se suelta la tecla FILA 1
                GOTO    Espera1         ;vuelve a esperar. 
Espera2         BTFSS   PORTB,5         ;Si no se suelta la tecla FILA 2
                GOTO    Espera2         ;vuelve a esperar.
Espera3         BTFSS   PORTB,6         ;Si no se suelta la tecla FILA 3
                GOTO    Espera3         ;vuelve a esperar.              
Espera4         BTFSS   PORTB,7         ;Si no se suelta la tecla FILA 4
                GOTO    Espera4         ;vuelve a esperar.          
                
                MOVF    Tecla,w		;pone en w el numero contenido en la variable
                CALL    T_Conv          ;llama a la tabla de conversion y retorna
                MOVWF   Tecla  		;con el valor en hexadecimal y lo pone en la variable.
                RETURN       		;vuelve al programa principal que hizo la llamada.
                 
                             
T_Conv          ADDWF   PCL,1
				RETLW   .0
                RETLW   .15             ;Tecla nº0 = 0
                RETLW   .1             ;Tecla nº1 = 1
                RETLW   .2             ;Tecla nº2 = 4
                RETLW   .3             ;Tecla nº3 = 7 
                RETLW   .4             ;Tecla nº4 = A                       
                RETLW   .5             ;Tecla nº5 = 2 
                RETLW   .6             ;Tecla nº6 = 5 
                RETLW   .7             ;Tecla nº7 = 8 
                RETLW   .8             ;Tecla nº8 = 0 
                RETLW   .9             ;Tecla nº9 = 3 
                RETLW   .10             ;Tecla nº10 = 6
                RETLW   .11             ;Tecla nº11 = 9
                RETLW   .12             ;Tecla nº12 = B
                RETLW   .13             ;Tecla nº13 = F
                RETLW   .14             ;Tecla nº14 = E
                RETLW   .15             ;Tecla nº15 = D

                                 
                                 
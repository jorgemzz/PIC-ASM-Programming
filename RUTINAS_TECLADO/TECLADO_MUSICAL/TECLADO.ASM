TECLADO.ASM
 
 
;Conjunto de rutinas para el manejo del teclado.
;No es un programa en s¡ mismo. Para utilizarlo hay que 
;colocar en el programa principal: 
;KEY_VAR EQU dir_inicio_del_bloque
 
;BLOQUE DE ETIQUETAS
 
 
	CBLOCK	 KEY_VAR 		;Inicio de las variables
		 TECLA			;Retorno del c¢digo de tecla
		 KEY_1			;N§ de filas a explorar
		 KEY_2 	 		;Temporal de c¢digo
	 	 KEY_DELAY_1		;Variable de temporizaci¢n
		 KEY_DELAY_2		;Variable de temporizaci¢n
	ENDC			
 
 
;RUTINA KEY_SCAN: Rutina de exploraci¢n del teclado. La variable 
;"Tecla" retorna con el c¢digo de la tecla pulsada o el c¢digo 0x80
;si no se pulsa ninguna.
 
 
KEY_SCAN	bsf 	STATUS,RP0		;Selecciona p gina 1
		movlw	b'00001111'
		movwf	TRISB			;RB7-RB4 salidas, RB3-RB0 entradas
		bcf 	OPTION_REG,NOT_RBPU	;Activa cargas pull-up	(otro error)
		bcf 	STATUS,RP0		;Selecciona p gina 0
		movlw	4
		movwf	KEY_1			;N§ de columnas a explorar
		movlw	b'01111111'
		movwf	TECLA			;Columna a activar
KEY_SCAN_1	movf 	TECLA,W
		movwf	PORTB			;Activa fila
		nop
		movf	PORTB,W
		movwf	KEY_2
		subwf	TECLA,W			;Lee las columnas
		btfss 	STATUS,Z 		;Hay alguna pulsada ?
		goto	KEY_SCAN_2		;Si hay alguna pulsada
		bsf 	STATUS,C 		;No hay ninguna en esa fila
		rrf 	TECLA,F			;Selecciona siguiente fila
		decfsz 	KEY_1,F			;Salta si se han terminado las filas
		goto	KEY_SCAN_1
		movlw	0x80
		goto	VOLVER			;Retorna c¢digo 0x80 (no hay pulsaci¢n)
		
KEY_SCAN_2	movlw	.100			;Bucle de temporizaci¢n de unos 20 ms
		movwf	KEY_DELAY_1		;para evitar el rebote de los pulsadores
KEY_SCAN_3	clrf	KEY_DELAY_2		
		clrwdt
KEY_SCAN_4	decfsz 	KEY_DELAY_2,F
		goto 	KEY_SCAN_4
		decfsz 	KEY_DELAY_1,F
		goto	KEY_SCAN_3
		movf	TECLA,W			;Tras la temporizaci¢n se lee nuevamente
		movwf	PORTB			;si la tecla es la misma. As¡ se
		nop				;evitan los rebotes.
		movf	PORTB,W
		subwf	KEY_2,W
		btfss	STATUS,Z		;Es la misma ??
		goto	KEY_SCAN_1		;No, seguir con la exploraci¢n
		movf	KEY_2,W	  		;S¡, guardar en variable de salida TECLA el valor 
						; recogido
VOLVER          movwf   TECLA
		return				;Fin de exploraci¢n								
 
;RUTINA KEY_HEX:	Convierte el c¢digo de tecla que haya en la variable
;"Tecla" a Hex. (0-F). El resultado se devuelve en la variable "Tecla". 
;Usa como rutina auxiliar Key_tabla
 
KEY_TABLA	movf	KEY_1,W
		addwf	PCL,F		;Calcula desplazamiento
		retlw	0x7D		;0
		retlw	0xEE		;1
		retlw	0xED		;2
		retlw	0xEB		;3
		retlw	0xDE		;4
		retlw	0xDD		;5
		retlw	0xDB		;6
		retlw	0xBE		;7
		retlw	0xBD		;8
		retlw	0xBB		;9
		retlw	0x7E		;A
		retlw	0x7B		;B
		retlw	0x77		;C
		retlw	0xB7		;D
		retlw	0xD7		;E
		retlw	0xE7		;F

KEY_HEX		movf	TECLA,W
		movwf	KEY_2		;Almacena el c¢digo temporalmente
		clrf 	KEY_1		;Contador HEX a 0
KEY_HEX_2	call	KEY_TABLA	;Busca c¢digo en la tabla
		subwf 	KEY_2,W		;Compara con el de la tecla
		btfsc 	STATUS,Z	;Coincide ?
		goto 	KEY_HEX_1	;S¡
		incf 	KEY_1,F		;No, incrementa contador HEX
		goto	KEY_HEX_2
KEY_HEX_1	movf	KEY_1,W
		movwf	TECLA		;Carga contador HEX en la variable de salida
		return
 
 
 
 
;RUTINA HEX_7SEG:	Rutina de conversi¢n de HEX (0-F) a 7 segmentos. 
;El acumulador W contiene, durante la llamada, el c¢digo HEX y, al retornar,
;el correspondiente a 7 segmentos
 
 
HEX_7SEG	andlw	 b'00001111'
		addwf	 PCL,F		;Desplazamiento sobre la tabla
		retlw	 b'00111111'	;0
		retlw	 b'00000110'	;1
		retlw	 b'01011011'	;2
		retlw	 b'01001111'	;3
		retlw	 b'01100110'	;4
		retlw	 b'01101101'	;5
		retlw	 b'01111101'	;6
		retlw	 b'00000111'	;7
		retlw	 b'01111111'	;8
		retlw	 b'01100111'	;9
		retlw	 b'01110111'	;A
		retlw	 b'01111100'	;B
		retlw	 b'00111001'	;C
		retlw	 b'01011110'	;D
		retlw	 b'01111001'	;E
		retlw	 b'01110001'	;F

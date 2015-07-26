;LCD_CXX.ASM
 
 
;El conjunto de rutinas que se presentan a continuaci¢n permiten realizar
;las tareas b sicas de control del m¢dulo de visualizaci¢n LCD. Se emplean
;con los PIC 16cxx. En el programa principal se deber  reservar memoria
;para el bloque de variables que utiliza el LCD del modo:
;	LCD_VAR EQU dir_inicio_del_bloque

;BLOQUE DE ETIQUETAS
 
 
	#define ENABLE 		bsf PORTA,2 ;Activa E
	#define DISABLE 	bcf PORTA,2 ;Desactiva
	#define LEER 		bsf PORTA,1 ;Pone LCD en Modo RD
	#define ESCRIBIR 	bcf PORTA,1 ;Pone LCD en Modo WR
	#define OFF_COMANDO 	bcf PORTA,0 ;Desactiva RS (modo comando)
	#define ON_COMANDO 	bsf PORTA,0 ;Activa RS (modo datos)
	CBLOCK 	LCD_VAR
		LCD_TEMP_2	;Inicio de las variables. Ser  la primera direcci¢n libre
				; disponible 
		LCD_TEMP_1	
	ENDC		
 
 
;RUTINA UP_LCD: Con esta rutina se configura el PIC para que trabaje con el LCD.
 
 
UP_LCD		bsf	STATUS,RP0 	;Banco 1
	 	clrf 	PORTB 		;RB <0-7> salidas digitales
		clrf 	PORTA 		;RA <0-4> salidas digitales
	 	bcf 	STATUS,RP0 	;Banco 0
		OFF_COMANDO 		;RS=0
		DISABLE 		;E=0
		return
 
 
;RUTINA LCD_BUSY: Con esta rutina se chequea el estado del 
;flag BUSY del m¢dulo LCD, que indica, cuando est  activado, que el
;m¢dulo a£n no ha terminado el comando anterior. La rutina espera a
;que se complete cualquier comando anterior antes de retornar al
;programa principal, para poder enviar un nuevo comando.
 
 
LCD_BUSY	LEER 			;Pone el LCD en Modo RD
		bsf 	STATUS,RP0 
		movlw 	H'FF'
		movwf 	PORTB 		;Puerta B como entrada
		bcf 	STATUS,RP0 	;Selecciona el banco 0
		ENABLE 			;Activa el LCD
		nop
L_BUSY 		btfsc 	PORTB,7		;Chequea bit de Busy
		goto 	L_BUSY
		DISABLE 	 	;Desactiva LCD
		bsf 	STATUS,RP0 
		clrf 	PORTB 		;Puerta B salida
		bcf 	STATUS,RP0 
		ESCRIBIR		;Pone LCD en modo WR(ERROR CORREGIDO ANTES SOLO DECIA ESCRIB)
		return
 
 
;RUTINA LCD_E: Se trata de una peque¤a rutina que se encarga de generar
;un impulso de 1æ s (para una frecuencia de funcionamiento de 4 Mhz)
;por la patita de salida de la Puerta A RA2, que se halla conectada
;a la se¤al E (Enable) del m¢dulo LCD. Con esta rutina se pretende activar
;al m¢dulo LCD.
 
 
LCD_E 		ENABLE			;Activa E
		nop
		DISABLE			;Desactiva E
		return
 
 
;RUTINA LCD_DATO: Es una rutina que pasa el contenido cargado en el
;registro W, el cual contiene un car cter ASCII, a la PUERTA B, para 
;visualizarlo por el LCD o escribirlo en la CGRAM.
 
 
LCD_DATO 	OFF_COMANDO 		;Desactiva RS (modo comando)
		movwf	PORTB 		;Valor ASCII a sacar por PORTB
		call 	LCD_BUSY 	;Espera a que se libere el LCD
		ON_COMANDO 		;Activa RS (modo dato)
		call 	LCD_E 		;Genera pulso de E
 		return
 
 
;RUTINA LCD_REG: Rutina parecida a la anterior, pero el contenido de W
;ahora es el c¢digo de un comando para el LCD, que es necesario pasar
;tambi‚n a la PUERTA B para su ejecuci¢n.
 
 
LCD_REG 	OFF_COMANDO 		;Desactiva RS (modo comando)
		movwf 	PORTB 		;C¢digo de comando
		call 	LCD_BUSY 	;LCD libre?.
		call 	LCD_E 		;S¡. Genera pulso de E.
 		return
 
 
;RUTINA LCD_INI: Esta rutina se encarga de realizar la secuencia de 
;inicializaci¢n del m¢dulo LCD de acuerdo con los tiempos dados por 
;el fabricante (15 ms). Se especifican los valores de DL, N y F,
;as¡ como la configuraci¢n de un interfaz de 8 l¡neas con el bus
;de datos del PIC, y 2 l¡neas de 16 caracteres de 5 x 7 pixels. 
 
 
LCD_INI	movlw	b'00111000'
		call	LCD_REG 	;C¢digo de instrucci¢n
		call	LCD_DELAY	;Temporiza
		movlw	b'00111000'
		call	LCD_REG		;C¢digo de instrucci¢n
		call	LCD_DELAY	;Temporiza
		movlw 	b'00111000'
		call	LCD_REG		;C¢digo de instrucci¢n
		call 	LCD_DELAY	;Temporiza
		return
 
 
;RUTINA BORRA_Y_HOME: Borra el display y retorna el cursor a la posici¢n 0. 
 
 
BORRA_Y_HOME	movlw 	b'00000001' 	;Borra LCD y Home.
		call 	LCD_REG
		return
 
 
;RUTINA DISPLAY_ON_CUR_OFF: Control del display y cursor.
;Activa el display y desactiva es cursor
 
DISPLAY_ON_CUR_OFF	movlw b'00001100' 	;LCD on, cursor off.
			call 	LCD_REG
			return
 
 
;RUTINA LCD_DELAY: Se trata de un rutina que implementa un retardo 
;o temporizaci¢n de 5 ms. Utiliza dos variables llamadas LCD_TEMP_1 
;y LCD_TEMP_2, que se van decrementando hasta alcanzar dicho tiempo.
 
 
LCD_DELAY	clrwdt
		movlw 	10
		movwf 	LCD_TEMP_1
		clrf 	LCD_TEMP_2
LCD_DELAY_1 	decfsz	LCD_TEMP_2,F
		goto	LCD_DELAY_1
		decfsz	LCD_TEMP_1,F
		goto	LCD_DELAY_1
		return
	

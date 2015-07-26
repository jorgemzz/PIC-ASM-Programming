;---------------------ENCABEZADO--------------

	LIST		P=16F84A
	INCLUDE		"P16F84A.INC"

;------------VARIABLES A UTILIZAR-----------

	CBLOCK		0X0D
		
		RET1
		RET2			;REGIDTROS PARA RETARDOS
		ROTA			;REGISTRO PARA ROTACION(CAMBIO DE DISPLAY)
		DISP1			;PRIMER DATO A MOSTRAR
		DISP2			;SEGUNDO DATO A MOSTRAR
		DISP3			;TERCER	DATO A MOSTRAR
		DISP4			;CUARTO DATO A MOSTRAR
		DISP5			;UN DATO MAS EN LA TABLA
		DISP6			;UN DATO MAS EN LA TABLA
		DISP7			;UN DATO MAS EN LA TABLA
		DISP8			;UN DATO MAS EN LA TABLA
		DISP9			;UN DATO MAS EN LA TABLA
		DISP10			;UN DATO MAS EN LA TABLA
		DISP11			;UN DATO MAS EN LA TABLA
		DISP12			;UN DATO MAS EN LA TABLA
		TIEMPO_1
		TIEMPO_2
		DESPLAZA		;PARA DESPLAZAR LOS DIGITOS
		

	ENDC

;---------CONFIGURACION DE PUERTOS---------

RESET	ORG		0X00
		GOTO	INICIO
		ORG		0X05

INICIO	BSF		STATUS,RP0		;CONFIGURANDO PUERTOS
		CLRF	TRISA			;PORTA ES SALIDA
		CLRF	TRISB			;PORTB ES SALIDA
		BCF		STATUS,RP0

;--------CARGA DE REGISTROS A MOSTRAR-------

		MOVLW	0X01
		MOVWF	DISP1
		MOVLW	0X02
		MOVWF	DISP2
		MOVLW	0X03
		MOVWF	DISP3
		MOVLW	0X04
		MOVWF	DISP4
		MOVLW	0X05			;CARGO PARA VISUALIZAR UN DATO MAS
		MOVWF	DISP5			;EL QUINTO DATO
		MOVLW	0X06
		MOVWF	DISP6
		MOVLW	0X07
		MOVWF	DISP7
		MOVLW	0X08
		MOVWF	DISP8
		MOVLW	0X09
		MOVWF	DISP9
		MOVLW	0X0A
		MOVWF	DISP10
		MOVLW	0X0B
		MOVWF	DISP11
		MOVLW	0X0C
		MOVWF	DISP12

		CLRF	DESPLAZA		;INICIALIZA PARA VER DISP1
		BSF		DESPLAZA,0		;DESPLAZA='00000001'
		
		MOVLW	.180
		MOVWF	TIEMPO_1
	

;--------------APAGA TRANSISTORES------------
		
		CLRF	PORTA

;-------------PROGRAMA PRINCIPAL-------------

INI		MOVLW	0X08
		MOVWF	ROTA		;ROTA=00001000

		CALL	DISP??		;PARA DESPLAZAR DIGITOS
		MOVWF	FSR			;CARGA FSR CON LA DIRECCION DE DISPX 	

DISPLAY	MOVLW	0X00		;APAGO TODOS LOS DISPLAY
		MOVWF	PORTB		;PORTB=00000000

		MOVF	ROTA,W		;SELECCIONAMOS EL TRANSISTOR DEL DISPLAY DE  LA IZQUIERDA
		MOVWF	PORTA		;PORTA=00001000	

		MOVF	INDF,W		;LEE DATO AL QUE APUNTA FSR OSEA DISP1
		CALL	TABLA		;LLAMA A TABLA
		MOVWF	PORTB		;PASA EL DATO OBTENIDO A PORTB

		CALL	RETARDO		;LLA,A AL MINIRETARDO
		BTFSC	ROTA,0		;ROTA="00000001"...???	
		GOTO	INI			;SI ES SI SE VIO TODO, REINICIA	
		
		BCF		STATUS,C	;CARRY=0, PARA NO AFECTAR ROTACIONES
		RRF		ROTA,F		;ROTA DISPLAY
		INCF	FSR,F		;APUNTA AL SIGUIENTE DISP_X
		GOTO	DISPLAY

;----------------------RETARDO-------------------

RETARDO	MOVLW	0X03
		MOVWF	RET1
DOS		MOVLW	0X6E
		MOVWF	RET2
UNO		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		DECFSZ	RET2,F
		GOTO	UNO
		DECFSZ	RET1,F
		GOTO	DOS
		RETLW	0X00

;------------------------TABLA-------------------

TABLA	ADDWF	PCL,F		;SE INCREMENTA EL CONTADORE DE PROGRAMA
		;display . gfedcba segmentos de los leds del display
		NOP

		RETLW	B'10000000'	;PARA  EL QUINTO DATO(.)
		RETLW	B'10000000'	;PARA  EL SEXTO DATO(.)
		RETLW	B'10000000'	;PARA  EL SEPTIMO DATO(.)
		RETLW	B'10000000'	;PARA  EL OCTAVO DATO(.)

		RETLW 	B'00000110' ; c�digo para la l 
		RETLW 	B'01011100' ; c�digo para la o 
		RETLW 	B'01111100' ; c�digo para la b 
		RETLW 	B'01011100' ; c�digo para la o.
		
		RETLW	B'10000000'	;PARA  EL QUINTO DATO(.)
		RETLW	B'10000000'	;PARA  EL SEXTO DATO(.)
		RETLW	B'10000000'	;PARA  EL SEPTIMO DATO(.)
		RETLW	B'10000000'	;PARA  EL OCTAVO DATO(.)

;OBSERVACION:
;PARA QUE LAS LETRAS SE DESPLACEN	SELECCIONAMOS A PARTIR DE QUE
;DISPLAY SE LEE PARA CARGARLO AL FSR CON EL CODIGO
		;MOVLW	DISP1
		;MOVWF	FSR			;CARGA FSR CON LA DIRECCION DE DISP1 

;------------------DESPLAZANDO DIGITOS--------------
		;AQUI PONGO EL PROGRAMA PARA CAMBIAR DE DISP (DIGITO) OSEA
		;LA SECUENCIA PARA DESPLAZAR DIGITOS

DISP??	

CONT_1	INCFSZ	TIEMPO_1,F		
		GOTO	SEGUIR
		MOVLW	.180
		MOVWF	TIEMPO_1
		BCF		STATUS,C
		RLF		DESPLAZA,F			;PARA DESPLAZAR DIGITOS

SEGUIR	BTFSC	DESPLAZA,0
		RETLW	DISP1	
		BTFSC	DESPLAZA,1
		RETLW	DISP2
		BTFSC	DESPLAZA,2
		RETLW	DISP3
		BTFSC	DESPLAZA,3
		RETLW	DISP4	
		BTFSC	DESPLAZA,4
		RETLW	DISP5

		BTFSC	DESPLAZA,5
		RETLW	DISP6
		BTFSC	DESPLAZA,6
		RETLW	DISP7
		BTFSC	DESPLAZA,7
		RETLW	DISP8	
	
		CLRF	DESPLAZA		;REPITE TODO DE NUEVO
		BSF		DESPLAZA,0
		GOTO	DISP??

;-------------------------------------------------
	END
;-------------------------------------------------
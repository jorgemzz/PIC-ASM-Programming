;*******************************************************************************
;   CODIGO A NIVEL DE PIXEL con cristal a 4Mhz 
;   CON 5 X 7 DOTS (se pueden crear hasta 8 caracteres solamente)
;   EN ESTE EJEMPLO SE PRUEBA COMO GRABAR NUEVOS CARACTERES
;   EN LA CG-RAM-DATA DIRECCIONANDO CADA LINEA CON EL CG-RAM-ADDRESS
;*******************************************************************************
	List    p=16F84a        ;Tipo de procesador
	include "P16F84a.inc"   ;Definiciones de registros internos
;************************************************************************
	__CONFIG   _CP_OFF & _PWRTE_ON & _WDT_OFF & _XT_OSC
;************************************************************************
	cblock  0x0c
	Lcd_var
	contador
	endc
;************************************************************************
	org     0x00             ;Vector de Reset
	goto     inicio
;************************************************************************
	 org     0x05
caracter0_direccion:    
	addwf PCL, F
	dt 0x40,0x41,0x42,0x43,0x44,0x45,0x46,0x47;0x40 ME DIRECCIONA A LA POSICION 0 DE LA CG RAM
caracter0_datos:    
	addwf PCL, F
	dt b'10101',b'01010',b'10101',b'01010',b'10101',b'01010',b'10101',b'01010'
caracter1_direccion:    
	addwf PCL, F
	dt 0x48,0x49,0x4a,0x4b,0x4c,0x4d,0x4e,0x4f
caracter1_datos:    
	addwf PCL, F
	dt b'11111',b'10101',b'11011',b'11011',b'11011',b'11011',b'10101',b'11111'

caracter2_direccion:    
	addwf PCL, F
	dt 0x50,0x51,0x52,0x53,0x54,0x55,0x56,0x57
caracter2_datos:    
	addwf PCL, F
	dt b'11011',b'11011',b'10001',b'00000',b'00000',b'11011',b'10101',b'11111'
caracter3_direccion:    
	addwf PCL, F
	dt 0x58,0x59,0x5a,0x5b,0x5c,0x5d,0x5e,0x5f
caracter3_datos:    
	addwf PCL, F
	dt b'11111',b'10101',b'11011',b'10101',b'01110',b'10101',b'11011',b'11111'
caracter4_direccion:    
	addwf PCL, F
	dt 0x60,0x61,0x62,0x63,0x64,0x65,0x66,0x67
caracter4_datos:    
	addwf PCL, F
	dt b'11111',b'11111',b'00100',b'00100',b'10101',b'01010',b'00100',b'00100'
caracter5_direccion:    
	addwf PCL, F
	dt 0x68,0x69,0x6a,0x6b,0x6c,0x6d,0x6e,0x6f
caracter5_datos:    
	addwf PCL, F
	dt b'11111',b'11111',b'00100',b'00100',b'10101',b'01010',b'00100',b'0'
caracter6_direccion:    
	addwf PCL, F
	dt 0x70,0x71,0x72,0x73,0x74,0x75,0x76,0x77
caracter6_datos:    
	addwf PCL, F
	dt b'00000',b'00100',b'00010',b'11111',b'11111',b'00010',b'00100',b'0'
caracter7_direccion:    
	addwf PCL, F
	dt 0x78,0x79,0x7a,0x7b,0x7c,0x7d,0x7e,0x7f
caracter7_datos:    
	addwf PCL, F
	dt b'11011',b'11011',b'00000',b'11011',b'11011',b'00000',b'11011',b'11011'


;************************************************************************
	    #include "Lcd_cxx.inc"    ; Rutinas de control LCD.
;*************************************************************************
inicio:
	bsf     STATUS,RP0        ;Banco 1
	clrf    TRISB             ;Puerta B salida
	clrf    TRISA             ;Puerta A salida
	bcf     STATUS,RP0        ;Banco 0
	clrf    INTCON            ;Desactivar interrupciones.
	bcf     PORTA,0           ;RS=0
	bcf     PORTA,2           ;E=0 Desactiva LCD

	call    LCD_INI           ;Inicia el modulo LCD
	movlw   b'00001100'
	call    LCD_REG           ;LCD On y Cursor Off

	movlw    b'00000001'
	call    LCD_REG           ;Borra display
	clrf    contador
;************************************************************************
;   RUTINA PARA GRABAR LOS n NUEVOS CARACTERES EN LA CG RAM DATA
;************************************************************************
ciclo:
	movf contador, W
	Call caracter0_direccion
	Call LCD_REG
	movf contador, W
	Call caracter0_datos
	Call LCD_DATO

	movf contador, W
	Call caracter1_direccion
	Call LCD_REG
	movf contador, W
	Call caracter1_datos
	Call LCD_DATO

	movf contador, W
	Call caracter2_direccion
	Call LCD_REG
	movf contador, W
	Call caracter2_datos
	Call LCD_DATO

	movf contador, W
	Call caracter3_direccion
	Call LCD_REG
	movf contador, W
	Call caracter3_datos
	Call LCD_DATO

	movf contador, W
	Call caracter4_direccion
	Call LCD_REG
	movf contador, W
	Call caracter4_datos
	Call LCD_DATO

	movf contador, W
	Call caracter5_direccion
	Call LCD_REG
	movf contador, W
	Call caracter5_datos
	Call LCD_DATO

	movf contador, W
	Call caracter6_direccion
	Call LCD_REG
	movf contador, W
	Call caracter6_datos
	Call LCD_DATO

	movf contador, W
	Call caracter7_direccion
	Call LCD_REG
	movf contador, W
	Call caracter7_datos
	Call LCD_DATO


	incf contador, 1
	movlw   0x8
	xorwf contador, W
	btfss   STATUS,Z    ;Comprueba si es el último
	goto    ciclo       ; NO ha llegado al final
;************************************************************************
;   RUTINA PARA MOSTRAR LOS n NUEVOS CARACTERES DE LA CG RAM DATA
;************************************************************************

	movlw   0xC4         ; 1 linea ; MODIFICADO PARA LA SEGUNDA LINEA
	Call LCD_REG
	clrf contador
cic:
	movf contador, W
	Call LCD_DATO
	incf contador, 1
	movlw   0x8
	xorwf contador, W
	btfss   STATUS,Z    ; Comprueba si es el último
	goto    cic         ; NO ha llegado al final
	goto    $
;************************************************************************
	end                    ; Fin de programa.
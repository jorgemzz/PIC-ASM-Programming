;********************************* Aritmetica_11.asm ************************************
;
;	===================================================================
;	  Del libro "MICROCONTROLADOR PIC16F84. DESARROLLO DE PROYECTOS"
;	  E. Palacios, F. Remiro y L. López.		www.pic16f84a.com
; 	  Editorial Ra-Ma.  www.ra-ma.es
;	===================================================================
;
; Programa donde se comprueba la forma de convertir un número binario de 16 bits a un
; número decimal de 5 digitos. Un ejemplo se visualizará en el LCD.
;
; Así por ejemplo:
; - En la primera línea visualiza: "Hex. = 25E9".
; - En la segunda línea visualiza: "Dec. = 09705"
;
; ZONA DE DATOS *************************************************************************

	__CONFIG   _CP_OFF &  _WDT_OFF & _PWRTE_ON & _XT_OSC
	LIST	P=16F84A
      	INCLUDE	<P16F84A.INC>

	CBLOCK	0x0C
	ENDC

Binario		EQU	0x25E9		; El número a convertir.

; ZONA DE CÓDIGOS ***********************************************************************

	ORG 	0
Inicio
	call	LCD_Inicializa
	movlw	MensajeHex
	call	LCD_Mensaje
	movlw	HIGH Binario		; Carga todos los registros y visualiza los digitos.
	movwf	Arit_Binario_H
	call	LCD_ByteCompleto
	movlw	LOW Binario
	movwf	Arit_Binario_L
	call	LCD_ByteCompleto
	call	Arit_Bin_BCD_16Bit	; Pasa de binario natural en 16 bits a BCD de 5 digitos.
	call	LCD_Linea2		; Pasa a la segunda línea del LCD.
	movlw	MensajeBCD		; Visualiza el resultado en decimal.
	call	LCD_Mensaje
	movf	Arit_DecenasMillar,W
	call	LCD_Nibble
	movf	Arit_Millares,W
	call	LCD_Nibble
	movf	Arit_Centenas,W
	call	LCD_Nibble
	movf	Arit_Decenas,W
	call	LCD_Nibble
	movf	Arit_Unidades,W
	call	LCD_Nibble
	sleep				; Pasa a modo de bajo consumo.

Mensajes
	addwf	PCL,F
MensajeBCD
	DT "Dec. = ", 0x00
MensajeHex
	DT "Hex. = ", 0x00

	INCLUDE	<ARITMETICA.INC>	; Subrutina Arit_Bin_BCD_16Bit.
	INCLUDE	<RETARDOS.INC>
	INCLUDE	<LCD_4BIT.INC>
	INCLUDE <LCD_MENS.INC>
	END
	
;	===================================================================
;	  Del libro "MICROCONTROLADOR PIC16F84. DESARROLLO DE PROYECTOS"
;	  E. Palacios, F. Remiro y L. López.		www.pic16f84a.com
; 	  Editorial Ra-Ma.  www.ra-ma.es
;	===================================================================

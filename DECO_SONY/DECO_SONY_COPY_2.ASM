;**********************************************************************
; Programa para decodificar un tren de pulsos codificados en *
; formato Sony para el Microcontrolador PIC16F84 @ 4Mhz. *
; *
; Este programa es una adaptación del programa del autor Jim Nagy *
; presentado en el articulo DS40160A/6_007 Michochip Technology Inc.*
; *
; *
;**********************************************************************
; *
; Filename: decosony.asm *
; Date: 20/08/2001 *
; File Version: 1.0 *
; *
; Author: Carlos A. Narvaez V. *
; Company: Universidad de Oriente *
; *
; *
;**********************************************************************
	list p=16F84
	#include <p16F84.inc>
	__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_ON & _XT_OSC
;******* Eques del Programa
Zero 	EQU 	2
Carry 	EQU 	0
IR 		EQU 	4 ; RA4 input IR
;******* Definición de las teclas del Control Remoto
Power 	EQU 	0x15
ChanelL EQU 	0x11
ChanelP EQU 	0x10
TvVtr 	EQU 	0x4A
Rew 	EQU 	0x1B
Play 	EQU 	0x1A
FF 		EQU 	0x1C
Stop 	EQU 	0x18
Pause 	EQU 	0x19
;******* Definición de Variables
Temp 	EQU 	0x0D
CntrLo 	EQU 	0x0E ; Contador de tiempo (low byte)
CntrMid EQU 	0x0F ; (middle byte)
CntrHi 	EQU 	0x10 ; (high byte)
BitCnt 	EQU 	0x11 ; Contador de bits
Command EQU 	0x12 ; Ultimo comando recibido
Bit_puerto	EQU	0X13

		ORG 0x000 ; vector reset del procesador
		goto init ; ir a comienzo del programa
; Subrutinas
;
;**********************************************************************
; Delay
; Espera por aproximadamente W mseg y retorna
;**********************************************************************
Delay 	CLRF 	Temp
d1 		NOP
		DECFSZ 	Temp,F ; Lazo 255 * 4uS
		GOTO 	d1
		MOVWF 	Temp ; repita el lazo W veces
		DECFSZ 	Temp,W
		GOTO 	Delay
		RETLW 	0
;**********************************************************************
; GetaByte espera hasta 50ms segundos por 12 bits. Los datos
; Sony son enviados como 7 bits del comando y 5 bits
; del código de dispositivo, en ambos casos los LSB
; primero. Sólo necesitamos el comando de 7 bit al cual
; agregamos un octavo bit puesto a cero para completar
; un byte
;**********************************************************************
GetaByte
		CLRF CntrLo ; reset contadores
		MOVLW 	.223	;produce un retardo de aprox 50ms 
		MOVWF CntrMid
		CLRF CntrHi

gb1 	INCF 	CntrLo,F ; Espera por una señal
		BTFSC 	STATUS,Zero
		INCF 	CntrMid,F
		BTFSC 	STATUS,Zero
		INCF 	CntrHi,F
		MOVLW 	D'1' ; pero no mas de 50mseg
		SUBWF 	CntrHi,W ; (1*256*16*12us ~ 50mseg)
		BTFSC 	STATUS,Carry
		GOTO 	main2 ; aborte si el tiempo se excede(va a indicar que no se pulsa tecla)
		BTFSC 	PORTA,IR ; sino cheque a ver si hay señal
		Goto 	gb1 ; y sino, loop
; Hay señal
;
		CALL 	HdrCheck ; ver si es un encabezado
		BTFSS 	STATUS,Carry
		GOTO 	gb1
;
; Es un encabezado...continue
; Lee los primeros 7 bit. Resultado en Command
		MOVLW 	D'7' ; preparado para recibir 7 bits
		MOVWF 	BitCnt
		CLRF 	Command
gb2 	CALL 	GetaBit
		RRF 	Command,F
		DECFSZ 	BitCnt,F
		GOTO 	gb2
		RRF 	Command,F ; agrega un 8 bit
		BCF 	Command,7 ; puesto a cero
; Lee 5 bit Código del dipositivo pero los ignora
;
		MOVLW 	D'5'
		MOVWF 	BitCnt ; Preparado para recibir 5 bits
gb3 	CALL 	GetaBit
		DECFSZ 	BitCnt,F
		GOTO 	gb3
; Como test final, asegurese que son solo 12 bits los recibidos
		CLRF 	CntrLo ; Reset contadores
		CLRF 	CntrMid
gb4 	BTFSS 	PORTA,IR ; Chequee que no hay señal por el
; resto del frame
		GOTO 	main ; Si hay aborte
		INCF 	CntrLo,F
		BTFSC 	STATUS,Zero
		INCF 	CntrMid,F
		MOVLW	 D'4' ; Cheque cuanto he esperado
		SUBWF 	CntrMid,W ; (4*256*10us = 10ms)
		BTFSS 	STATUS,Carry
		GOTO 	gb4 ; loop hasta que los 10ms expiren
		RETLW 	0
;**********************************************************************
; GetaBit Determina el valor del bit que se esta recibiendo.
; Retorna con carry = 1 si el bit = 1 y carry = 0 si el bit = 0
; Los bits Sony son codificados como 400us sin portadora (low) seguido
; de 800us de portadora (high) para un "0" o 1400us para un "1".
;**********************************************************************
GetaBit CLRF 	CntrLo ; Reset contador
b1 		INCF 	CntrLo,F ; determne tiempo de no portadora
		MOVLW 	D'100'
		SUBWF 	CntrLo,W ; permite hasta 800us (100*8us)
		BTFSC 	STATUS,Carry
		GOTO 	main ; aborte si es mayor
		BTFSC 	PORTA,IR ; mantengase contando portadora viene
		GOTO 	b1
; Un espacio menor que 800us fue recibido
;
		MOVLW 	D'25' ; Asegurese que es mas grande que
		SUBWF 	CntrLo,W ; 25*8us = 200us
		BTFSS 	STATUS,Carry
		GOTO 	main ; aborte si es menor
; Determine la longitud del pulso IR que esta siendo recibido
		CLRF 	CntrLo
b2 		INCF 	CntrLo,F ; Cuente este pase
		MOVLW 	D'225'
		SUBWF 	CntrLo,W ; Permita hasta 1800us (255*8us)
		BTFSC 	STATUS,Carry
		GOTO 	main ; Aborte si es mayor
		BTFSS 	PORTA,IR ; siga contando hasta final pulso
		GOTO 	b2
; Señal presente
		MOVLW 	D'50' ; Asegurese que es mayor que
		SUBWF 	CntrLo,W ; 50*8us = 400us
		BTFSS 	STATUS,Carry
		GOTO 	main ; Si no aborte
; Que es: un 1 o un 0
		MOVLW 	D'125' ; Compare con un ancho de 1000us
		SUBWF 	CntrLo,W ; Carry 1 o 0
		RETLW 	0
;**********************************************************************
;
; Detecta encabezado > 1.8 ms low
; Retorna con carry = 1 si es un encabezado y carry = 0 si no lo es.
;
;**********************************************************************
HdrCheck
		CLRF 	Temp ; Chequee para un encabezado
; de aprox. 2.5 ms de longitud
hc1 	INCF 	Temp,F ; Cuente cada pase a traves del loop
		BSF 	PORTA,IR
		BSF 	STATUS,RP0 ; Banco 1
		MOVLW 	B'00100000' ;
		MOVWF 	PORTA ; Reset schmitt
		MOVLW 	B'00110000' ; Entrada a la deriva debido a la
		MOVWF 	PORTA ; luz ambiental
		BCF 	STATUS,RP0 ; Banco 0
		MOVLW 	D'250' ; Chequee para un encabezado de
		SUBWF 	Temp,W ; aprox. (250*13us ~3.25 ms)
		BTFSC 	STATUS,Carry
		GOTO 	hc2 ; Aborte si es muy largo
		BTFSS 	PORTA,IR ; Chequee si la señal esta aun ahi
		GOTO 	hc1 ; y si esta mantengase looping
; Un pulso de menos de 3ms de duración ha sido recibido
;
		MOVLW 	D'138' ; Asegurese que es mayor que
		SUBWF 	Temp,W ; 138*13us ~ 1.8ms
		RETLW 	0 ; C = 1 si T>1.8ms
hc2 	CLRW
		ADDWF 	Temp,W ; Agregando 0 a cualquier numero C=0
		RETLW 	0
;**********************************************************************
;
; Programa Principal
;
;**********************************************************************
init
		CLRF 	PORTA ; Clear registro PORTA
		CLRF 	PORTB ; Clear registro PORTB	
		BSF 	STATUS,RP0 ; Banco 1
		MOVLW 	B'00110000' ; RA4 - RA5 como input
		MOVWF 	PORTA ; Configure TRISA
		MOVLW 	0x00 ; PORTB todos Salidas
		MOVWF 	PORTB ; configura TRISA
		BCF 	STATUS,RP0 ; Banco 0
main
		CALL 	GetaByte ; Tomar un byte de Comando
		
;--------------controla bit a encender-------------

		CLRF	Bit_puerto

		MOVF 	Command,W
		XORLW	0X15	
		BTFSC	STATUS,Z	;si es tecla 0x00 
		BSF		Bit_puerto,0	;selecciona bit a encender
		MOVF 	Command,W
		XORLW	0X2A	
		BTFSC	STATUS,Z	;si es tecla 0x01 
		BSF		Bit_puerto,1	;selecciona bit a encender
		MOVF 	Command,W
		XORLW	0X10	
		BTFSC	STATUS,Z	;si es tecla 0x02 
		BSF		Bit_puerto,2	;selecciona bit a encender
		MOVF 	Command,W
		XORLW	0X11	
		BTFSC	STATUS,Z	;si es tecla 0x03 
		BSF		Bit_puerto,3	;selecciona bit a encender
		MOVF 	Command,W
		XORLW	0X1A	
		BTFSC	STATUS,Z	;si es tecla 0x04 
		BSF		Bit_puerto,4	;selecciona bit a encender
		MOVF 	Command,W
		XORLW	0X1B	
		BTFSC	STATUS,Z	;si es tecla 0x05 
		BSF		Bit_puerto,5	;selecciona bit a encender
		MOVF 	Command,W
		XORLW	0X1C	
		BTFSC	STATUS,Z	;si es tecla 0x06 
		BSF		Bit_puerto,6	;selecciona bit a encender
		MOVF 	Command,W
		XORLW	0X18	
		BTFSC	STATUS,Z	;si es tecla 0x07
		BSF		Bit_puerto,7	;selecciona bit a encender

		MOVF	Bit_puerto,0
		MOVWF 	PORTB ; Muestre comando por PORTB
		GOTO 	main

main2
		CLRF	PORTB	;llega aqui cuando no se pulsa boton por mas de 100ms
		GOTO	main	;borro	port b  para que solo visualce el dato de la tecla 
						;si ésta esta presionada
		
		

	END ; directive 'end of program'
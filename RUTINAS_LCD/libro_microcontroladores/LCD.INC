
;********declarar hardware*******

	RS		EQU		1	;SELECCION DE REGISTRO
	RW		EQU		2	;LEER ESCRIBIR
	EN		EQUU	3	;HABILITAR SALIDA/CLK
	
;*********COMANDOS LCD***********

	CONSTANT	LCDEM8 = B'00110000'	;MODO 8 BITS DOS LINEAS
	CONSTANT	LCDDZ  = B'10000000'	;ESCRIBIR	0 DDRAM
	CONSTANT	LCDEM4 = B'00100000'	;MODO 4 BITS DOS LINEAS

;*****COMANDOS ESTANDAR OPARA INICIAR EL LCD****
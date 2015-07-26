;******************************** Librería "Aritmetica.INC" *****************************
;
;	===================================================================
;	  Del libro "MICROCONTROLADOR PIC16F84. DESARROLLO DE PROYECTOS"
;	  E. Palacios, F. Remiro y L.J. López.		www.pic16f84a.com
; 	  Editorial Ra-Ma.  www.ra-ma.es
;	===================================================================
;
; Librería de subrutinas con diversas operaciones aritméticas:
;
; - Arit_VisualizaBinario: Visualiza en el LCD el dato en binario que le entra por W.
; - Arit_Negar: Niega el contenido de un número binario de 16 bits.
; - Arit_Suma_16Bit: Realiza la suma con dos registros de 16 bits.
; - Arit_Resta_16Bit: Realiza la resta con dos registros de 16 bits.
; - Arit_Multiplica_8Bit: Multiplica dos registros de 8 bits.
; - Arit_Multiplica_16Bit: Multiplica dos registros de 16 bits.
; - Arit_Divide_8Bit: Divide dos registros de 8 bits.
; - Arit_Divide_16Bit: Divide un registro de 16 bits entre otro de 7 bits.
; - Arit_BCD_Bin_16Bit: Convierte un número BCD de 5 dígitos a binario natural de 16 bits.
; - Arit_Bin_BCD_16Bit: Convierte un número binario de 16 bits a BCD de 5 dígitos.
; - Arit_VisualizaBCD: Visualiza en el LCD un número decimal de varios dígitos.

	CBLOCK
	Arit_Operando_1L	; Byte bajo del operando 1.
	Arit_Operando_1H	; Byte alto del operando 1.
	Arit_Operando_2L	; Byte bajo del operando 2.
	Arit_Operando_2H	; Byte alto del operando 2.
	Arit_Resultado_1L	; Byte bajo del byte 1 del resultado.
	Arit_Resultado_1H	; Byte alto del byte 1 del resultado.
	Arit_Resultado_2L	; Byte bajo del byte 2 del resultado.
	Arit_Resultado_2H	; Byte alto del byte 2 del resultado.
	Arit_ContadorBits	; Para realizar diferentes contadores con bits.
	Arit_Auxiliar		; Registro temporal para realizar operaciones intermedias.
	ENDC

; Subrutina "Arit_VisualizaBinario" -------------------------------------------------------
;
; Visualiza en binario en el visualizador LCD el dato que le entra por el registro W.
;
Arit_VisualizaBinario
	movwf	Arit_Auxiliar		; Pasa el dato a visualizar a un registro auxiliar.
	movlw	.8
	movwf	Arit_ContadorBits	; Se van a visualizar ocho bits en el LCD
Arit_VisualizaBit
	rlf	Arit_Auxiliar,F		; El bit a visualizar pasa al Carry .
	movlw	'1'			; En principio supone que es un "1".
	btfss	STATUS,C		; Comprueba su valor.
	movlw	'0'			; Ha sido cero.
	call	LCD_Caracter		; Lo visualiza.
	decfsz	Arit_ContadorBits,F	; ¿Ha terminado de visualizar los 8 bits?
	goto	Arit_VisualizaBit	; No, sigue visualizando otro bit.
	return

; Subrutina "Arit_Negar" ----------------------------------------------------------------
;
; Niega el contenido de un número de 16 bits almacenado en dos registros
; (Arit_Operando_1H, Arit_Operando_1L).
;
; Lo hace en complemento a 2 por el método clásico, es decir, primero invierte todos los bits
; y después le suma "1".
;
; Se utiliza la instrucción "addwf __", en lugar de "incf ___", porque ésta no posiciona
; el flag de Carry.
;
; En el registro de trabajo W también aparece el resultado de la negación del byte bajo.
;
; Entrada:	En los registros (Arit_Operando_1H, Arit_Operando_1L) el dato de 
;		16 bits a negar.
; Salida: 	En los mismo registros (Arit_Operando_1H, Arit_Operando_1L) el dato de 
;		16 bits negado. En (W) el byte más bajo negado.

Arit_Negar
	comf	Arit_Operando_1H,F	; Invierte los registros que contienen los operandos.
	comf	Arit_Operando_1L,F
	movlw	.1			; Le suma 1.
	addwf	Arit_Operando_1L,F		
	btfsc	STATUS,C		; Si hay acarreo tiene que llevarlo al byte superior.
	incf	Arit_Operando_1H,F	
	movf	Arit_Operando_1L,W	; En (W) el resultado del byte bajo.
	return
	
; Subrutinas "Arit_Suma_16Bit" y "Arit_Resta_16Bit" ---------------------------------------
;
; Realiza la suma/resta en 16 bits (Operando 2) +/- (Operando 1) y el resultado lo guarda en
; (Operando 2). El resultado lo guarda en 16 bits. Es decir:
; (Arit_Operando_2H, Arit_Operando_2L) +/- (Arit_Operando_1H, Arit_Operando_1L) --> 
; (Arit_Operando_2H, Arit_Operando_2L).
;
Arit_Resta_16Bit
	call	Arit_Negar		; Para la resta, simplemente niega el numero de 16 bits
Arit_Suma_16Bit				; (Arit_Operando_1H, Arit_Operando_1L) y suma.
	movf	Arit_Operando_1L,W	; Suma el byte más bajo.
	addwf	Arit_Operando_2L,F	; y lo guarda en Arit_Operando_2L.
	btfsc	STATUS,C		; Si hay acarreo incrementa en una unidad uno de
	incf	Arit_Operando_1H,F	; de los bytes altos.
	movf	Arit_Operando_1H,W
	addwf	Arit_Operando_2H,F	; Suma el byte alto.
	return

; Subrutinas "Arit_Multiplica_8Bit" ------------------------------------------------------
;
; Realiza la multiplicación del contenido de dos registros de 8 bits. El resultado se almacena
; en 16 bits. La operación se realiza sin signo.
;
; El algoritmo utilizado se basa en el método empleado para efectuar una multiplicación
; manualmente con lápiz y papel. En este método, la multiplicación se lleva a cabo tomando
; un bit del multiplicador, empezando por el menos significativo: 
; - Si es "1" se efectúa la suma del multiplicando y el producto parcial anterior. El producto
;   parcial resultante se desplaza un bit a la derecha, introduciendo un cero por la izquierda.
; - Si es "0" la suma no es necesaria y el producto parcial resultante anterior se desplaza un
;   bit a la derecha, introduciendo además un cero por la izquierda.
;
; Este proceso se repite tantas veces como bits tiene el multiplicador.
;
; Previo a la llamada de esta subrutinas los números a multiplicar se almacenan en los registros
; Arit_Multiplicando y Arit_Multiplicador. El resultado se almacena en 16 bits en los registros 
; (Arit_Producto_H, Arit_Producto_L). Es decir:
; (Arit_Multiplicando) * (Arit_Multiplicador) --> (Arit_Producto_H, Arit_Producto_L)
;
; Se utilizan posiciones de memoria definidas anteriormente, a las que se les cambia el nombre 
; por motivos puramente pedagógicos:

Arit_Multiplicando	EQU	Arit_Operando_1L
Arit_Multiplicador	EQU	Arit_Operando_2L
Arit_Producto_H		EQU	Arit_Resultado_1H
Arit_Producto_L		EQU	Arit_Resultado_1L

Arit_Multiplica_8Bit
	clrf	Arit_Producto_H		; En principio el resultado es cero.
	clrf	Arit_Producto_L
	movlw	.8			; Carga el contador de 8 bits.
	movwf	Arit_ContadorBits
	movf	Arit_Multiplicando,W	; Carga el multiplicando.
Arit_MultiplicaBit8
	rrf	Arit_Multiplicador,F	; Va a comprobar el siguiente bit del multiplicador.
	btfsc	STATUS,C		; Si el bit del multiplicador es "1"
	addwf	Arit_Producto_H,F	; suma el resultado parcial anterior más el multiplicando.
	rrf	Arit_Producto_H,F	; Desplaza el resultado parcial un lugar hacia la 
	rrf	Arit_Producto_L,F	; derecha, introduciendo un "0" por la izquierda.
	decfsz	Arit_ContadorBits,F	; ¿Ha multiplicado los 8 bits?
	goto	Arit_MultiplicaBit8	; Repite la operación.
	return
	
; Subrutinas "Arit_Multiplica_16Bit" ------------------------------------------------------
;
; Realiza la multiplicación del contenido de dos registros de 16 bits. El resultado se almacena
; en 32 bits. La operación se realizan sin signo.
;
; El algoritmo utilizado es similar al de la multiplicación de 8 bits.
;
; Previo a la llamada de esta subrutinas los números a multiplicar se almacenan en los registros
; (Arit_Multiplicando_H, Arit_Multiplicando_L) y (Arit_Multiplicador_H, Arit_Multiplicador_L).
; El resultado en 32 bits se proporciona en los registros 
; (Arit_Producto_2H, Arit_Producto_2L, Arit_Producto_1H, Arit_Producto_1L).
;
; Se utilizan posiciones de memoria definidas anteriormente, a las que se les cambia el nombre 
; por motivos puramente pedagógicos:

Arit_Multiplicando_H	EQU	Arit_Operando_1H
Arit_Multiplicando_L	EQU	Arit_Operando_1L
Arit_Multiplicador_H	EQU	Arit_Operando_2H
Arit_Multiplicador_L	EQU	Arit_Operando_2L
Arit_Producto_1H	EQU	Arit_Resultado_1H
Arit_Producto_1L	EQU	Arit_Resultado_1L
Arit_Producto_2H	EQU	Arit_Resultado_2H
Arit_Producto_2L	EQU	Arit_Resultado_2L

Arit_Multiplica_16Bit
	clrf	Arit_Producto_1H	; En principio el resultado es cero.
	clrf	Arit_Producto_1L
	clrf	Arit_Producto_2H
	clrf	Arit_Producto_2L
	movlw	.16			; Carga el contador de 16 bits.
	movwf	Arit_ContadorBits
Arit_Multiplica16Bit
	rrf	Arit_Multiplicador_H,F	; Va a comprobar el siguiente bit del multiplicador.
	rrf	Arit_Multiplicador_L,F
	btfss	STATUS,C
	goto	Arit_Multiplicador_BitCero
	movf	Arit_Multiplicando_L,W	; Suma en 16 bits el resultado parcial y
	addwf	Arit_Producto_2L,F	; y el multiplicando.
	btfsc	STATUS,C
	incf	Arit_Producto_2H,F
	movf	Arit_Multiplicando_H,W
	addwf	Arit_Producto_2H,F
Arit_Multiplicador_BitCero
	rrf	Arit_Producto_2H,F	; Desplaza el resultado parcial un lugar hacia la 
	rrf	Arit_Producto_2L,F	; derecha, introduciendo un "0" por la izquierda.
	rrf	Arit_Producto_1H,F
	rrf	Arit_Producto_1L,F
	decfsz	Arit_ContadorBits,F	; ¿Ha multiplicado los 16 bits?
	goto	Arit_Multiplica16Bit	; Repite la operación.
	return

; Subrutinas "Arit_Divide_8Bit" ---------------------------------------------------------
;
; Realiza la división del contenido del dividendo de 8 bits entre un divisor de 8 bits.
;
; El algoritmo utilizado se basa en el método empleado para resolver una división de 
; números binarios con lápiz y papel. En este método se van tomando los bits del dividendo
; uno a uno, comenzando por el más significativo: por cada bit del dividendo se genera un
; bit en el cociente. Los bits separados constituyen el dividendo parcial. Cada vez que se
; toma un nuevo bit del dividendo, el valor conjunto de los bits en el dividendo parcial se 
; compara con el divisor. El el primero resulta ser mayor o igual al segundo, entonces al 
; dividendo parcial se le resta el valor del divisor, el bit respectivo del cociente se pone
; a "1" y el resultado de la resta se convierte en el nuevo dividendo parcial, una vez que
; se le agrega el siguiente bit del dividendo. Si la comparación entre dividendo y divisor
; indica que éste último es mayor, entonces el bit del cociente se pone a "0" y al dividendo
; parcial anterior se le añade el siguiente bit del dividendo para formar el nuevo dividendo
; parcial. El proceso termina cuando se agotan los bits del dividendo; el contenido del 
; dividendo parcial en ese momento constituye precisamente el resto de la operación de
; división.
;
; Entradas: 	- (Arit_Dividendo) que hacen de dividendo de 8 bits.
;		- (Arit_Divisor) que es el divisor de 8 bits.
; Salidas:	- (Arit_Cociente). 
;		- (Resto).
;		- (W), en el registro de trabajo también el resto.
;
; La división se hará sin signo y el programa que le llame deberá detectar que el divisor no
; es cero.
;
; Se utilizan posiciones de memoria definidas anteriormente, a las que se les cambia el nombre 
; por motivos puramente pedagógicos:

Arit_Dividendo	EQU	Arit_Operando_1L
Arit_Divisor	EQU	Arit_Operando_2L
Arit_Cociente	EQU	Arit_Resultado_1L
Arit_Resto	EQU	Arit_Resultado_2L

Arit_Divide_8Bit
	clrf	Arit_Cociente		; En principio el resultado es cero.
	clrf	Arit_Resto
	movlw	.8			; Carga el contador.
	movwf	Arit_ContadorBits
Arit_DivideBit8
	rlf	Arit_Dividendo,F
	rlf	Arit_Resto,F		; (Arit_Resto) contiene el dividendo parcial.
	movf	Arit_Divisor,W
	subwf	Arit_Resto,W		; Compara dividendo parcial y divisor.
	btfsc	STATUS,C		; Si (dividendo parcial)>(divisor)
	movwf	Arit_Resto		; (dividendo parcial) - (divisor) --> (dividendo parcial)
	rlf	Arit_Cociente,F		; Desplaza el cociente introduciendo el bit apropiado.
	decfsz	Arit_ContadorBits,F
	goto	Arit_DivideBit8
	movf	Arit_Resto,W		; El resto también en (W)
	return
	
; Subrutinas "Arit_Divide_16Bit" --------------------------------------------------------
;
; Realiza la división del contenido del dividendo de 16 bits entre un divisor de 7 bits.
; El máximo valor del divisor será 127.
;
; Se utiliza el mismo algoritmo explicado para la subrutina Arit_Divide_8bit.
;
; Entradas: 	- (Arit_Dividendo_H) y (Arit_Dividendo_L) que hacen de dividendo de 16 bits.
;		- (Arit_Divisor) que es el divisor de 7 bits, (máximo b'01111111'=0x7F=d'127').
; Salidas:	- (Arit_Cociente_H) y (Arit_Cociente_L) que hacen de cociente de 16 bits.
;		- (Resto) de 8 bits.
;		- (W), en el registro de trabajo también el resto.
;
; La división se hará sin signo y el programa que le llame deberá detectar que el divisor no
; es cero. El divisor será de 7 bits, es decir su valor máximo será:
; b'01111111'=0x7F=d'127'.
;
; Se utilizan posiciones de memoria definidas anteriormente, a las que se les cambia el nombre 
; por motivos puramente pedagógicos:
;
Arit_Dividendo_H	EQU	Arit_Operando_1H
Arit_Dividendo_L	EQU	Arit_Operando_1L
Arit_Cociente_H		EQU	Arit_Resultado_1H
Arit_Cociente_L		EQU	Arit_Resultado_1L

Arit_Divide_16Bit
	clrf	Arit_Cociente_H		; En principio el resultado es cero.
	clrf	Arit_Cociente_L
	clrf	Arit_Resto
	movlw	.16			; Carga el contador.
	movwf	Arit_ContadorBits
Arit_DivideBit16
	rlf	Arit_Dividendo_L,F
	rlf	Arit_Dividendo_H,F
	rlf	Arit_Resto,F		; (Arit_Resto) contiene el dividendo parcial.
	movf	Arit_Divisor,W
	subwf	Arit_Resto,W		; Compara dividendo parcial y divisor.
	btfsc	STATUS,C		; Si (dividendo parcial)>(divisor)
	movwf	Arit_Resto		; (dividendo parcial) - (divisor) --> (dividendo parcial)
	rlf	Arit_Cociente_L,F	; Desplaza el cociente introduciendo el bit apropiado
	rlf	Arit_Cociente_H,F	; "0" ó "1" según corresponda.
	decfsz	Arit_ContadorBits,F
	goto	Arit_DivideBit16
	movf	Arit_Resto,W		; El resto también en (W).
	return
	
; Subrutinas "Arit_BCD_Bin_16Bit" ------------------------------------------------------
;
; Realiza la conversión de un número decimal de 5 digitos a binario natural de 16 bits.
; El máximo número a convertir será pues el b'1111111111111111'=0xFFFF=d'65535'
;
; El metodo usado para la conversión de un número BCD a binario natural, se basa en que
; cada dígito de un número codificado en BCD tiene un peso igual a la potencia de diez
; asociada a su posición. Para convertir el número BCD a su equivalente binario sólo es
; necesario multiplicar cada dígito BCD por su peso correspondiente y luego sumar todos
; los productos parciales obtenidos, el resultado es el número binario natural buscado.
; Es decir el valor de un número BCD de 5 dígitos se puede expresar como:
;
; 10^4 DecenasMillar + 10^3 Millares + 10^2 Centenas + 10 Decenas + Unidades =
; 10*10*10*10 DecenasMillar + 10*10*10 Millares + 10*10 Centenas + 10 Decenas + Unidades
;
; Finalmente la subrutina aplica el siguiente algoritmo:
; 10(10(10(10 DecenasMillar + Millares) + Centenas) + Decenas) + Unidades = Resultado
;
; El resultado se obtiene en 16 bits, es decir en 2 registros de 8 bits, que son:
; (Arit_Resultado_1H, Arit_Resultado_1L). Esta subrutina no tiene sistema alguno para 
; detectar desbordamiento que debe preveerse en el programa que la llame.

; Previo a la llamada de esta subrutinas, cada digito del número decimal a convertir se
; almacenan en registros independientes, que son:

	CBLOCK
	Arit_Unidades
	Arit_Decenas
	Arit_Centenas
	Arit_Millares
	Arit_DecenasMillar
	ENDC

Arit_BCD_Bin_16Bit
	clrf	Arit_Resultado_1H	; Realiza la carga inicial de los registros.
	movf	Arit_DecenasMillar,W
	movwf	Arit_Resultado_1L	; (Resultado Parcial) = (DecenasMillar)
;
	movf	Arit_Millares,W		
	call	Arit_BCD_Operacion	; (10*DecenasMillar+Millares)
	movf	Arit_Centenas,W
	call	Arit_BCD_Operacion	; (10(10*DecenasMillar+Millares)+Centenas)
	movf	Arit_Decenas,W
	call	Arit_BCD_Operacion	; (10(10(10*DecenasMillar+Millares)+Centenas)+Decenas)
	movf	Arit_Unidades,W
	call	Arit_BCD_Operacion	; Resultado final.
	return
	
Arit_BCD_Operacion			; Realiza la operacion:	(10 * Resultado Anterior + W)
	movwf	Arit_Auxiliar		; Guarda la variable de entrada.
	movf	Arit_Resultado_1L,W
	movwf	Arit_Multiplicando_L	; (Resultado Anterior) --> (Multiplicando)
	movf	Arit_Resultado_1H,W
	movwf	Arit_Multiplicando_H
	clrf	Arit_Multiplicador_H	; Carga el multiplicador con 10.
	movlw	.10
	movwf	Arit_Multiplicador_L
	call	Arit_Multiplica_16Bit	; (10 * Resultado Anterior)
	movf	Arit_Auxiliar,W
	addwf	Arit_Resultado_1L,F
	btfsc	STATUS,C
	incf	Arit_Resultado_1H,F	; (10 * Resultado Anterior + W)
	return
	
; Subrutinas "Arit_Bin_BCD_16Bit" --------------------------------------------------------
;
; Convierte un número binario de 16 bits almacenado en los registros 
; (Arit_Binario_H, Arit_Binario_L) a BCD. 

; La conversión de binario a BCD se puede realizar a través de la división sucesiva del número
; binario entre diez (0x0A). El resto generado después de la primera división proporciona el 
; dígito BCD correspondiente a la unidades y cada división subsecuente proporciona el dígito
; siguiente, es decir, decenas, centenas, etc. A continuación se explica un ejemplo expresado
; en decimal:
;		58634 : 10 = 5863	Resto = 4 (Unidades)
;		 5863 : 10 = 586	Resto = 3 (Decenas)
;		  586 : 10 = 58		Resto = 6 (Centenas)
;		   58 : 10 = 5		Resto = 8 (Millares)
;		    5 : 10 = 0		Resto = 5 (Decenas de Millar) 

; El mismo ejemplo expresado en hexadecimal:
; 		0xE50A : 0x0A = 0x16E7	Resto = 0x04 (Unidades)
;		0x16E7 : 0x0A = 0x024A	Resto = 0x03 (Decenas)
;		0x024A : 0x0A = 0x003A	Resto = 0x06 (Centenas)
;		0x003A : 0x0A = 0x0005	Resto = 0x08 (Millares)
;		0x0005 : 0x0A = 0x0000	Resto = 0x05 (Decenas de Millar) 
;
; Entrada: Número binario de 16 bits en los registros (Arit_Binario_H, Arit_Binario_L)
; Salida: Número decimal de 5 digitos en los registros:
;	  (Arit_DecenasMillar, Arit_Millares, Arit_Centenas, Arit_Decenas, Arit_Unidades).

	CBLOCK
	Arit_ContadorDigitos
	Arit_Binario_H
	Arit_Binario_L
	ENDC

Arit_Bin_BCD_16Bit
	movf	Arit_Binario_H,W	; Carga el número de entrada como primer dividendo
	movwf	Arit_Dividendo_H	; parcial para realizar las sucesivas divisiones
	movf	Arit_Binario_L,W	; entre 10.
	movwf	Arit_Dividendo_L
	movlw	.5			; El número decimal tendrá 5 digitos.
	movwf	Arit_ContadorDigitos
	movlw	Arit_Unidades		; Se va a utilizar direccionamiento indirecto.
	movwf	FSR			; Apunta al primer digito BCD, las unidades.
Arit_DigitoBCD	
	movlw	.10			; Carga 10 en el divisor.
	movwf	Arit_Divisor
	call	Arit_Divide_16Bit	; Divide el cociente anterior entre 10.
	movwf	INDF			; El resto producido en la división es el digito BCD.
	incf	FSR,F			; Apunta a siguiente posición de registros de salida.
	movf	Arit_Cociente_H,W	; El cociente anterior será el dividendo de la
	movwf	Arit_Dividendo_H	; próxima division de 16 bits.
	movf	Arit_Cociente_L,W
	movwf	Arit_Dividendo_L	
	decfsz	Arit_ContadorDigitos,F
	goto	Arit_DigitoBCD
	return
	
; Subrutinas "Arit_VisualizaBCD" --------------------------------------------------------
;
; Visualiza en el LCD un número decimal de varios dígitos de manera tal que no se representan
; los ceros no significativos de la izquierda. El número decimal de entrada se almacena en los
; registros:(Arit_DecenasMillar, Arit_Millares, Arit_Centenas, Arit_Decenas, Arit_Unidades).

	CBLOCK				; Si (Arit_FlagVisual)=0x00 No escribe el siguiente
	Arit_FlagVisual			; nibble si es "0".
	ENDC				; Si (Arit_FlagVisual)=b'00000001' SI escribe el					; siguiente nibble aunque sea "0".
Arit_NumeroDigitos	EQU	.5

Arit_VisualizaBCD
	clrf	Arit_FlagVisual		; En principio no escribe si el dígito es cero.
	movlw	Arit_NumeroDigitos-1	; El último dígito de unidades se visualizará siempre
	movwf	Arit_ContadorDigitos	; por tanto son n-1 digitos a comprobar.
	movlw	Arit_DecenasMillar	; Se va a utilizar direccionamiento indirecto.
	movwf	FSR			; Apunta al dígito BCD más a la izquierda.
Arit_VisualizaDigitoBCD	
	movf	INDF,W			; Carga el dígito a visualizar.
	btfsc	Arit_FlagVisual,0	; Si el dígito anterior fue visualizado también 
	goto	Arit_VisualizaDigito	; visualiza el actual.
	btfsc	STATUS,Z		; Comprueba si el digito actual es cero
	goto	Arit_PasaAlSiguiente	; No visualiza y pasa al siguiente dígito.
Arit_VisualizaDigito
	call	LCD_Nibble		; Visualiza en digito
	bsf	Arit_FlagVisual,0	; Señala que ha visualizado el dígito actual.
Arit_PasaAlSiguiente
	decf	FSR,F			; Apunta a la siguiente posición de los registros
	decfsz	Arit_ContadorDigitos,F	; de entrada.
	goto	Arit_VisualizaDigitoBCD
	movf	Arit_Unidades,W		; Las unidades siempre se visualizan, aunque sean 
	call	LCD_Nibble		; cero.
	return
	
;	===================================================================
;	  Del libro "MICROCONTROLADOR PIC16F84. DESARROLLO DE PROYECTOS"
;	  E. Palacios, F. Remiro y L. López.		www.pic16f84a.com
; 	  Editorial Ra-Ma.  www.ra-ma.es
;	===================================================================

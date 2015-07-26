;CLAVEMEN.ASM programa que debe leer clave ingresada desde un teclado
;de 4 por 4, y debe visualizar en leds el codigo binario del numero pulsado
;y prender RA4 de no pulsar ninguno. El teclado es el encontrado en el libro

        LIST    P=16C84         ;Comando que indica el PIC usado
        RADIX   HEX             ;Los valores se representar n en hexadecimal

;----------------------------------------------------------------------------
        
        PUERTAA EQU     0X05    ;Etiqueta "PUERTAA" 
        PUERTAB EQU     0X06    ;Etiqueta PUERTAB
        ESTADO  EQU     0X03    ;Estado corresponde con el valor 0x03.
        RBOUT   EQU     0X0C
        RBIN    EQU     0X0D
        INTCON  EQU     0X0B
        TMR_OPT EQU     0X01
        INDF    EQU     0X00
;----------------------------------------------------------------------------
        ORG     0               
        bsf     ESTADO,5        ;Banco 1
        movlw   0x00            ;W <-- 00(Hex)
        movwf   PUERTAA         ;W --> TRISA      PUERTAA salidas
        movlw   b'11110000'     ;W <-- b'11110000'
        movwf   PUERTAB         ;W --> TRISB  RB 0-3 salidas
                                ;             RB 4-7 entradas
        bcf     ESTADO,5        ;Banco 0                                
        clrf    RBIN
        clrf    RBOUT
        clrf    PUERTAB
        comf    PUERTAB,1
        clrf    PUERTAA

cifra

paso1
        movlw   b'00001110'
        iorwf   PUERTAB,1         
        bcf     PUERTAB,0        ;Envio el valor b'1110' por RB 0-3
        movf    PUERTAB,0          
        movwf   RBIN
        movlw   b'11110000'
        andwf   RBIN,1           ;Recupero los bits RB 4-7 en RBIN
        subwf   RBIN,0
        btfsc   ESTADO,2
        goto    paso2
        goto    halle1           ;Encontre un codigo binario de una tecla

paso2
        movlw   b'00001101'
        iorwf   PUERTAB,1         
        bcf     PUERTAB,1        ;Envio el valor b'1101' por RB 0-3
        movf    PUERTAB,0          
        movwf   RBIN
        movlw   b'11110000'
        andwf   RBIN,1           ;Recupero los bits RB 4-7 en RBIN
        subwf   RBIN,0
        btfsc   ESTADO,2
        goto    paso3
        goto    halle2           ;Encontre un codigo binario de una tecla

paso3
        movlw   b'00001011'
        iorwf   PUERTAB,1         
        bcf     PUERTAB,2        ;Envio el valor b'1011' por RB 0-3
        movf    PUERTAB,0          
        movwf   RBIN
        movlw   b'11110000'
        andwf   RBIN,1           ;Recupero los bits RB 4-7 en RBIN
        subwf   RBIN,0
        btfsc   ESTADO,2
        goto    paso4
        goto    halle3           ;Encontre un codigo binario de una tecla
paso4
        movlw   b'00000111'
        iorwf   PUERTAB,1         
        bcf     PUERTAB,3        ;Envio el valor b'0111' por RB 0-3
        movf    PUERTAB,0          
        movwf   RBIN
        movlw   b'11110000'
        andwf   RBIN,1           ;Recupero los bits RB 4-7 en RBIN
        subwf   RBIN,0
        btfsc   ESTADO,2
        goto    nopulso
        goto    halle4           ;Encontre un codigo binario de una tecla

halle1
        movlw   b'11100000'                                                 
        subwf   RBIN,0
        btfsc   ESTADO,2
        goto    tengoC
        movlw   b'11010000'                                                 
        subwf   RBIN,0
        btfsc   ESTADO,2
        goto    tengoB
        movlw   b'10110000'                                                 
        subwf   RBIN,0
        btfsc   ESTADO,2
        goto    tengo0
        goto    tengoA
halle2
        movlw   b'11100000'                                                 
        subwf   RBIN,0
        btfsc   ESTADO,2
        goto    tengoD
        movlw   b'11010000'                                                 
        subwf   RBIN,0
        btfsc   ESTADO,2
        goto    tengo9
        movlw   b'10110000'                                                 
        subwf   RBIN,0
        btfsc   ESTADO,2
        goto    tengo8
        goto    tengo7
halle3
        movlw   b'11100000'                                                 
        subwf   RBIN,0
        btfsc   ESTADO,2
        goto    tengoE
        movlw   b'11010000'                                                 
        subwf   RBIN,0
        btfsc   ESTADO,2
        goto    tengo6
        movlw   b'10110000'                                                 
        subwf   RBIN,0
        btfsc   ESTADO,2
        goto    tengo5
        goto    tengo4
halle4
        movlw   b'11100000'                                                 
        subwf   RBIN,0
        btfsc   ESTADO,2
        goto    tengoF
        movlw   b'11010000'                                                 
        subwf   RBIN,0
        btfsc   ESTADO,2
        goto    tengo3
        movlw   b'10110000'                                                 
        subwf   RBIN,0
        btfsc   ESTADO,2
        goto    tengo2
        goto    tengo1
tengoC
        movlw   0x0C
        movwf   PUERTAA
        goto    cifra
tengoB
        movlw   0x0B
        movwf   PUERTAA
        goto    cifra
tengo0
        movlw   0x00
        movwf   PUERTAA
        goto    cifra
tengoA
        movlw   0x0A
        movwf   PUERTAA
        goto    cifra
tengoD
        movlw   0x0D
        movwf   PUERTAA
        goto    cifra
tengo9
        movlw   0x09
        movwf   PUERTAA
        goto    cifra
tengo8
        movlw   0x08
        movwf   PUERTAA
        goto    cifra
tengo7
        movlw   0x07
        movwf   PUERTAA
        goto    cifra
tengoE
        movlw   0x0E
        movwf   PUERTAA
        goto    cifra
tengo6
        movlw   0x06
        movwf   PUERTAA
        goto    cifra
tengo5
        movlw   0x05
        movwf   PUERTAA
        goto    cifra
tengo4
        movlw   0x04
        movwf   PUERTAA
        goto    cifra
tengoF
        movlw   0x0F
        movwf   PUERTAA
        goto    cifra
tengo3
        movlw   0x03
        movwf   PUERTAA
        goto    cifra
tengo2
        movlw   0x02
        movwf   PUERTAA
        goto    cifra
tengo1
        movlw   0x01
        movwf   PUERTAA
        goto    cifra
nopulso
        movlw   b'00010000'
        movwf   PUERTAA
        goto    cifra

   END
















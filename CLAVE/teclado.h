;**************************************************************************
;                               TECLADO.H
;
;                       Autor: Jorge Ra£l Mu¤oz
;                     (c) Microsystems Engineering
;
;Esta rutina realiza una exploraci¢n del teclado matricial de 16 teclas
;conectado a la puerta B y devuelve el c¢digo BCD de la tecla pulsada. Si 
;no se pulsa ninguna se devuelve el c¢digo 0x80. Sea el c¢digo que sea
;este retorna en la variable Num_tecla.
;
       cblock 0x0C
              CONT1                 ; Contador
              CONT2                 ; Contador
              Num_tecla             ; Reg. de tecla pulsada
              Temp_Tecla            ; Reg. de lectura Temporal
              Static                ; Reg. de Flags 
       endc
;
;************************************************************************
; Configuraci¢n del PIC para esta rutina de escaneo del teclado.
;
TECLADO      bsf _rp0                ; Pagina 1
             movlw b'11110000'       ; RB<0-3> Salidas a Columnas
             movwf trisb             ; RB<4-7> Entradas a Filas
             bcf _rbpu               ; activa pull_up
             bcf _rp0                ; Pagina 0
;
             clrf Static             ; Flag de proceso
Test         clrf Num_tecla          ; Contador teclas a 0.
             movlw 0x0E              ; 0000 1110 <==
             movwf portb             ; al portb
             nop                     ; espera para asegurar la se¤al

Que_tecla    btfss portb,4           ; Salta la sig. si RB<4>=1
             goto CRONOS             ; A temporizar
             incf Num_tecla,f        ; 

             btfss portb,5
             goto CRONOS
             incf Num_tecla,f

             btfss portb,6
             goto CRONOS
             incf Num_tecla,f

             btfss portb,7
             goto CRONOS
             incf Num_tecla,f

             movlw 0x10              ; Valor limite de Num_tecla.
             subwf Num_tecla,w
             btfsc _z                ; Si _z=0 el resultado no fu‚ 0.
             goto No_Tecla           ; Si _z=1 lleg¢ a m ximo de Num_tecla.
             bsf _c                  ; Carry a 1
             rlf portb,f             ; xxxx 
             goto Que_tecla

No_Tecla     movlw 0x80              ; 0x080 c¢digo de que no hay tecla
             movwf Num_tecla         ; pulsada
Fuera        return                  ; Retorno
;
;
;*************************************************************************
CRONOS       btfsc Static,7          ; Flag.Si bit 7=0 es 2§ pasada.Si bit 7=1..
             goto CRONOS_1           ; salta esta instruccion.
             bsf Static,7            ; Flag de proceso
             movf Num_tecla,w        ; 1§ pasada
             movwf Temp_Tecla        ; guarda valor de Num_tecla en temporal..
             goto CRONOS_2           ; y va a temporizar.

CRONOS_1     bcf Static,7            ; Es la 2§ pasada.Baja Flag de aviso..
             movf Num_tecla,w        ; Num_tecla==>w
             subwf Temp_Tecla,w      ; RESTA.
             btfss _z                ; Si _z=1 ==>Num_tecla=Temp_Tecla, va $+1
             goto No_Tecla           ; Si _z=0 resultado <> 0.
             movf Num_tecla,w        ; Num_tecla=desplazamiento en tabla
             call Tabla              ; localizaci¢n del valor de la tecla
             movwf Num_tecla         ; w retorna con el valor. 
             goto Fuera              ; Num_tecla ya contiene el c¢digo de tecla.
;
;
;*************************************************************************
;Temporizaci¢n para eliminar el efecto de los rebotes
;*************************************************************************
;
;Temporizaci¢n total 20,736 ms con una frecuencia de trabajo de 4MHz
;
;
CRONOS_2     movlw 0x05              ; Carga del bucle externo. 
             movwf CONT1

CRONOS_3     clrf CONT2              ; 00 y decrementa pasando a FFh
             decfsz CONT2,f          ; En este bucle anidado...
             goto $ - 1              ; se cuentan 0,000768æs.

             decfsz CONT1,f          ; En este bucle externo..
             goto CRONOS_3           ; se cuenta 9 veces el bucle interno.
             goto Test               ; va a realizar  2§ escaneo.
;
Tabla       addwf 0x02,f             ; pcl + w(desplazamiento en Tabla)
            retlw 1
            retlw 4
            retlw 7
            retlw 0x0A
            retlw 2
            retlw 5
            retlw 8
            retlw 0
            retlw 3
            retlw 6
            retlw 9
            retlw 0x0B
            retlw 0x0F
            retlw 0x0E
            retlw 0x0D
            retlw 0x0C



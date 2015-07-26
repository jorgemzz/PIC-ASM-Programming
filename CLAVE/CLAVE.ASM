;-------------------------------------------------------------------------
; CLAVE.ASM
; Autor: Mikel Etxebarria
;       (c) Microsystems Engineering
;-------------------------------------------------------------------------
;
;El programa de car cter did ctico que se presenta a continuaci¢n pretende
;emular un sistema de contol de acceso.
;
;Mediante un teclado matricial de 16 teclas conectado a la puerta B, el usua-
;rio pulsa la tecla A de apertura, e introduce una clave de 4 d¡gitos. Si es
;correcta se activa un rel‚ conectado a la l¡nea RA4 durante un segundo, si-
;mulando la apertura de una puerta. Se dan tres oportunidades para introducir
;la clave correcta. Cada pulsaci¢n va precedida de un beep generado por el
;piezoel‚ctrico conectado en RA3.
;
;La tecla C permite realizar el cambio de clave pidiendo una nueva y la
;correspondiente confirmaci¢n.
;
;La pantalla LCD conectada tambi‚n a la puerta B ir  presentando los oportu-
;nos mensajes.
;
;En la memoria EEPROM de datos disponible en los dispositivos 16C84 quedar 
;registrada, de forma permanente, la clave actual.
;
;
                list    p=16c84         ;Tipo de procesador

                cblock  0x11

                        digito_1
                        digito_2
                        digito_3
                        digito_4        ;Variables para los d¡gitos clave
                        di_tem_1
                        di_tem_2
                        di_tem_3
                        di_tem_4        ;Temporales para los d¡gitos

                        cont_err        ;Contador de fallos
                        cont_tecla      ;Contador de teclas pulsadas
                        temp_1
                        temp_2          ;Variables temporales
                        Delay_1
                        Delay_2
                        Delay_3         ;Variables para la temporizaci¢n de 1 s

                endc                                

                include "16cxx.h"

                org     0               ;Vector de inicio
                goto    Inicio

                org     5

tabla           movwf   pcl             ;Desplazamiento sobre la tabla
Mens_1          equ     $
                retlw   '('
                retlw   'A'
                retlw   ')'
                retlw   ' '
                retlw   'A'
                retlw   'p'
                retlw   'e'
                retlw   'r'
                retlw   't'
                retlw   'u'
                retlw   'r'
                retlw   'a'
                retlw   0x00

Mens_1_1        equ     $
                retlw   '('
                retlw   'C'
                retlw   ')'
                retlw   ' '
                retlw   'C'
                retlw   'a'
                retlw   'm'
                retlw   'b'
                retlw   'i'
                retlw   'o'
                retlw   ' '
                retlw   'C'
                retlw   'l'
                retlw   'a'
                retlw   'v'
                retlw   'e'
                retlw   0x00

Mens_2          equ     $
                retlw   'C'
                retlw   'l'
                retlw   'a'
                retlw   'v'
                retlw   'e'
                retlw   ' '
                retlw   '?'
                retlw   ' '
                retlw   0x00

Mens_2_1        equ     $
                retlw   '('
                retlw   'C'
                retlw   ')'
                retlw   ' '
                retlw   'C'
                retlw   'a'
                retlw   'n'
                retlw   'c'
                retlw   'e'
                retlw   'l'
                retlw   'a'
                retlw   'r'
                retlw   0x00

Mens_3          equ     $
                retlw   'N'
                retlw   'u'
                retlw   'e'
                retlw   'v'
                retlw   'a'
                retlw   ' '
                retlw   'C'
                retlw   'l'
                retlw   'a'
                retlw   'v'
                retlw   'e'
                retlw   ' '
                retlw   0x00

Mens_4          equ     $
                retlw   'C'
                retlw   'o'
                retlw   'n'
                retlw   'f'
                retlw   'i'
                retlw   'r'
                retlw   'm'
                retlw   'a'
                retlw   'r'
                retlw   ' '
                retlw   0x00

Mens_5          equ     $
                retlw   'P'
                retlw   'u'
                retlw   'e'
                retlw   'd'
                retlw   'e'
                retlw   ' '
                retlw   'P'
                retlw   'a'
                retlw   's'
                retlw   'a'
                retlw   'r'
                retlw   0x00

Mens_6          equ     $
                retlw   'A'
                retlw   'C'
                retlw   'C'
                retlw   'E'
                retlw   'S'
                retlw   'O'
                retlw   ' '
                retlw   'D'
                retlw   'E'
                retlw   'N'
                retlw   'E'
                retlw   'G'
                retlw   'A'
                retlw   'D'
                retlw   'O'
                retlw   0x00

                include "teclado.h"
                include "lcd.h"

;-------------------------------------------------------------------------
;Key_Off: Esta rutina genera un Beep y espera que la tecla reci‚n pulsada
;se suelte. Debe usarse justo despu‚s de llamar a la rutina TECLADO
;
Key_Off         movf    Num_tecla,w
                movwf   temp_1          ;Guarda temporalmente la tecla
                bcf     porta,3         ;Activa zumbador beep
                movlw   1
                call    Delay           ;Temporiza
                bsf     porta,3         ;Beep OFF
Key_Off_No      call    TECLADO
                movlw   0x80
                subwf   Num_tecla,w
                btfss   _z              ;Se ha soltado la tecla ?
                goto    Key_Off_No      ;Todavia no
                movf    temp_1,w        ;Ahora si
                movwf   Num_tecla       ;Repone la tecla pulsada
                return


;-------------------------------------------------------------------------
;Delay: Esta rutina realiza una temporizaci¢n que depende del valor del
;acumulador en el momento en que se le llama.
;
Delay           movwf   Delay_1
Delay_loop      decfsz  Delay_3,f
                goto    Delay_loop
                decfsz  Delay_2,f
                goto    Delay_loop
                decfsz  Delay_1,f
                goto    Delay_loop
                return

;-------------------------------------------------------------------------
;Mensaje: Esta rutina saca al LCD el mensaje cuyo inicio est  indicado en
;el acumulador

Mensaje         movwf   temp_1          ;Salva posici¢n de la tabla
Mensaje_1       movf    temp_1,w        ;Recupera posici¢n de la tabla
                call    tabla           ;Busca caracter de salida
                movwf   temp_2          ;Guarda el caracter
                movf    temp_2,f
                btfss   _z              ;Mira si es el £ltimo
                goto    No_es_ultimo
                return
No_es_ultimo    call    LCD_DATO        ;Visualiza en el LCD
                incf    temp_1,f        ;Siguiente caracter
                goto    Mensaje_1       ;Repite con siguiente caracter

;-------------------------------------------------------------------------
;Control: Espera que se tecleen los cuatro d¡gitos de la clave, los alma-
;cena en digito_1 .. digito_4 y visualiza ---- en LCD. La tecla C permite
;cancelar


Control         movlw   4
                movwf   cont_tecla      ;Inicia contador de pulsaciones
                movlw   digito_1
                movwf   fsr             ;Apunta al inicio del buffer de tecla
N_tecla         call    TECLADO         ;Explora el teclado
                movlw   0x80
                subwf   Num_tecla,w
                btfsc   _z              ;Hay alguna pulsada ?
                goto    N_tecla         ;NO
                call    UP_LCD          ;Reconfigura el LCD
                movlw   '-'
                call    LCD_DATO        ;Visualiza el -
                call    Key_Off         ;Genera Beep y espera se libere
                movlw   0x0c
                subwf   Num_tecla,w
                btfsc   _z              ;Mira si es tecla C (Cancelar)
                goto    Es_Can
                goto    No_es_Can
Es_Can          bsf     temp_1,1        ;Activa Flag de cancelaci¢n
                return

No_es_Can       bcf     temp_1,1        ;Desactiva Flag de cancelaci¢n
                movf    Num_tecla,w
                movwf   indf            ;Almacena la tecla en el buffer
                incf    fsr,f           ;Siguiente posici¢n del buffer
                decfsz  cont_tecla,f    ;Actualiza contador de tecla
                goto    N_tecla         ;Repite el proceso
                return

;-------------------------------------------------------------------------
;Okey: Comprueba si la clave introducida en el buffer coincide con la de
;la EEPROM. En caso afirmativo el flag carry se pone a "0", de lo contra-
;rio a "1".
;
Okey            bcf     temp_1,0        ;Borra flag de error
                movlw   4
                movwf   cont_tecla      ;N£mero de bytes a comprobar
                movlw   digito_1
                movwf   fsr             ;Primer d¡gito
                clrf    eeadr           ;Primera posici¢n de la EEPROM
Okey_1          call    EE_Read         ;Lee byte de la EEPROM
                movf    eedato,w        
                andlw   0x0f            
                subwf   indf,w          ;Lo compara con el del buffer
                btfss   _z              ;Mira si es igual
                bsf     temp_1,0        ;NO, activa flag de error
                incf    eeadr,f         ;Siguiente posici¢n de la EEPROM
                incf    fsr,f           ;Siguiente d¡gito
                decfsz  cont_tecla,f    ;Repite la comprobaci¢n
                goto    Okey_1
                return                                                                        
                

;-------------------------------------------------------------------------
;EE_Read: Lee un byte de la EEPROM
;
EE_Read         bsf     _rp0            ;Selecciona banco 1
                bsf     _rd             ;Orden de lectura
                bcf     _rp0            ;Selecci¢n banco 0
                return

;-------------------------------------------------------------------------
;EE_Write: Graba un byte en la EEPROM
;
EE_Write        bsf     _rp0            ;Selecciona banco 1
                bsf     _wren           ;Permiso de escritura
                movlw   0x55
                movwf   eecon2
                movlw   0xaa
                movwf   eecon2          ;Secuencia seg£n Microchip
                bsf     _wr             ;Orden de escritura
                bcf     _wren           ;Evita posteriores escrituras
Wait            btfss   _eeif           ;Testear final de byte grabado
                goto    Wait
                bcf     _eeif           ;Reponer flag de final
                bcf     _rp0            ;Selecci¢n banco 0
                return

Inicio          call    UP_LCD
                call    LCD_INI         ;Inicializa LCD
                call    DISPLAY_ON_CUR_OFF

                movlw   b'00011000'
                movwf   porta           ;Desconecta rel‚ y zumbador

                clrf    eeadr           ;Posici¢n EEPROM de la firma
                call    EE_Read         ;Lee byte de EEPROM
                movlw   0xff
                subwf   eedato,w
                btfss   _z              ;Mira si est  usada
                goto    Si_usada

;Carga en la EEPROM la clave 1234 por defecto

No_usada        clrf    eedato
                movlw   4               ;N£mero de bytes a guardar
                movwf   temp_1
No_usada_1      incf    eedato,f        ;Clave a guardar
                call    EE_Write        ;Graba dato
                incf    eeadr,f
                decfsz  temp_1,f
                goto    No_usada_1

Si_usada        call    BORRA_Y_HOME    ;Actualiza LCD
                movlw   Mens_1          ;Offset del mensaje 1
                call    Mensaje         ;Visualiza "Apertura (A)"
                movlw   0xc0
                call    LCD_REG         ;Ajusta posici¢n del mensaje
                movlw   Mens_1_1        ;Offset del mensaje 1.1
                call    Mensaje         ;Visualiza "Cambio Clave (C)"
No_hay          call    TECLADO         ;Explora el teclado
                movlw   0x80
                subwf   Num_tecla,w
                btfsc   _z              ;Hay tecla
                goto    No_hay
                call    Key_Off         ;Genera beep y espera se libere
                movlw   0x0A
                subwf   Num_tecla,w
                btfsc   _z              ;Es la tecla A (Apertura) ?
                goto    Si_es_A
No_es_A         movlw   0x0C
                subwf   Num_tecla,w
                btfss   _z              ;Es la tecla C (Cambio clave) ?
                goto    No_hay

Si_es_C         call    UP_LCD          ;Reconfigura LCD
                call    BORRA_Y_HOME    ;Actualiza
                movlw   Mens_2_1        ;Offset del mensaje 2.1
                call    Mensaje         ;Visualiza "Cancelar (C)"
                movlw   0xc0
                call    LCD_REG         ;Reposiciona cursor del LCD
                movlw   Mens_2          ;Offset del mensaje 2
                call    Mensaje         ;Visualiza "Clave ?"
                call    Control         ;Espera se introduza clave actual

                btfsc   temp_1,1        ;Hubo cancelaci¢n ??
                goto    Si_usada        ;Si.

                call    Okey            ;Comprueba si es correcta
                btfsc   temp_1,0        ;Es v lida ?
                goto    Si_usada        ;No, vuelta al principio 
                call    UP_LCD          ;Si. Reconfigura LCD
                call    BORRA_Y_HOME    ;Borra e inicia el LCD
                movlw   Mens_2_1        ;Offset del mensaje 2.1
                call    Mensaje         ;Visualiza "(C) Cancelar"
                movlw   0xc0            ;Reposiciona el LCD
                call    LCD_REG
                movlw   Mens_3          ;Offset del mensaje 3
                call    Mensaje         ;Visualiza "Nueva clave"
                call    Control         ;Espera que se pulse la nueva clave

                btfsc   temp_1,1        ;Hubo cancelaci¢n ??
                goto    Si_usada        ;Si.

                call    UP_LCD          ;Reconfigura LCD
                call    BORRA_Y_HOME    ;Borra e inicia LCD
                movlw   Mens_2_1        ;Offset del mensaje 2.1
                call    Mensaje         ;Visualiza "(C) Cancelar"
                movlw   0xc0            ;Reposicionar LCD
                call    LCD_REG
                movlw   Mens_4          ;Offset del mensaje 4
                call    Mensaje         ;Visualiza "Confirmar"
                movf    digito_1,w
                movwf   di_tem_1
                movf    digito_2,w
                movwf   di_tem_2
                movf    digito_3,w
                movwf   di_tem_3
                movf    digito_4,w
                movwf   di_tem_4        ;Salva temporalmente 1¦ clave

                call    Control         ;Lee la segunda clave

                btfsc   temp_1,1        ;Hubo cancelaci¢n ??
                goto    Si_usada        ;Si.

                movf    digito_1,w
                subwf   di_tem_1,w      ;Compara 1er.d¡gito
                btfss   _z              ;Igual ?
                goto    Si_usada        ;No

                movf    digito_2,w
                subwf   di_tem_2,w      ;Compara 2§ d¡gito
                btfss   _z              ;Igual ?
                goto    Si_usada        ;No

                movf    digito_3,w
                subwf   di_tem_3,w      ;Compara 3er.d¡gito
                btfss   _z              ;Igual ?
                goto    Si_usada        ;No

                movf    digito_4,w
                subwf   di_tem_4,w      ;Compara 4§ d¡gito
                btfss   _z              ;Igual ?
                goto    Si_usada        ;No

;Graba en la EEPROM la nueva clave

                movlw   4
                movwf   cont_tecla      ;N§ de octetos a grabar
                movlw   digito_1
                movwf   fsr             ;Indice de d¡gitos
                clrf    eeadr           ;Primera direci¢n de EEPROM
Otro_digito     movf    indf,w          ;Carga digito
                movwf   eedato
                call    EE_Write        ;Graba en EEPROM
                incf    fsr,f           ;Siguiente d¡gito
                incf    eeadr,f         ;Siguiente posici¢n EEPROM
                decfsz  cont_tecla,f
                goto    Otro_digito
                goto    Si_usada


Si_es_A         movlw   3
                movwf   cont_err        ;Establece n£mero de intentos
Otro_mas        call    UP_LCD          ;Reconfigura LCD
                call    BORRA_Y_HOME    ;Actualiza
                movlw   Mens_2_1        ;Offset del mensaje 2.1
                call    Mensaje         ;Visualiza "Cancelar (C)"
                movlw   0xc0
                call    LCD_REG         ;Reposicionar cursor del LCD
                movlw   Mens_2          ;Offset del mensaje 2
                call    Mensaje         ;Visualiza "Clave ?"
                call    Control         ;Espera que se introduzca la clave

                btfsc   temp_1,1        ;Hubo cancelaci¢n ??
                goto    Si_usada        ;Si.

                call    Okey            ;Comprueba si es correcta
                btfsc   temp_1,0        ;Es v lida ?
                goto    No_Ok           ;No
                call    UP_LCD          ;Reconfigura LCD
                call    BORRA_Y_HOME    ;Borra e inicia LCD
                movlw   Mens_5          ;Offset del mensaje 5
                call    Mensaje         ;Visualiza "Puede Pasar"
                bcf     porta,4         ;Si, activa rel‚
                bcf     porta,3         ;Activa beep
                movlw   0x0a
                call    Delay           ;Temporiza 2 seg.
                bsf     porta,4         ;Desactiva rel‚
                bsf     porta,3         ;Desactiva beep
                clrf    cont_err        ;Pone a 0 contador de intentos
                goto    Si_usada        ;Repite el proceso

No_Ok           decfsz  cont_err,f      ;Intento fallido
                goto    Otro_mas        ;Repite otro intento
                call    UP_LCD          ;Reconfigura LCD
                call    BORRA_Y_HOME    ;Borra e inicia LCD
                movlw   Mens_6          ;Offset del mensaje 6
                call    Mensaje         ;Visualiza "ACCESO DENEGADO"
                movlw   0x10
                call    Delay           ;Temporiza
                goto    Si_usada        ;Repite el proceso

                end


; -------------------------------------------------------------------------
; Programa: LCH.H
; Autor: Jorge Ra£l Mu¤oz
;       (c) Microsystems Engineering
;
; El conjunto de rutinas que se presentan a continuaci¢n permiten realizar
; las tareas b sicas de control del m¢dulo de visualizaci¢n LCD
; -------------------------------------------------------------------------
                                        
#define ENABLE       bsf porta,2        ;Activa E
#define DISABLE      bcf porta,2        ;Desactiva
#define LEER         bsf porta,1        ;Pone LCD en Modo RD
#define ESCRIBIR     bcf porta,1        ;Pone LCD en Modo WR
#define OFF_COMANDO  bcf porta,0        ;Desactiva RS (modo comando)
#define ON_COMANDO   bsf porta,0        ;Activa RS
;
;-------------------------------------------------------------------------
;UP_LCD: Configuraci¢n PIC para el LCD.
;
UP_LCD          bsf     _rp0            ;Banco 1
                clrf    trisb           ;RB <0-7> salidas digitales
                movlw   B'00000000'     ;RA0=RS||RA1=R/W||RA2=E
                movwf   trisa           ;RA<0,1,2> Sd.  RA<3,4> Ed.
                movlw   B'10000111'     ;Preescaler asignado al
                movwf   opcion          ;timer 0 Div 1:128
                bcf     _rp0            ;Banco 0
                movlw   0
                movwf   intcon          ;Desactivar interrupciones.
                OFF_COMANDO             ;RS=0
                DISABLE                 ;E=0
                return
;
;--------------------------------------------------------------------------
;LCD_BUSY: Lectura del Flag Busy y la direcci¢n.
;
LCD_BUSY        LEER                    ;Pone el LCD en Modo RD
                bsf     _rp0            
                movlw   H'FF'
                movwf   trisb           ;Puerta B como entrada
                bcf     _rp0            ;Selecciona el banco 0
                ENABLE                  ;Activa el LCD
                nop
                btfsc   portb,7         ;Chequea bit de Busy
                goto    $-1
                DISABLE                 ;Desactiva LCD
                bsf     _rp0                               
                clrf    trisb           ;Puerta B salida
                bcf     _rp0                              
                ESCRIBIR                ;Pone LCD en modo WR
                return
;
;--------------------------------------------------------------------------
;LCD_E: Pulso de Enable
;
LCD_E           ENABLE                  ;Activa E
                nop
                DISABLE                 ;Desactiva E
                return
;
;--------------------------------------------------------------------------
;LCD_DATO: Escritura de datos en DDRAM o CGRAM
;
LCD_DATO        OFF_COMANDO             ;Desactiva RS (modo comando)
                movwf   portb           ;Valor ASCII a sacar por portb
                call    LCD_BUSY        ;Espera a que se libere el LCD
                ON_COMANDO              ;Activa RS (modo dato).
                goto    LCD_E           ;Genera pulso de E

;--------------------------------------------------------------------------
;LCD_REG: Escritura de comandos del LCD
;W=C¢digo de comando para el LCD
;W ==> portb
;
LCD_REG         OFF_COMANDO             ;Desactiva RS (modo comando)
                movwf   portb           ;C¢digo de comando.
                call    LCD_BUSY        ;LCD libre?.
                goto    LCD_E           ;SI.Genera pulso de E.
;
;---------------------------------------------------------------------------
;LCD_INI: icializaci¢n del LCD 
;
LCD_INI         movlw   D'3'            ;Contador de inicializaci¢n
                movwf   CONT1           ;interface de 8 bits,2 l¡neas de
                clrwdt               
                movlw   b'00111000'     ;caracteres 5-7,datos de 8 bits.(#)
                call    LCD_REG         ;Comando.
                movlw   H'D6'           ;5ms.(Especificaci¢n de Fabricante)
                movwf   tmr0           
                btfss   intcon,2        ;Rebos¢ el timer 0?
                goto    $-1             ;NO.
                bcf     intcon,2        ;SI.Borrar flag TOIF.
                decfsz  CONT1,1         ;Decrementar contador
                goto    $-9
                return
;
;-------------------------------------------------------------------------
;BORRA_Y_HOME: Borra el display y retorna el cursor a la posici¢n 0 
;
BORRA_Y_HOME    movlw   b'00000001'     ;Borra LCD y Home.
                call    LCD_REG
                return
;
;-------------------------------------------------------------------------
;DISPLAY_ON_CUR_OFF: Control ON/OFF del display y cursor.
;Activa Display desactiva cursor.

DISPLAY_ON_CUR_OFF
                movlw   b'00001100'     ;LCD on,cursor off.
                call    LCD_REG
                return


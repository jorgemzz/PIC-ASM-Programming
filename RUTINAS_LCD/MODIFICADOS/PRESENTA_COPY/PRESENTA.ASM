;---------------------------------------------------------------------------         
; PRESENTA.ASM
; Autor: Mikel Etxebarria
;---------------------------------------------------------------------------
;
; El programa que se presenta a continuaci¢n consiste en sacar unos mensajes
; de presentaci¢n del sistema de evaluaci¢n Micro'PIC Trainer por el m¢dulo
; LCD de visualizaci¢n
;---------------------------------------------------------------------------
           
           list p=16c84      ;Procesador PIC16c84  
           list c=132        ;Listado a 132 caracteres

TIMER0     equ 01            ;Registro del TIMER0
OPCION     equ 0x1           ;Registro de opciones,p gina 1
PCL        equ 0x2           ;Registro PC
PCLATH     equ 0xa           ;Registro alto del PC
STATUS     equ 03            ;Registro de estado
RA         equ 05            ;Puerta A
RB         equ 06            ;Puerta B
TRISA      equ 0x5           ;Reg. de programaci¢n de la puerta A, p gina 1
TRISB      equ 0x6           ;Reg. de programaci¢n de la puerta B, p gina 1 
INTCON     equ 0xb           ;Registro de control de interrupciones
DATO_A     equ 0xc           ;Registro del dato A
DATO_B     equ 0xd           ;Registro del dato B
RESUL      equ 0xe           ;Registro de resultados
TEMPO1     equ 0xf           ;Registro temporal 1
TEMPO2     equ 0x10          ;Registro temporal 2
OFFSET     equ 0x11          ;Variable de desplazamientos de mensajes

           org 0             ;Vector de RESET
           goto INICIO

           org 5

INICIO     bsf STATUS,5      ;Selecciona el banco 1 de datos 
           clrf TRISB        ;RB se programa como salida     
           movlw b'00011000' ;RA<4:3> se programan como entradas
           movwf TRISA       ;RA<2:0> se programan como salidas
           movlw b'10000111'
           movwf OPCION      ;Asigna preescaler al TMR0

           bcf STATUS,5      ;Selecciona el banco 0 de datos

           movlw b'00000000'
           movwf INTCON      ;Desactiva interrupciones
           bcf RA,0          ;Desactiva RS del m¢dulo LCD
           bcf RA,2          ;Desactiva E del m¢dulo LCD
           goto START

DATOS      addwf PCL,1
           retlw '*'         ;OFFSET = 0
           retlw '*'
           retlw ' '
           retlw 'P'
           retlw 'R'
           retlw 'E'
           retlw 'S'
           retlw 'E'
           retlw 'N'
           retlw 'T'
           retlw 'A'
           retlw ' '
           retlw '*'
           retlw '*'
           retlw 0x0

           retlw '"'         ;OFFSET 0xf
           retlw '"'        ;
           retlw 'R'
           retlw 'U'
           retlw 'T'
           retlw 'I'
           retlw 'N'
           retlw 'A'
           retlw 'S'
           retlw ' '
           retlw ' '
           retlw 'L'
           retlw 'C'
           retlw 'D'
           retlw '"'
           retlw '"'
           retlw 0

           retlw 'C'
           retlw 'O'
           retlw 'N'
           retlw ' '
           retlw 0xe4         ;OFFSET 0x20
           retlw 'C'
           retlw 'O'
           retlw 'N'
           retlw 'T'
           retlw 'R'
           retlw 'O'
           retlw 'L'
           retlw 'A'
           retlw 'D'
           retlw 'O'
           retlw 'R'
           retlw 0

           retlw 'P'
           retlw 'I'
           retlw 'C'
           retlw ' '
           retlw '1'         ;OFFSET 0x31
           retlw '6'
           retlw 'F'
           retlw '8'
           retlw '4'
           retlw 'A'
           retlw ' '
           retlw 0

           retlw 'D'
           retlw 'E'
           retlw ' '           
           retlw 'M'         ;OFFSET 0x3d
           retlw 'I'
           retlw 'C'
           retlw 'R'
           retlw 'O'
           retlw 'C'
           retlw 'H'
           retlw 'I'
           retlw 'P'
           retlw 0

           retlw 'M'         ;OFFSET 0x4a
           retlw 'o'
           retlw 'd'
           retlw 'u'
           retlw 'l'
           retlw 'o'
           retlw ' '
           retlw 'L'
           retlw 'C'
           retlw 'D'
           retlw ' '
           retlw 0

           retlw 'T'         ;OFFSET 0x56
           retlw 'S'
           retlw ' '
           retlw '1'
           retlw '6'
           retlw '2'
           retlw '0'
           retlw 'A'
           retlw '-'
           retlw '1'
           retlw '7'
           retlw '_'
           retlw '2'
           retlw ' '
           retlw 0

           retlw 'F'         ;OFFSET 0x65
           retlw 'U'
           retlw 'E'
           retlw 'N'
           retlw 'T'
           retlw 'E'
           retlw 'S'
           retlw ':'
           retlw 0

           retlw 't'         ;OFFSET 0x6e
           retlw 'u'
           retlw 't'
           retlw 'o'
           retlw 'r'
           retlw 'i'
           retlw 'a'
           retlw 'l'
           retlw 'e'
           retlw 's'
           retlw ' '
           retlw 0

           retlw 'b'         ;OFFSET 0x7a
           retlw 'a'
           retlw 'j'
           retlw 'a'
           retlw 'd'
           retlw 'o'
           retlw 's'
           retlw ' '
           retlw 'd'
           retlw 'e'
           retlw ' '
           retlw 0

           retlw 'R'         ;OFFSET 0x86
           retlw 'O'
           retlw 'B'
           retlw 'O'
           retlw 'T'
           retlw 'I'
           retlw 'X'
           retlw 0

           retlw 0xe4         ;OFFSET 0x8e
           retlw 'C'
           retlw 'O'
           retlw 'N'
           retlw 'T'
           retlw 'R'
           retlw 'O'
           retlw 'L'
           retlw ' '
           retlw 0

           retlw 'y'         ;OFFSET 0x98
           retlw ' '
           retlw 'O'
           retlw 'T'
           retlw 'R'
           retlw 'O'
           retlw 'S'
           retlw '.'
           retlw '.'
           retlw '.'
           retlw 0
           
           retlw '*'         ;OFFSET 0xA3
           retlw '*'
           retlw ' '
           retlw 'T'
           retlw 'H'
           retlw 'E'
           retlw ' '
           retlw ' '
           retlw 'E'
           retlw 'N'
           retlw 'D'
           retlw ' '
           retlw '*'
           retlw '*'
           retlw 0

           retlw '*'         ;OFFSET 0xb2
           retlw '*'
           retlw '*'
           retlw '*'
           retlw '*'
           retlw '*'
           retlw '*'
           retlw '*'
           retlw '*'
           retlw '*'
           retlw '*'
           retlw '*'
           retlw '*'
           retlw '*'
           retlw '*'
           retlw '*'
           retlw 0

DATO_1     addwf PCL,1
           retlw 'L'
           retlw 'o'
           retlw 'b'
           retlw 'o'
           retlw ' '
           retlw 'V'
           retlw 'e'
           retlw 'l'
           retlw 'o'
           retlw 'z'
           retlw ' '
           retlw ' '
           retlw ' '
           retlw ' '
           retlw ' '
           retlw 0x0

DATO_2     addwf PCL,1
           retlw 'C'
           retlw 'o'
           retlw 'm'
           retlw 'p'
           retlw 'a'
           retlw 'n'
           retlw 'y'
           retlw 0x0

;LCD_BUSY Chequea el estado del flag Busy del LCD y espera a que finalice
;cualquier comando previo antes de retornar

LCD_BUSY   bsf RA,1          ;Pone el LCD en modo RD
           bsf STATUS,5      ;Selecciona el banco 1
           movlw 0xff
           movwf TRISB       ;Puerta B es entrada
           bcf STATUS,5      ;Selecciona el banco 0
           bsf RA,2          ;Activa el LCD (E)
           nop
L_BUSY     btfsc RB,7        ;Chequea el bit busy
           goto L_BUSY
           bcf RA,2          ;Desactiva el LCD (E)
           bsf STATUS,5      ;Selecciona el banco 1
           clrf TRISB        ;Puerta B salida
           bcf STATUS,5      ;Selecciona el banco 0
           bcf RA,1          ;Pone el LCD en modo WR
           return

;LCE_E Genera un pulso en la se¤al E de 1 uS de duraci¢n. Esto es posible
;gracias a la NOP y a que el PIC trabaja a 4MHz. Para velocidades superiores
;habr  que insertar alguna NOP adicional para no rebasar la duraci¢n m¡nima
;del LCD

LCD_E      bsf RA,2          ;Activa E
           nop               ;pausa
           bcf RA,2          ;Desactiva E
           return

;LCD_DATO  Deposita el c¢digo ASCII presente en W, sobre RB. Espera que el
;LCD ejecute la £ltima operaci¢n y genera el pulso E.

LCD_DATOS  bcf RA,0          ;Desactiva RS (modo comando)
           movwf RB          ;Valor ASCII a sacar por RB
           call LCD_BUSY     ;Espera que se libere el LCD
           bsf RA,0          ;Activa RS (modo dato)
           goto LCD_E        ;Genera pulso en se¤al E

;LCD_REG Deposita el c¢digo del comando presente en W, sobre RB. Espera que
;el LCD ejecute la £ltima operaci¢n y genera el pulso E.

LCD_REG    bcf RA,0          ;Desactiva RS (Modo comando)
           movwf RB          ;C¢digo del comando
           call LCD_BUSY     ;Espera que se libere el LCD
           goto LCD_E        ;Genera pulso en se¤al E

;LCD_INI Realiza la inicializaci¢n del LCD seg£n los tiempos marcados por el
;fabricante. Se inicia con un interface de 8 bits, 2 l¡neas de visualizaci¢n,
;y caracteres de 5 * 7. Se temporiza 15 mS.

LCD_INI    movlw b'00111000'
           call LCD_REG
           call DELAY_5MS
           movlw b'00111000'
           call LCD_REG
           call DELAY_5MS
           movlw b'00111000'
           call LCD_REG
           call DELAY_5MS
           return

;DELAY_5MS genera una temporizaci¢n de 5mS necesario para la secuencia de
;inicio del LCD

DELAY_5MS  movlw 0x1a       
           movwf DATO_B
           clrf DATO_A
DELAY_1    decfsz DATO_A,1
           goto DELAY_1
           decfsz DATO_B,1
           goto DELAY_1
           return

;DELAY10 genera, con ayuda del TMR0 y el preescaler, una temporizaci¢n de 
;10 ms que se repite tantas veces como indique la variable TEMPO1

DELAY10    bcf INTCON,2      ;Borra flag del TMR0
           movlw 0xd8
           movwf TIMER0      ;Carga TMR0 para que cuente 39
DELAY10_1  btfss INTCON,2    ;Espera overflow del TMR0
           goto DELAY10_1
           decfsz TEMPO1,1   ;Repite 10 veces
           goto DELAY10
           return

;DELAY1S temporiza 1 segundo

DELAY1S    movlw 0x64        ;Repite la rutina DELAY10 (de 10 mS) 100
           movwf TEMPO1      ;veces
           call DELAY10
           return

;BLINK mantiene el LCD activado durante 2 seg. y a continuaci¢n genera 
;una intermitencia de 6 veces del encendido y apagado del LCD, de 1/4 segundo 
;cada una

BLINK      movlw 0xc8
           movwf TEMPO1
           call DELAY10      ;Temporiza 2 segundos con el mensaje
           movlw 6
           movwf TEMPO2      ;6 veces de intermitencia
BLINK_1    movlw b'00001000'
           call LCD_REG      ;Apaga LCD
           movlw 25
           movwf TEMPO1
           call DELAY10      ;Temporiza 1/2 segundo
           movlw b'00001100'
           call LCD_REG      ;Enciende LCD
           movlw 25
           movwf TEMPO1 
           call DELAY10      ;Temporiza 1/2 segundo
           decfsz TEMPO2,1
           goto BLINK_1
           return


MENS_1     clrf RESUL
MENS_1_1   movf RESUL,0      ;Inicia contador de caracteres     
           call DATO_1       ;Saca caracter
           iorlw 0
           btfsc STATUS,2    ;¨Es el £ltimo?
           return            ;Si
           call LCD_DATOS    ;Visualiza caracter
           incf RESUL,1      ;Incrementa contador de caracteres
           movlw 10
           movwf TEMPO1      ;Temporiza 100mS
           call DELAY10
           movlw b'00011000' ;Desplazamiento a la izda.
           call LCD_REG
           goto MENS_1_1

MENS_2     clrf RESUL        ;Inicia contador de caracteres
MENS_2_1   movf RESUL,0           
           call DATO_2       ;Coge el caracter
           iorlw 0
           btfsc STATUS,2    ;¨Es el £ltimo?
           return            ;Si
           call LCD_DATOS    ;Visualiza caracter
           incf RESUL,1      ;Incrementa contador de caracteres
           movlw 10
           movwf TEMPO1      ;Temporiza 100mS
           call DELAY10
           goto MENS_2_1

MENS       clrf RESUL        ;Inicia contador de caracteres
MENS1      movf OFFSET,0     ;Coge el desplazamiento
           addwf RESUL,0           
           call DATOS        ;Coge el caracter
           iorlw 0
           btfsc STATUS,2    ;¨Es el £ltimo?
           return            ;Si
           call LCD_DATOS    ;Visualiza caracter
           incf RESUL,1      ;Incrementa contador de caracteres
           movlw 10
           movwf TEMPO1      ;Temporiza 100mS
           call DELAY10
           goto MENS1


START      call LCD_INI      ;Inicia LCD
START_1    movlw b'00000001' ;Borrar LCD y Home
           call LCD_REG
           movlw b'00000110' ;
           call LCD_REG
           movlw b'00001100' ;LCD On, cursor Off
           call LCD_REG
           movlw 0x8f        ;Direcci¢n £ltimo caracter 1¦ linea
           call LCD_REG
           call MENS_1       ;Mensaje "MicroSystems"
           movlw 0xd8        ;Direcci¢n 2¦ l¡nea
           call LCD_REG
           call MENS_2       ;Mensaje "Engenering"
           call BLINK        ;Intermitencia
           movlw b'00000001'
           call LCD_REG      ;Borra LCD y Home
           call DELAY1S      ;Temporiza 1 seg.
           movlw 0x81
           call LCD_REG      ;Posici¢n 1¦ fila
           clrf OFFSET
           call MENS         ;Mensaje "** PRESENTA **"
           call DELAY1S      ;Temporiza 1 seg.
           movlw 0xc0
           call LCD_REG      ;Posici¢n 2¦ fila
           movlw 0xf
           movwf OFFSET
           call MENS         ;Mensaje "PIC Trainer"
           call DELAY1S      ;Temporiza 1 seg.
           movlw b'00000001'
           call LCD_REG      ;Borra LCD y Home
           call DELAY1S      ;Temporiza 1 seg.
           movlw 0x20
           movwf OFFSET
           call MENS         ;Mensaje "Entrenador para"
           movlw 0xc0
           call LCD_REG      ;Posici¢n 2¦ fila
           movlw 0x31
           movwf OFFSET
           call MENS         ;Mensaje "PIC 16c7x/84"
           call DELAY1S      ;Temporiza 1 seg.
           movlw b'00000001'
           call LCD_REG      ;Borra LCD y home
           call DELAY1S      ;Temporiza 1 seg.
           movlw 0x3d
           movwf OFFSET
           movlw 0x82
           call LCD_REG      ;Posici¢n 1¦ linea
           call MENS         ;Mensaje "CONSTA DE:
           call BLINK        ;Parpadeo
           movlw b'00000001'
           call LCD_REG      ;Borra LCD y home
           call DELAY1S      ;temporiza 1 seg.
           movlw 0x4a
           movwf OFFSET
           call MENS         ;Mensaje "F. Alimentacion'
           movlw 0xc0
           call LCD_REG      ;Posici¢n 2¦ linea
           call DELAY1S      ;Temporiza 1 seg.
           movlw 0x56
           movwf OFFSET
           call MENS         ;Mensaje "Modulo grabador"
           call DELAY1S      ;Delay 1 seg
           movlw b'00000001'
           call LCD_REG      ;Borra LCD y Home
           call DELAY1S      ;Temporiza 1 seg
           movlw 0x65
           movwf OFFSET
           call MENS         ;Mensaje "5 entradas digi-"
           movlw 0xc0
           call LCD_REG      ;Posici¢n 2¦ linea
           movlw 0x6e
           movwf OFFSET
           call MENS         ;Mensaje "tales"
           call DELAY1S      ;Temporizaci¢n de 1 seg.
           movlw b'00000001'
           call LCD_REG      ;Borra LCD y home
           call DELAY1S      ;Temporiza 1 seg.
           movlw 0x7a
           movwf OFFSET
           call MENS         ;Mensaje "4 Entradas ana-"
           movlw 0xc0
           call LCD_REG      ;Posici¢n 2¦ linea
           movlw 0x86
           movwf OFFSET
           call MENS         ;Mensaje "l¢gicas"
           call DELAY1S      ;Temporiza 1 seg
           movlw b'00000001'
           call LCD_REG      ;Borra LCD y Home
           call DELAY1S      ;Temporiza 1 seg
           movlw 0x8e
           movwf OFFSET
           call MENS         ;Mensaje "8 Salidas a LED"
           movlw 0xc0
           call LCD_REG      ;Posici¢n 2¦ linea
           movlw 0x98
           movwf OFFSET
           call MENS         ;Mensaje "y a Display"
           call DELAY1S      ;Temporiza 1 seg.

           movlw b'00000001'
           call LCD_REG      ;Borra LCD y Home
           call DELAY1S      ;Temporiza 1 seg.
           movlw 0x81
           call LCD_REG      ;Posici¢n 1¦ fila
           movlw 0xa3
           movwf OFFSET
           call MENS         ;Mensaje "** PRESENTA **"
           call DELAY1S      ;Temporiza 1 seg.
           movlw 0xc0
           call LCD_REG      ;Posici¢n 2¦ fila
           movlw 0xb2
           movwf OFFSET
           call MENS         ;Mensaje "PIC Trainer"
           call DELAY1S      ;Temporiza 1 seg.

           call BLINK        ;Parpadeo
           call DELAY1S      ;Temporiza 1 seg.
           goto START_1
           
           END


;************************************************************************
;                            16CXX.H
;
;Fichero de cabecera con las definiciones de registros de los microcontro-
;ladores PIC 16CXX.
;
;                    Autor: Mikel Etxebarria
;                  (c) Microsystems Engineering
;************************************************************************

w                       equ 0           ;Referencia al acumulador
f                       equ 1           ;Referencia al registro fuente
indf                    equ 0x00        ;Direccionado indirecto
tmr0                    equ 0x01        ;Registro del timer 0
opcion                  equ 0x01        ;Registro de opciones
pcl                     equ 0x02        ;8 bits de menos peso del PC
status                  equ 0x03        ;Registro de estado
fsr                     equ 0x04        ;Registro de indirecci¢n
trisa                   equ 0x05        ;Regitsro de direccionado de la puerta A
trisb                   equ 0x06        ;Registro de direccionado de la puerta B
porta                   equ 0x05        ;Registro de la puerta A
portb                   equ 0x06        ;Registro de la puerta B
eedato                  equ 0x08        ;Regsitro  de datos EEPROM
eecon1                  equ 0x08        ;Registro 1 de control EEPROM
eeadr                   equ 0x09        ;Registro de direcciones EEPROM
eecon2                  equ 0x09        ;Registro 2 de control EEPROM
pclath                  equ 0x0a        ;Parte alta del PC
intcon                  equ 0x0b        ;Registro de control de interrupci¢n

;***************************************************************************
;El registro de opciones del microcontrolador "option"
;***************************************************************************

#define _ps0            opcion,0        ;Bit 0 de selecci¢n del preescaler
#define _ps1            opcion,1        ;Bit 1 de selecci¢n del preescaler
#define _ps2            opcion,2        ;Bit 2 de selecci¢n del preescaler
#define _psa            opcion,3        ;Asignaci¢n del preescaler a TMR0 o WDT
#define _t0se           opcion,4        ;Selecci¢n de tipo de flanco para TMR0
#define _t0cs           opcion,5        ;Selecci¢n de tipo de reloj para el TMR0
#define _intedg         opcion,6        ;Selecci¢n de flanco de la interrupci¢n INT
#define _rbpu           opcion,7        ;Actibaci¢n de cargas pull-up para puerta B

;***************************************************************************
;Registro de control de interrupciones del microcontrolador "intcon"
;***************************************************************************

#define _rbif           intcon,0        ;Flag de interrupci¢n de la puerta B
#define _intf           intcon,1        ;Flag de interrupci¢n externa INT
#define _t0if           intcon,2        ;Flag de interrupci¢n del TMR0
#define _rbie           intcon,3        ;Habilitaci¢n de interrupci¢n de la puerta B
#define _inte           intcon,4        ;Habilitaci¢n de la interrupci¢n externa INT
#define _t0ie           intcon,5        ;Habilitaci¢n de interrupci¢n del TMR0
#define _eeie           intcon,6        ;Habilitaci¢n de interrupci¢n de la EEPROM
#define _gie            intcon,7        ;Habilitaci¢n global de interrupciones

;***************************************************************************
;El registro de estado del microcontrolador "status"
;***************************************************************************

#define _c              status,0        ;Flag de acarreo
#define _dc             status,1        ;Flag de acarreo decimal
#define _z              status,2        ;Flag Z (a "1" si resultado=0)
#define _pd             status,3        ;Flag de "power down"
#define _to             status,4        ;Flag de "WDT Timer Out"
#define _rp0            status,5        ;Bit 0 selector de p gina 
#define _rp1            status,6        ;Bit 1 selector de p gina
#define _irp            status,7        ;Selecci¢n de bancos (direcionado indirecto)

;***************************************************************************
;El registro de control de la memoria EEPROM de datos "eecon1"
;***************************************************************************

#define _rd             eecon1,0        ;Orden de lectura
#define _wr             eecon1,1        ;Orden de escritura
#define _wren           eecon1,2        ;Permiso de escritura
#define _wrerr          eecon1,3        ;Flag de error de escritura
#define _eeif           eecon1,4        ;Flad de fin de escritura



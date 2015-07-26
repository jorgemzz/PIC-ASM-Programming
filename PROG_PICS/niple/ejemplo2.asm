;------------------------------------------------------------
; Código assembler generado por Niple V5.2.1
; Proyecto: ejemplo1
; Autor: ---
; Fecha: 18/12/2009
; PIC: 16F84
; Velocidad de reloj: 4 Mhz
; Descripcion: 
;------------------------------------------------------------


 LIST    P=PIC16F84


_XT_OSC               equ  0x3FFD
_WDT_OFF              equ  0x3FFB
_PWRTE_ON             equ  0x3FF7
_CP_OFF               equ  0x3FFF

 __config _XT_OSC & _WDT_OFF & _PWRTE_ON & _CP_OFF


;------------------------------------------------------------
;                  Declaración de Registros
;------------------------------------------------------------
w                     equ  0x0000
status                equ  0x0003
portb                 equ  0x0006
pclath                equ  0x000a
contador              equ  0x000d
unidad                equ  0x000e
decena                equ  0x000f
_np_temp1             equ  0x0010
_np_temp2             equ  0x0011
_np_temp3             equ  0x0012
_np_tiempo            equ  0x0013
_np_dy_c_1            equ  0x0015
_np_dy_c_2            equ  0x0016
_np_disp_valor        equ  0x0017
trisb                 equ  0x0086


;------------------------------------------------------------
;                  Declaración de Bits
;------------------------------------------------------------
c                     equ  0   ;carry / borrow bit
rp0                   equ  5   ;registrer bank select bit
rp1                   equ  6   ;registrer bank select bit
z                     equ  2   ;bit cero


;------------------------------------------------------------
;                        Inicio
;------------------------------------------------------------

reset   org 0
   goto paso2


;------------------------------------------------------------
;                      programa principal
;------------------------------------------------------------
paso2
   movlw b'00000000'                ;configurar el puerto b como ssssssss
   bsf status,rp0                   ;cambiar a banco 1
   movwf trisb
   movlw d'0'
   movwf contador
paso4
   ;convertir un registro a bcd
   movf contador,w
   movwf _np_temp1
   call conv_8_bcd
   movf _np_temp1,w
   movwf unidad
   movf _np_temp2,w
   movwf decena
   ;visualizar datos en displays anodo común (74ls47)
   clrf _np_dy_c_1                  ;limpiar el contador de repeticiones
   clrf _np_dy_c_2
   bcf portb,3                      ;apagar display para evitar error de visualizacion
   bcf portb,2                      ;apagar display para evitar error de visualizacion
paso5_mostrar
   call dy2ab4b5b6b7
   movf unidad,w                    ;mostrar el valor del registro unidad
   movwf _np_disp_valor
   call dy3ab4b5b6b7
   bsf portb,3                      ;encender el display 1
   movlw .2                         ;temporizador 20 use
   call tiempo_10_1000_uc
   bcf portb,3                      ;apagar el display 1
   call dy2ab4b5b6b7
   movf decena,w                    ;mostrar el valor del registro decena
   movwf _np_disp_valor
   call dy3ab4b5b6b7
   bsf portb,2                      ;encender el display 2
   movlw .2                         ;temporizador 20 use
   call tiempo_10_1000_uc
   bcf portb,2                      ;apagar el display 2
   incf _np_dy_c_2,1
   btfsc status,z
   incf _np_dy_c_1,1
   movlw b'00000011'
   subwf _np_dy_c_1,w
   btfss status,c
   goto paso5_mostrar
   movlw b'11101000'
   subwf _np_dy_c_2,w
   btfss status,c
   goto paso5_mostrar

   clrf contador
   incf contador,1                  ;incrementar el registrocontador
   btfsc status,z                   ;recuperar acarreo por desborde
   incf contador,1
   movf contador,w                  ;si el reg contador > d'99'
   sublw d'99'
   btfsc status,c
   goto paso4                       ;cierra el ciclo
   movlw d'0'
   movwf contador
   goto paso4                       ;cierra el ciclo


;------------------------------------------------------------
;                  Declaración de Subrutinas
;------------------------------------------------------------

conv_8_bcd
   ;convertir un registro a formato bcd (u, d y c)
   bcf status,rp0                   ;cambiar a banco 0
   clrf _np_temp3
   clrf _np_temp2
   movlw .100
conv_8_bcd_otro
   subwf _np_temp1,1
   btfss status,c
   goto conv_8_bcd_suma
   incf _np_temp3,1
   goto conv_8_bcd_otro
conv_8_bcd_suma
   addwf _np_temp1,1
   movlw .10
conv_8_bcd_bucle
   subwf _np_temp1,1
   btfss status,c
   goto conv_8_bcd_salir
   incf _np_temp2,1
   goto conv_8_bcd_bucle
conv_8_bcd_salir
   addwf _np_temp1,1
   return

dy2ab4b5b6b7
   ;visualizar datos en displays anodo común
   bcf portb,4                      ;limpiar el bus de datos
   bcf portb,5
   bcf portb,6
   bcf portb,7
   return

dy3ab4b5b6b7
   ;visualizar datos en displays anodo común
   btfsc _np_disp_valor,0           ;asignar el nuevo valor al bus de datos
   bsf portb,4
   btfsc _np_disp_valor,1
   bsf portb,5
   btfsc _np_disp_valor,2
   bsf portb,6
   btfsc _np_disp_valor,3
   bsf portb,7
   return

tiempo_10_1000_uc
   movwf _np_tiempo
   goto tiempo_10_1000_uc_10
tiempo_10_1000_uc_bucle
   nop
   nop
   nop
   nop
   nop
   nop
   nop
tiempo_10_1000_uc_10
   decfsz _np_tiempo,1
   goto tiempo_10_1000_uc_bucle
   return


 End
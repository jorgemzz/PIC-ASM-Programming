;****************************************************************************
;viernes 01-05-07
;diseño de un reloj temporizado ya exacto  con cuatro lineas , rb4= detiene el tiempo
;rb5:selecciona hora y/o minuto, rb6=incrementa lo seleccionado
;AUTOR: CARLOS ALBERTO YACO TINCUSI
; digito4digito3:digito2digito1:digito6digto5 formato de hora
;****************************************************************************
list P=16F84A
include<P16F84A.inc>
cblock 0x0C
segundo_uni
segundo_dec
unidad 
decena 
centena 
unidmil 
digito1  ;minutos
digito2 ;munutos
digito3 ;hora
digito4 ;hora
digito5
digito6
alar_digito1; digito alarma minuto
alar_digito2; digito alarma minuto
alar_digito3; digito alarma hora
alar_digito4; digito alarma hora
contador 
segundo 
contador_interupcion  ; controla la  sincronizacion del reloj
controlador_interupcion;  se encarga de controlar las interupciones
controlador_cambio; 
contador_alarma
activar ; controlar la sincronizacion del reloj
timbre_alarma
endc
org 0
goto inicio
org 4
goto controlador

inicio ;configuracion  de pines
bsf  STATUS, RP0
movlw b'01110000'
movwf PORTB
movlw b'11110000'
movwf PORTA
movlw b'10100000'
movwf INTCON
movlw b'00000011'
movwf OPTION_REG
bcf STATUS,RP0
clrf segundo_uni
clrf segundo_dec
clrf unidad
clrf decena
clrf centena
clrf unidmil
clrf contador
clrf segundo
clrf activar
clrf contador_interupcion
clrf controlador_interupcion
clrf controlador_cambio
clrf digito6
clrf digito5
clrf timbre_alarma
movlw d'0'
movwf TMR0
;inicializacion de los digitos del display
clrf digito4
clrf digito3
clrf digito2
clrf digito1
clrf alar_digito4
clrf alar_digito2
clrf alar_digito3
movlw d'1'
movwf alar_digito1
clrf contador_alarma
call visualizar

; contador de segundos unidad
contador_unidad_segundo
incf segundo_uni
movfw segundo_uni
sublw d'10'
btfsc STATUS,Z
call contador_decena_segundo
movfw segundo_uni
movwf digito5
call visualizar

; contador de segundos decena
contador_decena_segundo
clrf segundo_uni
clrf digito5
incf segundo_dec
movfw segundo_dec
sublw d'6'
btfsc STATUS,Z
call contador_unidad_minuto
movfw segundo_dec
movwf digito6
call visualizar

;contador de unidades minuto
contador_unidad_minuto 
clrf segundo_dec
clrf digito6
incf unidad
movf unidad,w
sublw d'10'
btfsc  STATUS,Z
call contador_decena_minuto
movf unidad,w
movwf digito1
;  es hora de alarma 
movfw centena
subwf alar_digito3,0
btfsc STATUS,Z
call activar_alarma
;
call visualizar

;contador de decena minuto
contador_decena_minuto
clrf unidad
clrf digito1
incf decena
movf decena,w
sublw d'6'
btfsc  STATUS,Z
call contador_unidad_hora
movf decena,w
movwf digito2
;  es hora de alarma 
movfw centena
subwf alar_digito3,0
btfsc STATUS,Z
call activar_alarma
;
call visualizar

;contador de unidad hora
contador_unidad_hora
clrf decena
clrf digito2
incrementar_hora
incf centena
movf centena,w
sublw d'10'
btfsc  STATUS,Z
call contador_decena_hora
movf centena,w
movwf digito3
movfw centena
sublw d'4'
btfss STATUS,Z
call visualizar
incf contador,1
movfw contador
sublw d'3'
btfss STATUS,Z
call visualizar
clrf digito3
clrf digito4
clrf centena
clrf unidmil
clrf contador
call visualizar

;contador de decena hora
contador_decena_hora
clrf centena
clrf digito3
incf unidmil
movf unidmil,w
sublw d'10'
btfsc  STATUS,Z
clrf unidmil
movf unidmil,w
movwf digito4
call visualizar

visualizar
movfw digito1
bcf PORTA,1 ;DESHABILTAR DECENAS
bcf PORTA,2 ;DESHABILTAR CENTENAS
bcf PORTA,3 ;DESHABILTAR UNIDAD DE MILLAR
movwf PORTB
bsf PORTA,0 ; HABILITAR UNIDADES
movfw digito2
bcf PORTA,0; DESHABILITAS UNIDADES
movwf PORTB
bsf PORTA,1; HABILITAS DECENAS
movfw digito3
bcf PORTA,1; DESHABILITAS DECENAS
movwf PORTB
bsf PORTA,2 ; HABILITO CENTENAS
movfw digito4
bcf PORTA,2 ;DESHABILITO CENTENAS
movwf PORTB
bsf PORTA,3 ; HABILITO UNIDAD DE MILLAR
btfsc PORTB,4
goto stop; detener el tiempo
movfw controlador_interupcion
sublw d'5'
btfsc STATUS,Z
goto activar_interupcion
goto visualizar

controlador ; se encarga de controlar la ocurenncia de un segundo
bsf INTCON,7
bcf INTCON,2
movlw d'0'
movwf TMR0
incf segundo
movfw segundo
sublw d'243'
btfss STATUS,Z
call visualizar
clrf segundo
call contador_unidad_segundo


stop
bcf INTCON,7 ; deshabilitas cualquier tipo de interupcion
btfsc PORTB,4
call continuamos_stop
activar_interupcion
bsf INTCON,7
bcf INTCON,2
movlw d'0'
movwf TMR0
clrf activar
clrf contador_interupcion
clrf controlador_interupcion
clrf controlador_cambio
goto visualizar  

continuamos_stop
movlw d'5'
movwf controlador_interupcion ; activamos el controlador
btfsc PORTB,5
goto pre_controlador
call RETARDO_10MS
btfsc PORTB,5
goto pre_controlador
incf contador_interupcion
cambio
bucle
btfss PORTB,5
goto bucle
call RETARDO_10MS
btfss PORTB,5
goto bucle
sigue
movlw d'5'
movwf activar; activamos que se produjo un intento de camibo de horairo
movfw contador_interupcion
sublw d'6' ;;
btfsc STATUS,Z
call special
movfw contador_interupcion
sublw d'1'
btfsc STATUS,Z ; horas?
goto pre_incrementar_hora
movfw contador_interupcion
sublw d'2'
btfsc STATUS,Z  ; minutos?
goto pre_incrementar_minuto
movfw contador_interupcion
sublw d'3'
btfsc STATUS,Z ; mostrar alarma?
goto visualizar_especial
movfw contador_interupcion
sublw d'4'
btfsc STATUS,Z ; horas_alarma?
goto pre_incrementar_hora_alarma
movfw contador_interupcion
sublw d'5'
btfsc STATUS,Z ; minutos_alaram?
goto pre_incrementar_minuto_alarma

special 
movlw d'1'
movwf contador_interupcion
return
pre_controlador
movfw activar
sublw d'5'
btfss STATUS, Z
goto visualizar
goto sigue

pre_incrementar_hora  ; espera que se pulse para incrementar
btfsc PORTB,6
goto visualizar
call RETARDO_10MS
btfsc PORTB,6
goto visualizar
bucle2
btfss PORTB,6
goto bucle2
goto incrementar_hora

pre_incrementar_minuto; espera que se pulse para incrementar
btfsc PORTB,6
goto visualizar
call RETARDO_10MS
btfsc PORTB,6
goto visualizar
bulce3
btfss PORTB,6
goto bulce3
goto contador_unidad_minuto

visualizar_especial
movfw alar_digito1
bcf PORTA,1 ;DESHABILTAR DECENAS
bcf PORTA,2 ;DESHABILTAR CENTENAS
bcf PORTA,3 ;DESHABILTAR UNIDAD DE MILLAR
movwf PORTB
bsf PORTA,0 ; HABILITAR UNIDADES
movfw alar_digito2
bcf PORTA,0; DESHABILITAS UNIDADES
movwf PORTB
bsf PORTA,1; HABILITAS DECENAS
movfw alar_digito3
bcf PORTA,1; DESHABILITAS DECENAS
movwf PORTB
bsf PORTA,2 ; HABILITO CENTENAS
movfw alar_digito4
bcf PORTA,2 ;DESHABILITO CENTENAS
movwf PORTB
bsf PORTA,3 ; HABILITO UNIDAD DE MILLAR
btfsc PORTB,4
goto stop; detener el tiempo
movfw controlador_interupcion
sublw d'5'
btfsc STATUS,Z
goto activar_interupcion
goto visualizar_especial

;contador de unidades minuto alarma
contador_unidad_minuto_alarma
incf alar_digito1
movf alar_digito1,w
sublw d'10'
btfsc  STATUS,Z
call contador_decena_minuto_alarma
call visualizar_especial

;contador de decena minuto
contador_decena_minuto_alarma
clrf alar_digito1
incf alar_digito2
movf alar_digito2,w
sublw d'6'
btfsc  STATUS,Z
call contador_unidad_hora_alarma
call visualizar_especial

;contador de unidad hora
contador_unidad_hora_alarma
clrf alar_digito2
incrementar_hora_alarma
incf alar_digito3
movf alar_digito3,w
sublw d'10'
btfsc  STATUS,Z
call contador_decena_hora_alarma
movfw alar_digito3
sublw d'4'
btfss STATUS,Z
call visualizar_especial
incf contador_alarma,1
movfw contador_alarma
sublw d'3'
btfss STATUS,Z
call visualizar_especial
clrf alar_digito3
clrf alar_digito4
clrf contador_alarma
call visualizar_especial

;contador de decena hora
contador_decena_hora_alarma
clrf alar_digito3
incf alar_digito4
movf alar_digito4,w
sublw d'10'
btfsc  STATUS,Z
clrf alar_digito4
call visualizar_especial

pre_incrementar_hora_alarma  ; espera que se pulse para incrementar
btfsc PORTB,6
goto visualizar_especial
call RETARDO_10MS
btfsc PORTB,6
goto visualizar_especial
bucle4
btfss PORTB,6
goto bucle4
goto incrementar_hora_alarma

pre_incrementar_minuto_alarma; espera que se pulse para incrementar
btfsc PORTB,6
goto visualizar_especial
call RETARDO_10MS
btfsc PORTB,6
goto visualizar_especial
bulce5
btfss PORTB,6
goto bulce5
goto contador_unidad_minuto_alarma

activar_alarma
movfw unidmil
subwf alar_digito4,0
btfss STATUS,Z
return
movfw decena
subwf alar_digito2,0
btfss STATUS,Z
return
movfw unidad
subwf alar_digito1,0
btfss STATUS,Z
return
bcf INTCON,7; deshabilitado todo tipo de  interupcion
bsf PORTB,7
call RETARDO_20S
call RETARDO_5S
bcf PORTB,7
call RETARDO_1S
bsf PORTB,7
call RETARDO_20S
call RETARDO_5S
bcf PORTB,7
call RETARDO_1S
bsf PORTB,7
call RETARDO_5S
call RETARDO_2S
bcf INTCON,2
bsf INTCON,7
movlw d'0'
movwf TMR0
goto contador_unidad_minuto 

include<RETARDOS.inc>
END


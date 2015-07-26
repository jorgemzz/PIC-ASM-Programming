
BANK0 macro
Bcf STATUS, RP0 ;Selecionar o banco 0 da memória
Endm
BANK1 macro
Bsf STATUS, RP0 ; Selecionar o banco 1 da memória
Endm
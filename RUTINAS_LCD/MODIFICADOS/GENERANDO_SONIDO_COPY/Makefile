# MPLAB IDE generated this makefile for use with GNU make.
# Project: GENERANDO_SONIDO.mcp
# Date: Fri Jan 04 00:08:10 1980

AS = MPASMWIN.exe
CC = mcc18.exe
LD = mplink.exe
AR = mplib.exe
RM = rm

SONIDO.cof : SONIDO.o
	$(LD) /p16F84A "SONIDO.o" /u_DEBUG /z__MPLAB_BUILD=1 /z__MPLAB_DEBUG=1 /o"SONIDO.cof" /M"SONIDO.map" /W /x

SONIDO.o : SONIDO.ASM C:/Archivos\ de\ programa/Microchip/MPASM\ Suite/P16F84A.INC bank.inc button.inc wait.inc beep.inc
	$(AS) /q /p16F84A "SONIDO.ASM" /l"SONIDO.lst" /e"SONIDO.err" /d__DEBUG=1

clean : 
	$(RM) "SONIDO.o" "SONIDO.hex" "SONIDO.err" "SONIDO.lst" "SONIDO.cof"


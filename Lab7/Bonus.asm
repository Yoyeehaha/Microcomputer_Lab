#include "p18f4520.inc"

; CONFIG1H
  CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)
    L1 EQU 0x14
    L2 EQU 0x15
    org 0x00
    
DELAY macro num1, num2 
    local LOOP1 
    local LOOP2
    MOVLW num2
    MOVWF L2
    LOOP2:
	MOVLW num1
	MOVWF L1
    LOOP1:
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1, 1
	BRA LOOP1
	DECFSZ L2, 1
	BRA LOOP2
endm
    
goto Initial			    
ISR:				
    org 0x08
    MOVF 0x02, W
    BTFSS 0x02, 0
    DECF 0x00
    MOVLW 0x01         
    MOVWF 0x02  ;active flag
    INCF 0x00
    MOVLW 0x06
    CPFSLT 0x00
    CLRF 0x00 ;state
    CLRF 0x01 ;counter
    MOVLW 0x0F
    MOVWF 0x02 ;reverse counter
    CLRF 0x20 
    CLRF 0x21
    CLRF 0x22
    DELAY d'111', d'70'
    BCF INTCON, INT0IF
    RETFIE
    
Initial:			
    MOVLW 0x0F
    MOVWF ADCON1		
    
    CLRF TRISA
    CLRF LATA
    BSF TRISB,  0
    BCF RCON, IPEN
    BCF INTCON, INT0IF		
    BSF INTCON, GIE		
    BSF INTCON, INT0IE	
    
    CLRF 0x00    ;state 
    CLRF 0x01   ;counter 
    CLRF 0x03   ;reverse counter
    
main:		
    MOVF 0x02, W     ;before push the button the light are off
    BTFSC STATUS, Z
    GOTO main
    
    MOVF 0x00, W
    SUBLW 0x00
    BTFSC STATUS, Z
    GOTO State1

    MOVF 0x00, W
    SUBLW 0x01 
    BTFSC STATUS, Z
    GOTO State2

    MOVF 0x00, W
    SUBLW 0x02 
    BTFSC STATUS, Z
    GOTO State3
    
    MOVF 0x00, W
    SUBLW 0x03
    BTFSC STATUS, Z
    GOTO State4

    MOVF 0x00, W
    SUBLW 0x04 
    BTFSC STATUS, Z
    GOTO State5

    MOVF 0x00, W
    SUBLW 0x05 
    BTFSC STATUS, Z
    GOTO State6

    BRA main 
    
State1: 
    
    MOVF 0x01, W
    ANDLW 0x07 
    MOVWF LATA 
    INCF 0x01, 1 
    DELAY d'111', d'70'
    INCF 0x21
    BRA main

State2: 
    
    MOVF 0x01, W
    ANDLW 0x0F 
    MOVWF LATA 
    INCF 0x01, 1 
    DELAY d'111', d'140'
    INCF 0x22
    BRA main
    
State3: 
    
    MOVF 0x03, W
    ANDLW 0x0F 
    MOVWF LATA 
    DECF 0x03, 1 
    DELAY d'111', d'70'
    INCF 0x22
    BRA main  
    
State4: 
    
    MOVF 0x01, W
    ANDLW 0x07 
    MOVWF LATA 
    INCF 0x01, 1 
    DELAY d'111', d'140'
    INCF 0x21
    BRA main

State5: 
    
    MOVF 0x01, W
    ANDLW 0x0F 
    MOVWF LATA 
    INCF 0x01, 1 
    DELAY d'111', d'70'
    INCF 0x22
    BRA main
    
State6:     
    MOVF 0x03, W
    ANDLW 0x0F 
    MOVWF LATA 
    DECF 0x03, 1 
    DELAY d'111', d'140'
    INCF 0x22
    BRA main    
    
end

LIST p=18f4520
#include<p18f4520.inc>

    CONFIG OSC = INTIO67 ; Set internal oscillator to 1 MHz
    CONFIG WDT = OFF     ; Disable Watchdog Timer
    CONFIG LVP = OFF     ; Disable Low Voltage Programming
    org 0x00
    
    start:
	MOVLW 0x0F          ; Set ADCON1 register for digital mode
	MOVWF ADCON1        ; Store WREG value into ADCON1 register
	CLRF PORTA            ; Clear PORTA (turn off all LEDs)
	CLRF PORTB            ; Clear PORTB
	MOVLW 0xF8          ; Set RA0, RA1, RA2 as outputs 
	MOVWF TRISA
	MOVLW 0x01          ; Set RB0 as input 
	MOVWF TRISB

    check_button:
	BTFSC PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
	BRA check_button     
	BRA light_first_up         ; If button is pressed, branch to lightup
	
    no_light_up:
	BCF LATA, 2
	BTFSC PORTB, 0
	BRA no_light_up
	BRA light_first_up
	
    light_first_up:
	BSF LATA, 0
	BTFSC PORTB, 0
	BRA light_first_up 
	BRA light_second_up
	
    light_second_up:
        BCF LATA, 0
	BSF LATA, 1
	BTFSC PORTB, 0
	BRA light_second_up
	BRA light_third_up
	
    light_third_up:
	BCF LATA, 1
	BSF LATA, 2
	BTFSC PORTB, 0
	BRA light_third_up
	BRA no_light_up

    end
